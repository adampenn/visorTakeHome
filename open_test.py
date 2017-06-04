from PIL import Image
import sys
import subprocess

p = subprocess.Popen(["display", sys.argv[1]])
input("Give a name for image:")
p.kill()
