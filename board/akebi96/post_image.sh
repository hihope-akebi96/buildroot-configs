#!/bin/bash

# clean up image folder
dont_remove_tbl=(
    Image.gz
    fip.bin
    partition_info.inc
    akebi96.dtb
    unph_bl.bin
    usb_update
    kernel.release
)

for file in `\find ${BINARIES_DIR} -maxdepth 1 -type f`; do
    found=0
    filename=`basename $file`
    for item in ${dont_remove_tbl[@]} ; do
        if [ "$filename" == "$item" ] ; then
            # echo "same : $item"
            found=1
        fi
    done
    if [ "$found" == "0" ] ; then 
        # echo "rm $file"
        rm -f $file
    fi
done
