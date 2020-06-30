#!/usr/bin/env sh
date +"%F %T"
mkdir -p /backup
cd /backup
# remove /home/user/docker_backup/data
rm -f *
# Switch to root privileges. my system is set to only run Docker as root 
echo "Stopping Container..."
su - root -c "docker stop  \$(docker ps -a -f 'label=nextcloud' -q)"

V=$(su - root -c "docker volume ls -f 'label=nextcloud' -q")
for i in ${V}
do
    echo "Backup ${i}..."
    su - root -c "docker run -v ${i}:/volume -v $PWD:/backup --rm loomchild/volume-backup backup ${i}.tar.bz2 -v"
done

echo "Starting Container..."
su - root -c "docker start \$(docker ps -a -f 'label=nextcloud' -q)"
