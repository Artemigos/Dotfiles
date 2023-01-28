#!/bin/python3

import requests

unicode_url = 'https://www.unicode.org/Public/UCD/latest/ucd/UnicodeData.txt'

ranges = []

ranges.append(range(0x2000, 0x206F)) # General Punctuation
ranges.append(range(0x2190, 0x21FF)) # Arrows
ranges.append(range(0x2200, 0x22FF)) # Mathematical Operators
ranges.append(range(0x2300, 0x23FF)) # Miscellaneous Technical
ranges.append(range(0x2400, 0x243F)) # Control Pictures
ranges.append(range(0x2460, 0x24FF)) # Enclosed Alphanumerics
ranges.append(range(0x2500, 0x257F)) # Box Drawing
ranges.append(range(0x2580, 0x259F)) # Block Elements
ranges.append(range(0x25A0, 0x25FF)) # Geometric Shapes
ranges.append(range(0x2600, 0x26FF)) # Miscellaneous Symbols
ranges.append(range(0x2700, 0x27BF)) # Dingbats
ranges.append(range(0x27C0, 0x27EF)) # Miscellaneous Mathematical Symbols-A
ranges.append(range(0x27F0, 0x27FF)) # Supplemental Arrows-A
ranges.append(range(0x2900, 0x297F)) # Supplemental Arrows-B
ranges.append(range(0x2980, 0x29FF)) # Miscellaneous Mathematical Symbols-B
ranges.append(range(0x2A00, 0x2AFF)) # Supplemental Mathematical Operators
ranges.append(range(0x2B00, 0x2BFF)) # Miscellaneous Symbols and Arrows
ranges.append(range(0x1F100, 0x1F1FF)) # Enclosed Alphanumeric Supplement
ranges.append(range(0x1F300, 0x1F5FF)) # Miscellaneous Symbols and Pictographs
ranges.append(range(0x1F600, 0x1F64F)) # Emoticons
ranges.append(range(0x1F650, 0x1F67F)) # Ornamental Dingbats
ranges.append(range(0x1F680, 0x1F6FF)) # Transport and Map Symbols
ranges.append(range(0x1F780, 0x1F7FF)) # Geometric Shapes Extended
ranges.append(range(0x1F800, 0x1F8FF)) # Supplemental Arrows-C
ranges.append(range(0x1F900, 0x1F9FF)) # Supplemental Symbols and Pictographs
ranges.append(range(0x1FA00, 0x1FA6F)) # Chess Symbols
ranges.append(range(0x1FA70, 0x1FAFF)) # Symbols and Pictographs Extended-A
ranges.append(range(0x1FB00, 0x1FBFF)) # Symbols for Legacy Computing

def in_range(num):
    for r in ranges:
        if num in r:
            return True
    return False

unicode_data = requests.get(unicode_url).text

print('return {')

for line in unicode_data.splitlines():
    segments = line.split(';')
    code = int(segments[0], base=16)
    if in_range(code):
        print(f'    ["{segments[1]}"] = "{chr(code)}",')

print('}')
