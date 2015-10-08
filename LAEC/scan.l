%namespace LAEC
%option unicode noEmbedBuffers nolisting caseInsensitive
%visibility public

double_quote				\"
percent						\%
ampersand					&
quote						\'
left_paren					\(
right_paren					\)
asterisk					*
plus_sign					+
comma						,
minus_sign					-
period						\.
solidus						/
colon						:
semicolon					;
question_mark				?
vertical_bar				|
left_bracket				\[
right_bracket				\]

operator_lt					<
operator_le					<=
operator_ne					(<>|!=)
operator_eq					=
operator_gt					>
operator_ge					>=

space						[ \t\n\r\f]
newline						[\n\r]
non_newline					[^\n\r]

comment						("--"{non_newline}*)

whitespace					({space}+|{comment})

digit						[0-9]
hexdigit					[0-9A-Fa-f]

integer						{digit}+
decimal						(({digit}*\.{digit}+)|({digit}+\.{digit}*))
decimalfail					{digit}+\.\.
double						({integer}|{decimal})[Ee][\-\+]?{digit}+
doublefail1					({integer}|{decimal})[Ee]
doublefail2					({integer}|{decimal})[Ee][\-\+]

string_const				({quote}[^{quote}]{quote})

//parameter					\${integer}

identifier_start			[A-Za-z_]
identifier_part				[A-Za-z_0-9]
identifier_body				{identifier_start}{identifier_part}*
ansi_identifier_body		\"{identifier_body}\"
tsql_identifier_body		\[{identifier_body}\]
sql_identifier				{identifier_body}|{ansi_identifier_body}|{tsql_identifier_body}
//identifier					({sql_identifier}\.)?{sql_identifier}
identifier					{sql_identifier}

ascii_string				'[^']*'
unicode_string				[nN]{ascii_string}
hexstring					0x{hexdigit}*

%%

{comment}					{ /* Игнорируем комментарий */ }


// Ключевые слова (в алфавитном порядке)

// Ключевые слова, обозначающие типы данных
BIT							{ return TokenInfo(Tokens.BIT); }
BIGINT						{ return TokenInfo(Tokens.BIGINT); }
INT							{ return TokenInfo(Tokens.INT); }
SMALLINT					{ return TokenInfo(Tokens.SMALLINT); }
TINYINT						{ return TokenInfo(Tokens.TINYINT); }
DECIMAL						{ return TokenInfo(Tokens.DECIMAL); }
NUMERIC						{ return TokenInfo(Tokens.NUMERIC); }
MONEY						{ return TokenInfo(Tokens.MONEY); }
SMALLMONEY					{ return TokenInfo(Tokens.SMALLMONEY); }
REAL						{ return TokenInfo(Tokens.REAL); }
FLOAT						{ return TokenInfo(Tokens.FLOAT); }
DATETIME					{ return TokenInfo(Tokens.DATETIME); }
SMALLDATETIME				{ return TokenInfo(Tokens.SMALLDATETIME); }
CHAR						{ return TokenInfo(Tokens.CHAR); }
VARCHAR						{ return TokenInfo(Tokens.VARCHAR); }
TEXT						{ return TokenInfo(Tokens.TEXT); }
NCHAR						{ return TokenInfo(Tokens.NCHAR); }
NVARCHAR					{ return TokenInfo(Tokens.NVARCHAR); }
NTEXT						{ return TokenInfo(Tokens.NTEXT); }
BINARY						{ return TokenInfo(Tokens.BINARY); }
VARBINARY					{ return TokenInfo(Tokens.VARBINARY); }
IMAGE						{ return TokenInfo(Tokens.IMAGE); }
UNIQUEIDENTIFIER			{ return TokenInfo(Tokens.UNIQUEIDENTIFIER); }
SQLVARIANT					{ return TokenInfo(Tokens.SQLVARIANT); }
XML							{ return TokenInfo(Tokens.XML); }

