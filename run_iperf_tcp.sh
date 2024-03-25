#!/bin/bash

now=$(date +"%Y-%m-%d_%H-%M-%S")

# Get data from config file
config_file="/home/bolt6/network_monitor/config.ini"
output_dir="network_monitor/iperf_results"
output_file="$output_dir/iperf_results_$now.txt"

# Get variables for IP & Port
#!/bin/bash

# Define the location to parse
location="grand_rapids"

# Use awk to parse the data for the specified location
parsed_data=$(echo "$data" | awk -v location="$location" '/\['location'\]/,/\[' location '\]/')

# Use awk to parse the data
Location=$(echo "$data" | awk -F' = ' '/location/ {print $2}')
IP=$(echo "$data" | awk -F' = ' '/ip/ {print $2}')
Port=$(echo "$data" | awk -F' = ' '/port/ {print $2}')
Streams=$(echo "$data" | awk -F' = ' '/streams/ {print $2}')
Bandwidth=$(echo "$data" | awk -F' = ' '/bandwidth/ {print $2}')
Time=$(echo "$data" | awk -F' = ' '/time/ {print $2}')

# Print the parsed data
echo "Location: $location"
echo "IP: $IP"
echo "Port: $Port"
echo "Streams: $Streams"
echo "Bandwidth: $Bandwidth"
echo "Time: $Time"

# Ping Google DNS 3 times
ping -c 3 8.8.8.8

# Check the return code of the ping command
if [ $? -eq 0 ]; then
    echo "Ping successful. Running iperf test..."
    # Run iperf test here
    iperf3 -c "$IP" -p "$Port" -P "$Streams" -b "$Bandwidth" -l 0  -t "$Time" >> "$output_file"
else
    echo "Ping failed. Exiting..."
fi

python network_monitor/parse_iperf.py "$output_file" "$Location" "$now"
