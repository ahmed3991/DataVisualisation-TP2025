
from typing import Optional
import pandas as pd
import sqlalchemy as sa

import dlt
from dlt.sources.helpers import requests


def load_sqlite_data() -> None:
    """Load data from a sqlite database"""

    engine = sa.create_engine("sqlite:///northwind.db")

    # Load Customers data
    with engine.connect() as conn:
        customers_query = "SELECT * FROM Customers"
        customers_rows = conn.execution_options(yield_per=100).exec_driver_sql(customers_query)

        pipeline = dlt.pipeline(
            pipeline_name="sqlite_customers_pipeline",
            destination='postgres',
            dataset_name="staging",
        )
        load_info = pipeline.run(map(lambda row: dict(row._mapping), customers_rows), table_name="Customers")
        print(load_info)  

    # Load Orders data
    with engine.connect() as conn:
        orders_query = "SELECT * FROM Orders"
        orders_rows = conn.execution_options(yield_per=100).exec_driver_sql(orders_query)

        pipeline = dlt.pipeline(
            pipeline_name="sqlite_orders_pipeline",
            destination='postgres',
            dataset_name="staging",
        )
        load_info = pipeline.run(map(lambda row: dict(row._mapping), orders_rows), table_name="Orders")
        print(load_info) 

        ## TODO: complete the ETL process by adding more tables as needed


if __name__ == "__main__":
    load_sqlite_data()
