#!/bin/bash
DRIVE=/dev/sdc
#DRIVE=./zzz

echo 
echo "============= START ============"

umount "${DRIVE}1"
umount "${DRIVE}2"

umount -f "${DRIVE}1"
umount -f "${DRIVE}2"

mkdir -p ./1
mkdir -p ./2

parted "${DRIVE}" print

hdparm -g "${DRIVE}"

echo 
echo "will destroy all data on device: ${DRIVE}"
read
echo "really?"
read
echo "very well!"
read

###################################

echo 
echo "=== erase start (MBR) of the drive"
#dd if=/dev/zero bs=512 count=16384 of="${DRIVE}"
dd if=/dev/zero bs=512 count=10000 oseek=0 conv=notrunc of="${DRIVE}"

echo 
echo "=== partion drive to the first partion start at sector 63 (second cylinder OR second head), 2nd partition to end of the drive"

SECTOR_NUM=$(LANG=C fdisk -l /dev/sdc 2> /dev/null | grep " bytes, " | sed  "s/.* bytes, \(.*\) sectors.*/\1/")

echo "number of sectors $SECTOR_NUM"

if [ "${SECTOR_NUM}" -ge 4294967295 ] ; then
SECTOR_NUM="4294967295s"
else
SECTOR_NUM="-1s"
fi

#originalne 327679s

#exit

cat <<EOF | parted -a none "${DRIVE}"
mklabel msdos
unit s
mkpart primary 63s 1527679s
type 1 6
mkpart primary ext4 1527680s "${SECTOR_NUM}"
set 1 boot on
quit
EOF

#exit

#fat16 type uses 0xe (LBA), use 6 (CHS)

echo 
echo "=== write syslinux MBR code, partition table will survive"
dd if=/usr/share/syslinux/mbr.bin conv=notrunc of="${DRIVE}"

echo 
echo "=== patch CHS start"
echo -e -n "\x01\x01\x00" | dd bs=1 count=3 oseek=$((0x1bf)) conv=notrunc of="${DRIVE}"

echo 
echo "=== print MBR"
parted "${DRIVE}" -- print

######################## INSTALL partition 1

echo 
echo "=== format partition 1"
mkdosfs -v -F 16 "${DRIVE}1"

echo 
echo "=== mount partition 1"
mount -o noexec,fmask=111 "${DRIVE}1" ./1

######## boot base

#NOTICE must be first thing copied
cp ./boot_v6.base/IO.SYS ./1/		
#NOTICE must be second thing copied
cp ./boot_v6.base/MSDOS.SYS ./1/	

#########cp ./boot_v6.base/COMMAND.COM ./1/
#######3#mkdir -p ./1/boot
##########mkdir -p ./1/boot/bin

## exclude IO+MSDOS
rsync -a -H -A -X --open-noatime --exclude ./boot_v6.base/IO.SYS --exclude ./boot_v6.base/MSDOS.SYS ./boot_v6.base/ ./1/

cp /usr/share/syslinux/cpuid.c32 ./1/boot/bin
cp /usr/share/syslinux/menu.c32 ./1/boot/bin
cp /usr/share/syslinux/sysdump.c32 ./1/boot/bin
cp /usr/share/syslinux/reboot.c32 ./1/boot/bin
cp /usr/share/syslinux/pcitest.c32 ./1/boot/bin
cp /usr/share/syslinux/meminfo.c32 ./1/boot/bin
cp /usr/share/syslinux/linux.c32 ./1/boot/bin
cp /usr/share/syslinux/isolinux.bin ./1/boot/bin
cp /usr/share/syslinux/cmd.c32 ./1/boot/bin
cp /usr/share/syslinux/config.c32 ./1/boot/bin

######## boot patch

rsync -a -H -A -X --open-noatime --exclude ./boot_v6.base/IO.SYS --exclude ./boot_v6.base/MSDOS.SYS ./boot_v6.patch/ ./1/

cp ./0_kernel/boot/System.map ./1/boot/
cp ./0_kernel/boot/vmlinuz ./1/boot/

umount "${DRIVE}1"

######################## INSTALL partition 2

echo 
echo "=== format partition 2"
mkfs.ext4 -q -F "${DRIVE}2"

echo 
echo "=== mount partition 2"
mount "${DRIVE}2" ./2

######## rootfs base

dd if=/dev/zero bs=$((1024*1024)) count=180 of=./2/linux.swap
chmod 0600 ./2/linux.swap
mkswap ./2/linux.swap

tar -xf ./rootfs.base/rootfs.tar -C ./2

######## rootfs patch

rsync -a -H -A -X --open-noatime ./rootfs.patch/ ./2/

mkdir -p ./2/lib/modules
cp -r ./0_kernel/lib/modules ./2/lib/

chmod -x ./2/etc/init.d/S81cupsd
chmod -x ./2/etc/init.d/S50dropbear

umount "${DRIVE}2"

######################## syslinux install

syslinux -i -d boot "${DRIVE}1"

exit

xxd -g 1 /dev/sdc | less
xxd -g 1 /dev/sdc1 | less