// Список зарезервированных слов для стандарта SQL-92 (взято с запасом)
ABORT						{ return TokenInfo(Tokens.ABORT); }
ABSOLUTE					{ return TokenInfo(Tokens.ABSOLUTE); }
ACCESS						{ return TokenInfo(Tokens.ACCESS); }
ACTION						{ return TokenInfo(Tokens.ACTION); }
ADD							{ return TokenInfo(Tokens.ADD); }
ALL							{ return TokenInfo(Tokens.ALL); }
ALLOCATE					{ return TokenInfo(Tokens.ALLOCATE); }
ALTER						{ return TokenInfo(Tokens.ALTER); }
AND							{ return TokenInfo(Tokens.AND); }
ANY							{ return TokenInfo(Tokens.ANY); }
ARE							{ return TokenInfo(Tokens.ARE); }
AS							{ return TokenInfo(Tokens.AS); }
ASC							{ return TokenInfo(Tokens.ASC); }
ASSEMBLY					{ return TokenInfo(Tokens.ASSEMBLY); }
ASSERTION					{ return TokenInfo(Tokens.ASSERTION); }
AT							{ return TokenInfo(Tokens.AT); }
AUTHORIZATION				{ return TokenInfo(Tokens.AUTHORIZATION); }
AVG							{ return TokenInfo(Tokens.AVG); }
BEGIN						{ return TokenInfo(Tokens.BEGIN); }
BETWEEN						{ return TokenInfo(Tokens.BETWEEN); }
BIT_LENGTH					{ return TokenInfo(Tokens.BIT_LENGTH); }
BOTH						{ return TokenInfo(Tokens.BOTH); }
BY							{ return TokenInfo(Tokens.BY); }
CASCADE						{ return TokenInfo(Tokens.CASCADE); }
CASCADED					{ return TokenInfo(Tokens.CASCADED); }
CASE						{ return TokenInfo(Tokens.CASE); }
CAST						{ return TokenInfo(Tokens.CAST); }
CATALOG						{ return TokenInfo(Tokens.CATALOG); }
CHAR_LENGTH					{ return TokenInfo(Tokens.CHAR_LENGTH); }
CHARACTER					{ return TokenInfo(Tokens.CHARACTER); }
CHARACTER_LENGTH			{ return TokenInfo(Tokens.CHARACTER_LENGTH); }
CHECK						{ return TokenInfo(Tokens.CHECK); }
CLOSE						{ return TokenInfo(Tokens.CLOSE); }
COALESCE					{ return TokenInfo(Tokens.COALESCE); }
COLLATE						{ return TokenInfo(Tokens.COLLATE); }
COLLATION					{ return TokenInfo(Tokens.COLLATION); }
COLUMN						{ return TokenInfo(Tokens.COLUMN); }
COMMIT						{ return TokenInfo(Tokens.COMMIT); }
COUNT						{ return TokenInfo(Tokens.COUNT); }
CONNECT						{ return TokenInfo(Tokens.CONNECT); }
CONNECTION					{ return TokenInfo(Tokens.CONNECTION); }
CONSTRAINT					{ return TokenInfo(Tokens.CONSTRAINT); }
CONSTRAINTS					{ return TokenInfo(Tokens.CONSTRAINTS); }
CONTINUE					{ return TokenInfo(Tokens.CONTINUE); }
CONVERT						{ return TokenInfo(Tokens.CONVERT); }
CORRESPONDING				{ return TokenInfo(Tokens.CORRESPONDING); }
CREATE						{ return TokenInfo(Tokens.CREATE); }
CROSS						{ return TokenInfo(Tokens.CROSS); }
CURRENT						{ return TokenInfo(Tokens.CURRENT); }
CURRENT_DATE				{ return TokenInfo(Tokens.CURRENT_DATE); }
CURRENT_TIME				{ return TokenInfo(Tokens.CURRENT_TIME); }
CURRENT_TIMESTAMP			{ return TokenInfo(Tokens.CURRENT_TIMESTAMP); }
CURRENT_USER				{ return TokenInfo(Tokens.CURRENT_USER); }
CURSOR						{ return TokenInfo(Tokens.CURSOR); }
DATABASE					{ return TokenInfo(Tokens.DATABASE); }
DATE						{ return TokenInfo(Tokens.DATE); }
DAY							{ return TokenInfo(Tokens.DAY); }
DEALLOCATE					{ return TokenInfo(Tokens.DEALLOCATE); }
DEC							{ return TokenInfo(Tokens.DEC); }
DECLARE						{ return TokenInfo(Tokens.DECLARE); }
DEFAULT						{ return TokenInfo(Tokens.DEFAULT); }
DEFERRABLE					{ return TokenInfo(Tokens.DEFERRABLE); }
DEFERRED					{ return TokenInfo(Tokens.DEFERRED); }
DELETE						{ return TokenInfo(Tokens.DELETE); }
DESC						{ return TokenInfo(Tokens.DESC); }
DESCRIBE					{ return TokenInfo(Tokens.DESCRIBE); }
DESCRIPTOR					{ return TokenInfo(Tokens.DESCRIPTOR); }
DIAGNOSTICS					{ return TokenInfo(Tokens.DIAGNOSTICS); }
DISALLOW					{ return TokenInfo(Tokens.DISALLOW); }
DISCONNECT					{ return TokenInfo(Tokens.DISCONNECT); }
DISTINCT					{ return TokenInfo(Tokens.DISTINCT); }
DOMAIN						{ return TokenInfo(Tokens.DOMAIN); }
DOUBLE						{ return TokenInfo(Tokens.DOUBLE); }
DROP						{ return TokenInfo(Tokens.DROP); }
ELSE						{ return TokenInfo(Tokens.ELSE); }
ENGINE						{ return TokenInfo(Tokens.ENGINE); }
END							{ return TokenInfo(Tokens.END); }
END-EXEC					{ return TokenInfo(Tokens.END_EXEC); }
ESCAPE						{ return TokenInfo(Tokens.ESCAPE); }
EXCEPT						{ return TokenInfo(Tokens.EXCEPT); }
EXCEPTION					{ return TokenInfo(Tokens.EXCEPTION); }
EXCLUSIVE					{ return TokenInfo(Tokens.EXCLUSIVE); }
EXEC						{ return TokenInfo(Tokens.EXEC); }
EXECUTE						{ return TokenInfo(Tokens.EXECUTE); }
EXISTS						{ return TokenInfo(Tokens.EXISTS); }
EXTERNAL					{ return TokenInfo(Tokens.EXTERNAL); }
EXTRACT						{ return TokenInfo(Tokens.EXTRACT); }
FALSE						{ return TokenInfo(Tokens.FALSE); }
FETCH						{ return TokenInfo(Tokens.FETCH); }
FIRST						{ return TokenInfo(Tokens.FIRST); }
FOR							{ return TokenInfo(Tokens.FOR); }
FOREIGN						{ return TokenInfo(Tokens.FOREIGN); }
FOUND						{ return TokenInfo(Tokens.FOUND); }
FROM						{ return TokenInfo(Tokens.FROM); }
FULL						{ return TokenInfo(Tokens.FULL); }
FUNCTION					{ return TokenInfo(Tokens.FUNCTION); }
GET							{ return TokenInfo(Tokens.GET); }
GLOBAL						{ return TokenInfo(Tokens.GLOBAL); }
GO							{ return TokenInfo(Tokens.GO); }
GOTO						{ return TokenInfo(Tokens.GOTO); }
GRANT						{ return TokenInfo(Tokens.GRANT); }
GROUP						{ return TokenInfo(Tokens.GROUP); }
HAVING						{ return TokenInfo(Tokens.HAVING); }
HIDDEN						{ return TokenInfo(Tokens.HIDDEN); }
HOUR						{ return TokenInfo(Tokens.HOUR); }
IDENTITY					{ return TokenInfo(Tokens.IDENTITY); }
IF							{ return TokenInfo(Tokens.IF); }
IGNORE						{ return TokenInfo(Tokens.IGNORE); }
IMMEDIATE					{ return TokenInfo(Tokens.IMMEDIATE); }
IN							{ return TokenInfo(Tokens.IN); }
INDEX						{ return TokenInfo(Tokens.INDEX); }
INDICATOR					{ return TokenInfo(Tokens.INDICATOR); }
INITIALLY					{ return TokenInfo(Tokens.INITIALLY); }
INNER						{ return TokenInfo(Tokens.INNER); }
INPUT						{ return TokenInfo(Tokens.INPUT); }
INSENSITIVE					{ return TokenInfo(Tokens.INSENSITIVE); }
INSERT						{ return TokenInfo(Tokens.INSERT); }
INTERSECT					{ return TokenInfo(Tokens.INTERSECT); }
INTERVAL					{ return TokenInfo(Tokens.INTERVAL); }
INTO						{ return TokenInfo(Tokens.INTO); }
IS							{ return TokenInfo(Tokens.IS); }
ISOLATION					{ return TokenInfo(Tokens.ISOLATION); }
JOIN						{ return TokenInfo(Tokens.JOIN); }
KEY							{ return TokenInfo(Tokens.KEY); }
LANGUAGE					{ return TokenInfo(Tokens.LANGUAGE); }
LAST						{ return TokenInfo(Tokens.LAST); }
LEADING						{ return TokenInfo(Tokens.LEADING); }
LEFT						{ return TokenInfo(Tokens.LEFT); }
LEVEL						{ return TokenInfo(Tokens.LEVEL); }
LIKE						{ return TokenInfo(Tokens.LIKE); }
LOCAL						{ return TokenInfo(Tokens.LOCAL); }
LOCK						{ return TokenInfo(Tokens.LOCK); }
LOWER						{ return TokenInfo(Tokens.LOWER); }
MATCH						{ return TokenInfo(Tokens.MATCH); }
MAX							{ return TokenInfo(Tokens.MAX); }
MIN							{ return TokenInfo(Tokens.MIN); }
MINUTE						{ return TokenInfo(Tokens.MINUTE); }
MODE						{ return TokenInfo(Tokens.MODE); }
MODULE						{ return TokenInfo(Tokens.MODULE); }
MONTH						{ return TokenInfo(Tokens.MONTH); }
NAMES						{ return TokenInfo(Tokens.NAMES); }
NATIONAL					{ return TokenInfo(Tokens.NATIONAL); }
NATURAL						{ return TokenInfo(Tokens.NATURAL); }
NEXT						{ return TokenInfo(Tokens.NEXT); }
NO							{ return TokenInfo(Tokens.NO); }
NOT							{ return TokenInfo(Tokens.NOT); }
NOWAIT						{ return TokenInfo(Tokens.NOWAIT); }
NULL						{ return TokenInfo(Tokens.NULL); }
NULLIF						{ return TokenInfo(Tokens.NULLIF); }
OCTET_LENGTH				{ return TokenInfo(Tokens.OCTET_LENGTH); }
OF							{ return TokenInfo(Tokens.OF); }
ON							{ return TokenInfo(Tokens.ON); }
ONLY						{ return TokenInfo(Tokens.ONLY); }
OPEN						{ return TokenInfo(Tokens.OPEN); }
OPERATOR					{ return TokenInfo(Tokens.OPERATOR); }
OPTION						{ return TokenInfo(Tokens.OPTION); }
OR							{ return TokenInfo(Tokens.OR); }
ORDER						{ return TokenInfo(Tokens.ORDER); }
OUTER						{ return TokenInfo(Tokens.OUTER); }
OUTPUT						{ return TokenInfo(Tokens.OUTPUT); }
OVERLAPS					{ return TokenInfo(Tokens.OVERLAPS); }
PAD							{ return TokenInfo(Tokens.PAD); }
PARTIAL						{ return TokenInfo(Tokens.PARTIAL); }
POSITION					{ return TokenInfo(Tokens.POSITION); }
PRECISION					{ return TokenInfo(Tokens.PRECISION); }
PREPARE						{ return TokenInfo(Tokens.PREPARE); }
PRESERVE					{ return TokenInfo(Tokens.PRESERVE); }
PRIMARY						{ return TokenInfo(Tokens.PRIMARY); }
PRIOR						{ return TokenInfo(Tokens.PRIOR); }
PRIVILEGES					{ return TokenInfo(Tokens.PRIVILEGES); }
PROCEDURE					{ return TokenInfo(Tokens.PROCEDURE); }
PUBLIC						{ return TokenInfo(Tokens.PUBLIC); }
READ						{ return TokenInfo(Tokens.READ); }
REFERENCES					{ return TokenInfo(Tokens.REFERENCES); }
RELATIVE					{ return TokenInfo(Tokens.RELATIVE); }
RESTRICT					{ return TokenInfo(Tokens.RESTRICT); }
REVOKE						{ return TokenInfo(Tokens.REVOKE); }
RIGHT						{ return TokenInfo(Tokens.RIGHT); }
ROLLBACK					{ return TokenInfo(Tokens.ROLLBACK); }
ROW							{ return TokenInfo(Tokens.ROW); }
ROWS						{ return TokenInfo(Tokens.ROWS); }
SAVEPOINT					{ return TokenInfo(Tokens.SAVEPOINT); }
SCHEMA						{ return TokenInfo(Tokens.SCHEMA); }
SCROLL						{ return TokenInfo(Tokens.SCROLL); }
SECOND						{ return TokenInfo(Tokens.SECOND); }
SECTION						{ return TokenInfo(Tokens.SECTION); }
SELECT						{ return TokenInfo(Tokens.SELECT); }
SESSION						{ return TokenInfo(Tokens.SESSION); }
SESSION_USER				{ return TokenInfo(Tokens.SESSION_USER); }
SET							{ return TokenInfo(Tokens.SET); }
SIZE						{ return TokenInfo(Tokens.SIZE); }
SNAPSHOT					{ return TokenInfo(Tokens.SNAPSHOT); }
SHARE						{ return TokenInfo(Tokens.SHARE); }
SHOW						{ return TokenInfo(Tokens.SHOW); }
SOME						{ return TokenInfo(Tokens.SOME); }
SPACE						{ return TokenInfo(Tokens.SPACE); }
SQL							{ return TokenInfo(Tokens.SQL); }
SQLCODE						{ return TokenInfo(Tokens.SQLCODE); }
SQLERROR					{ return TokenInfo(Tokens.SQLERROR); }
SQLSTATE					{ return TokenInfo(Tokens.SQLSTATE); }
START						{ return TokenInfo(Tokens.START); }
SUBSTRING					{ return TokenInfo(Tokens.SUBSTRING); }
SUM							{ return TokenInfo(Tokens.SUM); }
SYSTEM_USER					{ return TokenInfo(Tokens.SYSTEM_USER); }
TABLE						{ return TokenInfo(Tokens.TABLE); }
TABLES						{ return TokenInfo(Tokens.TABLES); }
TEMPORARY					{ return TokenInfo(Tokens.TEMPORARY); }
THEN						{ return TokenInfo(Tokens.THEN); }
TIME						{ return TokenInfo(Tokens.TIME); }
TIMESTAMP					{ return TokenInfo(Tokens.TIMESTAMP); }
TIMEZONE_HOUR				{ return TokenInfo(Tokens.TIMEZONE_HOUR); }
TIMEZONE_MINUTE				{ return TokenInfo(Tokens.TIMEZONE_MINUTE); }
TO							{ return TokenInfo(Tokens.TO); }
TRAILING					{ return TokenInfo(Tokens.TRAILING); }
TRANSACTION					{ return TokenInfo(Tokens.TRANSACTION); }
TRANSLATE					{ return TokenInfo(Tokens.TRANSLATE); }
TRANSLATION					{ return TokenInfo(Tokens.TRANSLATION); }
TRIM						{ return TokenInfo(Tokens.TRIM); }
TRUE						{ return TokenInfo(Tokens.TRUE); }
UNION						{ return TokenInfo(Tokens.UNION); }
UNIQUE						{ return TokenInfo(Tokens.UNIQUE); }
UNKNOWN						{ return TokenInfo(Tokens.UNKNOWN); }
UNLOCK						{ return TokenInfo(Tokens.UNLOCK); }
UPDATE						{ return TokenInfo(Tokens.UPDATE); }
UPPER						{ return TokenInfo(Tokens.UPPER); }
USAGE						{ return TokenInfo(Tokens.USAGE); }
USE							{ return TokenInfo(Tokens.USE); }
USER						{ return TokenInfo(Tokens.USER); }
USING						{ return TokenInfo(Tokens.USING); }
VALUE						{ return TokenInfo(Tokens.VALUE); }
VALUES						{ return TokenInfo(Tokens.VALUES); }
VARYING						{ return TokenInfo(Tokens.VARYING); }
VIEW						{ return TokenInfo(Tokens.VIEW); }
WHEN						{ return TokenInfo(Tokens.WHEN); }
WHENEVER					{ return TokenInfo(Tokens.WHENEVER); }
WHERE						{ return TokenInfo(Tokens.WHERE); }
WITH						{ return TokenInfo(Tokens.WITH); }
WORK						{ return TokenInfo(Tokens.WORK); }
WRITE						{ return TokenInfo(Tokens.WRITE); }
YEAR						{ return TokenInfo(Tokens.YEAR); }
ZONE						{ return TokenInfo(Tokens.ZONE); }

