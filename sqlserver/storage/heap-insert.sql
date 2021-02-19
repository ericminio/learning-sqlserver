USE exploration
GO
SET NOCOUNT ON
GO
	
DROP TABLE IF EXISTS PRODUCT
GO
CREATE TABLE PRODUCT (
    ID char(1),
    MAXIMUM_PAGE_CAPACITY varchar(8000)
)
GO

insert into PRODUCT (ID, MAXIMUM_PAGE_CAPACITY) values ('1', replicate('A', 4000))
insert into PRODUCT (ID, MAXIMUM_PAGE_CAPACITY) values ('2', replicate('B', 8000))
insert into PRODUCT (ID, MAXIMUM_PAGE_CAPACITY) values ('3', replicate('C', 4000))

select ID from PRODUCT
select ID from PRODUCT order by ID
