#!/usr/bin/env python3

import subprocess
import sys
import pandas as pd
import re
import numpy as np

def run_traceroute_and_collect_output(target_ip):
    output_lines = []
    with subprocess.Popen(['traceroute', target_ip], stdout=subprocess.PIPE, text=True, bufsize=1, universal_newlines=True) as proc:
        if proc.stdout is not None:
            for line in proc.stdout:
                sys.stdout.write('---')  # Print - for each hop
                sys.stdout.flush()  # Ensure it's displayed immediately
                output_lines.append(line.strip())
            print()  # Newline after completion
    return output_lines

def parse_traceroute(output_lines):
    # Regex to match each line of the traceroute output
    line_re = re.compile(r'\s*(\d+)\s+([\w\.-]+|\*)\s*(\(\d+\.\d+\.\d+\.\d+\))?(\s+[\d\.]+\s+ms){1,3}')
    parsed_data = []

    for line in output_lines:
        match = line_re.match(line)
        if match:
            hop = match.group(1)
            ip_or_star = match.group(2)
            latencies = match.groups()[3:]
            latencies = [re.findall(r'([\d\.]+)\s+ms', lat) for lat in latencies if lat]
            # Flatten the list of latencies and convert to float, fill missing with NaN
            latencies = [float(lat[0]) if lat else np.nan for lat in latencies]
            while len(latencies) < 3:  # Ensure there are 3 latency columns
                latencies.append(np.nan)
            parsed_data.append([hop, ip_or_star] + latencies)

    df = pd.DataFrame(parsed_data, columns=['Hops', 'IP', 'Latency_1', 'Latency_2', 'Latency_3'])
    return df

# Input from the user for traceroute target
target_ip = input("Enter the IP address or hostname for traceroute: ")

# Run traceroute, collect output, and parse into DataFrame
traceroute_output_lines = run_traceroute_and_collect_output(target_ip)
df_traceroute = parse_traceroute(traceroute_output_lines)

# Display the DataFrame
print(df_traceroute)
