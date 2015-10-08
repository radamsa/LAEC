%namespace LAEC
%visibility public
%output=gram.cs

%using System.Linq.Expressions;
%using QPDB.Core.Exceptions;
%using PGTypes;
%using QPDB.Core.SqlTypes.Expressions;
%using QPDB.Core.Tables;
%using QPDB.Core.Indexes;
%using QPDB.Parsers.Grammar.Statements;
%using QPDB.Core.PG;
%using QPDB.Core.Programming.Types;


%{
	// В этом списке накапливаются команды SQL для последующего исполнения в пакетном режиме
	private List<Statement> m_Statements = new List<Statement>();
	public List<Statement> Statements { get { return m_Statements; } }
//	// В этом списке накапливаются блоки, которые следует выполнять отдельно друг от друга
//	private List<Statement[]> m_Scenario = new List<Statement[]>();
//	public List<Statement[]> Scenario { get { return m_Scenario; } }
%}

%valuetype Statement
%YYLTYPE Location

%start Sql


%token Identifier Parameter
%token IntegerConst DecimalConst DoubleConst StringConst BinaryConst


// Операторы

%token	DOUBLE_QUOTE
%token	PERCENT
%token	AMPERSAND
%token	QUOTE
%token	LEFT_PAREN
%token	RIGHT_PAREN
%token	ASTERISK
%token	PLUS_SIGN
%token	COMMA
%token	MINUS_SIGN
%token	PERIOD
%token	SOLIDUS
%token	COLON
%token	SEMICOLON
%token	QUESTION_MARK
%token	VERTICAL_BAR
%token	LEFT_BRACKET
%token	RIGHT_BRACKET

%token	OPERATOR_LT		//'<'
%token	OPERATOR_LE		//'<='
%token	OPERATOR_NE		//'<>'|'!='
%token	OPERATOR_EQ		//'=='
%token	OPERATOR_GT		//'>'
%token	OPERATOR_GE		//'>='

// Ключевые слова (в алфавитном порядке)

// Ключевые слова, обозначающие типы данных
%token	BIT BIGINT INT SMALLINT TINYINT DECIMAL NUMERIC
%token	MONEY SMALLMONEY REAL FLOAT
%token	DATETIME SMALLDATETIME
%token	CHAR VARCHAR TEXT NCHAR NVARCHAR NTEXT
%token	BINARY VARBINARY IMAGE
%token	UNIQUEIDENTIFIER
%token	TIMESTAMP
%token	SQLVARIANT
%token	XML

// Список зарезервированных слов для стандарта SQL-92 (взято с запасом)
%token	ABORT ABSOLUTE ACCESS ACTION ADD ALL ALLOCATE ALTER AND ANY ARE
%token	AS ASC ASSEMBLY ASSERTION AT AUTHORIZATION AVG
%token	BEGIN BETWEEN BIT_LENGTH BOTH BY
%token	CASCADE CASCADED CASE CAST CATALOG CHARACTER CHARACTER_LENGTH
%token	CHAR_LENGTH CHECK CLOSE COALESCE COLLATE COLLATION COLUMN COMMIT COUNT
%token	CONNECT CONNECTION CONSTRAINT CONSTRAINTS CONTINUE CONVERT CORRESPONDING
%token	CREATE CROSS CURRENT CURRENT_DATE CURRENT_TIME CURRENT_TIMESTAMP CURRENT_USER CURSOR
%token	DATABASE DATE DAY DEALLOCATE DEC DECLARE DEFAULT
%token	DEFERRABLE DEFERRED DELETE DESC DESCRIBE DESCRIPTOR DIAGNOSTICS
%token	DISALLOW DISCONNECT DISTINCT DOMAIN DOUBLE DROP
%token	ELSE ENGINE END END_EXEC ESCAPE EXCEPT EXCEPTION EXCLUSIVE EXEC EXECUTE EXISTS EXTERNAL EXTRACT
%token	FALSE FETCH FIRST FLOAT FOR FOREIGN FOUND FROM FULL FUNCTION
%token	GET GLOBAL GO GOTO GRANT GROUP
%token	HAVING HIDDEN HOUR
%token	IDENTITY IF IGNORE IMMEDIATE IN INDEX INDICATOR INITIALLY INNER INPUT INSENSITIVE
%token	INSERT INTERSECT INTERVAL INTO IS ISOLATION
%token	JOIN
%token	KEY
%token	LANGUAGE LAST LEADING LEFT LEVEL LIKE LOCAL LOCK LOWER
%token	MATCH MAX MIN MINUTE MODE MODULE MONTH
%token	NAMES NATIONAL NATURAL NEXT NO NOT NOWAIT NULL NULLIF
%token	OCTET_LENGTH OF ON ONLY OPEN OPERATOR OPTION OR ORDER OUTER OUTPUT OVERLAPS
%token	PAD PARTIAL POSITION PRECISION PREPARE PRESERVE PRIMARY PRIOR PRIVILEGES PROCEDURE PUBLIC
%token	READ REAL REFERENCES RELATIVE RESTRICT REVOKE RIGHT ROLLBACK ROW ROWS
%token	SAVEPOINT SCHEMA SCROLL SECOND SECTION SELECT SESSION SESSION_USER SET SHARE SHOW
%token	SIZE SNAPSHOT SOME SPACE SQL SQLCODE SQLERROR SQLSTATE START SUBSTRING SUM SYSTEM_USER
%token	TABLE TABLES TEMPORARY THEN TIME TIMEZONE_HOUR TIMEZONE_MINUTE
%token	TO TRAILING TRANSACTION TRANSLATE TRANSLATION TRIM TRUE
%token	UNION UNIQUE UNKNOWN UNLOCK UPDATE UPPER USAGE USE USER USING
%token	VALUE VALUES VARYING VIEW
%token	WHEN WHENEVER WHERE WITH WORK WRITE
%token	YEAR
%token	ZONE

// Список не зарезервированных слов для стандарта SQL-92 (взято с запасом)
%token	ADA
%token	C CATALOG_NAME CHARACTER_SET_CATALOG CHARACTER_SET_NAME CHARACTER_SET_SCHEMA
%token	CLASS_ORIGIN COBOL COLLATION_CATALOG COLLATION_NAME COLLATION_SCHEMA
%token	COLUMN_NAME COMMAND_FUNCTION COMMITTED CONDITION_NUMBER CONNECTION_NAME
%token	CONSTRAINT_CATALOG CONSTRAINT_NAME CONSTRAINT_SCHEMA CURSOR_NAME
%token	DATA DATETIME_INTERVAL_CODE DATETIME_INTERVAL_PRECISION DYNAMIC_FUNCTION
%token	FORTRAN
%token	LENGTH
%token	MESSAGE_LENGTH MESSAGE_OCTET_LENGTH MESSAGE_TEXT MORE MUMPS
%token	NAME NULLABLE NUMBER
%token	PASCAL PLI
%token	REPEATABLE RETURNED_LENGTH RETURNED_OCTET_LENGTH RETURNED_SQLSTATE ROW_COUNT
%token	SCALE SCHEMA_NAME SERIALIZABLE SERVER_NAME SUBCLASS_ORIGIN
%token	TABLE_NAME TYPE
%token	UNCOMMITTED UNNAMED