// Список не зарезервированных слов для стандарта SQL-92 (взято с запасом)
ADA							{ return TokenInfo(Tokens.ADA); }
C							{ return TokenInfo(Tokens.C); }
CATALOG_NAME				{ return TokenInfo(Tokens.CATALOG_NAME); }
CHARACTER_SET_CATALOG		{ return TokenInfo(Tokens.CHARACTER_SET_CATALOG); }
CHARACTER_SET_NAME			{ return TokenInfo(Tokens.CHARACTER_SET_NAME); }
CHARACTER_SET_SCHEMA		{ return TokenInfo(Tokens.CHARACTER_SET_SCHEMA); }
CLASS_ORIGIN				{ return TokenInfo(Tokens.CLASS_ORIGIN); }
COBOL						{ return TokenInfo(Tokens.COBOL); }
COLLATION_CATALOG			{ return TokenInfo(Tokens.COLLATION_CATALOG); }
COLLATION_NAME				{ return TokenInfo(Tokens.COLLATION_NAME); }
COLLATION_SCHEMA			{ return TokenInfo(Tokens.COLLATION_SCHEMA); }
COLUMN_NAME					{ return TokenInfo(Tokens.COLUMN_NAME); }
COMMAND_FUNCTION			{ return TokenInfo(Tokens.COMMAND_FUNCTION); }
COMMITTED					{ return TokenInfo(Tokens.COMMITTED); }
CONDITION_NUMBER			{ return TokenInfo(Tokens.CONDITION_NUMBER); }
CONNECTION_NAME				{ return TokenInfo(Tokens.CONNECTION_NAME); }
CONSTRAINT_CATALOG			{ return TokenInfo(Tokens.CONSTRAINT_CATALOG); }
CONSTRAINT_NAME				{ return TokenInfo(Tokens.CONSTRAINT_NAME); }
CONSTRAINT_SCHEMA			{ return TokenInfo(Tokens.CONSTRAINT_SCHEMA); }
CURSOR_NAME					{ return TokenInfo(Tokens.CURSOR_NAME); }
DATA						{ return TokenInfo(Tokens.DATA); }
DATETIME_INTERVAL_CODE		{ return TokenInfo(Tokens.DATETIME_INTERVAL_CODE); }
DATETIME_INTERVAL_PRECISION	{ return TokenInfo(Tokens.DATETIME_INTERVAL_PRECISION); }
DYNAMIC_FUNCTION			{ return TokenInfo(Tokens.DYNAMIC_FUNCTION); }
FORTRAN						{ return TokenInfo(Tokens.FORTRAN); }
LENGTH						{ return TokenInfo(Tokens.LENGTH); }
MESSAGE_LENGTH				{ return TokenInfo(Tokens.MESSAGE_LENGTH); }
MESSAGE_OCTET_LENGTH		{ return TokenInfo(Tokens.MESSAGE_OCTET_LENGTH); }
MESSAGE_TEXT				{ return TokenInfo(Tokens.MESSAGE_TEXT); }
MORE						{ return TokenInfo(Tokens.MORE); }
MUMPS						{ return TokenInfo(Tokens.MUMPS); }
NAME						{ return TokenInfo(Tokens.NAME); }
NULLABLE					{ return TokenInfo(Tokens.NULLABLE); }
NUMBER						{ return TokenInfo(Tokens.NUMBER); }
PASCAL						{ return TokenInfo(Tokens.PASCAL); }
PLI							{ return TokenInfo(Tokens.PLI); }
REPEATABLE					{ return TokenInfo(Tokens.REPEATABLE); }
RETURNED_LENGTH				{ return TokenInfo(Tokens.RETURNED_LENGTH); }
RETURNED_OCTET_LENGTH		{ return TokenInfo(Tokens.RETURNED_OCTET_LENGTH); }
RETURNED_SQLSTATE			{ return TokenInfo(Tokens.RETURNED_SQLSTATE); }
ROW_COUNT					{ return TokenInfo(Tokens.ROW_COUNT); }
SCALE						{ return TokenInfo(Tokens.SCALE); }
SCHEMA_NAME					{ return TokenInfo(Tokens.SCHEMA_NAME); }
SERIALIZABLE				{ return TokenInfo(Tokens.SERIALIZABLE); }
SERVER_NAME					{ return TokenInfo(Tokens.SERVER_NAME); }
SUBCLASS_ORIGIN				{ return TokenInfo(Tokens.SUBCLASS_ORIGIN); }
TABLE_NAME					{ return TokenInfo(Tokens.TABLE_NAME); }
TYPE						{ return TokenInfo(Tokens.TYPE); }
UNCOMMITTED					{ return TokenInfo(Tokens.UNCOMMITTED); }
UNNAMED						{ return TokenInfo(Tokens.UNNAMED); }

