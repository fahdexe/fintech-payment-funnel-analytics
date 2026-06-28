-- Query 1: Global Operations & Revenue Overview
SELECT 
    currency,
    COUNT(transaction_id) as total_transaction_attempts,
    SUM(CASE WHEN status = 'SUCCESS' THEN 1 ELSE 0 END) as successful_transactions,
    
    -- Calculating the exact Success Rate percentage
    ROUND((SUM(CASE WHEN status = 'SUCCESS' THEN 1 ELSE 0 END) / COUNT(transaction_id)) * 100, 2) as success_rate_pct,
    
    -- Normalising total processed volume to USD for executive reporting
    ROUND(SUM(CASE 
        WHEN status = 'SUCCESS' AND currency = 'INR' THEN amount * 0.012  -- approx exchange rate
        WHEN status = 'SUCCESS' AND currency = 'SAR' THEN amount * 0.27   -- approx exchange rate
        WHEN status = 'SUCCESS' AND currency = 'AED' THEN amount * 0.27   -- approx exchange rate
        ELSE 0 
    END), 2) as total_processed_volume_usd
FROM fintech_transaction_logs
GROUP BY currency;

-- Query 2: Preventable Technical Revenue Leakage Analysis
WITH technical_failures AS (
    SELECT 
        payment_gateway,
        currency,
        amount,
        error_code,
        -- Converting leaked amount to USD for standardized ranking
        CASE 
    WHEN currency = 'INR' THEN amount * 0.012
    WHEN currency = 'SAR' THEN amount * 0.27
    WHEN currency = 'AED' THEN amount * 0.27
    ELSE 0
END as leaked_amount_usd
    FROM fintech_transaction_logs
    WHERE status = 'FAILED' 
      AND error_code IN ('SYSTEM_TIMEOUT', 'GATEWAY_DOWN')
)
SELECT 
    payment_gateway,
    COUNT(*) as technical_failure_count,
    ROUND(SUM(leaked_amount_usd), 2) as total_lost_revenue_usd,
    ROUND(AVG(leaked_amount_usd), 2) as avg_ticket_size_lost_usd
FROM technical_failures
GROUP BY payment_gateway
ORDER BY total_lost_revenue_usd DESC;

-- Query 3: Hourly Gateway Performance Tracking (Spotting the Anomaly)
SELECT 
    DATE(timestamp) as log_date,
    HOUR(timestamp) as log_hour,
    payment_gateway,
    currency,
    COUNT(transaction_id) as total_attempts,
    ROUND((SUM(CASE WHEN status = 'SUCCESS' THEN 1 ELSE 0 END) / NULLIF(COUNT(transaction_id), 0)) * 100, 2) as hourly_success_rate_pct
FROM fintech_transaction_logs
WHERE payment_gateway = 'Checkout.com' 
  AND DATE(timestamp) = '2026-06-15'
GROUP BY DATE(timestamp), HOUR(timestamp), payment_gateway, currency
HAVING total_attempts >= 5
ORDER BY log_hour ASC;