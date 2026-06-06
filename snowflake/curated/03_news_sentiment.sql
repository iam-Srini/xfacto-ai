CREATE OR REPLACE TABLE XFACTO_AI.CURATED.NEWS_SENTIMENT AS

WITH base AS (
    SELECT
        ticker,
        title,
        url,
        time_published,
        authors,
        summary,
        source,
        TRY_PARSE_JSON(topics) AS topics_json,
        TRY_PARSE_JSON(ticker_sentiment) AS ticker_sentiment_json,
        overall_sentiment_score,
        overall_sentiment_label,
        ingestion_time
    FROM XFACTO_AI.RAW.STOCK_NEWS_RAW
),

aapl_sentiment AS (
    SELECT
        b.*,
        ts.value:relevance_score::FLOAT AS aapl_relevance_score,
        ts.value:ticker_sentiment_score::FLOAT AS aapl_sentiment_score,
        ts.value:ticker_sentiment_label::STRING AS aapl_sentiment_label
    FROM base b,
    LATERAL FLATTEN(input => b.ticker_sentiment_json) ts
    WHERE ts.value:ticker::STRING = 'AAPL'
),

primary_topic AS (
    SELECT
        a.*,
        t.value:topic::STRING AS primary_topic,
        t.value:relevance_score::FLOAT AS primary_topic_relevance
    FROM aapl_sentiment a,
    LATERAL FLATTEN(input => a.topics_json) t

    QUALIFY ROW_NUMBER() OVER (
        PARTITION BY title, time_published
        ORDER BY t.value:relevance_score::FLOAT DESC
    ) = 1
)

SELECT
    ticker,
    title,
    url,
    time_published,
    authors,
    summary,
    source,
    overall_sentiment_score,
    overall_sentiment_label,
    aapl_relevance_score,
    aapl_sentiment_score,
    aapl_sentiment_label,
    primary_topic,
    primary_topic_relevance,
    topics_json AS topics,
    ingestion_time
FROM primary_topic;


