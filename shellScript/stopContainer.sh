#!/usr/bin/env sh

# Switch to root privileges. my system is set to only run Docker as root 
echo "Stopping Container..."
su - root -c "docker stop  \$(docker ps -a -f 'label=nextcloud' -q)"