import pandas as pd
import sys
import re

# Sample data - replace this with reading from your file

with open(sys.argv[1],'r') as file:
        data = file.read().strip().split('\n')

# Adjusted regex pattern to include packet loss percentage
pattern = re.compile(
    r'\[\s*(\d+|SUM)\]\s+(\d+\.\d+-\d+\.\d+)\s+sec\s+(\d+\.\d+\sMBytes)\s+(\d+\.\d+\sMbits/sec)\s+(\d+)\s*(\((\d+)%\))?'
)

# Initialize a list for storing parsed data
parsed_data = []

# Process each line of the provided data
for line in data:
    match = pattern.search(line)
    if match:
        id, interval, transfer, bitrate, total_datagrams, _, loss_percentage = match.groups()
        parsed_data.append({
            'ID': id,
            'Interval': interval,
            'Transfer': transfer,
            'Bitrate': bitrate,
            'Total Datagrams': total_datagrams,
            'Loss Percentage': loss_percentage if loss_percentage else "0%"  # Default to 0% if not found
        })

# Convert the list of dictionaries to a pandas DataFrame
df = pd.DataFrame(parsed_data)
# Filter the DataFrame to show only rows with a 30-second interval
df_30s = df[df['Interval'].str.contains("0.00-30.00")]

# Display the filtered DataFrame
print(df_30s)
