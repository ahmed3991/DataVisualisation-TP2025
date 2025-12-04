from typing import Optional
import pandas as pd
import sqlalchemy as sa
import dlt


def load_table(conn, table, proper_name):
    print(f"🔄 Loading table: {proper_name}")

    df = pd.read_sql_query(f'SELECT * FROM "{table}"', conn)
    if df.empty:
        print(f"⚠️ WARNING: Table {table} is EMPTY in SQLite.")
    else:
        print(f"📦 {len(df)} rows loaded from {table}")

    pipeline = dlt.pipeline(
        pipeline_name="northwind_loader",
        destination="postgres",
        dataset_name="staging",
    )

    pipeline.run(df, table_name=proper_name)
    print(f"✅ Loaded → {proper_name}\n")


def main():
    engine = sa.create_engine("sqlite:///northwind.db")

    TABLE_MAP = {
        "Customers": "customers",
        "Orders": "orders",
        "Order Details": "order_details",
        "Products": "products",
        "Categories": "categories",
        "Employees": "employees"
    }

    with engine.connect() as conn:
        for sqlite_name, postgres_name in TABLE_MAP.items():
            load_table(conn, sqlite_name, postgres_name)


if __name__ == "__main__":
    main()
