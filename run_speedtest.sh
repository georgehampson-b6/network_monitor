# Get data from config file
config_file="/home/bolt6/network_monitor/config.ini"

# Get variables for IP & Port

# Parse the location from [grand_rapids] section
location=$(awk -F' *= *' '/^\[grand_rapids\]/{flag=1; next} /^\[/{flag=0} flag && /^location/{print $2; exit}' "$config_file" | tr -d '[:space:]')

echo "Location: $location"

# Ping Google DNS 3 times
ping -c 3 8.8.8.8

# Check the return code of the ping command
if [ $? -eq 0 ]; then
    echo "Ping successful. Running speedtest..."
    # Run iperf test here
    python network_monitor/parse_speedtest.py "$location" "$now"

else
    echo "Ping failed. Exiting..."
fi
