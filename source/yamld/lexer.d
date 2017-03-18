import std.algorithm;
import std.file: readText;
import std.stdio: writeln;
import std.string: indexOf;

import token: Token;
import comment: Comment;

class Lexer
{
    const COMMENT_START = '#';

    private int index;
    private string content;
    private string filename;

    this(string f)
    {
        filename = f;
    }

    private bool isWhitespace(char chr)
    {
        return chr == ' ' || chr == '\t' || chr == '\r' || chr == '\n';
    }

    Token comment()
    {
        int end = cast(int)content.indexOf('\n', index);

        if (end == -1) {
            end = cast(int)content.length;
        }

        auto comment = new Comment(content[(index + 1)..end]);

        index = end;
        
        return comment;
    }

    Token[] lex()
    {
        Token[] tokens;
        content = readText(filename);

        for (index = 0; index < content.length; index++) {
            // Skip whitespaces on global level
            if (isWhitespace(content[index])) {
                continue;
            }

            if (content[index] == COMMENT_START) {
                tokens ~= comment();
                continue;
            }
        }
        
        return tokens;
    }
}