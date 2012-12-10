DECLARE @Table varchar(50);
SET @Table = 'payment_type';

 DECLARE @objName VARCHAR(255);
  SELECT @objName =  REPLACE(dbo.udf_titlecase(TABLE_NAME),'_','') FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = @Table
  SELECT 'public class ' + @objName + ' : EntityBase'

SELECT 
'//NULLABLE: ' + CAST(IS_NULLABLE as VARCHAR(MAX)) + '
//DATA TYPE: ' + CAST(DATA_TYPE AS VARCHAR(MAX)) + '
public virtual ' + 

CASE 
WHEN (DATA_TYPE = 'bit')
	THEN 'bool' 
WHEN (DATA_TYPE = 'int') 
	THEN 'int'
WHEN (DATA_TYPE = 'varchar')
	THEN 'string'
WHEN (DATA_TYPE = 'money')
	THEN 'decimal'
WHEN (DATA_TYPE = 'uniqueidentifier')
	THEN 'Guid'
WHEN (DATA_TYPE = 'datetime')
	THEN 'DateTime'
else
	DATA_TYPE
END



 + ' ' + REPLACE(dbo.udf_titlecase(COLUMN_NAME), '_','') + '
{
	get;
	set;
}'
  
FROM   
  INFORMATION_SCHEMA.COLUMNS 
WHERE   
  TABLE_NAME = @Table
ORDER BY 
  ORDINAL_POSITION ASC; 

  

  SELECT 'public class ' + @objName + 'Map : ClassMap<FRD.Domain.' + @objName + '>';

  SELECT 

'Map(x=> x.' + REPLACE(dbo.udf_titlecase(COLUMN_NAME),'_','') + ', "' + COLUMN_NAME + '")' + 
CASE WHEN DATA_TYPE = 'varchar' THEN '.CustomSqlType("VARCHAR(' + CAST(CHARACTER_MAXIMUM_LENGTH as VARCHAR(5)) + ')");' ELSE ';' END

FROM   
  INFORMATION_SCHEMA.COLUMNS 
WHERE   
  TABLE_NAME = @Table
ORDER BY 
  ORDINAL_POSITION ASC; 


 
  SELECT 'public class ' + @objName + 'Repository : RepositoryBase<FRD.Domain.' + @objName + '>, I' + @objName + 'Repository'
  SELECT 'public interface I' + @objName + 'Repository : IRepository<FRD.Domain.' + @objName + '>'