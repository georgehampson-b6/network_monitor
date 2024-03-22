echo "$Bandwidth"
echo "$Time"

# Ping Google DNS 3 times
ping -c 3 8.8.8.8

# Check the return code of the ping command
if [ $? -eq 0 ]; then
    echo "Ping successful. Running iperf test..."
    # Run iperf test here
    iperf3 -c "$IP" -p "$Port" -P "$Streams" -b "$Bandwidth" -l 0  -t "$Time" >>
else
    echo "Ping failed. Exiting..."
fi

python parse_iperf.py "$output_file" "$Location" "$now"
python tcp_data_table.py



