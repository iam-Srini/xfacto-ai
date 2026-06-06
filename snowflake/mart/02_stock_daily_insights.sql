CREATE OR REPLACE TABLE XFACTO_AI.MART.STOCK_DAILY_INSIGHTS AS
SELECT
    s.ticker,
    s.trade_date,
    s.close_price,
    s.daily_return_pct,
    s.price_signal,
    s.trend_signal,

    COUNT(n.title) AS news_count,

    AVG(n.aapl_relevance_score) AS avg_aapl_relevance_score,
    AVG(n.aapl_sentiment_score) AS avg_aapl_sentiment_score,

    COUNT_IF(n.aapl_sentiment_label = 'Bullish') AS bullish_news_count,
    COUNT_IF(n.aapl_sentiment_label = 'Somewhat-Bullish') AS somewhat_bullish_news_count,
    COUNT_IF(n.aapl_sentiment_label = 'Neutral') AS neutral_news_count,
    COUNT_IF(n.aapl_sentiment_label = 'Somewhat-Bearish') AS somewhat_bearish_news_count,
    COUNT_IF(n.aapl_sentiment_label = 'Bearish') AS bearish_news_count,

    LISTAGG(n.title, ' | ')
        WITHIN GROUP (ORDER BY n.time_published) AS news_headlines,

    LISTAGG(DISTINCT n.primary_topic, ', ') AS main_topics

FROM XFACTO_AI.CURATED.STOCK_FEATURES s

LEFT JOIN XFACTO_AI.CURATED.NEWS_SENTIMENT n
    ON s.ticker = n.ticker
   AND CAST(n.time_published AS DATE) = s.trade_date
   AND n.aapl_relevance_score >= 0.8

GROUP BY
    s.ticker,
    s.trade_date,
    s.close_price,
    s.daily_return_pct,
    s.price_signal,
    s.trend_signal;