// Ключевые слова управляющие процессом функционирования QPDB
%token	FLUSH_BUFFERS MLS


%left	VERTICAL_BAR //'|'
%left	AMPERSAND //'&'
%left	PLUS_SIGN MINUS_SIGN //'+' '-'
%left	ASTERISK SOLIDUS PERCENT //'*' '/' '%'
%left	UMINUS


%%

// ===============================================================
// Типы данных
//

DataType
	:	PredefinedType
	;

PredefinedType
	:	CharacterStringType
	|	NationalCharacterStringType
	|	BinaryLargeObjectStringType
	|	NumericType
	|	BooleanType
	|	DatetimeType
	|	OtherType
	;

CharacterStringType
	:	CHAR TypeLengthOpt
		{
			$$ = new StatementDataType()
			{
				TypeName = "CHAR",
				//Length = (StatementDataTypeLength)$2
				PrecisionAndScale = (StatementDataTypePrecisionAndScale)$2
			};
		}
	|	VARCHAR TypeLengthOpt
		{
			$$ = new StatementDataType()
			{
				TypeName = "VARCHAR",
				//Length = (StatementDataTypeLength)$2
				PrecisionAndScale = (StatementDataTypePrecisionAndScale)$2
			};
		}
	;

NationalCharacterStringType
	:	NCHAR TypeLengthOpt
		{
			$$ = new StatementDataType()
			{
				TypeName = "CHAR",
				//Length = (StatementDataTypeLength)$2
				PrecisionAndScale = (StatementDataTypePrecisionAndScale)$2
			};
		}
	|	NVARCHAR TypeLengthOpt
		{
			$$ = new StatementDataType()
			{
				TypeName = "VARCHAR",
				//Length = (StatementDataTypeLength)$2
				PrecisionAndScale = (StatementDataTypePrecisionAndScale)$2
			};
		}
	;

BinaryLargeObjectStringType
	:	BINARY TypeLengthOpt
		{
			$$ = new StatementDataType()
			{
				TypeName = "BINARY",
				//Length = (StatementDataTypeLength)$2
				PrecisionAndScale = (StatementDataTypePrecisionAndScale)$2
			};
		}
	|	VARBINARY TypeLengthOpt
		{
			$$ = new StatementDataType()
			{
				TypeName = "VARBINARY",
				//Length = (StatementDataTypeLength)$2
				PrecisionAndScale = (StatementDataTypePrecisionAndScale)$2
			};
		}
	;

NumericType
	:	ExactNumericType
	|	ApproximateNumericType
	;

ExactNumericType
	:	BIGINT
		{ $$ = new StatementDataType() { TypeName = "INT8" }; }
	|	INT
		{ $$ = new StatementDataType() { TypeName = "INT4" }; }
	|	SMALLINT
		{ $$ = new StatementDataType() { TypeName = "INT2" }; }
	|	TINYINT
		{ $$ = new StatementDataType() { TypeName = "BYTE" }; }
	|	DECIMAL TypePrecisionAndScaleOpt
		{
			$$ = new StatementDataType()
			{
				TypeName = "DECIMAL",
				PrecisionAndScale = (StatementDataTypePrecisionAndScale)$2
			};
		}
	|	NUMERIC TypePrecisionAndScaleOpt
		{
			$$ = new StatementDataType()
			{
				TypeName = "NUMERIC",
				PrecisionAndScale = (StatementDataTypePrecisionAndScale)$2
			};
		}
	;

ApproximateNumericType
	:	FLOAT TypePrecisionAndScaleOpt
		{
			$$ = new StatementDataType()
			{
				TypeName = "FLOAT8",
				PrecisionAndScale = (StatementDataTypePrecisionAndScale)$2
			};
		}
	|	REAL
		{ $$ = new StatementDataType() { TypeName = "FLOAT4" }; }
	;

BooleanType
	:	BIT
		{ $$ = new StatementDataType() { TypeName = "BOOL" }; }
	;

DatetimeType
	:	DATETIME
		{ $$ = new StatementDataType() { TypeName = "DATETIME" }; }
	|	SMALLDATETIME
		{ $$ = new StatementDataType() { TypeName = "DATETIME" }; }
	;

OtherType
	:	UNIQUEIDENTIFIER	{ $$ = new StatementDataType() { TypeName = "UUID" }; }
	;

TypeLengthOpt
	:	/* empty */
	|	TypeLength
	;

TypeLength
	:	LEFT_PAREN IntegerConst RIGHT_PAREN
		{
			SqlExpression precision = new SqlExpressionConvert(((StatementValue)$2).Value, GetQType("int4")/*Postgres.TYPE_INT4*/);

			//$$ = new StatementDataTypeLength() { Length = ((StatementExactNumericConstant)$2).Value, IsMax = false };
			$$ = new StatementDataTypePrecisionAndScale()
			{
				//Precission = (int)((StatementExactNumericConstant)$2).Value,
				Precission = (int)precision.Evaluate(),
				Scale = 0
			};
		}
	|	LEFT_PAREN MAX RIGHT_PAREN
		{
			//$$ = new StatementDataTypeLength() { IsMax = true };
			$$ = new StatementDataTypePrecisionAndScale()
			{
				Modifier = -1
			};
		}
	;

TypePrecisionAndScaleOpt
	:	/* empty */
	|	TypePrecisionAndScale
	;

TypePrecisionAndScale
	:	LEFT_PAREN IntegerConst RIGHT_PAREN
		{
			SqlExpression precision = new SqlExpressionConvert(((StatementValue)$2).Value, GetQType("int4")/*Postgres.TYPE_INT4*/);

			$$ = new StatementDataTypePrecisionAndScale()
			{
				//Precission = (int)((StatementExactNumericConstant)$2).Value,
				Precission = (int)precision.Evaluate(),
				Scale = 0
			};
		}
	|	LEFT_PAREN IntegerConst COMMA IntegerConst RIGHT_PAREN
		{
			SqlExpression precision = new SqlExpressionConvert(((StatementValue)$2).Value, GetQType("int4")/*Postgres.TYPE_INT4*/);
			SqlExpression scale = new SqlExpressionConvert(((StatementValue)$4).Value, GetQType("int4")/*Postgres.TYPE_INT4*/);

			$$ = new StatementDataTypePrecisionAndScale()
			{
				//Precission = (int)((StatementExactNumericConstant)$2).Value,
				Precission = (int)precision.Evaluate(),
				//Scale = (int)((StatementExactNumericConstant)$4).Value
				Scale = (int)scale.Evaluate()
			};
		}
	;

