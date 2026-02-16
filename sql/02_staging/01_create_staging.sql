-- Create stag schema
IF NOT EXISTS (
    SELECT 1 
    FROM sys.schemas 
    WHERE name = 'stag'
)
BEGIN
    EXEC('CREATE SCHEMA stag');
END;
GO

-- DDL for stag.customer_success table
IF EXISTS ( SELECT 1 FROM sys.tables WHERE name = 'customer_success' and schema_id = (SELECT schema_id FROM sys.schemas WHERE name='stag'))
	DROP TABLE stag.customer_success;
CREATE TABLE stag.customer_success
(
	raw_load_id             BIGINT NOT NULL,
    raw_load_dttm           DATETIME2(0) NOT NULL,

    customer_id             VARCHAR(50) NOT NULL,
    customer_name           VARCHAR(255) NULL,
    industry                VARCHAR(100) NULL,
    account_manager         VARCHAR(100) NULL,
    subscription_start_date DATE NULL, 
    subscription_end_date   DATE NULL,
    subscription_status     VARCHAR(20) NULL,
    plan_type               VARCHAR(20) NULL,
    monthly_fee             DECIMAL(12,2)  NULL,
    user_count              INT NULL,
    last_login_date         DATE NULL,
    monthly_active_users    INT NULL,
    feature_usage_score     DECIMAL(5,2)   NULL,
    retention_rate_6m       DECIMAL(5,2)   NULL,
    retention_rate_12m      DECIMAL(5,2)   NULL,
    churn_risk_score        DECIMAL(4,2)   NULL,
    last_success_touch_date DATE,
    notes                   NVARCHAR(MAX),
)
