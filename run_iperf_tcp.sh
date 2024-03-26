#!/bin/bash

now=$(date +"%Y-%m-%d_%H-%M-%S")

# Get data from config file
config_file="config.ini"
output_dir="network_monitor/iperf_results"
output_file="$output_dir/iperf_results_$now.txt"

# Parse the location from [grand_rapids] section
location=$(awk -F' *= *' '/^\[las_vegas\]/{flag=1; next} /^\[/{flag=0} flag && /^location/{print $2; exit}' "$config_file" | tr -d '[:space:]')
ip=$(awk -F' *= *' '/^\[las_vegas\]/{flag=1; next} /^\[/{flag=0} flag && /^ip/{print $2; exit}' "$config_file" | tr -d '[:space:]')
port=$(awk -F' *= *' '/^\[las_vegas\]/{flag=1; next} /^\[/{flag=0} flag && /^port/{print $2; exit}' "$config_file" | tr -d '[:space:]')
streams=$(awk -F' *= *' '/^\[las_vegas\]/{flag=1; next} /^\[/{flag=0} flag && /^streams/{print $2; exit}' "$config_file" | tr -d '[:space:]')
bandwidth=$(awk -F' *= *' '/^\[las_vegas\]/{flag=1; next} /^\[/{flag=0} flag && /^bandwidth/{print $2; exit}' "$config_file" | tr -d '[:space:]')
seconds=$(awk -F' *= *' '/^\[las_vegas\]/{flag=1; next} /^\[/{flag=0} flag && /^seconds/{print $2; exit}' "$config_file" | tr -d '[:space:]')

# Output the parsed location
echo "Location: $location"
echo "IP: $ip"
echo "Port: $port"
echo "Streams: $streams"
echo "Bandwidth: $bandwidth"
echo "Time: $seconds"

# Ping Google DNS 3 times

ping -c 3 8.8.8.8

# Check the return code of the ping command
if [ $? -eq 0 ]; then
    echo "Ping successful. Running iperf test..."
    # Run iperf test here
    iperf3 -c "$ip" -p "$port" -P "$streams" -b "$bandwidth" -l 0  -t "$seconds" >> "$output_file"
else
    echo "Ping failed. Exiting..."
fi

python network_monitor/parse_iperf.py "$output_file" "$location" "$now"
