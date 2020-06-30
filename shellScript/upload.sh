#!/usr/bin/env sh
date +"%F %T"
echo "Starting Transfer to backup server..."
su - root -c "mkdir -p ~/.ssh"
su - root -c "ssh-keyscan -p 22 rsync.domain.com >> ~/.ssh/known_hosts"
su - root -c "sshpass -f ~/ssh.pas rsync -e 'ssh -p 22' -avz --no-p --no-g /backup/ rsync@rsync.domain.com::NetBackup/docker_backup/"
