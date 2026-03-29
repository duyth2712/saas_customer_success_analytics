-- =============================================
-- Description:	Create the staging schema and staging data storage tables
-- =============================================

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

-- DDL for stag.CustomerSuccess table
IF EXISTS ( SELECT 1 FROM sys.tables WHERE name = 'CustomerSuccess' and schema_id = (SELECT schema_id FROM sys.schemas WHERE name='stag'))
	DROP TABLE stag.CustomerSuccess;
CREATE TABLE stag.CustomerSuccess
(
	batch_id				BIGINT NOT NULL,
    load_dttm				DATETIME2(0) NOT NULL,

    customer_id             NVARCHAR(50) NOT NULL,
    customer_name           NVARCHAR(255),
    industry                NVARCHAR(100),
    account_manager         NVARCHAR(100),
    subscription_start_date DATE, 
    subscription_end_date   DATE,
    subscription_status     NVARCHAR(20),
    plan_type               NVARCHAR(20),
    monthly_fee             DECIMAL(12,2) ,
    user_count              INT,
    last_login_date         DATE,
    monthly_active_users    INT,
    feature_usage_score     DECIMAL(5,2),
    retention_rate_6m       DECIMAL(5,2),
    retention_rate_12m      DECIMAL(5,2),
    churn_risk_score        DECIMAL(4,2),
    last_success_touch_date DATE,
    notes                   NVARCHAR(MAX),
)
