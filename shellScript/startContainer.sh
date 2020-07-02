#!/bin/bash

echo "Starting Container..."
su - root -c "docker start \$(docker ps -a -f 'label=proxy' -q)"
su - root -c "docker start \$(docker ps -a -f 'label=nextcloud' -q)"
