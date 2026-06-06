CREATE OR REPLACE TABLE XFACTO_AI.CURATED.STOCK_FEATURES AS
SELECT
    ticker,
    date AS trade_date,
    close AS close_price,
    volume,
    daily_return_pct,
    ma_20,
    ma_50,

    CASE
        WHEN close > ma_20 THEN 'BULLISH'
        WHEN close < ma_20 THEN 'BEARISH'
        ELSE 'NEUTRAL'
    END AS price_signal,

    CASE
        WHEN ma_20 > ma_50 THEN 'UPTREND'
        WHEN ma_20 < ma_50 THEN 'DOWNTREND'
        ELSE 'SIDEWAYS'
    END AS trend_signal,

    CURRENT_TIMESTAMP() AS curated_at

FROM XFACTO_AI.RAW.STOCK_PRICES_RAW;