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

self						[,()\[\].;\:\+\-\*\/\%\^\<\>\=\{\}\|]

node						S{integer}

%%

{comment}					{ /* Игнорируем комментарий */ }

// Ключевые слова
CONDITION					{ return (int)Tokens.CONDITION; }
DATA						{ return TokenInfo(Tokens.DATA); }
D							{ return TokenInfo(Tokens.DATA); }
TRANS						{ return TokenInfo(Tokens.TRANS); }
T							{ return TokenInfo(Tokens.TRANS); }
TRUE						{ return TokenInfo(Tokens.TRUE); }
FALSE						{ return TokenInfo(Tokens.FALSE); }
START						{ return TokenInfo(Tokens.START); }
FINISH						{ return TokenInfo(Tokens.FINISH); }
R							{ return TokenInfo(Tokens.RETURN); }
E							{ return TokenInfo(Tokens.EMPTY); }
N							{ return TokenInfo(Tokens.NOTHING); }

{node}						{ Console.WriteLine(yytext); return TokenInfo(Tokens.Node); }
{self}						{ Console.WriteLine(yytext[0]); return yytext[0]; }

<<EOF>>						{ return TokenInfo(Tokens.EOF); }

%%
	private int TokenInfo(Tokens token)
	{
		yylloc = new LexLocation(tokLin, tokCol, tokELin, tokECol, tokPos, tokEPos);
		Console.WriteLine(token); 

		return (int)token;
	}

	public override void yyerror(string format, params object[] args)
	{
        Console.WriteLine(yylloc.ToString());
		Console.WriteLine(format, args);
	}
