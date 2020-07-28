<h1>name-of-script</h1>
description

<h2>dopStats</h2>
By default uses a created user that can bypass log-cache permissions checks for fast cf queries. It also uses the log-cache cli.
For log-cache cli: https://github.com/cloudfoundry/log-cache-cli
To create the user - use uaac cli:
uaac target uaa.<systemFQDN>
uaac token client get admin -s <admin-client-secret>
uaac user add dopStats \
    --password dopStats \
    --emails dopStats@dopStats.com \
    && uaac member add doppler.firehose dopStats
