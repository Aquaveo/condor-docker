#!/bin/bash

## Ensure SSH Key works
# 
# This is a workaround for K8s secret mounts being root-only
if [ -e  ~condor/keys/authorized_keys ]; then
    cp ~condor/keys/authorized_keys ~condor/.ssh/
    chown -R condor ~condor/.ssh/
    chmod 700 ~condor/.ssh 
    chmod 600 ~condor/.ssh/authorized_keys
fi

# Make sure that condor's run directory exists
mkdir -p /run/condor
chown condor:condor /run/condor
chmod 775 /run/condor

# Run HTCondor
/usr/bin/supervisord -c /etc/supervisor/supervisord.conf
