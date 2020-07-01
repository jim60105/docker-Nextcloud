#!/usr/bin/env sh

echo "Starting Container..."
su - root -c "docker start \$(docker ps -a -f 'label=nextcloud' -q)"