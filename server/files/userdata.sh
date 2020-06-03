#!/bin/bash

set -ex

# Send the log output from this script to user-data.log, syslog, and the console
# From: https://alestic.com/2010/12/ec2-user-data-output/
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

cd /home/ubuntu

# Download server zip
sudo -u ubuntu bash -c "aws s3 cp s3://minecraft-forge-858463413507/minecraft-server.zip ."

# Unzip server
sudo -u ubuntu bash -c "unzip ./minecraft-server.zip"

# Run server
nohup sudo -u ubuntu bash -c "./run.sh"
