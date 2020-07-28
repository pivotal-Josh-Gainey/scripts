###### dopStats.sh
By default uses a created user that can bypass log-cache permissions checks for fast cf queries. It also uses the [log-cache cli](https://github.com/cloudfoundry/log-cache-cli).
```java
uaac target uaa.<systemFQDN>
uaac token client get admin -s <admin-client-secret>
uaac user add dopStats \
    --password dopStats \
    --emails dopStats@dopStats.com \
    && uaac member add doppler.firehose dopStats
```
This script needs to be edited with the api endpoint for the cf cli along with an admin user.
