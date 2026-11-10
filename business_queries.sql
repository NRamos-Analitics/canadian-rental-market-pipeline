-- ==============================================================================
-- CANADIAN RENTAL MARKET: BUSINESS OPERATIONS & PROFITABILITY ANALYSIS
-- ==============================================================================

-- Query 1: Regional Profitability and Price per Square Foot Analysis
-- Identifies the most lucrative markets by calculating average rent and value per square foot.
SELECT 
    city, 
    type, 
    COUNT(*) as total_properties, 
    ROUND(AVG(price), 2) as avg_rent, 
    ROUND(AVG(price / NULLIF(SAFE_CAST(sq_feet AS FLOAT64), 0)), 2) as avg_price_per_sqft 
FROM `portfolio-rentals.canadian_real_estate.rental_market` 
WHERE SAFE_CAST(sq_feet AS FLOAT64) > 0 
GROUP BY city, type 
HAVING total_properties > 50 
ORDER BY avg_price_per_sqft DESC 
LIMIT 10;

-- ------------------------------------------------------------------------------

-- Query 2: Market Inventory Segmentation by Price Tiers
-- Categorizes raw rental prices into business segments (Economy, Mid-Range, Luxury).
SELECT 
    city,
    CASE 
        WHEN price < 1500 THEN '1. Economy (<$1500)' 
        WHEN price BETWEEN 1500 AND 2500 THEN '2. Mid-Range ($1500-$2500)' 
        ELSE '3. Luxury (>$2500)' 
    END AS price_tier, 
    COUNT(*) as property_count,
    ROUND(AVG(SAFE_CAST(sq_feet AS FLOAT64)), 0) as avg_space
FROM `portfolio-rentals.canadian_real_estate.rental_market` 
WHERE price IS NOT NULL
GROUP BY city, price_tier 
ORDER BY city ASC, price_tier ASC;

-- ------------------------------------------------------------------------------

-- Query 3: Property Configuration Efficiency and ROI (using CTE)
-- Isolates the performance of different bedroom configurations to determine optimal yield.
WITH PropertyMetrics AS ( 
    SELECT 
        type, 
        SAFE_CAST(beds AS FLOAT64) as beds_num, 
        price, 
        SAFE_CAST(sq_feet AS FLOAT64) as sq_feet_num, 
        (price / NULLIF(SAFE_CAST(sq_feet AS FLOAT64), 0)) as price_per_sqft 
    FROM `portfolio-rentals.canadian_real_estate.rental_market` 
    WHERE SAFE_CAST(beds AS FLOAT64) > 0 
      AND SAFE_CAST(sq_feet AS FLOAT64) > 200 
) 
SELECT 
    type, 
    beds_num as beds, 
    COUNT(*) as total_units, 
    ROUND(AVG(price), 2) as avg_monthly_rent, 
    ROUND(AVG(price_per_sqft), 2) as avg_sqft_value 
FROM PropertyMetrics 
GROUP BY type, beds 
HAVING total_units > 100 
ORDER BY avg_sqft_value DESC;