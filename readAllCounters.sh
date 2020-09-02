#!/bin/bash

# read doppler counters
export SUM_DOPPLER_INGRESS=0
for i in `cf query "ingress{source_id='doppler'}" | jq -r '.data.result[].value[1]'`
do
export SUM_DOPPLER_INGRESS=`echo "${i} + $SUM_DOPPLER_INGRESS" | bc`
done
echo "Doppler ingress sum: $SUM_DOPPLER_INGRESS"

# read all CounterNozzle counters
export CURRENT_COUNTERNOZZLE_TOTAL=0
for i in {0..9}
do
INSTANCE_TOTAL=`curl -s counternozzle-sleepy-chipmunk.apps.joshbot.pas/read -H "X-Cf-App-Instance":"afa78ee5-b952-4d7d-a553-fc48fe470245:$i"`
CURRENT_COUNTERNOZZLE_TOTAL=`echo "${INSTANCE_TOTAL} + $CURRENT_COUNTERNOZZLE_TOTAL" | bc`
done
echo "CounterNozzle ingress sum: $CURRENT_COUNTERNOZZLE_TOTAL"
