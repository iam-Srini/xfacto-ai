import sys
import os
from dotenv import load_dotenv
import snowflake.connector

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

sql_file = sys.argv[1]

with open(sql_file) as f:
    sql = f.read()

for statement in sql.split(";"):
    if statement.strip():
        cur.execute(statement)

print(f"Executed: {sql_file}")

cur.close()
conn.close()