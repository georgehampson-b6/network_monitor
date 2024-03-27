#!/bin/bash

now=$(date +"%Y-%m-%d_%H-%M-%S")
read -p "Enter location: " location
read -p "Enter IP address: " ip
read -p "Enter Port number: " port
read -p "Enter No. of Cams: " streams
read -p "Enter Bandwidth MB/s: " bandwidth
read -p "Enter length of test sec: " seconds

# Get data from config file
config_file="network_monitor/config.ini"
output_dir="network_monitor/iperf_results"
output_file="$output_dir/iperf_results_$now.txt"

# Parse the location from [grand_rapids] section
#location=$(awk -F' *= *' '/^\[atlanta\]/{flag=1; next} /^\[/{flag=0} flag && /^location/{print $2; exit}' "$config_file>
#ip=$(awk -F' *= *' '/^\[atlanta\]/{flag=1; next} /^\[/{flag=0} flag && /^ip/{print $2; exit}' "$config_file" | tr -d '[>
#port=$(awk -F' *= *' '/^\[atlanta\]/{flag=1; next} /^\[/{flag=0} flag && /^port/{print $2; exit}' "$config_file" | tr ->
#streams=$(awk -F' *= *' '/^\[atlanta\]/{flag=1; next} /^\[/{flag=0} flag && /^streams/{print $2; exit}' "$config_file" >#bandwidth=$(awk -F' *= *' '/^\[atlanta\]/{flag=1; next} /^\[/{flag=0} flag && /^bandwidth/{print $2; exit}' "$config_fi>
#seconds=$(awk -F' *= *' '/^\[atlanta\]/{flag=1; next} /^\[/{flag=0} flag && /^time/{print $2; exit}' "$config_file" | t>

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
    iperf3 -c "$ip" -p "$port" -u -P "$streams" -b "${bandwidth}M" -l 0  -t "$seconds" >> "$output_file"
else
    echo "Ping failed. Exiting..."
fi

python network_monitor/parse_iperf_udp.py "$output_file" "$location" "$now"
