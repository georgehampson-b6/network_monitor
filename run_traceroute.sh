# Get data from config file
config_file="/home/bolt6/network_monitor/config.ini"
output_dir="traceroute_results"
output_file="$output_dir/traceroute_results_$now.txt"

# Get variables for IP & Port
# Parse the location from [grand_rapids] section
location=$(awk -F' *= *' '/^\[grand_rapids\]/{flag=1; next} /^\[/{flag=0} flag && /^location/{print $2; exit}' "$config_file" | tr -d '[:space:]')
ip=$(awk -F' *= *' '/^\[grand_rapids\]/{flag=1; next} /^\[/{flag=0} flag && /^ip/{print $2; exit}' "$config_file" | tr -d '[:space:]')

echo "Location: $location"
echo "IP: $ip"

# Ping Google DNS 3 times
ping -c 3 8.8.8.8

# Check the return code of the ping command
if [ $? -eq 0 ]; then
    echo "Ping successful. Running traceroute..."
    python network_monitor/parse_traceroute.py "$output_file" "$location" "$now" "$ip"
else
    echo "Ping failed. Exiting..."
fi
