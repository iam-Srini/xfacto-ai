CREATE OR REPLACE TABLE XFACTO_AI.MART.STOCK_MARKET_INSIGHTS AS
SELECT
    *,

    CASE
        WHEN news_count = 0 OR weighted_sentiment_score IS NULL THEN 'No Relevant News'
        WHEN weighted_sentiment_score >= 0.35 THEN 'Strong Positive News'
        WHEN weighted_sentiment_score >= 0.15 THEN 'Mild Positive News'
        WHEN weighted_sentiment_score <= -0.35 THEN 'Strong Negative News'
        WHEN weighted_sentiment_score <= -0.15 THEN 'Mild Negative News'
        ELSE 'Neutral News'
    END AS news_sentiment_signal,

    CASE
        WHEN daily_return_pct >= 2 THEN 'Strong Price Up'
        WHEN daily_return_pct >= 0.5 THEN 'Moderate Price Up'
        WHEN daily_return_pct <= -2 THEN 'Strong Price Down'
        WHEN daily_return_pct <= -0.5 THEN 'Moderate Price Down'
        ELSE 'Flat / Low Movement'
    END AS price_movement_signal,

    CASE
        WHEN news_count = 0 OR weighted_sentiment_score IS NULL
            THEN 'Price Move Without Relevant News'

        WHEN daily_return_pct > 0 AND weighted_sentiment_score > 0.15
            THEN 'Price Up Supported by Positive News'

        WHEN daily_return_pct < 0 AND weighted_sentiment_score < -0.15
            THEN 'Price Down Supported by Negative News'

        WHEN daily_return_pct > 0 AND weighted_sentiment_score < -0.15
            THEN 'Price Up Despite Negative News'

        WHEN daily_return_pct < 0 AND weighted_sentiment_score > 0.15
            THEN 'Price Down Despite Positive News'

        WHEN ABS(daily_return_pct) < 0.5 AND ABS(weighted_sentiment_score) >= 0.35
            THEN 'Strong News But Limited Price Reaction'

        ELSE 'Mixed / Neutral Market Reaction'
    END AS daily_insight_summary

FROM XFACTO_AI.MART.STOCK_DAILY_INSIGHTS;


SELECT * FROM XFACTO_AI.MART.STOCK_MARKET_INSIGHTS LIMIT 10;