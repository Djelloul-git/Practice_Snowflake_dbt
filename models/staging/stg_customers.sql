select 
        CUSTOMER_ID,
        FIRST_NAME,
        LAST_NAME,
        EMAIL,
        PHONE,
        to_date(BIRTH_DATE) as BIRTH_DATE,
        REGION,
        CITY,
        to_date(SUBSCRIPTION_DATE) as SUBSCRIPTION_DATE,
        OFFER_CODE,
        CHANNEL,
        PAYMENT_MODE,
        IS_CHURNED,
        to_date(CHURN_DATE) as CHURN_DATE,
        SEGMENT,
        to_timestamp(CREATED_AT) as CREATED_AT,
        to_timestamp(UPDATED_AT) as UPDATED_AT        
  from {{ source('data_raw', 'CUSTOMERS') }}
