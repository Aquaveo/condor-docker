#!/bin/bash

## Ensure SSH Key works
# 
# This is a workaround for K8s secret mounts being root-only
if [ -e  ~condor/keys/authorized_keys ]; then
    cp ~condor/keys/authorized_keys ~condor/.ssh/
    chown -R condor ~condor/.ssh/
    chmod 700 ~condor/.ssh 
    chmod 600 ~condor/.ssh/authorized_keys
    cp ~condor/keys/authorized_keys ~submituser/.ssh/
    chown -R submituser ~submituser/.ssh/
    chmod 700 ~submituser/.ssh 
    chmod 600 ~submituser/.ssh/authorized_keys
fi

# Do the same thing for the pool password
if [ -e ~condor/pool_password/password ]; then
    mkdir -p /etc/condor/pool_password
    cp ~condor/pool_password/password /etc/condor/pool_password/password
    chown -R condor /etc/condor/pool_password
    chmod 600 /etc/condor/pool_password/password
fi

# Make sure that condor's directories exists
mkdir -p /run/condor /var/spool/condor
chown condor:condor /run/condor
chmod 775 /run/condor
chown condor:condor /var/spool/condor
chmod 775 /var/spool/condor

# Run HTCondor
/usr/bin/supervisord -c /etc/supervisor/supervisord.conf
