-- Create raw schema
IF NOT EXISTS (
    SELECT 1 
    FROM sys.schemas 
    WHERE name = 'raw'
)
BEGIN
    EXEC('CREATE SCHEMA raw');
END;
GO

-- Create a run log table to generate batch_id
IF OBJECT_ID('raw.load_run', 'U') IS NULL
BEGIN
    CREATE TABLE raw.load_run
    (
        batch_id    BIGINT IDENTITY(1,1) NOT NULL
            CONSTRAINT PK_raw_load_run PRIMARY KEY,
        load_dttm   DATETIME2(0) NOT NULL
            CONSTRAINT DF_raw_load_run_load_dttm DEFAULT SYSDATETIME(),
        source_file NVARCHAR(4000) NULL
    );
END;
GO

-- Create table raw.customer_success_load 
IF EXISTS ( SELECT 1 FROM sys.tables WHERE name = 'customer_success_load' and schema_id = (SELECT schema_id FROM sys.schemas WHERE name='raw'))
	DROP TABLE raw.customer_success_load;
CREATE TABLE raw.customer_success_load
(
    customer_id                 VARCHAR(50),
    customer_name               NVARCHAR(255),
    industry                    NVARCHAR(100),
    account_manager             NVARCHAR(100),
    subscription_start_date     VARCHAR(20),
    subscription_end_date       VARCHAR(20),
    subscription_status         VARCHAR(20),
    plan_type                   NVARCHAR(50),
    monthly_fee                 VARCHAR(20),
    user_count                  VARCHAR(20),
    last_login_date             VARCHAR(20),
    monthly_active_users        VARCHAR(20),
    feature_usage_score         VARCHAR(20),
    retention_rate_6m           VARCHAR(20),
    retention_rate_12m          VARCHAR(20),
    churn_risk_score            VARCHAR(20),
    last_success_touch_date     VARCHAR(20),
    notes                       NVARCHAR(MAX),
);

-- Create table raw.customer_success
IF EXISTS ( SELECT 1 FROM sys.tables WHERE name = 'customer_success' and schema_id = (SELECT schema_id FROM sys.schemas WHERE name='raw'))
	DROP TABLE raw.customer_success;
CREATE TABLE raw.customer_success
(
    customer_id                 VARCHAR(50),
    customer_name               NVARCHAR(255),
    industry                    NVARCHAR(100),
    account_manager             NVARCHAR(100),
    subscription_start_date     VARCHAR(20),
    subscription_end_date       VARCHAR(20),
    subscription_status         VARCHAR(20),
    plan_type                   NVARCHAR(50),
    monthly_fee                 VARCHAR(20),
    user_count                  VARCHAR(20),
    last_login_date             VARCHAR(20),
    monthly_active_users        VARCHAR(20),
    feature_usage_score         VARCHAR(20),
    retention_rate_6m           VARCHAR(20),
    retention_rate_12m          VARCHAR(20),
    churn_risk_score            VARCHAR(20),
    last_success_touch_date     VARCHAR(20),
    notes                       NVARCHAR(MAX),

	batch_id BIGINT NOT NULL,
	load_id BIGINT IDENTITY(1,1) NOT NULL,
    load_dttm DATETIME2(0) NOT NULL
        CONSTRAINT DF_raw_customer_success_load_dttm DEFAULT SYSDATETIME()
);
