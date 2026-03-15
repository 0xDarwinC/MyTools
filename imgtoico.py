import sys
import os
import time
from PIL import Image

def convert_to_ico(input_path):
    try:
        img = Image.open(input_path)
        
        base_name = os.path.splitext(input_path)[0]
        output_path = f"{base_name}.ico"
        
        icon_sizes = [(256, 256), (128, 128), (64, 64), (32, 32), (16, 16)]
        img.save(output_path, format='ICO', sizes=icon_sizes)
        print(f"[OK] {os.path.basename(output_path)}")
        
    except Exception as e:
        print(f"[ERROR] converting {os.path.basename(input_path)}: {e}")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Please drag and drop image files onto the provided batch script.")
        input("Press Enter to exit...")
        sys.exit(1)

    for file_path in sys.argv[1:]:
        if os.path.isfile(file_path):
            convert_to_ico(file_path)
            
    time.sleep(1.5)