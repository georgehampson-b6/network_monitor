import subprocess
import re
import pandas as pd
import sys
from datetime import datetime


now = datetime.now()
formatted_now = now.strftime("%Y-%m-%d_%H-%M-%S")

# Run speed test using subprocess
speedtest_output = subprocess.run(['speedtest-cli'], capture_output=True, text=True)

# Parse the output using regular expressions
host_match = re.search(r'Hosted by (.+?) \[', speedtest_output.stdout)
download_speed_match = re.search(r'Download:\s+([\d.]+)\s+Mbit/s', speedtest_output.stdout)
upload_speed_match = re.search(r'Upload:\s+([\d.]+)\s+Mbit/s', speedtest_output.stdout)
ping_match = re.search(r'Hosted by .+ \[(.+?)\]:\s+([\d.]+)\s+ms', speedtest_output.stdout)

# Extract the relevant information
host = host_match.group(1) if host_match else None
download_speed = float(download_speed_match.group(1)) if download_speed_match else None
upload_speed = float(upload_speed_match.group(1)) if upload_speed_match else None
ping = float(ping_match.group(2)) if ping_match else None

# Create a dictionary with the extracted data
data = {'Time':formatted_now, 'Location':sys.argv[1], 'Host': host, 'Ping': ping, 'Download Speed': upload_speed, 'Upload Speed': download_speed}

# Convert the dictionary to a DataFrame
df = pd.DataFrame([data])
print(df)

# Save the DataFrame to a CSV file
# Save DataFrame to a CSV file
#output_file = 'parsed_speedtest_data.csv'
#df.to_csv(output_file, index=False)
#print(f"DataFrame saved to {output_file}")