// ===============================================================
// Идентификаторы
//

TableIdentifier
	:	Identifier PERIOD Identifier
		{
			$$ = new StatementTableIdentifier()
			{
				SchemaName = ((StatementIdentifier)$1).Value,
				TableName = ((StatementIdentifier)$3).Value
			};
		}
	|	Identifier
		{
			$$ = new StatementTableIdentifier()
			{
				TableName = ((StatementIdentifier)$1).Value
			};
		}
	;

QualifiedIdentifier
	:	Identifier PERIOD Identifier PERIOD Identifier
		{
			$$ = new StatementQualifiedIdentifier()
			{
				SchemaName = ((StatementIdentifier)$1).Value,
				TableName = ((StatementIdentifier)$3).Value,
				ObjectName = ((StatementIdentifier)$5).Value
			};
		}
	|	Identifier PERIOD Identifier
		{
			$$ = new StatementQualifiedIdentifier()
			{
				TableName = ((StatementIdentifier)$1).Value,
				ObjectName = ((StatementIdentifier)$3).Value
			};
		}
	|	Identifier
		{
			$$ = new StatementQualifiedIdentifier()
			{
				ObjectName = ((StatementIdentifier)$1).Value
			};
		}
	;

TableIdentifiersList
	:	TableIdentifiersList COMMA TableIdentifier
		{
			$$ = $1;
			((StatementTableIdentifiersList)$$).Items.Add((StatementTableIdentifier)$3);
		}
	|	TableIdentifier
		{
			$$ = new StatementTableIdentifiersList();
			((StatementTableIdentifiersList)$$).Items.Add((StatementTableIdentifier)$1);
		}
	;

QualifiedIdentifiersList
	:	QualifiedIdentifiersList COMMA QualifiedIdentifier
		{
			$$ = $1;
			((StatementQualifiedIdentifiersList)$$).Items.Add((StatementQualifiedIdentifier)$3);
		}
	|	QualifiedIdentifier
		{
			$$ = new StatementQualifiedIdentifiersList();
			((StatementQualifiedIdentifiersList)$$).Items.Add((StatementQualifiedIdentifier)$1);
		}
	;

SimpleIdentifierList
	:	SimpleIdentifierList COMMA Identifier
		{
			$$ = $1;
			((StatementSimpleIdentifierList)$$).Items.Add((StatementIdentifier)$3);
		}
	|	Identifier
		{
			$$ = new StatementSimpleIdentifierList();
			((StatementSimpleIdentifierList)$$).Items.Add((StatementIdentifier)$1);
		}
	;

// ===============================================================
// Выражения
//

Expression
	:	AndExpression OR Expression
		{
			$$ = new StatementBinaryExpression()
			{
				NodeType = SqlExpressionType.Or,
				Left = (StatementExpression)$1,
				Right = (StatementExpression)$3
			};
		}
	|	AndExpression
	;

AndExpression
	:	NotExpression AND AndExpression
		{
			$$ = new StatementBinaryExpression()
			{
				NodeType = SqlExpressionType.And,
				Left = (StatementExpression)$1,
				Right = (StatementExpression)$3
			};
		}
	|	NotExpression
	;

NotExpression
	:	NOT PredExpression
		{
			$$ = new StatementUnaryExpression()
			{
				NodeType = SqlExpressionType.Not,
				Arg = (StatementExpression)$2
			};
		}
	|	PredExpression
	;

PredExpression
	:	AddExpression IS NOT NULL
		{
			$$ = new StatementUnaryExpression()
			{
				NodeType = SqlExpressionType.IsNotNull,
				Arg = (StatementExpression)$1
			};
		}
	|	AddExpression IS NULL
		{
			$$ = new StatementUnaryExpression()
			{
				NodeType = SqlExpressionType.IsNull,
				Arg = (StatementExpression)$1
			};
		}
	|	AddExpression LIKE StringConst
		{
			$$ = new StatementBinaryExpression()
			{
				NodeType = SqlExpressionType.Like,
				Left = (StatementExpression)$1,
				Right = new StatementExpressionConstant()
				{
					Arg = ((StatementValue)$3).Value
				}
			};
		}
	|	AddExpression NOT LIKE StringConst
		{
			$$ = new StatementBinaryExpression()
			{
				NodeType = SqlExpressionType.NotLike,
				Left = (StatementExpression)$1,
				Right = new StatementExpressionConstant()
				{
					Arg = ((StatementValue)$4).Value
				}
			};
		}
	|	AddExpression IN Tuple
		{
			$$ = new StatementInExpression()
			{
				NodeType = SqlExpressionType.In,
				Arg = (StatementExpression)$1,
				Targets = (StatementExpressionList)$3
			};
		}
	|	AddExpression OPERATOR_EQ AddExpression
		{
			$$ = new StatementBinaryExpression()
			{
				NodeType = SqlExpressionType.Equal,
				Left = (StatementExpression)$1,
				Right = (StatementExpression)$3
			};
		}
	|	AddExpression OPERATOR_NE AddExpression
		{
			$$ = new StatementBinaryExpression()
			{
				NodeType = SqlExpressionType.NotEqual,
				Left = (StatementExpression)$1,
				Right = (StatementExpression)$3
			};
		}
	|	AddExpression OPERATOR_GT AddExpression
		{
			$$ = new StatementBinaryExpression()
			{
				NodeType = SqlExpressionType.GreaterThan,
				Left = (StatementExpression)$1,
				Right = (StatementExpression)$3
			};
		}
	|	AddExpression OPERATOR_GE AddExpression
		{
			$$ = new StatementBinaryExpression()
			{
				NodeType = SqlExpressionType.GreaterThanOrEqual,
				Left = (StatementExpression)$1,
				Right = (StatementExpression)$3
			};
		}
	|	AddExpression OPERATOR_LT AddExpression
		{
			$$ = new StatementBinaryExpression()
			{
				NodeType = SqlExpressionType.LessThan,
				Left = (StatementExpression)$1,
				Right = (StatementExpression)$3
			};
		}
	|	AddExpression OPERATOR_LE AddExpression
		{
			$$ = new StatementBinaryExpression()
			{
				NodeType = SqlExpressionType.LessThanOrEqual,
				Left = (StatementExpression)$1,
				Right = (StatementExpression)$3
			};
		}
	|	AddExpression BETWEEN AddExpression AND AddExpression
		{
			$$ = new StatementBetweenExpression()
			{
				NodeType = SqlExpressionType.Between,
				Arg = (StatementExpression)$1,
				MinLimit = (StatementExpression)$3,
				MaxLimit = (StatementExpression)$5
			};
		}
	|	AddExpression NOT BETWEEN AddExpression AND AddExpression
		{
			$$ = new StatementBetweenExpression()
			{
				NodeType = SqlExpressionType.NotBetween,
				Arg = (StatementExpression)$1,
				MinLimit = (StatementExpression)$4,
				MaxLimit = (StatementExpression)$6
			};
		}
	|	AddExpression
	;

