import yfinance as yf

stk_df = yf.download(tickers= 'AAPL',period='1y',interval= '1d',auto_adjust= True)
stk_df = stk_df.reset_index()

stk_df["daily_return_pct"] = stk_df["Close"].pct_change() * 100
stk_df["ma_20"] = stk_df["Close"].rolling(20).mean()
stk_df["ma_50"] = stk_df["Close"].rolling(50).mean()

stk_df.to_csv("ingestion/AAPL_1year_data.csv", index=False)