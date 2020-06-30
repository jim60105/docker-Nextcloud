#!/usr/bin/env sh
date +"%F %T"
mkdir -p /backup
cd /backup

echo "Stopping Container..."
su - root -c "docker stop  \$(docker ps -a -f 'label=nextcloud' -q)"

V=$(su - root -c "docker volume ls -f 'label=nextcloud' -q")
for i in ${V}
do
    echo "Restore ${i}..."
    su - root -c "docker run -v ${i}:/volume -v $PWD:/backup --rm loomchild/volume-backup restore ${i}.tar.bz2 -v"
done
