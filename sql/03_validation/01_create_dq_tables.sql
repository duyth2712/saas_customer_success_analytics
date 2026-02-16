-- Create dq schema
IF NOT EXISTS (
    SELECT 1 
    FROM sys.schemas 
    WHERE name = 'dq'
)
BEGIN
    EXEC('CREATE SCHEMA dq');
END;
GO

-- DDL for dq.dq_issue table
IF EXISTS ( SELECT 1 FROM sys.tables WHERE name = 'dq_issue' and schema_id = (SELECT schema_id FROM sys.schemas WHERE name='dq'))
	DROP TABLE dq.dq_issue;
CREATE TABLE dq.dq_issue
(
    dq_issue_id        INT IDENTITY(1,1) PRIMARY KEY,

    source_schema      VARCHAR(50),
    source_table       VARCHAR(50),
    source_view        VARCHAR(100),

    customer_id        VARCHAR(50),

    issue_type         VARCHAR(50),
    issue_flag         VARCHAR(50),
    issue_description  VARCHAR(255),

    detected_date      DATE,
    load_date          DATETIME DEFAULT GETDATE()
);