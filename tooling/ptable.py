import subprocess

commit_hash = subprocess.run(['git', 'rev-parse', '--short', 'HEAD'], capture_output=True, text=True)r
global_version = "V" + commit_hash

class PartitionTableEntry:
    def __init__(self, offset, size):
        self.version = global_version
        self.offset = offset
        self.size = size
        self.raw = None
    
    def calculateRaw(self):
        

