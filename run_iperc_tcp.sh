#!/bin/bash

now=$(date +"%Y-%m-%d_%H-%M-%S")

# Get data from config file
config_file="/home/george/config.ini"
output_dir="iperf_results"
output_file="$output_dir/iperf_results_$now.txt"

# Get variables for IP & Port

Location=$(awk -F "=" '/location/{print $2}' "$config_file" | tr -d '[:space:]')
IP=$(awk -F "=" '/ip/{print $2}' "$config_file" | tr -d '[:space:]')
Port=$(awk -F "=" '/port/{print $2}' "$config_file" | tr -d '[:space:]')
Streams=$(awk -F "=" '/streams/{print $2}' "$config_file" | tr -d '[:space:]')
Bandwidth=$(awk -F "=" '/bandwidth/{print $2}' "$config_file" | tr -d '[:space:]')
Time=$(awk -F "=" '/time/{print $2}' "$config_file" | tr -d '[:space:]')

echo "$Location"
echo "$IP"
echo "$Port"
echo "$Streams"
echo "$Bandwidth"
echo "$Time"

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

python parse_iperf.py "$output_file" "$Location" "$now"
python tcp_data_table.py
