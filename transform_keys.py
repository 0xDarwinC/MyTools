# Code for transforming your bluetooth 5.1 keys for an arch linux dualboot

# --- 1. PASTE YOUR KEYS HERE ---
# Replace the placeholder text inside the quotes with your comma-separated values.
# The script will handle removing the commas automatically.
ltk_raw = "A1,B2,C3,D4,E5,F6,01,02,03,04,05,06,07,08,09,1A"
erand_raw = "63,02,84,B8,5D,40,44,DF"
ediv_raw = "1F,2E"

# --- 2. Transformation Logic (No need to edit below this line) ---

# Process LTK (LongTermKey.Key)
# First, replace commas with spaces, then remove all spaces.
ltk_processed = ltk_raw.strip().replace(",", " ").replace(" ", "").upper()

# Process ERand (LongTermKey.Rand)
# First, replace commas with spaces, then split, reverse, and join.
erand_octets_reversed = list(reversed(erand_raw.strip().replace(",", " ").split()))
erand_hex_string = "".join(erand_octets_reversed)
erand_processed = int(erand_hex_string, 16)

# Process EDIV (LongTermKey.EDiv)
# First, replace commas with spaces, then remove all spaces.
ediv_processed = ediv_raw.strip().replace(",", " ").replace(" ", "").upper()


# --- 3. Print the final output ---
print("Copy the entire block below into your /var/lib/bluetooth/.../info file:\n")
print("--------------------------------------------------")
print("[LongTermKey]")
print(f"Key = {ltk_processed}")
print(f"Rand = {erand_processed}")
print(f"EDiv = {ediv_processed}")
print("--------------------------------------------------")