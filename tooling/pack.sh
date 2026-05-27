BLOCKSIZE=65536
COMPRESSION="xz"
#ROOTS=("RSUP_Header" "CRC_table_A" "CRC_table_B" "uImage_header" "Linux_kernel_zImage" "LZMA_misc_we_dont_care" "Squashfs_rootfs_1" "Squashfs_rootfs_2" "JPEG_image_ignore_this" "Squashfs_rootfs_3")
#ROOTS_POST=("RSUP_Header" "CRC_table_A" "CRC_table_B" "uImage_header" "Linux_kernel_zImage" "LZMA_misc_we_dont_care" "../new-root.squashfs" "Squashfs_rootfs_2" "JPEG_image_ignore_this" "Squashfs_rootfs_3")

prereq() {
    for file in "${ROOTS[@]}"; do
        if [ -f "roots/$file" ]; then
            echo "$file exists.";
        else
            echo "$file is missing. Re-extracting";
            mkdir roots;
            cp ../firmware.bin .
            ln -s ../tooling .
            mise x -- uv run tooling/extract.py 2104 firmware.bin roots;
            break;
        fi
    done;
    if [ ! -d "../rootfs" ]; then
        echo "Rootfs not found. Extracting...";
        unsquashfs -d ../rootfs roots/Squashfs_rootfs_1;
    fi
}

pack_squash() {
    rm -f rootfs;
    rm roots/4_Squashfs_rootfs
    ln -s ../rootfs .;
    echo "Creating root squashfs...."
    mksquashfs rootfs/. roots/4_Squashfs_rootfs -comp $COMPRESSION -b $BLOCKSIZE
}

mkdir -p build;
cd build;
prereq

if [ "$1" = "squash" ]; then
    pack_squash
elif [ "$1" = "rsup" ]; then
    pack_squash
    rm update.bin
    echo "{" > ./fsfollow
    for i in $(ls roots/); do
        cat roots/$i >> update.bin;
        SIZE=$(stat -c %s roots/$i);
        OFFSET=$(echo "obase=16; $(($(stat -c %s update.bin)-$SIZE))" | bc);
        SIZE=$(echo "obase=16; $SIZE" | bc);
        ../tooling/glorify.sh alert info "wrote $i - size 0x$SIZE - offset 0x$OFFSET";
        echo "{'$i', '$OFFSET', '$SIZE'}," >> ./fsfollow
    done
    echo "{'EOF', '0', '0'}" >> ./fsfollow # since we assume every entry isn't the last, i need this block to make json not shit itself. can you tell this is budged together? i can't!
    echo "}" >> ./fsfollow
    ../tooling/glorify.sh alert info "Packed!";
    #for i in "${ROOTS_POST[@]}"; do
    #    cat roots/$i >> update.bin;
    #    echo "Wrote $i to update.bin";
    #done;
fi

