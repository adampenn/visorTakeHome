#!/usr/bin/python3

try:
  import Image
except ImportError:
  from PIL import Image
import pytesseract
import sys

fp = open('image_text', 'w')
fp.write(pytesseract.image_to_string(Image.open(sys.argv[1])))
fp.close()
 
