## dopStats.sh
This script will request,parse,and output doppler throughput and drops per instance in a table on the screen. (tip: use watch for it to update in real time.)
It requires the [log-cache cli](https://github.com/cloudfoundry/log-cache-cli).
Just be sure your cf cli is authenticated and you have the proper scopes. (Note - if you have doppler.firehose or logs.admin scope - it will skip the log-cache permission check leading to faster and more efficient running of the script.)

