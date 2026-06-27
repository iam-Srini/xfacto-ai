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


-- Grain: one row per ticker.
-- Business measures assume 252 trading days per year.
CREATE OR REPLACE TABLE XFACTO_AI.FACT.FACT_STOCK_RISK_METRICS AS
SELECT
    ticker AS ticker_key,
    sector,

    COUNT(daily_return_pct) AS trading_days,

    AVG(daily_return_pct) AS avg_daily_return,

    AVG(daily_return_pct) * 252
        AS annualized_return,

    STDDEV(daily_return_pct)
        AS daily_volatility,

    STDDEV(daily_return_pct) * SQRT(252)
        AS annualized_volatility

FROM XFACTO_AI.CURATED.STOCK_FEATURES
GROUP BY
    ticker,
    sector;


-- Grain: one row per ticker.
-- Business measures summarize daily and annualized return/risk distributions.
CREATE OR REPLACE TABLE XFACTO_AI.FACT.FACT_STOCK_RETURN_STATS AS
SELECT
    ticker AS ticker_key,
    sector,

    COUNT(simple_return) AS trading_days,

    -- Daily Returns
    AVG(simple_return) AS mean_daily_simple_return,
    AVG(log_return) AS mean_daily_log_return,
    AVG(daily_return_pct) AS mean_daily_return_pct,

    -- Annualized Returns
    AVG(simple_return) * 252 AS annualized_simple_return,
    AVG(log_return) * 252 AS annualized_log_return,
    AVG(daily_return_pct) * 252 AS annualized_return_pct,

    -- Daily Risk
    STDDEV(simple_return) AS daily_stddev_simple_return,
    STDDEV(log_return) AS daily_stddev_log_return,
    STDDEV(daily_return_pct) AS daily_stddev_return_pct,

    -- Annualized Risk
    STDDEV(simple_return) * SQRT(252) AS annualized_stddev_simple_return,
    STDDEV(log_return) * SQRT(252) AS annualized_stddev_log_return,
    STDDEV(daily_return_pct) * SQRT(252) AS annualized_stddev_return_pct

FROM XFACTO_AI.CURATED.STOCK_FEATURES
GROUP BY
    ticker,
    sector;


-- Grain: one row per ticker pair.
-- Business measures compare aligned same-day returns between stocks.
CREATE OR REPLACE TABLE XFACTO_AI.FACT.FACT_STOCK_CORRELATION_MATRIX AS
WITH returns AS (
    SELECT
        ticker,
        sector,
        trade_date,
        simple_return,
        log_return,
        daily_return_pct
    FROM XFACTO_AI.CURATED.STOCK_FEATURES
    WHERE simple_return IS NOT NULL
      AND log_return IS NOT NULL
      AND daily_return_pct IS NOT NULL
)

SELECT
    l.ticker AS ticker_key,
    l.sector AS sector,
    r.ticker AS comparison_ticker_key,
    r.sector AS comparison_sector,

    COUNT(*) AS overlapping_trading_days,

    CORR(l.simple_return, r.simple_return)
        AS simple_return_correlation,

    CORR(l.log_return, r.log_return)
        AS log_return_correlation,

    CORR(l.daily_return_pct, r.daily_return_pct)
        AS daily_return_pct_correlation

FROM returns l
INNER JOIN returns r
    ON l.trade_date = r.trade_date
GROUP BY
    l.ticker,
    l.sector,
    r.ticker,
    r.sector;


-- Grain: one row per ticker pair.
-- Business measures compare aligned same-day return covariance between stocks.
CREATE OR REPLACE TABLE XFACTO_AI.FACT.FACT_STOCK_COVARIANCE_MATRIX AS
WITH returns AS (
    SELECT
        ticker,
        sector,
        trade_date,
        simple_return,
        log_return,
        daily_return_pct
    FROM XFACTO_AI.CURATED.STOCK_FEATURES
    WHERE simple_return IS NOT NULL
      AND log_return IS NOT NULL
      AND daily_return_pct IS NOT NULL
)

SELECT
    l.ticker AS ticker_key,
    l.sector AS sector,
    r.ticker AS comparison_ticker_key,
    r.sector AS comparison_sector,

    COUNT(*) AS overlapping_trading_days,

    COVAR_SAMP(l.simple_return, r.simple_return)
        AS simple_return_covariance,

    COVAR_SAMP(l.log_return, r.log_return)
        AS log_return_covariance,

    COVAR_SAMP(l.daily_return_pct, r.daily_return_pct)
        AS daily_return_pct_covariance

FROM returns l
INNER JOIN returns r
    ON l.trade_date = r.trade_date
GROUP BY
    l.ticker,
    l.sector,
    r.ticker,
    r.sector;
