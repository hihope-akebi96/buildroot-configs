#!/bin/bash

# Copy kernel.release
kernel_release=`find ${BUILD_DIR}/linux* -name kernel.release`
if [ ! -z ${kernel_release} ]; then
    cp -f ${kernel_release} $BINARIES_DIR/kernel.release
fi