AddExpression
	:	AddExpression PLUS_SIGN MultExpression
		{
			$$ = new StatementBinaryExpression()
			{
				NodeType = SqlExpressionType.Add,
				Left = (StatementExpression)$1,
				Right = (StatementExpression)$3
			};
		}
	|	AddExpression MINUS_SIGN MultExpression
		{
			$$ = new StatementBinaryExpression()
			{
				NodeType = SqlExpressionType.Subtract,
				Left = (StatementExpression)$1,
				Right = (StatementExpression)$3
			};
		}
	|	MultExpression
	;

MultExpression
	:	MultExpression ASTERISK NegateExpression
		{
			$$ = new StatementBinaryExpression()
			{
				NodeType = SqlExpressionType.Multiply,
				Left = (StatementExpression)$1,
				Right = (StatementExpression)$3
			};
		}
	|	MultExpression SOLIDUS NegateExpression
		{
			$$ = new StatementBinaryExpression()
			{
				NodeType = SqlExpressionType.Divide,
				Left = (StatementExpression)$1,
				Right = (StatementExpression)$3
			};
		}
	|	MultExpression PERCENT NegateExpression
		{
			$$ = new StatementBinaryExpression()
			{
				NodeType = SqlExpressionType.Modulo,
				Left = (StatementExpression)$1,
				Right = (StatementExpression)$3
			};
		}
	|	NegateExpression
	;

NegateExpression
	:	MINUS_SIGN Value %prec UMINUS
		{
			// Во всем выражении только в этом месте Value присутствует в чистом виде
			// Во всех остальных местах заранее выполняется преобразование Value в StatementExpressionConstant
			$$ = new StatementUnaryExpression()
			{
				NodeType = SqlExpressionType.Negate,
				Arg = new StatementExpressionConstant()
				{
					Arg = ((StatementValue)$2).Value
				}
			};
		}
	|	DataContainerExpression
	;

DataContainerExpression
	:	Value
		{
			$$ = new StatementExpressionConstant()
			{
				Arg = ((StatementValue)$1).Value
			};
		}
	|	QualifiedIdentifier
		{	// В выражении объектом может быть только столбец таблицы
			$$ = new StatementExpressionIdentifier()
			{
				Arg = (StatementQualifiedIdentifier)$1
			};
		}
	|	LEFT_PAREN Expression RIGHT_PAREN
		{
			$$ = $2;
		}
	|	Identifier GroupedExpressionList
		{
			$$ = new StatementFuncExpression()
			{
				Identifier = ((StatementIdentifier)$1).Value,
				Args = (StatementExpressionList)$2
			};
		}
//	|	Tuple
	;
        
Value
	:	IntegerConst
	|	DecimalConst
	|	DoubleConst
	|	StringConst
	|	BinaryConst
	|	NULL
		{
			$$ = new StatementValue() { Value = SqlExpressionValue.Null };
		}
	;

Tuple
	:	GroupedExpressionList
//	|	LEFT_PAREN SelectStatement RIGHT_PAREN
	;

ExpressionList
	:	ExpressionList COMMA Expression
		{
			$$ = $1;
			((StatementExpressionList)$$).Items.Add((StatementExpression)$3);
		}
	|	Expression
		{
			$$ = new StatementExpressionList();
			((StatementExpressionList)$$).Items.Add((StatementExpression)$1);
		}
	;

GroupedExpressionList
	:	LEFT_PAREN ExpressionList RIGHT_PAREN
		{
			$$ = $2;
		}
	;


// ===============================================================
//
Sql
	:	/*empty */
	|	StatementList EOF
		{
//			BatchEnd();
		}
	|	StatementList SEMICOLON EOF
		{
//			BatchEnd();
		}
	;

StatementList
	:	StatementList SEMICOLON Statement
		{
			$3.Text = GetText(@3);
			m_Statements.Add($3);
		}
	|	Statement
		{
			$1.Text = GetText(@1);
			m_Statements.Add($1);
		}
	;

Statement
	:	DDLStatement // Готово, кроме Constraint
	|	DMLStatement
	|	DCLStatement
	|	TCLStatement
	|	DSCLStatement
	;

// ===============================================================
//
// DDL (Data Definition Language) - statements are used to define the database structure or schema.
//
// CREATE - to create objects in the database
// ALTER - alters the structure of the database
// DROP - delete objects from the database
//
DDLStatement
	:	CreateStatement
	|	AlterStatement
	|	DropStatement
	|	ShowStatement
	;

// ---------------------------------------------------------------
CreateStatement
	:	CreateDatabaseStatement
	|	CreateSchemaStatement
	|	CreateTableStatement
	|	CreateIndexStatement
	|	CreateAssemblyStatement
	|	CreateFunctionStatement
	|	CreateOperatorStatement
	;

CreateDatabaseStatement
	:	CREATE DATABASE Identifier
		{
			$$ = new StatementCreateDatabase()
			{
				DatabaseName = (StatementIdentifier)$3,
			};
		}
	;

CreateSchemaStatement
	:	CREATE SCHEMA Identifier SchemaAuthOpt
		{
			$$ = new StatementCreateSchema()
			{
				SchemaName = (StatementIdentifier)$3,
				Authorization = (StatementIdentifier)$4
			};
		}
	;

SchemaAuthOpt
	:	/* empty */
	|	AUTHORIZATION Identifier
		{
			$$ = (StatementIdentifier)$2;
		}
	;

CreateTableStatement
	:	CREATE TABLE TableIdentifier LEFT_PAREN ColumnDefinitionList RIGHT_PAREN EngineOpt
		{
			$$ = new StatementCreateTable()
			{
				TableName = (StatementTableIdentifier)$3,
				ColumnDefinitionList = (StatementColumnDefinitionList)$5,
				StorageProviderName = (StatementValue)$7
			};
		}
	;

