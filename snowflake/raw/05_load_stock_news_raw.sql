INSERT INTO XFACTO_AI.RAW.STOCK_NEWS_RAW
SELECT
    'AAPL' AS ticker,
    $1 AS title,
    $2 AS url,
    TO_TIMESTAMP($3, 'YYYYMMDD"T"HH24MISS') AS time_published,
    $4 AS authors,
    $5 AS summary,
    $6 AS banner_image,
    $7 AS source,
    $8 AS category_within_source,
    $9 AS source_domain,
    $10 AS topics,
    $11::FLOAT AS overall_sentiment_score,
    $12 AS overall_sentiment_label,
    $13 AS ticker_sentiment,
    CURRENT_TIMESTAMP() AS ingestion_time
FROM @XFACTO_AI.RAW.YAHOO_FINANCE_STAGE/aapl_news_1year.csv.gz
    (FILE_FORMAT => XFACTO_AI.RAW.CSV_FILE_FORMAT)
WHERE $1 IS NOT NULL;