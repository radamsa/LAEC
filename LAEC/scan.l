%namespace LAEC
%visibility internal
%option unicode noEmbedBuffers nolisting caseInsensitive

space						[ \t\n\r\f]
newline						[\n\r]
non_newline					[^\n\r]

comment						("--"{non_newline}*)

whitespace					({space}+|{comment})

digit						[0-9]
hexdigit					[0-9A-Fa-f]

quote						'
integer						{digit}+
string_const				({quote}[^{quote}]{quote})

identifier_start			[A-Za-z_]
identifier_part				[A-Za-z_0-9]
identifier					{identifier_start}{identifier_part}*

self						[,()\[\].;\:\+\-\*\/\%\^\<\>\=]

node						S{integer}

%%

{comment}					{ /* Игнорируем комментарий */ }

// Ключевые слова
CONDITION					{ 
								Console.WriteLine(yylloc);
								return (int)Tokens.CONDITION;
							}
DATA						{ return TokenInfo(Tokens.DATA); }
TRANS						{ return TokenInfo(Tokens.TRANS); }
TRUE						{ return TokenInfo(Tokens.TRUE); }
FALSE						{ return TokenInfo(Tokens.FALSE); }

{node}						{
								Console.WriteLine("node: {0}", yytext);
								return TokenInfo(Tokens.Node);
							}

{self}						{
								//SET_YYLLOC();
								return yytext[0];
							}

<<EOF>>						{ return TokenInfo(Tokens.EOF); }

%%
	private int TokenInfo(Tokens token)
	{
		yylloc = new LexLocation(tokLin, tokCol, tokELin, tokECol, tokPos, tokEPos);

		return (int)token;
	}

	public override void yyerror(string format, params object[] args)
	{
		Console.WriteLine(format, args);
	}