// Ключевые слова управляющие процессом функционирования QPDB
FLUSH_BUFFERS				{ return TokenInfo(Tokens.FLUSH_BUFFERS); }
MLS							{ return TokenInfo(Tokens.MLS); }

//{parameter}				{
//								yylval = new StatementParameter() { Value = yytext };
//								return TokenInfo(Tokens.Parameter;
//							}

{identifier}				{
								//Console.WriteLine("identifier: {0}", yytext);
								yylval = new StatementIdentifier(yytext);
								return TokenInfo(Tokens.Identifier);
							}

{integer}					{
								//Console.WriteLine("integer: {0}", yytext);
								yylval = ParseLong(yytext);
								if (null == yylval)
									yyerror("Can't convert {0} to integer", yytext);

								return TokenInfo(Tokens.IntegerConst);
							}
{decimal}					{
								//Console.WriteLine("decimal: {0}", yytext);
								yylval = ParseDecimal(yytext);
								if (null == yylval)
									yyerror("Can't convert {0} to decimal", yytext);

								return TokenInfo(Tokens.DecimalConst);
							}
{decimalfail}				{
								// возвращаем идущие подряд две точки (..) и считаем, что это целое число
								yyless(yyleng-2);

								yylval = ParseLong(yytext);
								if (null == yylval)
									yyerror("Can't convert {0} to integer", yytext);

								return TokenInfo(Tokens.IntegerConst);
							}
{double}					{
								//Console.WriteLine("double: {0}", yytext);
								yylval = ParseDouble(yytext);
								if (null == yylval)
									yyerror("Can't convert {0} to decimal", yytext);

								return TokenInfo(Tokens.DoubleConst);
							}
{doublefail1}				{
								yyless(yyleng - 1);

								yylval = ParseDouble(yytext);
								if (null == yylval)
									yyerror("Can't convert {0} to decimal", yytext);

								return TokenInfo(Tokens.DoubleConst);
							}
{doublefail2}				{
								/* возвращаем назад символы [Ee][+-], и обрабатываем также, как и doublefail1 */
								yyless(yyleng-2);

								//yylval = StatementApproximateNumericConstant.Parse(yytext);
								yylval = ParseDouble(yytext);
								if (null == yylval)
									yyerror("Can't convert {0} to decimal", yytext);

								return TokenInfo(Tokens.DoubleConst);
							}

