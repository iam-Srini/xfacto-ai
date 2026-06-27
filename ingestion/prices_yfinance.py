from pathlib import Path

import pandas as pd
import yfinance as yf

INGESTION_DIR = Path(__file__).resolve().parent
STOCK_UNIVERSE_FILE = INGESTION_DIR / "stock_universe.csv"
OUTPUT_FILE = INGESTION_DIR / "stock_prices_1year.csv"


def download_stock_prices(ticker, sector):
    stk_df = yf.download(tickers=ticker, period="1y", interval="1d", auto_adjust=True)
    stk_df = stk_df.reset_index()

    if isinstance(stk_df.columns, pd.MultiIndex):
        stk_df.columns = stk_df.columns.get_level_values(0)

    stk_df["ticker"] = ticker
    stk_df["sector"] = sector
    stk_df["ma_20"] = stk_df["Close"].rolling(20).mean()
    stk_df["ma_50"] = stk_df["Close"].rolling(50).mean()

    return stk_df[
        [
            "ticker",
            "sector",
            "Date",
            "Close",
            "High",
            "Low",
            "Open",
            "Volume",
            "ma_20",
            "ma_50",
        ]
    ]


def main():
    stock_universe_df = pd.read_csv(STOCK_UNIVERSE_FILE)

    price_frames = []
    for stock in stock_universe_df.itertuples(index=False):
        price_frames.append(download_stock_prices(stock.ticker, stock.sector))

    stock_prices_df = pd.concat(price_frames, ignore_index=True)
    stock_prices_df.to_csv(OUTPUT_FILE, index=False)


if __name__ == "__main__":
    main()
