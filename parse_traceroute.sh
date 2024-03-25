  GNU nano 7.2                                                         parse_traceroute.py                                                                  import subprocess
import re
import sys
import pandas as pd


# Define the target host
target_host = sys.argv[4]
location = sys.argv[2]
time = sys.argv[3]
# Execute the traceroute command
def run_traceroute(host):
    result = subprocess.run(["traceroute", host], capture_output=True, text=True)
    #print(result)
    return result.stdout

# Parse the traceroute output
def parse_traceroute(traceroute_output):
    traceroute_data = []
    pattern = re.compile(r"(\d+)\s+([\w.:-]+)\s+\(([\d.]+)\)\s+([\d.]+)\s+ms\s+([\d.]+)\s+ms\s+([\d.]+)\s+ms")

    for line in traceroute_output.split('\n'):
        match = pattern.search(line)
        if match:
            hop = match.group(1)
            ip_address = match.group(3)
            latency_1 = match.group(4)
            latency_2 = match.group(5)
            latency_3 = match.group(6)
            traceroute_data.append({
                "time": time,
                "location": location,
                "hop": hop,
                "ip_address": ip_address,
                "latency_1_ms": latency_1,
                "latency_2_ms": latency_2,
                "latency_3_ms": latency_3
            })

    return traceroute_data
# Main function to run and parse traceroute
def main():
    traceroute_output = run_traceroute(target_host)
    traceroute_data = parse_traceroute(traceroute_output)
    df = pd.DataFrame(traceroute_data)
    print(df)
    #output_file = 'parsed_traceroute_data.csv'
    #df.to_csv(output_file, index=False)
    #print(f"DataFrame saved to {output_file}")


if __name__ == "__main__":
    main()