CreateIndexStatement
	:	CREATE Unique INDEX Identifier ON TableIdentifier LEFT_PAREN OrderList RIGHT_PAREN WithClause
		{
			$$ = new StatementCreateIndex()
			{
				IsUnique = ($2 != null),
				IndexName = (StatementIdentifier)$4,
				TargetTableName = (StatementTableIdentifier)$6,
				OrderList = (StatementOrderList)$8,
				WithClause = (StatementWithClause)$10
			};
		}
	;

CreateAssemblyStatement
	:	CREATE ASSEMBLY Identifier StringConst
		{
			$$ = new StatementCreateAssembly()
			{
				Name = (StatementIdentifier)$3,
				Definition = ((StatementValue)$4)
			};
		}
	;

CreateFunctionStatement
	:	CREATE FUNCTION Identifier
		{
			$$ = new StatementCreateFunction()
			{
				Name = (StatementIdentifier)$3,
			};
		}
	;

CreateOperatorStatement
	:	CREATE OPERATOR Identifier
		{
			$$ = new StatementCreateOperator()
			{
				Name = (StatementIdentifier)$3,
			};
		}
	;

// ---------------------------------------------------------------
AlterStatement
	:	AlterTableStatement
	;

AlterTableStatement
	:	ALTER TABLE TableIdentifier ADD COLUMN ColumnDefinition
		{
			$$ = new StatementAlterTableAddColumn()
			{
				TableName = (StatementTableIdentifier)$3,
				ColumnDefinition = (StatementColumnDefinition)$6,
			};
		}
	|	ALTER TABLE TableIdentifier ADD CONSTRAINT Constraint
		{
			$$ = new StatementAlterTableAddConstraint()
			{
				TableName = (StatementTableIdentifier)$3,
				Constraint = (StatementConstraint)$6
			};
		}
	|	ALTER TABLE TableIdentifier DROP COLUMN QualifiedIdentifier
		{
			$$ = new StatementAlterTableDropColumn()
			{
				TableName = (StatementTableIdentifier)$3,
				ColumnName = (StatementQualifiedIdentifier)$6
			};
		}
	|	ALTER TABLE TableIdentifier DROP CONSTRAINT Identifier
		{
			$$ = new StatementAlterTableDropConstraint()
			{
				TableName = (StatementTableIdentifier)$3,
				ConstraintName = (StatementIdentifier)$6
			};
		}
	;
 
// ---------------------------------------------------------------
DropStatement
	:	DropDatabaseStatement
	|	DropTableStatement
	|	DropIndexStatement
	|	DropAssemblyStatement
	|	DropFunctionStatement
	|	DropOperatorStatement
	;

DropDatabaseStatement
	:	DROP DATABASE IfExistsOpt SimpleIdentifierList
		{
			$$ = new StatementDropDatabase()
			{
				DatabaseNames = (StatementSimpleIdentifierList)$4,
				IfExists = ($3 != null)
			};
		}
	;

DropTableStatement
	:	DROP TABLE IfExistsOpt TableIdentifiersList
		{
			$$ = new StatementDropTable()
			{
				TableNames = (StatementTableIdentifiersList)$4,
				IfExists = ($3 != null)
			};
		}
	;

DropIndexStatement
	:	DROP INDEX IfExistsOpt QualifiedIdentifier ON TableIdentifier
		{
			$$ = new StatementDropIndex()
			{
				IndexName = (StatementQualifiedIdentifier)$4,
				TableName = (StatementTableIdentifier)$6,
				IfExists = ($3 != null)
			};
		}
	;

DropAssemblyStatement
	:	DROP ASSEMBLY IfExistsOpt Identifier
		{
			$$ = new StatementDropAssembly()
			{
				Name = (StatementIdentifier)$4,
				IfExists = ($3 != null)
			};
		}
	;

DropFunctionStatement
	:	DROP FUNCTION IfExistsOpt Identifier
		{
			$$ = new StatementDropFunction()
			{
				Name = (StatementIdentifier)$4,
				IfExists = ($3 != null)
			};
		}
	;

DropOperatorStatement
	:	DROP OPERATOR IfExistsOpt Identifier
		{
			$$ = new StatementDropOperator()
			{
				Name = (StatementIdentifier)$4,
				IfExists = ($3 != null)
			};
		}
	;

IfExistsOpt
	:	/* empty */
		{
			$$ = null;
		}
	|	IF EXISTS
		{
			$$ = new Statement();
		}
	;

ShowStatement
	:	ShowDatabaseStatement
	|	ShowTablesStatement
	;

ShowDatabaseStatement
	:	SHOW DATABASE
		{
			$$ = new StatementShowDatabase() {};
		}
	;

ShowTablesStatement
	:	SHOW TABLES SimpleIdentifierList
		{
			$$ = new StatementShowTables()
			{
				DatabaseName = (StatementSimpleIdentifierList)$3
			};
		}
	;

// ===============================================================
// DML (Data Manipulation Language) - statements are used for managing data within schema objects.
//
// SELECT - retrieve data from the a database
// INSERT - insert data into a table
// UPDATE - updates existing data within a table
// DELETE - deletes all records from a table, the space for the records remain
//
DMLStatement
	:	SelectStatement
	|	InsertStatement
	|	UpdateStatement
	|	DeleteStatement
	;

SelectStatement
	:	SELECT SelectColumns FROM TableIdentifiersList WhereClause GroupClause HavingClause OrderClause
		{
			$$ = new StatementSelect()
			{
				SelectColumns = (StatementSelectColumns)$2,
				FromTablesList = (StatementTableIdentifiersList)$4,
				WhereClause = (StatementWhereClause)$5,
				GroupClause = (StatementGroupClause)$6,
				HavingClause = (StatementHavingClause)$7,
				OrderList = (StatementOrderList)$8
			};
		}
	;

InsertStatement
	:	INSERT INTO TableIdentifier InsertColumnListOpt VALUES InsertValuesList
		{
			$$ = new StatementInsert()
			{
				TableIdentifier = (StatementTableIdentifier)$3,
				ColumnsList = (StatementSimpleIdentifierList)$4,
				ValuesList = (StatementInsertValuesList)$6
			};
		}
	;

UpdateStatement
	:	UPDATE TableIdentifier SET UpdateValuesList WhereClause
		{
			$$ = new StatementUpdate()
			{	
				TableIdentifier = (StatementTableIdentifier)$2,
				UpdateValuesList = (StatementUpdateValuesList)$4,
				WhereClause = (StatementWhereClause)$5
			};
		}
	;

DeleteStatement
	:	DELETE FROM TableIdentifier WhereClause
		{
			$$ = new StatementDelete()
			{
				TableIdentifier = (StatementTableIdentifier)$3,
				WhereClause = (StatementWhereClause)$4
			};
		}
	;


