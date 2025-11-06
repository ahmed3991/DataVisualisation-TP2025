-- models/final_transactions_dzd.sql

-- First, flatten and select the latest DZD exchange rate from USD
WITH latest_dzd_rate AS (
    SELECT
        -- You may need to adjust this path based on your API's exact structure
        CAST("amount" AS NUMERIC) AS usd, 
        CAST("rates__eur" AS NUMERIC) AS eur_rate_usd,
        CAST("rates__gbp" AS NUMERIC) AS gbp_rate_usd,
        CAST("rates__jpy" AS NUMERIC) AS jpy_rate_usd,
        "date" AS rate_date
    FROM {{ source('raw_data_dlt', 'currency_rates') }}
    ORDER BY "date" DESC
    LIMIT 1
),

-- Select the raw transaction data
transactions AS (
    SELECT
        transaction_id,
        amount,
        currency,
        customer_id,
        transaction_date
    FROM {{ source('raw_data_dlt', 'daily_transactions') }}
)

SELECT
    t.transaction_id,
    t.customer_id,
    t.transaction_date,
    t.amount AS original_amount,
    t.currency AS original_currency,
    -- Step 1: Convert all currencies to a common base (USD)
    CASE
        WHEN t.currency = 'USD' THEN t.amount
        WHEN t.currency = 'EUR' THEN t.amount / r.eur_rate_usd
        WHEN t.currency = 'GBP' THEN t.amount / r.gbp_rate_usd
        WHEN t.currency = 'JPY' THEN t.amount / r.jpy_rate_usd
        ELSE NULL 
    END AS amount_usd
    -- -- Step 2: Convert the USD base amount to the final DZD amount
    -- (
    --     CASE
    --         WHEN t.currency = 'USD' THEN t.amount
    --         WHEN t.currency = 'EUR' THEN t.amount / r.eur_rate_usd
    --         WHEN t.currency = 'GBP' THEN t.amount / r.gbp_rate_usd
    --         WHEN t.currency = 'JPY' THEN t.amount / r.jpy_rate_usd
    --         ELSE NULL
    --     END
    -- ) AS amount_usd -- Final converted amount!
FROM transactions t
CROSS JOIN latest_dzd_rate r 
WHERE t.amount IS NOT NULL