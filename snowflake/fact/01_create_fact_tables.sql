CREATE SCHEMA IF NOT EXISTS XFACTO_AI.FACT;

-- Grain: one row per ticker per trading day.
-- Business measures:
-- simple_return = (close_price - previous_close_price) / previous_close_price
-- log_return = LN(close_price / previous_close_price)
-- daily_return_pct = simple_return * 100
CREATE OR REPLACE TABLE XFACTO_AI.FACT.FACT_STOCK_DAILY_INSIGHTS AS
SELECT
    ticker AS ticker_key,
    trade_date AS date_key,

    close_price,
    previous_close_price,
    simple_return,
    log_return,
    daily_return_pct,
    price_signal,
    trend_signal,

    news_count,
    avg_relevance_score,
    avg_sentiment_score,

    positive_news_count,
    neutral_news_count,
    negative_news_count,

    news_headlines,
    main_topics

FROM XFACTO_AI.MART.STOCK_DAILY_INSIGHTS;