// Строка символов
{unicode_string}			{
								//Console.WriteLine("string: {0}", yytext);
								m_str.Append(yytext);

								//Console.WriteLine("yyleng: {0}, yytext: {1}, code: {2}, m_str: {3}", yyleng, yytext, (char)code, m_str);

								if (code != '\'')
								{
									yylval = ParseUnicodeString(m_str.ToString());
									if (null == yylval)
										yyerror("Can't convert {0} to unicode string", yytext);

									m_str = new StringBuilder();

									return TokenInfo(Tokens.StringConst);
								}
							}

{ascii_string}				{
								//Console.WriteLine("string: {0}", yytext);
								m_str.Append(yytext);

								//Console.WriteLine("yyleng: {0}, yytext: {1}, code: {2}, m_str: {3}", yyleng, yytext, (char)code, m_str);

								if (code != '\'')
								{
									yylval = ParseString(m_str.ToString());
									if (null == yylval)
										yyerror("Can't convert {0} to ascii string", yytext);

									m_str = new StringBuilder();

									return TokenInfo(Tokens.StringConst);
								}
							}

// Шестнадцатиричное значение
{hexstring}					{
								//Console.WriteLine("hexstring: {0}", yytext);
								// Удалим из строки префикс 0x и преобразуем ее в двоичную константу
								yylval = ParseBinary(yytext.Substring(2));

								return TokenInfo(Tokens.BinaryConst);
							}

