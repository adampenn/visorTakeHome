#!/usr/bin/python3

try:
  import Image
except ImportError:
  from PIL import Image
import pytesseract
import os
import sys

pytesseract.pytesseract.tesseract_cmd = '/usr/bin/tesseract'

# check for user input -- error if non given
if len(sys.argv) != 3:
  print("Usage: python3 readimages.py <dir of images> <output file>")
  sys.exit()

os.chdir(sys.argv[1])

f = open(sys.argv[2], 'w')

for filename in os.listdir(sys.argv[1]):
  if str(filename) != sys.argv[2]:
    print("reading file: " + filename)
    f.write(pytesseract.image_to_string(Image.open(filename)))
f.close()

