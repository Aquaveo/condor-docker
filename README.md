Docker-Condor
=============

This project started as an attempt to get HTCondor to run nicely in a docker containter, and has morphed into supporting Tethys deployments to Kubernetes.

## Setup

1. Create a pool password file 
    - `condor_store_cred -p $(uuidgen) -f /tmp/password`
1. Add the pool password to Kubernetes
    - `kubectl create secret generic condor-pool-password --from-file=/tmp/password`
1. Create an ssh key 
    - `ssh-keygen -t rsa -b 2048`
1. Add the public key to Kubernetes
    - `cp .ssh/id_rsa.pub authorized_keys`
    - `kubectl create secret generic condor-ssh-key --from-file=authorized_keys`
1. Deploy the central manager
    - `helm install helm/condor-manager`
1. Once running, deploy the Workers
    - `helm install helm/condor-worker`

