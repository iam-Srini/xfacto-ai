CREATE OR REPLACE TABLE XFACTO_AI.CURATED.STOCK_FEATURES AS
WITH price_history AS (
    SELECT
        ticker,
        date AS trade_date,
        close AS close_price,
        volume,
        LAG(close) OVER (
            PARTITION BY ticker
            ORDER BY date
        ) AS previous_close_price,
        ma_20,
        ma_50
    FROM XFACTO_AI.RAW.STOCK_PRICES_RAW
)

SELECT
    ticker,
    trade_date,
    close_price,
    previous_close_price,
    volume,

    -- Business formula: (current close - previous close) / previous close
    (close_price - previous_close_price)
        / NULLIF(previous_close_price, 0) AS simple_return,

    -- Business formula: natural log(current close / previous close)
    LN(close_price / NULLIF(previous_close_price, 0)) AS log_return,

    -- Business formula: simple_return expressed as a percentage
    ((close_price - previous_close_price)
        / NULLIF(previous_close_price, 0)) * 100 AS daily_return_pct,

    ma_20,
    ma_50,

    CASE
        WHEN close_price > ma_20 THEN 'BULLISH'
        WHEN close_price < ma_20 THEN 'BEARISH'
        ELSE 'NEUTRAL'
    END AS price_signal,

    CASE
        WHEN ma_20 > ma_50 THEN 'UPTREND'
        WHEN ma_20 < ma_50 THEN 'DOWNTREND'
        ELSE 'SIDEWAYS'
    END AS trend_signal,

    CURRENT_TIMESTAMP() AS curated_at

FROM price_history;
