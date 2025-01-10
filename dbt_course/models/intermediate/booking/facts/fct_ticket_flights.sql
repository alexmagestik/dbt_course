{{
    config(
        materialized = 'view',
    )
}}
SELECT 
    ticket_no, 
    flight_id, 
    fare_conditions,
    amount
FROM 
    {{ ref('stg_booking__ticket_flights') }}