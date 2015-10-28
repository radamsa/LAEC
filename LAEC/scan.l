%namespace LAEC
%visibility internal
%option unicode noEmbedBuffers nolisting caseInsensitive

space						[ \t\n\r\f]
newline						[\n\r]
non_newline					[^\n\r]

comment						("//"{non_newline}*)

whitespace					({space}+|{comment})

digit						[0-9]
hexdigit					[0-9A-Fa-f]

quote						'
integer						{digit}+
string_const				({quote}[^{quote}]{quote})

identifier_start			[A-Za-z_]
identifier_part				[A-Za-z_0-9]
identifier					{identifier_start}{identifier_part}*

assign						<-

self						[,()\[\].;\:\+\-\*\/\%\^\<\>\=\{\}\|\&]

node						S{integer}
lae_target					[mq]{node}

%%

{comment}					{ /* Игнорируем комментарий */ }

// Ключевые слова
START						{ return TokenInfo(Tokens.START); }
FINISH						{ return TokenInfo(Tokens.FINISH); }
DATA						{ return TokenInfo(Tokens.DATA); }
D							{ return TokenInfo(Tokens.DATA); }
TRANS						{ return TokenInfo(Tokens.TRANS); }
T							{ return TokenInfo(Tokens.TRANS); }

//CONDITION					{ return (int)Tokens.CONDITION; }
Q							{ return (int)Tokens.CONDITION; }

TRUE						{
								yylval.boolean = true;
								return TokenInfo(Tokens.TRUE);
							}
FALSE						{
								yylval.boolean = false;
								return TokenInfo(Tokens.FALSE);
							}

E							{
								yylval.node = Node.Empty;
								return TokenInfo(Tokens.NODE); //return TokenInfo(Tokens.EMPTY);
							}
N							{
								yylval.node = Node.Nothing;
								return TokenInfo(Tokens.NODE); //return TokenInfo(Tokens.NOTHING);
							}
R							{
								yylval.node = Node.Return;
								return TokenInfo(Tokens.NODE); //return TokenInfo(Tokens.RETURN);
							}

{assign}					{ return TokenInfo(Tokens.ASSIGN); }

{node}						{
								yylval.node = new Node(yytext);
								return TokenInfo(Tokens.NODE);
							}
{lae_target}				{
								yylval.node = new Node(yytext.Substring(1));
								return TokenInfo(Tokens.LAE_TARGET);
							}
{self}						{ return yytext[0]; }

<<EOF>>						{ return TokenInfo(Tokens.EOF); }

%%
	private int TokenInfo(Tokens token)
	{
		yylloc = new LexLocation(tokLin, tokCol, tokELin, tokECol, tokPos, tokEPos);
		return (int)token;
	}

	public override void yyerror(string format, params object[] args)
	{
        Console.WriteLine(yylloc.ToString());
		Console.WriteLine(format, args);
	}
