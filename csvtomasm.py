import csv
import sys

# Standard Windows 16-color palette (approximate hex values)
WINDOWS_PALETTE = {
    0: (0, 0, 0),       # Black
    1: (0, 0, 128),     # Blue
    2: (0, 128, 0),     # Green
    3: (0, 128, 128),   # Cyan
    4: (128, 0, 0),     # Red
    5: (128, 0, 128),   # Magenta
    6: (128, 128, 0),   # Brown/Yellow
    7: (192, 192, 192), # Light Gray
    8: (128, 128, 128), # Dark Gray
    9: (0, 0, 255),     # Light Blue
    10: (0, 255, 0),    # Light Green
    11: (0, 255, 255),  # Light Cyan
    12: (255, 0, 0),    # Light Red
    13: (255, 0, 255),  # Light Magenta
    14: (255, 255, 0),  # Yellow
    15: (255, 255, 255) # White
}

def hex_to_rgb(hex_str):
    hex_str = hex_str.lstrip('#')
    return tuple(int(hex_str[i:i+2], 16) for i in (0, 2, 4))

def get_closest_color(hex_str):
    rgb = hex_to_rgb(hex_str)
    # Euclidean distance to find closest palette match
    closest_code = 0
    min_dist = float('inf')
    for code, p_rgb in WINDOWS_PALETTE.items():
        dist = sum((rgb[i] - p_rgb[i])**2 for i in range(3))
        if dist < min_dist:
            min_dist = dist
            closest_code = code
    return closest_code

def convert_csv_to_masm(input_file, output_file, label_name="ascii_art"):
    cells = []
    max_x, max_y = 0, 0

    with open(input_file, mode='r') as f:
        reader = csv.DictReader(f)
        for row in reader:
            x, y = int(row['X']), int(row['Y'])
            char_code = int(row['ASCII'])
            fg = get_closest_color(row['Foreground'])
            bg = get_closest_color(row['Background'])
            attr_byte = (bg << 4) | fg
            cells.append(((x, y), char_code, attr_byte))
            max_x = max(max_x, x)
            max_y = max(max_y, y)

    cells.sort(key=lambda c: (c[0][1], c[0][0]))
    width = max_x + 1

    with open(output_file, 'w') as f:
        f.write(f"; Dimensions: {width}x{max_y + 1}\n")
        f.write(f"{sys.argv[1]}_width DWORD {width}\n")
        f.write(f"{sys.argv[1]}_height DWORD {max_y + 1}\n")

        if len(sys.argv) > 4:
            f.write(f"{sys.argv[1]}_cellheight DWORD {sys.argv[4]}\n")

        if len(sys.argv) > 5:
            f.write(f"{sys.argv[1]}_cellwidth DWORD {sys.argv[5]}\n")

        f.write(f"\n")
        
        for i, (pos, char, attr) in enumerate(cells):
            # If it's the first byte, add the label. Otherwise, just indent.
            prefix = f"{sys.argv[1]}_{label_name} db " if i == 0 else "           db "
            
            # Every line starts its own 'db' directive
            
            comma = "," if (i + 1) % width != 0 and (i + 1) < len(cells) else ""
            
            # Format: Char, Attribute
            f.write(f"{prefix}0{char:02X}h, 0{attr:02X}h\n")

if __name__ == "__main__":
    convert_csv_to_masm(sys.argv[2], sys.argv[3])
    print(f"Conversion complete. Output saved to {sys.argv[3]}")
    