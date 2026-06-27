import pandas as pd
import yfinance as yf

TICKER = "AAPL"

stk_df = yf.download(tickers=TICKER, period="1y", interval="1d", auto_adjust=True)
stk_df = stk_df.reset_index()

if isinstance(stk_df.columns, pd.MultiIndex):
    stk_df.columns = stk_df.columns.get_level_values(0)

stk_df["ma_20"] = stk_df["Close"].rolling(20).mean()
stk_df["ma_50"] = stk_df["Close"].rolling(50).mean()

stk_df.to_csv(f"ingestion/{TICKER}_1year_data.csv", index=False)
