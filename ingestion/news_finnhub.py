import os
import time
import requests
import pandas as pd
from datetime import datetime
from dateutil.relativedelta import relativedelta
from dotenv import load_dotenv

load_dotenv()

API_KEY = os.getenv("ALPHA_VANTAGE_API_KEY")
BASE_URL = "https://www.alphavantage.co/query"

TICKER = "AAPL"
OUTPUT_FILE = "aapl_news_1year_alpha_vantage.csv"

def av_time(dt):
    return dt.strftime("%Y%m%dT%H%M")

def fetch_news_month(ticker, start_dt, end_dt):
    params = {
        "function": "NEWS_SENTIMENT",
        "tickers": ticker,
        "time_from": av_time(start_dt),
        "time_to": av_time(end_dt),
        "sort": "LATEST",
        "limit": 1000,
        "apikey": API_KEY
    }

    response = requests.get(BASE_URL, params=params)
    response.raise_for_status()

    data = response.json()

    if "feed" not in data:
        print("API message:", data)
        return []

    return data["feed"]

end_date = datetime.today()
start_date = end_date - relativedelta(years=1)

all_news = []
current = start_date

while current < end_date:
    next_month = current + relativedelta(months=1)

    if next_month > end_date:
        next_month = end_date

    print(f"Fetching {TICKER}: {av_time(current)} to {av_time(next_month)}")

    monthly_news = fetch_news_month(ticker= TICKER, start_dt= current, end_dt= next_month)
    print(f"Articles fetched: {len(monthly_news)}")

    all_news.extend(monthly_news)

    # Alpha Vantage free tier has rate limits
    time.sleep(15)

    current = next_month

news_df = pd.DataFrame(all_news)

if not news_df.empty:
    news_df["published_date"] = pd.to_datetime(news_df["time_published"], format="%Y%m%dT%H%M%S", errors="coerce")


news_df.to_csv("ingestion/aapl_news_1year.csv", index=False)