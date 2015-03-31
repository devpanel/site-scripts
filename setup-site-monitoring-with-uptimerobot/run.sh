#!/bin/bash

touch up.log
wget https://bitbucket.org/melnichevvv/test/raw/master/uptimerobot/uptimerobot.js -O uptimerobot.js
cat uptimerobot.js | sed "s|#user_name#|@email@|g" | sed "s|#user_password#|@password@|g" > uptimerobot_run.js
casperjs uptimerobot_run.js --ssl-protocol=tlsv1 >> up.log
Key=$(cat apiKey)
rm apiKey
rm uptimerobot.js
rm uptimerobot_run.js