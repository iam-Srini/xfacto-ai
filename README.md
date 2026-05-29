# XFacto AI

### Turning Market Signals into Actionable Insights

XFacto AI is an AI-powered financial intelligence platform that combines stock market data, financial news, SEC filings, and open-source AI models to explain stock movements, identify key market drivers, and generate short-term market outlooks.

The platform is designed to answer questions such as:

- Why did a stock move today?
- What news or events influenced the movement?
- What are the key risks and opportunities?
- What is the likely short-term outlook based on current market signals?

---

## Key Features

### Market Data Intelligence
- Ingest stock price and volume data
- Track price movements and volatility
- Identify unusual trading activity

### News & Sentiment Analysis
- Collect company-specific financial news
- Analyze sentiment using financial NLP models
- Detect major market-moving events

### SEC Filing Analysis
- Process 10-K, 10-Q, and 8-K filings
- Extract key financial and business insights
- Enable AI-powered filing search and summarization

### Explainable AI
- Explain why a stock moved
- Identify top contributing factors
- Generate evidence-backed insights
- Provide confidence scores and risk indicators

### AI Market Outlook
- Generate short-term market outlooks
- Highlight bullish and bearish signals
- Summarize opportunities and risks
- Support research-driven decision making

---

## Architecture

```text
Stock Data Sources (Yahoo Finance)
                +
Financial News APIs
                +
SEC EDGAR Filings
                │
                ▼
      Python Ingestion Layer
                │
                ▼
        Snowflake Data Warehouse
                │
                ▼
           dbt Models
                │
                ▼
      Feature Engineering Layer
                │
                ▼
        AI Intelligence Engine
      (FinBERT + Open Source LLMs)
                │
                ▼
        FastAPI Backend APIs
                │
                ▼
         Streamlit Dashboard
```

---

## Technology Stack

### Data Engineering
- Python
- Snowflake
- dbt
- SQL
- Apache Airflow (future phase)

### AI & Machine Learning
- Hugging Face
- FinBERT
- Sentence Transformers
- Open Source LLMs
- RAG Architecture

### Backend
- FastAPI
- REST APIs

### Frontend
- Streamlit

### Vector Database
- ChromaDB
- FAISS (future option)

### Deployment
- Docker
- GitHub Actions
- AWS (future phase)

---

## Project Roadmap

### Phase 1 – Data Foundation
- [ ] Create project structure
- [ ] Configure Snowflake environment
- [ ] Ingest stock market data
- [ ] Ingest financial news
- [ ] Ingest SEC filings
- [ ] Create raw and curated tables

### Phase 2 – Data Modeling
- [ ] Build dbt models
- [ ] Create financial metrics layer
- [ ] Create sentiment metrics layer
- [ ] Create stock movement feature layer

### Phase 3 – AI Intelligence Engine
- [ ] News sentiment analysis
- [ ] SEC filing embeddings
- [ ] Retrieval-Augmented Generation (RAG)
- [ ] Explain stock movement engine

### Phase 4 – Market Outlook Engine
- [ ] Trend analysis
- [ ] Risk analysis
- [ ] AI-generated outlooks
- [ ] Confidence scoring

### Phase 5 – User Experience
- [ ] Streamlit dashboard
- [ ] Stock search
- [ ] Research reports
- [ ] Interactive visualizations

### Phase 6 – Open Source Migration
- [ ] PostgreSQL/Supabase support
- [ ] Warehouse abstraction layer
- [ ] Cost-optimized deployment

---

## Example Output

### Why Did NVDA Move?

```text
NVDA declined 3.8% over the past week.

Primary Factors:
1. Increased concerns about semiconductor demand.
2. Negative analyst commentary.
3. Elevated market volatility.
4. Above-average trading volume.

Confidence Score: 74%

Supporting Evidence:
- News Sentiment: Negative
- Volume Change: +42%
- Sector Performance: Weak
```

### AI Market Outlook

```text
Outlook: Moderately Bullish

Confidence: 71%

Positive Signals:
- Strong earnings growth
- Positive news sentiment
- Healthy trading volume

Risks:
- Market-wide volatility
- Macroeconomic uncertainty

Expected Direction:
Upward bias over the next 3–5 trading days.
```

---

## Vision

XFacto AI aims to bridge the gap between traditional financial research and modern AI by transforming raw market signals into explainable, evidence-backed investment insights.

Instead of simply predicting prices, XFacto AI focuses on understanding and explaining the factors that drive market behavior.
