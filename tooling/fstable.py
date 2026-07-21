import re, sys

# Rewrite the RSUp partition table from build/fsfollow.
# Table: 7 entries at 0x11C, stride 0x5C; each is offset(LE u32), size(LE u32).
# Entry for part N (1_cmdline..7_www) lives at 0x11C+(N-1)*0x5C. 0_RSUP_Header has no slot.

fsfollow = sys.argv[1] if len(sys.argv) > 1 else "build/fsfollow"
image = sys.argv[2] if len(sys.argv) > 2 else "build/update.bin"

with open(image, "r+b") as img:
    for name, off, size in re.findall(r"'(\d+_[^']*)',\s*'([0-9A-Fa-f]+)',\s*'([0-9A-Fa-f]+)'", open(fsfollow).read()):
        n = int(name.split("_")[0])
        if n == 0:
            continue
        field = 0x11C + (n - 1) * 0x5C
        img.seek(field)
        img.write(int(off, 16).to_bytes(4, "little"))
        img.write(int(size, 16).to_bytes(4, "little"))
        print(f"{name}: offset 0x{off} size 0x{size} -> field 0x{field:X}")
