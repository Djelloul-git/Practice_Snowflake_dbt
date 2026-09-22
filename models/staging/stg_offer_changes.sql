select 
        CHANGE_ID,
        CUSTOMER_ID,
        OLD_OFFER,
        NEW_OFFER,
        to_date(CHANGE_DATE) as CHANGE_DATE,
        REASON,
        to_timestamp(CREATED_AT) as CREATED_AT
from {{source('data_raw', 'offer_changes')}}