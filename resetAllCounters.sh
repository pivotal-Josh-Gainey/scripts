#!/bin/bash

# reset doppler counters
bosh -d cf-9748d0756138673f201d ssh doppler -c "sudo /var/vcap/bosh/bin/monit restart loggr-forwarder-agent"
echo "doppler counters resetting."

# reset all CounterNozzle counters 

for i in {0..9}
do
INSTANCE_TOTAL=`curl -s counternozzle-sleepy-chipmunk.apps.joshbot.pas/reset -H "X-Cf-App-Instance":"afa78ee5-b952-4d7d-a553-fc48fe470245:$i"`
done
echo "CounterNozzle counters reset."
