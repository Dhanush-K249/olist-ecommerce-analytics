import pandas as pd
import unicodedata

def standardize_text(text):
    # Check if the input is a string; if not, return it unchanged
    if not isinstance(text, str):
        return text
    # 1. Convert to lowercase
    text = text.lower().strip()
    # 2. Decompose unicode characters (e.g., 'ú' becomes 'u' + accent mark)
    normalized = unicodedata.normalize('NFD', text)
    # 3. Strip out the accent marks, leaving only raw ASCII
    return "".join(c for c in normalized if not unicodedata.combining(c))

# Define the files that contain city names
files_to_clean = {
    "olist_customers_dataset.csv": "customer_city",
    "olist_sellers_dataset.csv": "seller_city",
    "olist_geolocation_dataset.csv": "geolocation_city"
}

for file_name, city_column in files_to_clean.items():
    print(f"Standardizing {file_name}...")
    
    # Read original file
    df = pd.read_csv(file_name, encoding='utf-8')
    
    # Clean the city column
    df[city_column] = df[city_column].apply(standardize_text)
    
    # Save over the file or write to a 'clean_' prefixed file
    output_name = f"clean_{file_name}"
    df.to_csv(output_name, index=False, encoding='utf-8')
    print(f"Saved cleaned version to {output_name}\n")

print("All location data successfully uniform!")