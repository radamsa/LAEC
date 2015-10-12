%namespace LAEC
%visibility internal
%output=gram.cs

%{
	private object m_parsetree;
	private List<object> m_statements = new List<object>();
%}

//%valuetype Statement
%YYLTYPE LexLocation

%union
{
	public object		stmt;
	public List<object>	stmt_list;
	public string		keyword;
	public string		node;
	public bool			boolean;
}

%type  <stmt>		LAE Expression
%type  <stmt_list>	ExpressionList
%type  <boolean>	BoolConst

%token <node>		Node
%token <keyword>	TRANS DATA CONDITION TRUE FALSE

%start LAE

%%

// ===============================================================

LAE
	:	ExpressionList EOF
		{
			m_parsetree = $1;
		}
	;

ExpressionList
	:	ExpressionList ';' Expression
		{
			if (null != $3)
				$1.Add($3);

			$$ = $1;
		}
	|	Expression
		{
			if (null != $1)
				$$ = new List<object> { $1 };
			else
				$$ = null;
		}
	;

// Logic and algebraic expression
Expression
	:	Node '<' '-' BoolConst
		{
			$$ = $1 + "=" + $3 + ";";
		}
	| /*EMPTY*/
		{ $$ = null; }
	;

BoolConst
	:	TRUE
		{
			$$ = true;
		}
	|	FALSE
		{
			$$ = false;
		}
	;

%%
	public object ParseTree { get { return m_parsetree; } }
	public Parser(Scanner scanner)
		: base(scanner)
	{
 	}
