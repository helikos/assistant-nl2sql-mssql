with tab as (select OBJECT_ID(concat(t.TABLE_SCHEMA,'.',t.TABLE_NAME))as object_id
					,t.* 
			 from INFORMATION_SCHEMA.TABLES t 
			 where t.TABLE_SCHEMA = 'HumanResources'
			   and t.TABLE_NAME  = 'EmployeePayHistory'
			)
	,cols as (select tab.object_id
					,c.*
 				from INFORMATION_SCHEMA.COLUMNS c
 				inner join tab on tab.TABLE_SCHEMA = c.TABLE_SCHEMA and tab.TABLE_NAME = c.TABLE_NAME
	)
	,prop as (SELECT cols.Table_schema
					 ,cols.Table_Name
					 ,cols.Column_Name
					,cast(p.Value as nvarchar(200)) as value
 				FROM sys.extended_properties p
 				inner join cols on cols.object_id = p.major_id and cols.ORDINAL_POSITION = p.minor_id
 				where p.class = 1 				  
	)
select concat(p.Table_name,'.',p.Table_schema,'.',p.Column_Name,': ',p.Value)
from prop p

with tab as (select OBJECT_ID(concat(t.TABLE_SCHEMA,'.',t.TABLE_NAME))as object_id
					,t.* 
			 from INFORMATION_SCHEMA.TABLES t 
			 where t.TABLE_SCHEMA = 'HumanResources'
			   and t.TABLE_NAME  = 'EmployeePayHistory'
			)
	,prop as (SELECT tab.Table_schema
					,tab.Table_Name
					,cast(p.Value as nvarchar(200)) as value
 				FROM sys.extended_properties p
 				inner join tab on tab.object_id = p.major_id
 				where p.class = 1
 				  and p.minor_id = 0
	)
select concat(p.Table_name,'.',p.Table_schema,': ',p.Value) 
from prop p