// ===============================================================
// DCL (Data Control Language).
//
// GRANT - gives user's access privileges to database
// REVOKE - withdraw access privileges given with the GRANT command
//
DCLStatement
	:	USE Identifier
		{
			$$ = new StatementUse()
			{
				DatabaseName = (StatementIdentifier)$2,
			};
		}
//	|	GrantStatement
//	|	RevokeStatement
	;


// ===============================================================
// TCL (Transaction Control Language) - statements are used to manage the changes made by DML statements.
// It allows statements to be grouped together into logical transactions.
//
// BEGIN TRANSACTION - start transaction
// COMMIT - save work done
// SAVEPOINT - identify a point in a transaction to which you can later roll back
// ROLLBACK - restore database to original since the last COMMIT
// SET TRANSACTION - Change transaction options like isolation level and what rollback segment to use	
//
// LOCK TABLE - блокирует доступ к таблице
// UNLOCK TABLE - разблокирует доступ к таблице

// TODO: Реализовать элементы TCL
TCLStatement
	:	BeginTransactionStatement
	|	CommitStatement
	|	SavepointStatement
	|	RollbackStatement
//	|	SetTransactionStatement
	|	LockStatement
	|	UnlockStatement
	;

BeginTransactionStatement
	:	BeginTransactionKeyword TransactionKeywordOpt TransactionIsolationLevelOpt TransactionReadModeOpt TransactionDeferrableOpt
		{
			$$ = new StatementBegin()
			{
				Level = (StatementIsolationLevel)$3,
				Readonly = (null == $4),
				Deferrable = (null == $5)
			};
		}
	;

BeginTransactionKeyword
	:	BEGIN
	|	START
	;

CommitStatement
	:	COMMIT TransactionKeywordOpt
		{
			$$ = new StatementCommit()
			{
			};
		}
	;

SavepointStatement
	:	SAVEPOINT StringConst
		{
			$$ = new StatementSavepoint()
			{
				Name = ((StatementValue)$2).Value
			};
		}
	;

RollbackStatement
	:	AbortTransactionKeyword TransactionKeywordOpt
		{
			$$ = new StatementRollback()
			{
			};
		}
	;

AbortTransactionKeyword
	:	ROLLBACK
	|	ABORT
	;


// SET может использоваться в виде отдельного оператора, осуществляющего присвоение значений локальным и глобальным переменным.
// Пока отложим реализацию и обойдемся только BEGIN
// SetTransactionStatement
// 	:	SET TRANSACTION TransactionIsolationLevelOpt TransactionReadModeOpt TransactionDeferrableOpt
// 		{
// 			$$ = new StatementSetTransaction()
// 			{
// 				Level = (StatementIsolationLevel)$3,
// 				Readonly = (null == $4),
// 				Deferrable = (null == $5)
// 			};
// 		}
// 	|	SET TRANSACTION SNAPSHOT StringConst
// 		{
// 			$$ = new StatementSetTransactionSnapshot()
// 			{
// 				Name = ((StatementValue)$4).Value
// 			};
// 		}
// 	;

LockStatement
//	:	LOCK TABLE TableIdentifiersList IN LockmodeStatement MODE NowaitOpt
//		{
//			$$ = new StatementLockTable()
//			{
//				Tables = (StatementTableIdentifiersList)$3,
//				Mode = ((StatementLockMode)$5).Mode,
//				NoWait = (null != $6)
//			};
//		}
// Пока реализуем упрощенный вариант блокировки - эксклюзивный доступ к блокируемой таблице
	:	LOCK TABLE TableIdentifiersList NowaitOpt
		{
			$$ = new StatementLockTable()
			{
				Tables = (StatementTableIdentifiersList)$3,
				NoWait = (null != $4)
			};
		}
	;

UnlockStatement
	:	UNLOCK TABLE TableIdentifiersList
		{
			$$ = new StatementUnlockTable()
			{
				Tables = (StatementTableIdentifiersList)$3
			};
		}
	;

//LockmodeStatement
//	:	ACCESS SHARE
//		{
//	        $$ = new StatementLockMode { Mode = LockMode.AccessShare };
//		}
//	|	ROW SHARE
//		{
//			$$ = new StatementLockMode { Mode = LockMode.RowShare };
//		}
//	|	ROW EXCLUSIVE
//		{
//			$$ = new StatementLockMode { Mode = LockMode.RowExclusive };
//		}
//	|	SHARE UPDATE EXCLUSIVE
//		{
//			$$ = new StatementLockMode { Mode = LockMode.ShareUpdateExclusive };
//		}
//	|	SHARE
//		{
//			$$ = new StatementLockMode { Mode = LockMode.Share };
//		}
//	|	SHARE ROW EXCLUSIVE
//		{
//			$$ = new StatementLockMode { Mode = LockMode.ShareRowExclusive };
//		}
//	|	EXCLUSIVE
//		{
//			$$ = new StatementLockMode { Mode = LockMode.Exclusive };
//		}
//	|	ACCESS EXCLUSIVE
//		{
//			$$ = new StatementLockMode { Mode = LockMode.AccessExclusive };
//		}
//	;

NowaitOpt
	:	/* empty */
	|	NOWAIT
		{
			$$ = new Statement();
		}
	;

TransactionKeywordOpt
	:	/* empty */
	|	TRANSACTION
	|	WORK
	;

TransactionIsolationLevelOpt
	:	/* empty */
		{
			$$ = new StatementIsolationLevel() { Value = System.Data.IsolationLevel.Unspecified };
		}
	|	ISOLATION LEVEL SERIALIZABLE
		{
			$$ = new StatementIsolationLevel() { Value = System.Data.IsolationLevel.Serializable };
		}
	|	ISOLATION LEVEL REPEATABLE READ
		{
			$$ = new StatementIsolationLevel() { Value = System.Data.IsolationLevel.RepeatableRead };
		}
	|	ISOLATION LEVEL READ COMMITTED
		{
			$$ = new StatementIsolationLevel() { Value = System.Data.IsolationLevel.ReadCommitted };
		}
	|	ISOLATION LEVEL READ UNCOMMITTED
		{
			$$ = new StatementIsolationLevel() { Value = System.Data.IsolationLevel.ReadUncommitted };
		}
	;

TransactionReadModeOpt
	:	/* empty */
	|	READ ONLY
	|	READ WRITE
		{
			$$ = new Statement();
		}
	;

TransactionDeferrableOpt
	:	/* empty */
	|	DEFERRABLE
	|	NOT DEFERRABLE
		{
			$$ = new Statement();
		}
	;

