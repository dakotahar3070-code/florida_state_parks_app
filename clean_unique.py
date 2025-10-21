import json
import re

INPUT_FILE = "data_dump/unique_amenities_experiences.json"
OUTPUT_FILE = "data_dump/normalized_amenities_experiences.json"

# Define manual mappings for known duplicates/variants
NORMALIZE_MAP = {
    "camping boat": "Camping",
    "camping equestrian": "Camping",
    "camping primitive": "Camping",
    "camping, devel. group": "Camping Group",
    "camping, primitive group": "Camping Group",
    "boat tours": "Boating",
    "roller blading": "Rollerblading",
    "walking and running": "Walking",
    "restroom facilities": "Restrooms",
    "wheelchair accessible": "Accessible Amenities",
    "accessible amenities": "Accessible Amenities",
    "rv": "RV Camping",
}

def normalize(item: str) -> str:
    # Lowercase and strip punctuation
    key = item.lower().strip()
    key = re.sub(r"[.,]", "", key)
    return NORMALIZE_MAP.get(key, item)

def main():
    with open(INPUT_FILE, "r", encoding="utf-8") as f:
        data = json.load(f)

    experiences = sorted({normalize(e) for e in data["experiences"]})
    amenities = sorted({normalize(a) for a in data["amenities"]})

    output = {
        "experiences": experiences,
        "amenities": amenities
    }

    with open(OUTPUT_FILE, "w", encoding="utf-8") as f:
        json.dump(output, f, indent=2, ensure_ascii=False)

    print(f"✅ Saved normalized list to {OUTPUT_FILE}")

if __name__ == "__main__":
    main()
