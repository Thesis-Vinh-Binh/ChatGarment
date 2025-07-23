import csv
import json
import os

def csv_to_json(csv_path, json_path):
    data = []
    
    with open(csv_path, mode='r', encoding='utf-8') as csvfile:
        reader = csv.DictReader(csvfile)
        for row in reader:
            data.append({
                "image": row["filename"],
                "caption": row["caption"]
            })

    with open(json_path, mode='w', encoding='utf-8') as jsonfile:
        json.dump(data, jsonfile, indent=2, ensure_ascii=False)

    print(f"JSON file saved to: {json_path}")

# Example usage
csv_file_path = 'captions.csv'       # Replace with your actual CSV file path
json_file_path = 'captions.json'         # Desired output JSON file
csv_to_json(csv_file_path, json_file_path)
