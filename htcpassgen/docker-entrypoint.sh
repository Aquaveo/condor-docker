#!/bin/sh
UUID=$(cat /proc/sys/kernel/random/uuid)
condor_store_cred add-pwd -p $UUID -f /dev/fd/1
