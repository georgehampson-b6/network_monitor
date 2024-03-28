#!/usr/bin/env python3

import pandas as pd
import speedtest

def get_speedtest_results():
    s = speedtest.Speedtest()
    s.get_best_server()
    s.download()
    s.upload()
    results_dict = s.results.dict()

    # Extracting necessary information
    data = {
        'Location': [results_dict['server']['name']],
        'Provider': [results_dict['client']['isp']],
        'Ping (ms)': [results_dict['ping']],
        'Download (Mbps)': [results_dict['download'] / 1024 / 1024],
        'Upload (Mbps)': [results_dict['upload'] / 1024 / 1024],
        'Jitter (ms)': [results_dict['ping']]
    }

    # Create a pandas DataFrame
    df = pd.DataFrame(data)
    return df

# Run the speed test and get results in a DataFrame
df = get_speedtest_results()

# Print the DataFrame
print(df)