{double_quote}				{ return TokenInfo(Tokens.DOUBLE_QUOTE); }
{percent}					{ return TokenInfo(Tokens.PERCENT); }
{ampersand}					{ return TokenInfo(Tokens.AMPERSAND); }
{left_paren}				{ return TokenInfo(Tokens.LEFT_PAREN); }
{right_paren}				{ return TokenInfo(Tokens.RIGHT_PAREN); }
{asterisk}					{ return TokenInfo(Tokens.ASTERISK); }
{plus_sign}					{ return TokenInfo(Tokens.PLUS_SIGN); }
{comma}						{ return TokenInfo(Tokens.COMMA); }
{minus_sign}				{ return TokenInfo(Tokens.MINUS_SIGN); }
{period}					{ return TokenInfo(Tokens.PERIOD); }
{solidus}					{ return TokenInfo(Tokens.SOLIDUS); }
{colon}						{ return TokenInfo(Tokens.COLON); }
{semicolon}					{ return TokenInfo(Tokens.SEMICOLON); }
{question_mark}				{ return TokenInfo(Tokens.QUESTION_MARK); }
{vertical_bar}				{ return TokenInfo(Tokens.VERTICAL_BAR); }
{left_bracket}				{ return TokenInfo(Tokens.LEFT_BRACKET); }
{right_bracket}				{ return TokenInfo(Tokens.RIGHT_BRACKET); }

