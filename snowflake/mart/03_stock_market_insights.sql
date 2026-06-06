CREATE OR REPLACE TABLE XFACTO_AI.MART.STOCK_MARKET_INSIGHTS AS
SELECT
    *,
    CASE
        WHEN news_count = 0 OR avg_aapl_sentiment_score IS NULL THEN 'No Relevant News'
        WHEN avg_aapl_sentiment_score >= 0.35 THEN 'Positive News Sentiment'
        WHEN avg_aapl_sentiment_score <= -0.35 THEN 'Negative News Sentiment'
        ELSE 'Neutral News Sentiment'
    END AS news_sentiment_signal,

    CASE
        WHEN news_count = 0 OR avg_aapl_sentiment_score IS NULL THEN 'Price Move Without Relevant News'
        WHEN daily_return_pct > 0 AND avg_aapl_sentiment_score > 0 THEN 'Price Up + Positive News'
        WHEN daily_return_pct < 0 AND avg_aapl_sentiment_score < 0 THEN 'Price Down + Negative News'
        WHEN daily_return_pct > 0 AND avg_aapl_sentiment_score < 0 THEN 'Price Up Despite Negative News'
        WHEN daily_return_pct < 0 AND avg_aapl_sentiment_score > 0 THEN 'Price Down Despite Positive News'
        ELSE 'Mixed / Neutral'
    END AS daily_insight_summary
FROM XFACTO_AI.MART.STOCK_DAILY_INSIGHTS;