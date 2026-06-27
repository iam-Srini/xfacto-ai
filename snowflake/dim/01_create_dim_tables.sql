CREATE SCHEMA IF NOT EXISTS XFACTO_AI.DIM;

CREATE OR REPLACE TABLE XFACTO_AI.DIM.DIM_DATE AS
SELECT DISTINCT
    trade_date AS date_key,
    YEAR(trade_date) AS year,
    QUARTER(trade_date) AS quarter,
    MONTH(trade_date) AS month,
    MONTHNAME(trade_date) AS month_name,
    DAY(trade_date) AS day,
    DAYNAME(trade_date) AS day_name,
    WEEKOFYEAR(trade_date) AS week_of_year
FROM XFACTO_AI.MART.STOCK_MARKET_INSIGHTS;


CREATE OR REPLACE TABLE XFACTO_AI.DIM.DIM_TICKER AS
SELECT DISTINCT
    ticker AS ticker_key,
    ticker AS ticker_symbol
FROM XFACTO_AI.MART.STOCK_MARKET_INSIGHTS;


CREATE OR REPLACE TABLE XFACTO_AI.DIM.DIM_NEWS_SENTIMENT AS
SELECT DISTINCT
    news_sentiment_signal AS news_sentiment_key,
    CASE
        WHEN news_sentiment_signal LIKE '%Positive%' THEN 'Positive'
        WHEN news_sentiment_signal LIKE '%Negative%' THEN 'Negative'
        WHEN news_sentiment_signal LIKE '%Neutral%' THEN 'Neutral'
        ELSE 'No News'
    END AS sentiment_group
FROM XFACTO_AI.MART.STOCK_MARKET_INSIGHTS
WHERE news_sentiment_signal IS NOT NULL;


CREATE OR REPLACE TABLE XFACTO_AI.DIM.DIM_PRICE_MOVEMENT AS
SELECT DISTINCT
    daily_insight_summary AS insight_key,
    CASE
        WHEN daily_insight_summary LIKE '%Price Up%' THEN 'Price Up'
        WHEN daily_insight_summary LIKE '%Price Down%' THEN 'Price Down'
        WHEN daily_insight_summary LIKE '%Without Relevant News%' THEN 'No News Driver'
        ELSE 'Mixed / Neutral'
    END AS movement_group
FROM XFACTO_AI.MART.STOCK_MARKET_INSIGHTS
WHERE daily_insight_summary IS NOT NULL;