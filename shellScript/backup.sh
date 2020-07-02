#!/bin/bash

date +"%F %T"

scriptFolder="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Make or clean backup folder
mkdir -p /backup
cd /backup
rm -f *

source ${scriptFolder}/stopContainer.sh

V=$(su - root -c "docker volume ls -f 'label=proxy' -q && docker volume ls -f 'label=nextcloud' -q")
for i in ${V}
do
    echo "Backup ${i}..."
    su - root -c "docker run -v ${i}:/volume -v $PWD:/backup --rm loomchild/volume-backup backup -v -c gz ${i}"
done

source ${scriptFolder}/startContainer.sh
