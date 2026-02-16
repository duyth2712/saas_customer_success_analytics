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
    customer_id             VARCHAR(50)  NOT NULL,
    customer_name           VARCHAR(255),
    industry                VARCHAR(100),
    account_manager         VARCHAR(100),

    subscription_start_date DATE,
    subscription_end_date   DATE,
    subscription_status     VARCHAR(20),
    plan_type               VARCHAR(20),
    monthly_fee             INT,

    user_count              INT,
    last_login_date         DATE,
    monthly_active_users    INT,
    feature_usage_score     FLOAT,

    retention_rate_6m       FLOAT,
    retention_rate_12m      FLOAT,
    churn_risk_score        FLOAT,

    last_success_touch_date DATE,
    notes                   NVARCHAR(MAX),

    load_date               DATETIME DEFAULT GETDATE()
);
