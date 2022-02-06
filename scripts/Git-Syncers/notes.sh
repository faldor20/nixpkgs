#!/usr/bin/env bash
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

cd $SCRIPT_DIR||exit
cd ../  

syncer="$PWD/git-sync.sh"

# adding -n and -s make it ad new files and turns on sync

cd ~/Notes/study&&$syncer -n -s

cd ~/Notes/personal&&$syncer -n -s
echo "finished syncing"

