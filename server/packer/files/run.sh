#!/bin/bash
cd /home/ubuntu/minecraft-server
java -Xms1024M -Xmx6144M -jar forgeserver.jar &
disown
