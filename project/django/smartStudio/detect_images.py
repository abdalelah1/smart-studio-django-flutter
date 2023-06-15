import os
import hashlib
from collections import defaultdict
def calculate_hash(image_path):
    with open(image_path, 'rb') as f:
        image_data = f.read()
        hash_value = hashlib.md5(image_data).hexdigest()
    return hash_value
def find_duplicate_photos(directory):
    duplicates = defaultdict(list)

    for root, dirs, files in os.walk(directory):
        for filename in files:
            if filename.lower().endswith(('.jpg', '.jpeg', '.png')):
                image_path = os.path.join(root, filename)
                hash_value = calculate_hash(image_path)
                duplicates[hash_value].append(image_path)

    duplicates = {hash_value: image_list for hash_value, image_list in duplicates.items() if len(image_list) > 1}

    return duplicates
directory_path = 'photos'
duplicate_photos = find_duplicate_photos(directory_path)

for hash_value, image_list in duplicate_photos.items():
    print(f"Duplicate images with hash {hash_value}:")
    for image_path in image_list:
        print(image_path)
    print() 