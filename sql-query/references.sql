with rel as (SELECT fk.name 'FK Name',
					concat(cast( OBJECT_SCHEMA_NAME ( tp.object_id ) as varchar(20)),'.',tp.name) as parent_table_name,
					OBJECT_SCHEMA_NAME ( tp.object_id ) as parent_schema,
					tp.name as parent_table,
					cp.name as parent_column_name,
					cp.column_id as parent_column_id,
					concat(cast( OBJECT_SCHEMA_NAME ( tr.object_id ) as varchar(20)),'.',tr.name) as Referenced_table_name,
					OBJECT_SCHEMA_NAME (tr.object_id) as Referenced_schema,
					tr.name as Referenced_table,
					cr.name as Referenced_column_name,
					cr.column_id as Referenced_column_id
				FROM sys.foreign_keys fk
				INNER JOIN sys.tables tp ON fk.parent_object_id = tp.object_id
				INNER JOIN sys.tables tr ON fk.referenced_object_id = tr.object_id
				INNER JOIN sys.foreign_key_columns fkc ON fkc.constraint_object_id = fk.object_id
				INNER JOIN sys.columns cp ON fkc.parent_column_id = cp.column_id AND fkc.parent_object_id = cp.object_id
				INNER JOIN sys.columns cr ON fkc.referenced_column_id = cr.column_id AND fkc.referenced_object_id = cr.object_id)
SELECT concat('FOREIGN KEY (`'
			,STRING_AGG(CONVERT (NVARCHAR (MAX), rel.parent_column_name), '`,`')
			,'`) REFERENCES '
			,Referenced_table_name
			,' (`'
			,STRING_AGG(CONVERT (NVARCHAR (MAX), rel.Referenced_column_name), '`,`')
			,'`)'
	  )
 from rel 
 where rel.parent_schema = 'Sales'
  and rel.parent_table = 'SalesOrderDetail'
  group by Referenced_table_name
  

	

with rel as (SELECT fk.name 'FK Name',
					concat(cast( OBJECT_SCHEMA_NAME ( tp.object_id ) as varchar(20)),'.',tp.name) as parent_table_name,
					OBJECT_SCHEMA_NAME ( tp.object_id ) as parent_schema,
					tp.name as parent_table,
					cp.name as parent_column_name,
					cp.column_id as parent_column_id,
					concat(cast( OBJECT_SCHEMA_NAME ( tr.object_id ) as varchar(20)),'.',tr.name) as Referenced_table_name,
					OBJECT_SCHEMA_NAME (tr.object_id) as Referenced_schema,
					tr.name as Referenced_table,
					cr.name as Referenced_column_name,
					cr.column_id as Referenced_column_id
				FROM sys.foreign_keys fk
				INNER JOIN sys.tables tp ON fk.parent_object_id = tp.object_id
				INNER JOIN sys.tables tr ON fk.referenced_object_id = tr.object_id
				INNER JOIN sys.foreign_key_columns fkc ON fkc.constraint_object_id = fk.object_id
				INNER JOIN sys.columns cp ON fkc.parent_column_id = cp.column_id AND fkc.parent_object_id = cp.object_id
				INNER JOIN sys.columns cr ON fkc.referenced_column_id = cr.column_id AND fkc.referenced_object_id = cr.object_id)
SELECT concat('FOREIGN KEY (`'
			,STRING_AGG(CONVERT (NVARCHAR (MAX), rel.Referenced_column_name), '`,`')
			,'`) REFERENCES '
			,parent_table_name
			,' (`'
			,STRING_AGG(CONVERT (NVARCHAR (MAX), rel.parent_column_name), '`,`')
			,'`)'
	  )
 from rel 
 where rel.Referenced_schema = 'Sales'
  and rel.Referenced_table = 'SalesOrderDetail'
  group by parent_table_name
  
  
  
  
FOREIGN KEY (`SpecialOfferID`,`ProductID`) REFERENCES Sales.SpecialOfferProduct (`SpecialOfferID`,`ProductID`)
FOREIGN KEY (`SalesOrderID`) REFERENCES Sales.SalesOrderHeader (`SalesOrderID`)


FOREIGN KEY (`SpecialOfferID`,`ProductID`) REFERENCES Sales.SalesOrderDetail (`SpecialOfferID`,`ProductID`)

