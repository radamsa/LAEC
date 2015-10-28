%namespace LAEC
%visibility internal
%output=gram.cs

%{
%}

%YYLTYPE LexLocation

%union
{
	public Statement				stmt;
	public LAExpr					lae;
	public List<LAExpr>				lae_list;
	public AlphaDisjuntion			alpha_disjuntion;
	public AlphaIteration			alpha_iteration;
	public Node						node;
	public bool						boolean;
	public Link						link;
	public Expr						expr;
	public List<Expr>				expr_list;
	public string					keyword;
}

%type	<lae>						lae
%type	<lae_list>					lae_list
%type	<alpha_disjuntion>			alpha_disjuntion
%type	<alpha_iteration>			alpha_iteration
%type	<boolean>					bool_const
%type	<link>						link
%type	<expr>						expr_single check_link_state_expr set_link_state alpha_condition
%type	<expr_list>					expr_list

%token								ASSIGN START FINISH TRANS DATA CONDITION 
%token <node>						EMPTY NOTHING RETURN NODE LAE_TARGET
%token <boolean>					TRUE FALSE

%start Programm

%%

// ===============================================================

Programm
	:	lae_list EOF
		{
			ParseTree = $1;
		}
	;

lae_list
	:	lae_list lae
		{
			$$ = $1;
			$$.Add($2);
		}
	|	lae
		{
			$$ = new List<LAExpr> { $1 };
		}
	;
// Логико-алгебраическое выражение (Logic and Algebraic Expression)
lae
	:	LAE_TARGET '=' alpha_disjuntion ';'
		{ $$ = new LAExpr($1, $3); }
	;

// Альфа дизъюнкция
alpha_disjuntion
	:	alpha_condition '(' alpha_iteration ')'
		{ $$ = new AlphaDisjuntion($1, $3); }
	;

alpha_condition
	:	'[' check_link_state_expr ']'
		{ $$ = $2; }
	;

alpha_iteration
	:	NODE '|' NODE
		{ $$ = new AlphaIteration(new List<Expr> { new ExprCall($1) }, $3); }
	|	'{' expr_list '}' '|' NODE
		{ $$ = new AlphaIteration($2, $5); }
	;

expr_list
	:	expr_list ';' expr_single
		{
			if (null != $3)
				$1.Add($3);
			$$ = $1;
		}
	|	expr_single
		{ $$ = new List<Expr> { $1 }; }
	;

expr_single
	:	NODE
		{ $$ = new ExprCall($1); }
	|	set_link_state
	|	'[' CONDITION '(' NODE ')' ']' '(' expr_list '|' expr_list ')'
		{ $$ = new CheckNodeResult($4, $8, $10); }
	;

bool_const
	:	TRUE
	|	FALSE
	;

// ---------------------------------------------------------------------
link
	:	START
		{ $$ = Link.Start; }
	|	FINISH
		{ $$ = Link.Finish; }
	|	TRANS '(' NODE ',' NODE ')'
		{ $$ = new TransLink($3, $5); }
	|	DATA '(' NODE ',' NODE ')'
		{ $$ = new DataLink($3, $5); }
	;

check_link_state_expr
	:	check_link_state_expr '|' link
		{ $$ = new ExprBinary(ExprOp.Or, $1, new ExprCheckState($3)); }
	|	check_link_state_expr '&' link
		{ $$ = new ExprBinary(ExprOp.And, $1, new ExprCheckState($3)); }
	|	link
		{ $$ = new ExprCheckState($1); }
	;

set_link_state
	:	link ASSIGN bool_const
		{ $$ = new ExprSetState($1, $3); }
	;

%%
	public List<LAExpr> ParseTree { get; private set; }

	public Parser(Scanner scanner)
		: base(scanner)
	{
 	}
