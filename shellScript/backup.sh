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
    su - root -c "docker run -v ${i}:/volume -v $PWD:/backup --rm loomchild/volume-backup backup -v -c gz ${i}"
done

echo "Starting Container..."
su - root -c "docker start \$(docker ps -a -f 'label=nextcloud' -q)"

echo "Starting Transfer to backup server..."
su - root -c "mkdir -p ~/.ssh"
su - root -c "ssh-keyscan -p 22 rsync.domain.com >> ~/.ssh/known_hosts"
su - root -c "sshpass -f ~/ssh.pas rsync -e 'ssh -p 22' -avz --no-p --no-g /backup/ rsync@rsync.domain.com::NetBackup/docker_backup/"
