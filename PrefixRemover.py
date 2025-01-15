import os
import re

# music directory
directory = r"directory here"

# change as needed. Currently strips 1. format and 01-01. format for track num. docs: https://docs.python.org/3/library/re.html
pattern = r"^\d+(\-\d+)?\.\s"

for filename in os.listdir(directory):
    new_name = re.sub(pattern, "", filename)
    if new_name != filename:
        old_path = os.path.join(directory, filename)
        new_path = os.path.join(directory, new_name)
        os.rename(old_path, new_path)
        print(f"Renamed: '{filename}' -> '{new_name}'")