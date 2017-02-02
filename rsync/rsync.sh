#!/bin/bash
#This Script syncs a directory tree to a remote server
#It also specifies the path of where rsync is located on the remote server
TARGET_SERVER="<ENTER TARGET SERVER>"
TARGET_DIRECTORY="<ENTER TARGET DIRECTORY>"
LOCAL_DIRECTORY="<ENTER LOCAL DIRECTORY>"
REMOTE_RSYNC_PATH="<ENTER REMOTE RSYNC PATH>"

/opt/sfw/bin/rsync -zav $LOCAL_DIRECTORY $TARGET_SERVER:$TARGET_DIRECTORY --rsync-path=$REMOTE_RSYNC_PATH --delete

