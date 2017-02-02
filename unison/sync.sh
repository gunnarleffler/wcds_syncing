#!/bin/bash

if [ $# -eq 0 ]
then
    echo "Error in $0 - Invalid Argument Count"
    echo "Syntax: $0 <node> [Unison Options]"
    exit
fi

TARGET_NODE=$1
shift
TARGET_MACHINE="wmlocal2"

#define synced directories
SYNC_DIR="DIRECTORY 1
DIRECTORY 2
"

SERVER="ssh://$TARGET_NODE-$TARGET_MACHINE.$TARGET_NODE.usace.army.mil"

# We want to only one instance of this is running at a time
# If we can create the lock file, all is well.
# If we cannot, check its age with perl's -M operator:
#   If it's older than two hours:
#     touch it to freshen it up, then proceed as normal
#   Otherwise, exit.

UNIQ=`echo $SYNC_DIR | sum | cut -f 1 -d " "`

export LOCK_DIR=/tmp/$UNIQ

export TOO_OLD=2

if mkdir $LOCK_DIR
then
  echo Lock obtained.
else
  echo Lock failed. Testing lock age.
  AGE=`perl -e 'printf "%d", ( -M "$ENV{LOCK_DIR}" ) * 24'`
  if [ $AGE -ge $TOO_OLD ]
  then
    echo Lock already $AGE hours old.  Refreshing.
    touch $LOCK_DIR
  else
    echo Lock only $AGE hours old \(not $TOO_OLD\).  Exiting.
    exit
  fi
fi

UNISON_FLAGS=""

#Loop Through sepcified directories and sync them with unison
for DIR in $SYNC_DIR
do
  /usr/bin/unison $UNISON_FLAGS $@ $DIR $SERVER/$DIR
done

echo "Removing Lock"
rmdir $LOCK_DIR
