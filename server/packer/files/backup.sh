#!/bin/bash

cd /home/ubuntu

# delete zip file if exists
if test -f "./minecraft-server.zip"; then
  echo "Zip file exists, removing..."
  rm ./minecraft-server.zip
fi

# stop server if running
pid=$(ps aux | grep forgeserver.jar | grep -v grep | awk '{print $2}')
if [[ ! -z "$pid"]]; then
  echo "Server running with pid ${pid}, sending kill signal..."
  kill -9 ${pid}
  sleep 20
fi

# zip server folder
echo "Zipping server folder..."
zip -r minecraft-server.zip ./minecraft-server/

# upload to s3
echo "Uploading archive to s3"
aws s3 cp ./minecraft-server.zip s3://minecraft-forge-858463413507/minecraft-server.zip
