#!/usr/bin/env bash
cd backup
# Switch to root privileges. my system is set to only run Docker as root 
su - root -c "docker stop  \$(docker ps -a -f 'label=nextcloud' -q)" >/dev/null

V=$(su - root -c "docker volume ls -f 'label=nextcloud' -q")
for i in ${V}
do
    su - root -c "docker run -v ${i}:/volume -v $PWD:/backup --rm loomchild/volume-backup restore ${i}.tar.bz2 -v"
done

su - root -c "docker start \$(docker ps -a -f 'label=nextcloud' -q)" >/dev/null
