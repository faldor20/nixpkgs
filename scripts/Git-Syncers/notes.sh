#!/usr/bin/env bash
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

cd $SCRIPT_DIR||exit
cd ../  

syncer="$PWD/git-sync.sh"

cd ~/Notes/study&&$syncer

cd ~/Notes/personal&&$syncer
echo "finished syncing"

