#!/usr/bin/python3
import os, readline, atexit
python_history = os.path.join(os.environ['HOME'], '.python_history')
try:
  readline.read_history_file(python_history)
  readline.parse_and_bind("tab: complete")
  readline.set_history_length(5000)
  atexit.register(readline.write_history_file, python_history)
except IOError:
  pass
del os, python_history, readline, atexit 
