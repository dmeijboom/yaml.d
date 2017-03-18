import std.stdio;
import lexer: Lexer;
import token: Token;
import comment: Comment;

void main(string[] args)
{
	if (args.length < 1) {
		writeln("No file specified");
		return;
	}

	auto lexer = new Lexer(args[1]);
	auto tokens = lexer.lex();

	foreach (ref Token token; tokens) {
		if (typeid(token) == typeid(Comment)) {
			auto x = cast(Comment)token;

			writeln("Comment => " ~ x.comment);
		}
	}
}
