# Tethys Charts Repo
This repository contains the helm chart for condor docker. These charts are designed for use by Tethys apps, and has not been tested for usability in stand-alone mode.

### How to install
This Github page is currently being build from the /docs folder in the master branch. The helm charts are located here.

To add this repo, you can run this command
```console
helm repo add condor-docker https://aquaveo.github.io/condor-docker/
```

You can search what is inside this repo:
```console
helm search repo condor-docker
```
You should see these following charts:
``` console
NAME                            CHART VERSION   APP VERSION     DESCRIPTION           
condor-docker/condor-manager    0.1.1           latest          HTCondor Manager Nodes
condor-docker/condor-worker     0.1.1           dev             HTCondor Worker Node 
```

Run this command to install:
``` console
helm install condor-docker/condor-manager --generate-name
helm install condor-docker/condor-worker --generate-name
```
