import json
import shutil

from clickgen import build_cursor_theme

sizes = [24]

# Building Cursor Theme
with open('./hotspots.json', 'r') as hotspot_file:
    config = json.loads(hotspot_file.read())
    build_cursor_theme(name="macOS Big Sur", image_dir="./bitmaps",
                       cursor_sizes=sizes, out_path="out", archive=False, delay=30)