// ===============================================================
// DSCL (Database State Control Language) - язык управления состоянием СУБД.
//
DSCLStatement
	:	FLUSH_BUFFERS
		{
			$$ = new StatementFlushBuffers();
		}
	;


// ===============================================================
// Сопутствующие правила
//

EngineOpt
	:	/* empty */
	|	ENGINE OPERATOR_EQ StringConst
		{
			$$ = $3;
		}
	;

InsertColumnListOpt
	:	/* empty */
	|	InsertColumnList
	;

InsertColumnList
	:	LEFT_PAREN SimpleIdentifierList RIGHT_PAREN
		{
			$$ = (StatementSimpleIdentifierList)$2;
		}
	;

InsertValuesList
	:	InsertValuesList COMMA GroupedExpressionList
		{
			$$ = $1;
			((StatementInsertValuesList)$$).Items.Add((StatementExpressionList)$3);
		}
	|	GroupedExpressionList
		{
			$$ = new StatementInsertValuesList();
			((StatementInsertValuesList)$$).Items.Add((StatementExpressionList)$1);
		}
	;

UpdateValuesList
	:	UpdateValuesList COMMA UpdateColumnItem
		{
			$$ = $1;
			((StatementUpdateValuesList)$$).Items.Add((StatementUpdateColumnItem)$3);
		}
	|	UpdateColumnItem
		{
			$$ = new StatementUpdateValuesList();
			((StatementUpdateValuesList)$$).Items.Add((StatementUpdateColumnItem)$1);
		}
	;

UpdateColumnItem
	:	QualifiedIdentifier OPERATOR_EQ Expression
		{
			$$ = new StatementUpdateColumnItem()
			{
				ColumnName = (StatementQualifiedIdentifier)$1,
				ColumnValue = (StatementExpression)$3
			};
		}
	;

SelectColumns
	:	Restriction ASTERISK
		{
			$$ = new StatementSelectColumns()
			{
				Restriction = (StatementRestriction)$1,
				AllColumns = true,
				ColumnsList = null
			};
		}
	|	Restriction	SelectColumnsList
		{
			$$ = new StatementSelectColumns()
			{
				Restriction = (StatementRestriction)$1,
				AllColumns = false,
				ColumnsList = (StatementSelectColumnsList)$2
			};
		}
	;

Restriction
	:	/* empty */
	|	ALL
		{
			$$ = new StatementRestriction()
			{
				RestrictionType = StatementRestriction.RestrictionTypeId.All
			};
		}
	|	DISTINCT
		{
			$$ = new StatementRestriction()
			{
				RestrictionType = StatementRestriction.RestrictionTypeId.Distinct
			};
		}
	;

SelectColumnsList
	:	SelectColumnsList COMMA SelectColumnItem
		{
			$$ = $1;
			((StatementSelectColumnsList)$$).Items.Add((StatementSelectColumnItem)$3);
		}
	|	SelectColumnItem
		{
			$$ = new StatementSelectColumnsList();
			((StatementSelectColumnsList)$$).Items.Add((StatementSelectColumnItem)$1);
		}
	;

SelectColumnItem
	:	Aggregate
		{
			$$ = new StatementSelectColumnItem()
			{
				Aggregate = (StatementAggregate)$1
			};
		}
	|	QualifiedIdentifier
		{
			$$ = new StatementSelectColumnItem()
			{
				ColumnName = (StatementQualifiedIdentifier)$1
			};
		}
	|	QualifiedIdentifier AS Identifier
		{
			$$ = new StatementSelectColumnItem()
			{
				ColumnName = (StatementQualifiedIdentifier)$1,
				AsName = (StatementIdentifier)$3
			};
		}
	;

Aggregate
	:	COUNT	LEFT_PAREN ASTERISK RIGHT_PAREN
		{
			$$ = new StatementAggregate()
			{
				AggregateType = StatementAggregate.AggregateTypeId.CountOnAll
			};
		}
	|	COUNT	LEFT_PAREN Expression RIGHT_PAREN
		{
			$$ = new StatementAggregate()
			{
				AggregateType = StatementAggregate.AggregateTypeId.Count,
				Expression = (StatementExpression)$3
			};
		}
	|	AVG		LEFT_PAREN Expression RIGHT_PAREN
		{
			$$ = new StatementAggregate()
			{
				AggregateType = StatementAggregate.AggregateTypeId.Avg,
				Expression = (StatementExpression)$3
			};
		}
	|	MIN		LEFT_PAREN Expression RIGHT_PAREN
		{
			$$ = new StatementAggregate()
			{
				AggregateType = StatementAggregate.AggregateTypeId.Min,
				Expression = (StatementExpression)$3
			};
		}
	|	MAX		LEFT_PAREN Expression RIGHT_PAREN
		{
			$$ = new StatementAggregate()
			{
				AggregateType = StatementAggregate.AggregateTypeId.Max,
				Expression = (StatementExpression)$3
			};
		}
	|	SUM		LEFT_PAREN Expression RIGHT_PAREN
		{
			$$ = new StatementAggregate()
			{
				AggregateType = StatementAggregate.AggregateTypeId.Sum,
				Expression = (StatementExpression)$3
			};
		}
	;

WhereClause
	:	/* empty */
	|	WHERE Expression
		{
			$$ = new StatementWhereClause()
			{
				Expression = (StatementExpression)$2
			};
		}
	;

GroupClause
	:	/* empty */
	|	GROUP BY QualifiedIdentifiersList
		{
			throw new NotSupportedException("GROUP BY QualifiedIdentifiersList");
		}
	;

HavingClause
	:	/* empty */
	|	HAVING Expression
		{
			throw new NotSupportedException("HAVING Expression");
		}
	;

OrderClause
	:	/* empty */
	|	ORDER BY OrderList
	;

OrderList
	:	QualifiedIdentifier OrderType
		{
			$$ = new StatementOrderList();
			((StatementOrderList)$$).Items.Add(
				new StatementOrderClause()
				{
					ColumnName = (StatementQualifiedIdentifier)$1,
					Descending = (null != $2)
				});
		}
	|	OrderList COMMA QualifiedIdentifier OrderType
		{
			$$ = $1;
			((StatementOrderList)$$).Items.Add(
				new StatementOrderClause()
				{
					ColumnName = (StatementQualifiedIdentifier)$3,
					Descending = (null != $4)
				});
		}
	;

OrderType
	:	/* empty */
	|	ASC
	|	DESC
		{ $$ = new Statement(); }
	;

Unique
	:	/* empty */
		{ $$ = null; }
	|	UNIQUE
		{ $$ = new Statement(); }
	;

