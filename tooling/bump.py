import argparse
from enum import Enum
import zlib
import shutil
from datetime import date


class Endianess(Enum):
    BIG = 'big'
    LITTLE = 'little'

def InjectVersionBump(filepath):
    offset = 0x228
    today = date.today().strftime('%y%m%d')
    version = "V" + today
    version = version.encode("utf-8")
    try:
        shutil.copy(filepath, filepath + ".bumped")
        with open(filepath + ".bumped", "r+b") as image:
            image.seek(offset)
            old_version = image.read(8)
            image.seek(offset)
            image.write(version)
            print(f"Replaced {old_version.hex()} with {version} at {hex(offset)}")
    except Exception as e:
        raise(e)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
                    prog='Raysharp CRC32 signed',
                    description='Bumps RSUp OTA images for the LHA2104 series',
                    epilog='wub wub')
    parser.add_argument('-f', '--filename')
    args = parser.parse_args()
    InjectVersionBump(args.filename)
