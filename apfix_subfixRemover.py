import os

# Change '.' to the target folder if needed
directory = '.'

print(f"Scanning directory: {os.path.abspath(directory)}")

found = False

for filename in os.listdir(directory):
    file_path = os.path.join(directory, filename)

    if os.path.isfile(file_path):  # Only process files
        name, ext = os.path.splitext(filename)
        if name.endswith('_apfix'):
            found = True
            new_name = name[:-6] + ext
            new_path = os.path.join(directory, new_name)
            os.rename(file_path, new_path)
            print(f'Renamed: {filename} -> {new_name}')
        else:
            print(f'Skipped (no _apfix): {filename}')
    else:
        print(f'Skipped (not a file): {filename}')

if not found:
    print("No files ending with '_apfix' found.")
