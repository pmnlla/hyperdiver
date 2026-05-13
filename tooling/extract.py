import sys

from parts import parts_2104
def extract_parts(firmware_path, output_dir):
    if sys.argv[1] == "2104":
        parts = parts_2104
    else:
        print("Unsupported firmware version")
        return
    with open(firmware_path, "rb") as f:
        for part in parts:
            outfile = open("build/" + output_dir + "/" + part.name, "wb")
            f.seek(part.offset)
            data = f.read(part.size)
            outfile.write(data)
            outfile.close()
            print(f"Extracted {part.name} to {output_dir}/{part.name}")

if __name__ == "__main__":
    if len(sys.argv) != 4:
        print("Usage: python extract.py <firmware_version> <firmware_path> <output_dir>")
        print(sys.argv)
        sys.exit(1)
    extract_parts(sys.argv[2], sys.argv[3])