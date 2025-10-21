import json
from collections import Counter

INPUT_FILE = "assets/parks_data_with_coords.json"
OUTPUT_FILE = "assets/parks_with_duplicate_camping.json"

def main():
    with open(INPUT_FILE, "r", encoding="utf-8") as f:
        parks = json.load(f)

    results = []

    for park in parks:
        experiences = park.get("experiences", [])
        counts = Counter(experiences)

        # Only flag if "Camping" appears more than once
        if counts.get("Camping", 0) > 1:
            results.append({
                "name": park.get("name", "Unknown Park"),
                "experiences": experiences
            })

    with open(OUTPUT_FILE, "w", encoding="utf-8") as f:
        json.dump(results, f, indent=2, ensure_ascii=False)

    print(f"✅ Found {len(results)} parks with duplicate 'Camping'. Saved to {OUTPUT_FILE}")

if __name__ == "__main__":
    main()
