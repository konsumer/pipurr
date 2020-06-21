# This file records all the tasks I use to build the disk-image

.PHONY: help download emulate bash purrdata pipurr

# These are from the pi download-page
SUM_IMAGE=f5786604be4b41e292c5b3c711e2efa64b25a5b51869ea8313d58da0b46afc64
ZIP=raspios_lite_armhf_latest
IMAGE=2020-05-27-raspios-buster-lite-armhf.img

# name of purr-data deb
PURRDEB=pd-l2ork-2.11.0-20200611-rev.aceceeb4-armv7l.deb

DATESTAMP=$(shell date +%Y-%m-%d)

# name of image I distro
OUTPUT_IMAGE=pipurr-buster-${DATESTAMP}.img


help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

# this takes a long time, so keep the file around
purrdata: ${PURRDEB} ## Build a purr-data deb for pi

download: ${IMAGE} ## Download & verify raspbiOS-lite disk image

emulate: ${OUTPUT_IMAGE} ## Fully emulate a pi running the current image
	@docker run -it -v ${PWD}/${IMAGE}:/sdcard/filesystem.img lukechilds/dockerpi

bash: ${IMAGE} ## Run bash inside chroot
	@mkdir -p work
	sudo ./builder/chroot.sh "${PWD}/${IMAGE}" "${PWD}/work" bash

pipurr: ${OUTPUT_IMAGE} ## Create image-file for distribution


# create the actual disk image
${OUTPUT_IMAGE}: ${PURRDEB} ${IMAGE} 
	@mkdir -p work
	@cp "${IMAGE}" "${PWD}/${OUTPUT_IMAGE}"
	sudo ./builder/resize_image.sh "${PWD}/${OUTPUT_IMAGE}" 3G
	sudo ./builder/chroot.sh "${PWD}/${OUTPUT_IMAGE}" "${PWD}/work" bash /usr/rpi/builder/setup_image.sh


# build the actual deb
${PURRDEB}:
	@docker run -it --rm \
		-v $(PWD):/usr/rpi \
		arm32v7/debian:buster-slim \
		bash /usr/rpi/builder/build_purr.sh

# get the zip-file & verify
${ZIP}: 
	@wget https://downloads.raspberrypi.org/${ZIP}
	@if [ "$(shell shasum -b -a 256 ${ZIP})" != "${SUM_IMAGE} \*${ZIP}" ]; then echo "Image not verified."; exit 1; fi

# extract the disk-image
${IMAGE}: ${ZIP}
	@unzip -n ${ZIP}
