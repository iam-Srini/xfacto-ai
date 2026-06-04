CREATE OR REPLACE TABLE XFACTO_AI.RAW.STOCK_PRICES_RAW (
    ticker STRING,
    date DATE,
    close FLOAT,
    high FLOAT,
    low FLOAT,
    open FLOAT,
    volume NUMBER,
    daily_return_pct FLOAT,
    ma_20 FLOAT,
    ma_50 FLOAT,
    ingestion_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
);

CREATE OR REPLACE TABLE XFACTO_AI.RAW.STOCK_NEWS_RAW (
    ticker STRING,
    title STRING,
    url STRING,
    time_published TIMESTAMP,
    authors STRING,
    summary STRING,
    banner_image STRING,
    source STRING,
    category_within_source STRING,
    source_domain STRING,
    topics STRING,
    overall_sentiment_score FLOAT,
    overall_sentiment_label STRING,
    ticker_sentiment STRING,
    ingestion_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
);