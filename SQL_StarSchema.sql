create database EGX
select * from FactFinancial;

-- 1. DimCompany
CREATE TABLE DimCompany
(
    CompanyKey INT IDENTITY(1,1) PRIMARY KEY,
    CompanyName VARCHAR(8) NOT NULL UNIQUE
);

-- 2. DimDate
CREATE TABLE DimDate
(
    DateKey INT PRIMARY KEY,
    FullDate DATE NOT NULL UNIQUE,
    Year INT NOT NULL,
    Quarter INT NOT NULL,
    QuarterName VARCHAR(2) NOT NULL
);

-- 3. DimStatement
CREATE TABLE DimStatement
(
    StatementKey INT IDENTITY(1,1) PRIMARY KEY,
    StatementType VARCHAR(50) NOT NULL UNIQUE
);

-- 4. DimFinancialTerm
CREATE TABLE DimFinancialTerm
(
    FinancialTermKey INT IDENTITY(1,1) PRIMARY KEY,
    FinancialTerm VARCHAR(200) NOT NULL,
);

--=======================================================================================
-- 1)
INSERT INTO DimCompany (CompanyName)
SELECT DISTINCT Company
FROM FactFinancial;

select * from DimCompany;

-- 2)
INSERT INTO DimDate
(
    DateKey,
    FullDate,
    Year,
    Quarter,
    QuarterName
)
SELECT DISTINCT
    YEAR([End Of Quarter]) * 10000
        + MONTH([End Of Quarter]) * 100
        + DAY([End Of Quarter]) AS DateKey,
    [End Of Quarter] AS FullDate,
    YEAR([End Of Quarter]) AS Year,
    DATEPART(QUARTER, [End Of Quarter]) AS Quarter,
    'Q' + CAST(DATEPART(QUARTER, [End Of Quarter]) AS VARCHAR(1)) AS QuarterName
FROM FactFinancial;

select * from DimDate;

-- 3)
INSERT INTO DimStatement (StatementType)
SELECT DISTINCT [Statement Type]
FROM FactFinancial;

select * from DimStatement;

-- 4)
INSERT INTO DimFinancialTerm
(
    FinancialTerm
)
SELECT DISTINCT
    [Financial Term]
FROM FactFinancial;

select * from DimFinancialTerm;


--=====================================================================

CREATE TABLE FactFinancial_Star
(
    FactKey BIGINT IDENTITY(1,1) PRIMARY KEY,

    CompanyKey INT NOT NULL,
    DateKey INT NOT NULL,
    StatementKey INT NOT NULL,
    FinancialTermKey INT NOT NULL,

    Amount DECIMAL(20,2) NULL,

    CONSTRAINT FK_FactFinancial_Company
        FOREIGN KEY (CompanyKey)
        REFERENCES DimCompany(CompanyKey),

    CONSTRAINT FK_FactFinancial_Date
        FOREIGN KEY (DateKey)
        REFERENCES DimDate(DateKey),

    CONSTRAINT FK_FactFinancial_Statement
        FOREIGN KEY (StatementKey)
        REFERENCES DimStatement(StatementKey),

    CONSTRAINT FK_FactFinancial_Term
        FOREIGN KEY (FinancialTermKey)
        REFERENCES DimFinancialTerm(FinancialTermKey)
);

INSERT INTO FactFinancial_Star
(
    CompanyKey,
    DateKey,
    StatementKey,
    FinancialTermKey,
    Amount
)
SELECT
    C.CompanyKey,

    D.DateKey,

    S.StatementKey,

    T.FinancialTermKey,

    F.Amount

FROM FactFinancial F

JOIN DimCompany C
    ON F.Company = C.CompanyName

JOIN DimDate D
    ON F.[End Of Quarter] = D.FullDate

JOIN DimStatement S
    ON F.[Statement Type] = S.StatementType

JOIN DimFinancialTerm T
    ON F.[Financial Term] = T.FinancialTerm


SELECT * FROM FactFinancial_Star;

SELECT
    C.CompanyName,
    D.FullDate,
    D.Year,
    D.QuarterName,
    S.StatementType,
    T.FinancialTerm,
    F.Amount
FROM FactFinancial_Star F

JOIN DimCompany C
    ON F.CompanyKey = C.CompanyKey

JOIN DimDate D
    ON F.DateKey = D.DateKey

JOIN DimStatement S
    ON F.StatementKey = S.StatementKey

JOIN DimFinancialTerm T
    ON F.FinancialTermKey = T.FinancialTermKey;