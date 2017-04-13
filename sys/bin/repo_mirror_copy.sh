#!/bin/bash

OLD_REPO=$1
OLD_REPO_NAME=$(echo $OLD_REPO | cut -d "/" -f 2)
NEW_REPO=$2
NEW_REPO_NAME=$(echo $NEW_REPO | cut -d "/" -f 2)


echo "-> Mirroring $OLD_REPO to $NEW_REPO"

echo "-> Bare cloning old repo"
git clone --bare $OLD_REPO

echo "-> Pushing old repo to new repo"
cd $OLD_REPO_NAME
git push --mirror $NEW_REPO

echo "-> Deleting old repo directory"
cd ..
rm -Rf $OLD_REPO_NAME

echo "-> Done"
