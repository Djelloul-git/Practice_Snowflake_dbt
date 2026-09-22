{% snapshot snap_customers %}

{{
    config(
        target_database='TELECOM_DB_DEV',
        target_schema='SNAPSHOTS',
        strategy='check',
        unique_key='customer_id',
        check_cols=['offer_code', 'segment']
    )
}}

select * from {{ ref('stg_customers') }}

{% endsnapshot %}