BLOCKSIZE=65536
COMPRESSION="xz"
ROOTS=("RSUP_Header" "CRC_table_A" "CRC_table_B" "uImage_header" "Linux_kernel_zImage" "LZMA_misc_we_dont_care" "Squashfs_rootfs_1" "Squashfs_rootfs_2" "JPEG_image_ignore_this" "Squashfs_rootfs_3")
ROOTS_POST=("RSUP_Header" "CRC_table_A" "CRC_table_B" "uImage_header" "Linux_kernel_zImage" "LZMA_misc_we_dont_care" "../new-root.squashfs" "Squashfs_rootfs_2" "JPEG_image_ignore_this" "Squashfs_rootfs_3")

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
    rm -rf rootfs;
    rm new-root.squashfs
    cp -r ../rootfs .;
    echo "Creating root squashfs...."
    mksquashfs rootfs new-root.squashfs -comp $COMPRESSION -b $BLOCKSIZE
}

mkdir -p build;
cd build;
prereq

if [ "$1" = "squash" ]; then
    pack_squash
elif [ "$1" = "rsup" ]; then
    pack_squash
    rm update.bin
    for i in "${ROOTS_POST[@]}"; do
        cat roots/$i >> update.bin;
        echo "Wrote $i to update.bin";
    done;
fi

