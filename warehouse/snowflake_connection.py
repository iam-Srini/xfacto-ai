import pandas as pd
import snowflake.connector
import os
from dotenv import load_dotenv
from snowflake.connector.pandas_tools import write_pandas

load_dotenv()

conn = snowflake.connector.connect(
    user=os.getenv("SNOWFLAKE_USER"),
    password=os.getenv("SNOWFLAKE_PASSWORD"),
    account=os.getenv("SNOWFLAKE_ACCOUNT"),
    warehouse=os.getenv("SNOWFLAKE_WAREHOUSE"),
    database=os.getenv("SNOWFLAKE_DATABASE"),
    schema=os.getenv("SNOWFLAKE_SCHEMA")
)

cur = conn.cursor()

cur.execute("""
PUT file://ingestion/stock_prices_1year.csv
@YAHOO_FINANCE_STAGE
AUTO_COMPRESS=TRUE
OVERWRITE=TRUE
""")

cur.execute("""
PUT file://ingestion/aapl_news_1year.csv
@YAHOO_FINANCE_STAGE
AUTO_COMPRESS=TRUE
OVERWRITE=TRUE
""")

print("News file staged:", cur.fetchall())

cur.execute("LIST @YAHOO_FINANCE_STAGE")
print("Files in stage:")
for row in cur.fetchall():
    print(row)

cur.close()
conn.close()
