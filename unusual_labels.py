import json

INPUT_FILE = "assets/parks_data_with_coords.json"
OUTPUT_FILE = "assets/parks_with_unusual_labels2.json"

# Define the "weird" labels you want to track
UNUSUAL_EXPERIENCES = {
    "Camping, Devel. Group",
}

UNUSUAL_AMENITIES = {
    
}

def main():
    with open(INPUT_FILE, "r", encoding="utf-8") as f:
        parks = json.load(f)

    results = []

    for park in parks:
        park_name = park.get("name", "Unknown Park")
        found = []

        # Check experiences
        for e in park.get("experiences", []):
            if e in UNUSUAL_EXPERIENCES:
                found.append({"type": "experience", "value": e})

        # Check amenities
        for a in park.get("amenities", []):
            if a in UNUSUAL_AMENITIES:
                found.append({"type": "amenity", "value": a})

        if found:
            results.append({
                "name": park_name,
                "issues": found
            })

    # Save results
    with open(OUTPUT_FILE, "w", encoding="utf-8") as f:
        json.dump(results, f, indent=2, ensure_ascii=False)

    print(f"✅ Found {len(results)} parks with unusual labels. Saved to {OUTPUT_FILE}")

if __name__ == "__main__":
    main()
