#!/bin/bash
# This variable environment is set but it does not appear in the POD by using the command `env`

UUID=$( cat /proc/sys/kernel/random/uuid | sed -e 's/-//g' )
echo $UUID > /WEBSITE_INSTANCE_ID.txt

exec env WEBSITE_INSTANCE_ID=$UUID "$@"