WithClause
	:	/* empty (Инициализируем вариант по умолчанию) */
		{ $$ = new StatementWithClause() { Clause = IndexFlags.DisallowNull }; }
	|	WITH PRIMARY
		{ $$ = new StatementWithClause() { Clause = IndexFlags.Primary }; }
	|	WITH DISALLOW NULL
		{ $$ = new StatementWithClause() { Clause = IndexFlags.DisallowNull }; }
	|	WITH IGNORE NULL
		{ $$ = new StatementWithClause() { Clause = IndexFlags.IgnoreNull }; }
	;

ColumnDefinitionList
	:	ColumnDefinition
		{
			$$ = new StatementColumnDefinitionList();
			((StatementColumnDefinitionList)$$).Items.Add((StatementColumnDefinition)$1);
		}
	|	ColumnDefinitionList COMMA ColumnDefinition
		{
			$$ = $1;
			((StatementColumnDefinitionList)$$).Items.Add((StatementColumnDefinition)$3);
		}
	;

ColumnDefinition
	:	Identifier DataType ColumnAllowNull DefaultValueOpt HiddenOpt WithMLSOpt
		{
			$$ = new StatementColumnDefinition()
			{
				Name = (StatementIdentifier)$1,
				DataType = (StatementDataType)$2,
				AllowNulls = (null == $3),
				DefaultValue = (StatementValue)$4,
				Hidden = (null != $5)
#if POLYINSTANTIATION_COL
				, WithPolyinstantiation = (null != $6)
#endif
			};
		}
	;

ColumnAllowNull
	:	/* empty */
		{
			$$ = null;
		}
	|	NULL
		{
			$$ = null;
		}
	|	NOT NULL
		{
			$$ = new Statement();
		}
	;

DefaultValueOpt
	:	/* empty */
	|	DEFAULT Value
	;

HiddenOpt
	:	/* empty */
		{
			$$ = null;
		}
	|	HIDDEN
		{
			$$ = new Statement();
		}
	;

WithMLSOpt
	:	/* empty */
		{
			$$ = null;
		}
	|	MLS
		{
			$$ = new Statement();
		}
	;

Constraint
	:	Identifier ConstraintType
		{
			$$ = new StatementConstraint()
			{
				Name = (StatementIdentifier)$1,
				Type = (StatementConstraintType)$2
			};
		}
	;

ConstraintType
	:	/* empty */
	|	PRIMARY KEY LEFT_PAREN QualifiedIdentifiersList RIGHT_PAREN
		{
			$$ = new StatementConstraintType()
			{
				Type = StatementConstraintType.TypeId.PrimaryKey,
				ReferencingColumns = (StatementQualifiedIdentifiersList)$4
			};
		}
	|	UNIQUE LEFT_PAREN QualifiedIdentifiersList RIGHT_PAREN
		{
			$$ = new StatementConstraintType()
			{
				Type = StatementConstraintType.TypeId.Unique,
				ReferencingColumns = (StatementQualifiedIdentifiersList)$3
			};
		}
	|	NOT NULL LEFT_PAREN QualifiedIdentifiersList RIGHT_PAREN
		{
			$$ = new StatementConstraintType()
			{
				Type = StatementConstraintType.TypeId.NotNull,
				ReferencingColumns = (StatementQualifiedIdentifiersList)$4
			};
		}
	|	FOREIGN KEY LEFT_PAREN QualifiedIdentifiersList RIGHT_PAREN ReferencesSpecification
		{
			$$ = new StatementConstraintType()
			{
				Type = StatementConstraintType.TypeId.ForeignKey,
				ReferencingColumns = (StatementQualifiedIdentifiersList)$4,
				ReferencesSpecification = (StatementReferencesSpecification)$6
			};
		}
	;

ReferencesSpecification
	:	REFERENCES ReferencedTableAndColumns ReferentialTriggeredActionOpt
		{
			$$ = new StatementReferencesSpecification()
			{
				ReferencedTableAndColumns = (StatementReferencedTableAndColumns)$2,
				ReferentialTriggeredAction = (StatementReferentialTriggeredAction)$3
			};
		}
	;

ReferencedTableAndColumns
	:	TableIdentifier ReferencedColumns
		{
			$$ = new StatementReferencedTableAndColumns()
			{
				TableName = (StatementTableIdentifier)$1,
				ReferencedColumns = (StatementQualifiedIdentifiersList)$2
			};
		}
	;

ReferencedColumns
	:	/* empty */
	|	LEFT_PAREN QualifiedIdentifiersList RIGHT_PAREN
		{ $$ = $2; }
	;

ReferentialTriggeredActionOpt
	:	/* empty */
	|	UpdateRule
		{
			$$ = new StatementReferentialTriggeredAction()
			{
				UpdateAction = (StatementOnEventAction)$1,
			};
		}
	|	DeleteRule
		{
			$$ = new StatementReferentialTriggeredAction()
			{
				DeleteAction = (StatementOnEventAction)$1
			};
		}
	|	UpdateRule DeleteRule
		{
			$$ = new StatementReferentialTriggeredAction()
			{
				UpdateAction = (StatementOnEventAction)$1,
				DeleteAction = (StatementOnEventAction)$2
			};
		}
	|	DeleteRule UpdateRule
		{
			$$ = new StatementReferentialTriggeredAction()
			{
				UpdateAction = (StatementOnEventAction)$2,
				DeleteAction = (StatementOnEventAction)$1
			};
		}
	;

DeleteRule
	:	ON DELETE ReferentialAction
	;

UpdateRule
	:	ON UPDATE ReferentialAction
	;

ReferentialAction
	:	NO ACTION
		{ $$ = new StatementOnEventAction() { ActionType = StatementOnEventAction.ReferentialActionTypeId.NoAction }; }
	|	CASCADE
		{ $$ = new StatementOnEventAction() { ActionType = StatementOnEventAction.ReferentialActionTypeId.Cascade }; }
	|	SET NULL
		{ $$ = new StatementOnEventAction() { ActionType = StatementOnEventAction.ReferentialActionTypeId.SetNull }; }
	|	SET DEFAULT
		{ $$ = new StatementOnEventAction() { ActionType = StatementOnEventAction.ReferentialActionTypeId.SetDefault }; }
	;

%%
//	private void BatchEnd()
//	{
//		// Выполняется разделение блоков пакетного выполнения
//		m_Scenario.Add(m_Statements.ToArray());
//		m_Statements = new List<Statement>();
//		Console.WriteLine("SqlParser.y: BatchEnd() called");
//	}

	public string GetText(Location location)
	{
		return ((Scanner)base.Scanner).GetText(location);
	}

	public QType GetQType(string name)
	{
		return ((Scanner)base.Scanner).GetQType(name);
	}

	public Parser(Scanner scanner)
		: base(scanner)
	{
 	}
