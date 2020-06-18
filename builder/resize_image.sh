#!/bin/bash

# resize the root partion to fill the disk-image
# TODO: doesn't seem to be working

if (( $# < 2 )); then
  echo "Usage: resize_image.sh IMAGE_FILE NEW_SIZE"
  exit 1
fi

IMAGE=$1
NEW_SIZE=$2 

dd if=/dev/zero of=/tmp/filler bs=1 count=1 seek=${NEW_SIZE}
cat /tmp/filler >> "${IMAGE}"
rm /tmp/filler

LOOP=$(losetup --partscan --find --show "${IMAGE}")
parted ${LOOP} resizepart 2 ${NEW_SIZE}
resize2fs -M ${LOOP}p2
e2fsck -f -y ${LOOP}p2
losetup --detach $LOOP