{operator_lt}				{ return TokenInfo(Tokens.OPERATOR_LT); }
{operator_le}				{ return TokenInfo(Tokens.OPERATOR_LE); }
{operator_ne}				{ return TokenInfo(Tokens.OPERATOR_NE); }
{operator_eq}				{ return TokenInfo(Tokens.OPERATOR_EQ); }
{operator_gt}				{ return TokenInfo(Tokens.OPERATOR_GT); }
{operator_ge}				{ return TokenInfo(Tokens.OPERATOR_GE); }

<<EOF>>						{ return TokenInfo(Tokens.EOF); }

%%
	private StringBuilder m_str = new StringBuilder();
	private readonly ExecutionContext m_eContext;

	public string ErrorMessage { get; private set; }
	public ParserException.ErrorPosition ErrorPos { get; private set; }

	public Scanner(ExecutionContext eContext)
		: this()
	{
		m_eContext = eContext;
	}

	public QType GetQType(string name)
	{
		return m_eContext.GetQType(name);
	}

	public override void yyerror(string format, params object[] args)
	{
		//Console.WriteLine(format, args);
		ErrorMessage = string.Format(format, args) + string.Format(" at line {0}, col {1} (pos {2}).",
			yyline,
			yycol,
			yypos);
		ErrorPos = new ParserException.ErrorPosition()
		{
			Line = yyline,
			Col = yycol,
			Pos = yypos
		};
	}

	private int TokenInfo(Tokens token)
	{
		yylloc = new Location(tokLin, tokCol, tokELin, tokECol, tokPos, tokEPos);

		return (int)token;
	}

	public string GetText(Location location)
	{
		return buffer.GetString(location.StartPosition, location.EndPosition);
	}

    public StatementValue ParseLong(string value)
    {
		return new StatementValue() { Value = new SqlExpressionValue(GetQType("numeric")/*Postgres.TYPE_NUMERIC*/, value) };
    }

    public StatementValue ParseDouble(string value)
    {
        return new StatementValue() { Value = new SqlExpressionValue(GetQType("numeric")/*Postgres.TYPE_NUMERIC*/, value) };
    }

    public StatementValue ParseDecimal(string value)
    {
        return new StatementValue() { Value = new SqlExpressionValue(GetQType("numeric")/*Postgres.TYPE_NUMERIC*/, value) };
    }

    public StatementValue ParseString(string value)
    {
        // Пропускаем символы кавычек, ограничивающие строку
        int startIndex = value.IndexOf('\'') + 1;
        // Вычитаем из длины все, что до начальной кавычки, включительно, и заключительную кавычку
        int len = value.Length - startIndex - 1;

		string str = value.Substring(startIndex, len).Replace("''", "'").Replace(@"\\", @"\");

		return new StatementValue() { Value = new SqlExpressionValue(GetQType("text")/*Postgres.TYPE_TEXT*/, str) };
    }

    public StatementValue ParseUnicodeString(string value)
    {
        // Пропускаем символы кавычек, ограничивающие строку
        int startIndex = value.IndexOf('\'') + 1;
        // Вычитаем из длины все, что до начальной кавычки, включительно, и заключительную кавычку
        int len = value.Length - startIndex - 1;

		string str = value.Substring(startIndex, len).Replace("''", "'").Replace(@"\\", @"\");

		return new StatementValue() { Value = new SqlExpressionValue(GetQType("text")/*Postgres.TYPE_TEXT*/, str) };
    }

    public StatementValue ParseBinary(string value)
    {
        // При не четном числе символов, следует добавить 0 в начало строки
        value = (value.Length % 2 != 0) ? "0" + value : value;

        return new StatementValue() { Value = new SqlExpressionValue(GetQType("bytea")/*Postgres.TYPE_BYTEA*/, value) };
    }
