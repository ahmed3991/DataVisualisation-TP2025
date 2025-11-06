import dlt
import requests
import pandas as pd
from typing import Iterator, Any, Dict

# --- 1. API Data Source (Exchange Rates) ---
def get_currency_rates() -> Iterator[Dict[str, Any]]:
    """Extracts exchange rates from USD to DZD, EUR, GBP, JPY."""
    # Replace this URL with the API you selected (e.g., Frankfurter)
    # We need the base to be USD and include EUR, GBP, JPY
    API_URL = "https://api.frankfurter.dev/v1/latest?base=USD&to=EUR,GBP,JPY" 

    # NOTE: You MUST check the structure of your chosen API response!

    params = {
        'base': 'USD',
        'symbols': 'EUR,GBP,JPY' 
    }

    response = requests.get(API_URL, params=params)
    response.raise_for_status()

    # Yield the response data. dlt will automatically create a table.
    yield response.json()


# --- 2. CSV Data Source (Transaction Logs) ---
def get_transaction_logs() -> pd.DataFrame:
    """Reads transactions from the local CSV file."""
    return pd.read_csv("https://drive.google.com/uc?export=download&id=1oY9CIYmtY0nL78bVp3lxvCWVDKMuhFv7")


# --- 3. Run the dlt Pipeline ---
def load_pipeline():
    # Initialize a dlt pipeline with the destination set to 'postgres'
    pipeline = dlt.pipeline(
        pipeline_name='currency_conversion',
        destination='postgres',
        dataset_name='raw' # Load data into the 'raw' schema
    )

    # 1. Load the API data (will create table 'raw.currency_rates')
    rate_info = get_currency_rates()
    load_info_rates = pipeline.run(
        rate_info,
        table_name='currency_rates',
        write_disposition='replace' # Replace the rates on every run
    )

    # 2. Load the CSV data (will create table 'raw.daily_transactions')
    transactions = get_transaction_logs()
    load_info_transactions = pipeline.run(
        transactions,
        table_name='daily_transactions',
        write_disposition='append' # Append new transactions
    )

    print("--- Load Success! ---")
    print(load_info_rates)
    print(load_info_transactions)

if __name__ == "__main__":
    load_pipeline()