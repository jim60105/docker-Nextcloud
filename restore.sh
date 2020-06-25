#!/usr/bin/env sh
date +"%F %T"
mkdir -p /backup
cd /backup

echo "Starting Sync with backup server..."
su - root -c "mkdir -p ~/.ssh"
su - root -c "ssh-keyscan -p 22722 drive.maki0419.com >> ~/.ssh/known_hosts"
su - root -c "sshpass -f ~/ssh.pas rsync -e 'ssh -p 22722' -avz --no-p --no-g /backup/ rsync@drive.maki0419.com::NetBackup/docker_backup/"

echo "Stopping Container..."
su - root -c "docker stop  \$(docker ps -a -f 'label=nextcloud' -q)"

V=$(su - root -c "docker volume ls -f 'label=nextcloud' -q")
for i in ${V}
do
    echo "Restore ${i}..."
    su - root -c "docker run -v ${i}:/volume -v $PWD:/backup --rm loomchild/volume-backup restore ${i}.tar.bz2 -v"
done

echo "Starting Container..."
su - root -c "docker start \$(docker ps -a -f 'label=nextcloud' -q)"

