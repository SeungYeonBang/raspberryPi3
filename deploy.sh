# Flash Tegra image 
#
#!/bin/bash

skip_remove=0

if [ "x"$YOCTO_DIR = "x" ] || [ "x"$MACHINE = "x" ] || [ "x"$IMAGE = "x" ]; then
    echo "\$YOCTO_DIR = $YOCTO_DIR"
    echo "\$MACHINE = $MACHINE"
    echo "\$IMAGE = $IMAGE"
    echo ""
    echo "Please execute 'source env.sh' first...."
    exit
fi

if [ $# -eq 1 ]; then
    if [ $1 = '-i' ]; then
        skip_remove=1
    fi  
fi

image_file=$YOCTO_DIR/build/tmp/deploy/images/$MACHINE/$IMAGE-$MACHINE.wic.bz2
actual_file=`ls -al $image_file | awk '{print $11}'`
create_date=`echo $actual_file | tr "-" "." | awk '{split($0,arr,"."); printf("%s\n", arr[6]); }'`
output_file=/dev/sda

tmpdir=/tmp/flash_$create_date

echo "Flash $actual_file ...."

if [ $skip_remove -eq 0 ] && [ -d $tmpdir ]; then
    echo "remove previous $tmpdir...."
    sudo rm -rf $tmpdir
fi

if [ -d $tmpdir ]; then
    echo "$tmpdir already exist.. skip it.."
else
    mkdir -p $tmpdir
    echo "Create $tmpdir, Uncompressed..."

    umount $output_file* 
    cp -r $YOCTO_DIR/build/tmp/deploy/images/$MACHINE/$actual_file $tmpdir/

    bzip2 -dkf $tmpdir/$actual_file
fi

actual_wic_file=`${actual_file%????}`
echo "Flash from $tmpdir"
sudo dd if=$tmpdir/$actual_wic_file of=$output_file bs=4096 status=progress && sync

if [ $skip_remove -eq 0 ]; then
    echo "Removing temp directory $tmpdir"
    sudo rm -rf $tmpdir
fi
