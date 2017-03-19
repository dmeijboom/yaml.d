import comment: Comment;
import lexer: Lexer;
import _string: String;
import literal: Literal;
import std.stdio;
import token: Token;

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
		} else if (typeid(token) == typeid(Literal)) {
			auto x = cast(Literal)token;

			writeln("Literal => " ~ x.value);
		} else if (typeid(token) == typeid(String)) {
			auto x = cast(String)token;

			writeln("String => " ~ x.value);
		}
	}
}
