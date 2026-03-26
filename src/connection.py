import os
import pandas as pd
import snowflake.connector
from dotenv import load_dotenv

load_dotenv()


def get_connection():
    return snowflake.connector.connect(
        account=os.getenv("SNOWFLAKE_ACCOUNT"),
        user=os.getenv("SNOWFLAKE_USER"),
        password=os.getenv("SNOWFLAKE_PASSWORD"),
        role=os.getenv("SNOWFLAKE_ROLE"),
        warehouse=os.getenv("SNOWFLAKE_WAREHOUSE"),
        database=os.getenv("SNOWFLAKE_DATABASE"),
        schema=os.getenv("SNOWFLAKE_SCHEMA"),  # default; queries use fully qualified names
    )


def query(sql: str) -> pd.DataFrame:
    """Run a SQL query and return a DataFrame."""
    with get_connection() as conn:
        return pd.read_sql(sql, conn)
