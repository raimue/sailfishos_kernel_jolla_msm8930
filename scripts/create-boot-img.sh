#!/bin/sh

set -e

BOOTIMG=boot.img
RAMDISKFILE=ramdisk-sailfish.img

# Create ramdisk
echo "Creating dummy ramdisk.."
touch $RAMDISKFILE
gzip -f $RAMDISKFILE

echo "Creating $BOOTIMG.."

KERNEL=$(find `pwd`/arch/arm/boot/zImage)

${BINARY_PATH}mkbootimg --kernel $KERNEL --ramdisk ${RAMDISKFILE}.gz --cmdline "init=/sbin/preinit root=/dev/mmcblk0p28 rootfstype=btrfs rootflags=recovery noinitrd androidboot.hardware=qcom user_debug=31 ehci-hcd.park=3 maxcpus=2" --base 0x00000000 --pagesize 2048 --kernel_offset 0x80208000 --ramdisk_offset 0x82200000 --second_offset 0x81100000 --tags_offset 0x80200100 --board '' -o $BOOTIMG

echo "Cleaning up.."
rm $RAMDISKFILE*

exit 0
