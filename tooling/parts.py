class FirmwarePart:
    def __init__(self, name, offset, size):
        self.name = name
        self.offset = offset
        self.size = size

# here's something noteworthy!
# add a number to indicate which part goes where.
# therefore, the reasembly process can automatically figure out "okay, this goes after that."
# oh and it also needs it defined since it's a 1 line cat command and REALLY stupid.
# i'll tag the files properly eventually

parts_2104_old = [ 
    # | DECIMAL       HEXADECIMAL     DESCRIPTION
    # | --------------------------------------------------------------------------------
    # | 179492        0x2BD24         CRC32 polynomial table, little endian
    # | 188072        0x2DEA8         CRC32 polynomial table, little endian
    # | 254436        0x3E1E4         uImage header, header size: 64 bytes, header CRC: 0x9B736D43, created: 2018-05-07 09:33:13, image size: 2447832 bytes, Data Address: 0x80008000, Entry Point: 0x80008000, data CRC: 0x5BC362AD, OS: Linux, CPU: ARM, image type: OS Kernel Image, compression type: none, image name: "Linux-3.10.0"
    # | 254500        0x3E224         Linux kernel ARM boot executable zImage (little-endian)
    # | 262524        0x4017C         LZMA compressed data, properties: 0x5D, dictionary size: 67108864 bytes, uncompressed size: -1 bytes
    # | 2702364       0x293C1C        Squashfs filesystem, little endian, version 4.0, compression:xz, size: 3055438 bytes, 743 inodes, blocksize: 65536 bytes, created: 2018-08-15 02:41:20
    # | 5757980       0x57DC1C        Squashfs filesystem, little endian, version 4.0, compression:xz, size: 9790668 bytes, 475 inodes, blocksize: 131072 bytes, created: 2019-08-09 09:34:06
    # | 15551516      0xED4C1C        JPEG image data, JFIF standard 1.02
    # | 15587589      0xEDD905        Squashfs filesystem, little endian, version 4.0, compression:xz, size: 4758152 bytes, 331 inodes, blocksize: 131072 bytes, created: 2019-05-20 08:13:06
    #
    FirmwarePart("RSUP_Header", 0x0, 0x2BD24),
    FirmwarePart("CRC_table_A", 0x2BD24, 0x2184),
    FirmwarePart("CRC_table_B", 0x2DEA8, 0x1033C),
    FirmwarePart("uImage_header", 0x3E1E4, 0x40),
    FirmwarePart("Linux_kernel_zImage", 0x3E224, 0x1F58),
    FirmwarePart("LZMA_misc_we_dont_care", 0x4017C, 0x253AA0),
    FirmwarePart("Squashfs_rootfs_1", 0x293C1C, 0x2EA000),
    FirmwarePart("Squashfs_rootfs_2", 0x57DC1C, 0x957000),
    FirmwarePart("JPEG_image_ignore_this", 0xED4C1C, 0x8CE9),
    FirmwarePart("Squashfs_rootfs_3", 0xEDD905, 0x1367905 - 0xEDD905),
]

parts_2104 = [
    # instead of binwalk, i went ahead and worked on decoding the inbuilt partition table in the RSUp header, following the magic string @ 0x00 
    FirmwarePart("0_RSUP_Header", 0x0, 0x398),
    FirmwarePart("1_cmdline", 0x398, 0x200),
    FirmwarePart("2_binary_1", 0x598, 0x3dc4c),
    FirmwarePart("3_kernel", 0x3E1E4, 0x255a38),
    FirmwarePart("4_Squashfs_rootfs", 0x293C1C, 0x2EA000),
    FirmwarePart("5_Squashfs_app", 0x57DC1C, 0x957000),
    FirmwarePart("6_bootlogo", 0xED4C1C, 0x8CE9),
    FirmwarePart("7_Squashfs_www", 0xEDD905, 0x48a000),
]
