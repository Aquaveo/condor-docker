#!/usr/bin/python
import htcondor
import json
import os
import requests
import time
import datetime


APISERVER = "https://kubernetes.default.svc"
SA_DIR = "/var/run/secrets/kubernetes.io/serviceaccount"
TOKEN = open(f"{SA_DIR}/token", "r").read
NAMESPACE = open(f"{SA_DIR}/namespace", "r").read
CACERT = f"{SA_DIR}/ca.crt"


def get_needed_cpus():
    coll = htcondor.Collector()
    results = coll.query(htcondor.AdTypes.Schedd, 'true', ['Name'])

    needed_cpus = 0
    for result in results:
        host = result['Name']
        schedd_ad = coll.locate(htcondor.DaemonTypes.Schedd, host)
        schedd = htcondor.Schedd(schedd_ad)

        jobs = schedd.query('', ['JobStatus', 'RequestCpus'])
        for job in jobs:
            if job['JobStatus'] == 1:  # Job status 1 is idle
                needed_cpus += int(job['RequestCpus'])

    return needed_cpus


def get_num_pods(label_selector):
    try:
        r = requests.get(
            f"{APISERVER}/api/v1/namespaces/{NAMESPACE}/pods?labelSelector={label_selector}",
            headers={f"Authorization: Bearer {TOKEN}"},
            verify=CACERT
        )
    except requests.exceptions.RequestException as e:
        print(f"Failed to get list of pods: {e}")
        exit(1)

    pods_pending = 0
    pods_running = 0

    if 'items' in r.json() and r.json()['items'] is None:
        for pod in r.json()['items']:
            if pod['status']['phase'] == 'Running':
                pods_running += 1
            elif pod['status']['phase'] == 'Pending':
                pods_pending += 1

    return pods_pending, pods_running


def create_pods(num, template, name):
    print('Creating', num, 'pods')
    try:
        with open(template, 'r') as content:
            raw = content.read()
    except:
        print('Failed to open pod template')
        exit(1)

    for i in range(0, num):
        pod = json.loads(raw)
        pod['metadata']['generateName'] = name + '-'
        try:
            r = requests.post(
                f"{APISERVER}/api/v1/namespaces/{NAMESPACE}/pods", data=json.dumps(pod),
                headers={f"Authorization: Bearer {TOKEN}"},
                verify=CACERT
            )
        except:
            print('Failed to create pod')
        print('  - status = ', r.status_code)


if __name__ == '__main__':
    time.sleep(10)

    label_selector = os.environ.get('HTCONDOR_LABEL_SELECTOR', 'app.kubernetes.io/name=condor-worker')
    pod_template = os.environ.get('HTCONDOR_POD_TEMPLATE', '/data/worker.json')
    max_workers = int(os.environ.get('HTCONDOR_MAX_WORKERS', 10))
    cpus_per_worker = int(os.environ.get('HTCONDOR_CPUS_PER_WORKER', 1))
    max_workers_per_cycle = int(os.environ.get('HTCONDOR_MAX_WORKERS_PER_CYCLE', 3))

    while True:
        # Get number of idle jobs
        needed_cpus = get_needed_cpus()

        # Get numbers of running & idle pods
        (num_pending_pods, num_running_pods) = get_num_pods(label_selector)

        time = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
        print(f"{time} - Pending: {num_pending_pods} Running: {num_running_pods} NeededCPUs={needed_cpus}")

        # Estimate number of worker pods to create
        num = needed_cpus / cpus_per_worker

        # Limit number of pods if necessary
        if num > max_workers_per_cycle:
            num = max_workers_per_cycle

        if num_running_pods + num_pending_pods + num > max_workers:
            num = max_workers - num_running_pods - num_pending_pods
            if num < 0:
                num = 0

        # If there are idle pods, don't create anymore
        if num_pending_pods > 0:
            num = 0

        # Create new pods if necessary
        if num > 0:
            create_pods(num, pod_template, os.environ['HTCONDOR_POD_NAME'])

        time.sleep(60)

exit(0)
