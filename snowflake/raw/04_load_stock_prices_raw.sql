INSERT INTO XFACTO_AI.RAW.STOCK_PRICES_RAW
SELECT
    $1 AS ticker,
    $2 AS sector,
    TO_DATE($3) AS date,
    $4::FLOAT AS close,
    $5::FLOAT AS high,
    $6::FLOAT AS low,
    $7::FLOAT AS open,
    $8::NUMBER AS volume,
    $9::FLOAT AS ma_20,
    $10::FLOAT AS ma_50,
    CURRENT_TIMESTAMP() AS ingestion_time
FROM @XFACTO_AI.RAW.YAHOO_FINANCE_STAGE/stock_prices_1year.csv.gz
    (FILE_FORMAT => XFACTO_AI.RAW.CSV_FILE_FORMAT)
WHERE $1 IS NOT NULL;
