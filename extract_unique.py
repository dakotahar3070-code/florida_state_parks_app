import json

# Input and output file paths
INPUT_FILE = "assets/parks_data_with_coords.json"
OUTPUT_FILE = "assets/unique_amenities_experiences.json"

def main():
    # Load the parks data
    with open(INPUT_FILE, "r", encoding="utf-8") as f:
        parks = json.load(f)

    # Use sets to collect unique values
    experiences_set = set()
    amenities_set = set()

    for park in parks:
        # Collect experiences
        if "experiences" in park and isinstance(park["experiences"], list):
            experiences_set.update(park["experiences"])

        # Collect amenities
        if "amenities" in park and isinstance(park["amenities"], list):
            amenities_set.update(park["amenities"])

    # Sort them alphabetically
    experiences = sorted(experiences_set)
    amenities = sorted(amenities_set)

    # Build the output structure
    output = {
        "experiences": experiences,
        "amenities": amenities
    }

    # Save to a new JSON file
    with open(OUTPUT_FILE, "w", encoding="utf-8") as f:
        json.dump(output, f, indent=2, ensure_ascii=False)

    print(f"✅ Saved unique experiences and amenities to {OUTPUT_FILE}")

if __name__ == "__main__":
    main()
