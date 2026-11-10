# ==============================================================================
# CANADIAN RENTAL MARKET: ETL & DATA CLEANING PIPELINE
# ==============================================================================

import pandas as pd
import numpy as np

print("1. Ingesting raw dataset...")
df = pd.read_csv('/content/rentfaster.csv')

print("2. Standardizing bedroom and bathroom metrics...")
# Convert "Studio" to 0 and extract numeric values from strings (e.g., "2 Beds" -> 2.0)
df['beds'] = df['beds'].astype(str).str.lower().str.replace('studio', '0')
df['beds'] = df['beds'].str.extract(r'(\d+\.?\d*)')[0].astype(float)
df['baths'] = pd.to_numeric(df['baths'], errors='coerce')

print("3. Handling missing values in square footage (Statistical Imputation)...")
df['sq_feet'] = pd.to_numeric(df['sq_feet'], errors='coerce')
# Advanced skillset: Impute null square footage using the median of the respective property type
df['sq_feet'] = df['sq_feet'].fillna(df.groupby('type')['sq_feet'].transform('median'))

print("4. Normalizing boolean flags (Pet policies)...")
# Enforce strict boolean values for data integrity
df['cats'] = df['cats'].map({'True': True, 'False': False, True: True, False: False}).fillna(False)
df['dogs'] = df['dogs'].map({'True': True, 'False': False, True: True, False: False}).fillna(False)

print("5. Purging corrupted records (Missing price or property type)...")
df = df.dropna(subset=['price', 'type'])

# Export clean dataset for BigQuery upload
output_path = '/content/rentfaster_clean.csv'
df.to_csv(output_path, index=False)

print(f"\nSUCCESS: Pipeline execution complete. Clean dataset exported to {output_path}")
print("Data sample:")
print(df[['city', 'type', 'price', 'beds', 'sq_feet']].head())