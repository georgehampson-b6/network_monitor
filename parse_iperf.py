import pandas as pd
import sys
import re

# Sample data - replace this with reading from your file

with open(sys.argv[1],'r') as file:
        data = file.read().strip().split('\n')

# Define a regex pattern to match the lines with results
pattern = re.compile(r'\[\s*(\S+)\]\s+(\d+\.\d+-\d+\.\d+)\s+sec\s+(\d+\.?\d*\sK>

# Prepare lists to hold parsed data
location, times, stream_ids, intervals, transfers, bandwidths = [], [], [], [],>

# Parse each line
for line in data:
    match = re.search(pattern, line)
    if match:
        stream_ids.append(match.group(1))
        intervals.append(match.group(2))
        transfers.append(match.group(3))
        bandwidths.append(match.group(4))
        location.append(sys.argv[2])
        times.append(sys.argv[3])
# Create a DataFrame
df = pd.DataFrame({
    "Times": times,
    "Location": location,
    "Stream ID": stream_ids,
    "Interval": intervals,
    "Transfer": transfers,
    "Bandwidth": bandwidths
})
print(df)
# Save DataFrame to a CSV file
output_file = 'parsed_data.csv'
df.to_csv(output_file, index=False)
print(f"DataFrame saved to {output_file}")

