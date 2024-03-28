#!/bin/bash

# Install python3-venv if not already installed
if ! dpkg -s python3-venv >/dev/null 2>&1; then
    echo "Installing python3-venv..."
    sudo apt update
    sudo apt install traceroute
    sudo apt install python3-venv
fi

# Define the name of your virtual environment
VENV_NAME="network_monitor"

# Navigate to your project directory
cd /home/bolt6/network-monitor
mkdir iperf_results
# Check if the virtual environment already exists
if [ ! -d "$VENV_NAME" ]; then
    # Create the virtual environment
    python3 -m venv $VENV_NAME
fi

# Activate the virtual environment
source $VENV_NAME/bin/activate

# Install required packages
pip install -r requirements.txt
sudo apt install iperf3
sudo apt install traceroute
chmod +x download_config.sh run_iperf_tcp.sh parse_iperf.sh run_traceroute.sh parse_traceroute.py run_speedtest.py

echo "Setup complete. Your virtual environment '$VENV_NAME' is ready."
