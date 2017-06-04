#!/usr/bin/python3

try:
  import Image
except ImportError:
  from PIL import Image
import pytesseract
import sys
import os
import shlex
import subprocess
import csv
from subprocess import Popen, PIPE


def convert_image(filename):
  # open a file to store the output of the file being determined
  try:
    fp = open('../image_text', 'w')
    fp.write(pytesseract.image_to_string(Image.open(filename)))
    fp.close()
    return True, ""
  except IOError as err:
    error_message = "could not read {0}: {1}".format(filename, err)
    print(error_message)
    return False, error_message


def run_sub_prog(cmd):
  args = shlex.split(cmd)
  if "display" in cmd:
    proc = Popen(args, stdout=PIPE, stderr=PIPE)
    return proc
  else:
    proc = Popen(args, stdout=PIPE, stderr=PIPE)
    out, err = proc.communicate()
    return proc, out, err



# check for user input -- error if non given
if len(sys.argv) != 2:
  print("No input file directory given")
  print("Usage: python3 readimages.py <dir of images>")
  sys.exit()

# set the path for tesseract
pytesseract.pytesseract.tesseract_cmd = '/usr/bin/tesseract'

# create CSV for result output
with open('analysis.csv', 'w', newline='') as csvfile:
  analysis = csv.writer(csvfile, delimiter='\t')
  analysis.writerow(['Filename', 'Catagory', 'Error', 'Customer Name'])

  # analyse files
  os.chdir(sys.argv[1])
  for filename in os.listdir("."):
    print("\nWorking on: " + filename);
    converted, err = convert_image(filename)
    if converted:
      proc, result, err = run_sub_prog("../file_type_nbc.rb image_text")
      proc = run_sub_prog(("display -resize 750x750 -geometry 750x750 " + filename))
      print("image catogarized as " + result.decode().rstrip())
      input("Hit enter to exit the image\n")
      proc.kill()
      os.remove("../image_text")
      analysis.writerow([filename, result.decode().rstrip(), 'NONE', 'FINISH THIS NAME'])
    else:
      analysis.writerow([filename, 'N/A', err, 'N/A'])



