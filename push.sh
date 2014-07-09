#!/bin/bash

set -e
set -x

GIT=`dirname $0`/git.sh

CERT=$1
CLONEOPTION=$2
REPO=$3
BRANCH=$4
DIR=$5
FORMAT=$6

cd $DIR

SOURCE_REV=`git rev-parse HEAD | cut -c1-9`
SOURCE_BRANCH=`git branch --no-color | cut -c3-`
SOURCE_MSG=`git log -1 --pretty=%B`

COMMIT_MSG=$FORMAT
COMMIT_MSG="${COMMIT_MSG//%REV%/$SOURCE_REV}"
COMMIT_MSG="${COMMIT_MSG//%MSG%/$SOURCE_MSG}"
COMMIT_MSG="${COMMIT_MSG//%BRANCH%/$SOURCE_BRANCH}"

# TMPDIR=`mktemp -d -t push` # for mac
TMPDIR=`mktemp -d` # for linux
cp -r $DIR $TMPDIR/it
rm -rf $TMPDIR/it/.git $TMPDIR/it/.git*

case $CLONEOPTION in
	clone)
		sh $GIT -i $CERT clone $REPO $TMPDIR/clone
		mv $TMPDIR/clone/.git $TMPDIR/it/
		cd $TMPDIR/it/
		git add --all --force
		git commit -m "$COMMIT_MSG"
		sh $GIT -i $CERT push origin master:$BRANCH
		;;
	noclone)
		cd $TMPDIR/it/
		git init
		git add remote origin $REPO
		git add --all --force
		git commit -m "$COMMIT_MSG"
		sh $GIT -i $CERT push -f origin master:$BRANCH
		;;
esac
