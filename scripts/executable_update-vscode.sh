#!/bin/sh

TAR_FILE='/tmp/code-stable-x64.tar.gz'
DEST="/opt/vscode"

echo '\033[92m==> Downloading latest version...\033[0m'
wget -O $TAR_FILE 'https://code.visualstudio.com/sha/download?build=stable&os=linux-x64'
echo '\033[92m==> Unpacking...\033[0m'
tar -xvf $TAR_FILE -C $DEST --strip-components=1
rm $TAR_FILE
echo '\033[92m==> Done!\033[0m'

