#!/usr/bin/python3

try:
  import Image
except ImportError:
  from PIL import Image
import pytesseract
import os

pytesseract.pytesseract.tesseract_cmd = '/usr/bin/tesseract'

os.chdir('/home/adam/visor_take_home/w2_learn_files')

f = open('W2_Learn_File.txt', 'w')

for filename in os.listdir('/home/adam/visor_take_home/w2_learn_files'):
  if str(filename) != "W2_Learn_File.txt":
    print("reading file: " + filename)
    f.write(pytesseract.image_to_string(Image.open(filename)))


os.chdir('/home/adam/visor_take_home/1099_learn_files')

f = open('1099_Learn_File.txt', 'w')

for filename in os.listdir('/home/adam/visor_take_home/1099_learn_files'):
  if str(filename) != "1099_Learn_File.txt":
    print("reading file: " + filename)
    f.write(pytesseract.image_to_string(Image.open(filename)))



