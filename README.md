## dopStats.sh
This script will request,parse,and output doppler throughput and drops per instance in a table on the screen. (tip: use watch for it to update in real time.)
It needs be edited with the api endpoint. Optionally, you can use an admin user or create a temporary user for the script. 
It also uses the [log-cache cli](https://github.com/cloudfoundry/log-cache-cli).
This is how to set up the dopStats user.
```java
uaac target uaa.<systemFQDN>
uaac token client get admin -s <admin-client-secret>
uaac user add dopStats \
    --password dopStats \
    --emails dopStats@dopStats.com \
    && uaac member add doppler.firehose dopStats
```
This is how to delete the dopStats user.
```java
uaac user delete dopStats
```
