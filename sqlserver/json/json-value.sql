USE exploration
GO
SET NOCOUNT ON
GO
	
IF EXISTS (select 1 from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'PRODUCT')
	DROP TABLE PRODUCT
GO
CREATE TABLE PRODUCT (
    ID uniqueidentifier NOT NULL DEFAULT (newid()),
    DESCRIPTION varchar(40)
)
GO

insert into PRODUCT (DESCRIPTION) values ('{ "name":"keyboard", "price":30 }')
insert into PRODUCT (DESCRIPTION) values ('{ "name":"mouse", "price":15 }')

select 
    JSON_VALUE(DESCRIPTION, '$.price') as PRICE
from PRODUCT
where JSON_VALUE(DESCRIPTION, '$.name') = 'mouse'
