with constr as (SELECT K.COLUMN_NAME, t.table_name, t.table_schema, t.CONSTRAINT_TYPE
                FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS T
                JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE K ON K.CONSTRAINT_NAME = T.CONSTRAINT_NAME
                WHERE T.CONSTRAINT_TYPE = 'PRIMARY KEY' 
     )
	,cols as (SELECT c.table_name
					,c.table_schema
					,c.column_name
					,c.data_type
					,c.character_maximum_length
					,c.is_nullable
					,constr.CONSTRAINT_TYPE
					,OBJECT_ID(concat(c.TABLE_SCHEMA,'.',c.TABLE_NAME))as table_object_id
					,c.ORDINAL_POSITION
				FROM information_schema.columns c
				left JOIN constr on c.TABLE_NAME = constr.TABLE_NAME and c.TABLE_SCHEMA = constr.TABLE_SCHEMA and c.column_name = constr.COLUMN_NAME
	)
	,col_prop as (SELECT cols.table_name
					,cols.table_schema
					,cols.column_name
					,cols.data_type
					,cols.character_maximum_length
					,cols.is_nullable
					,cols.CONSTRAINT_TYPE
					,cast(p.Value as nvarchar(200)) as comments
 				FROM cols
 				left join sys.extended_properties p on cols.table_object_id = p.major_id and cols.ORDINAL_POSITION = p.minor_id and p.class = 1 	
	)  
 select *
   from col_prop
	
	
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
 