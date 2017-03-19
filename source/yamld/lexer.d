import std.algorithm;
import std.file: readText;
import std.stdio: writeln;
import std.string: indexOf, toUpper;

import token: Token;
import comment: Comment;
import literal: Literal;
import _string: String;
import property_delimiter: PropertyDelimiter;

class Lexer
{
    const COMMENT_START = '#';
    const STRING_START = '"';
    const PROPERTY_DELIMITER = ':';

    private int index;
    private int lineNumber;
    private string content;
    private string filename;

    this(string f)
    {
        filename = f;
    }

    private bool isWhitespace(char chr)
    {
        return chr == ' ' || chr == '\t' || chr == '\r';
    }

    private bool isLiteral(char chr)
    {
        auto alpha = "abcdefghijklmnopqrstuvwxyz";
        char[] allowed = cast(char[])(alpha ~ alpha.toUpper);

        return allowed.any!(a => chr == a);
    }

    Token comment()
    {
        int end = cast(int)content.indexOf('\n', index);

        if (end == -1) {
            end = cast(int)content.length;
        }

        auto comment = new Comment(content[(index + 1)..end], lineNumber);

        index = end;
        
        return comment;
    }

    Token getstring()
    {
        string value = "";

        index++;

        for (; index < content.length; index++) {
            if (content[index] == STRING_START) {
                index++;
                break;
            }

            value ~= content[index];
        }

        return new String(value, lineNumber);
    }

    Token tryLiteral()
    {
        string value = "";

        for (; index < content.length && isLiteral(content[index]); index++) {
            value ~= content[index];
        }

        if (value.length > 0) {
            index--;
            return new Literal(value, lineNumber);
        }

        return null;
    }

    Token[] lex()
    {
        Token[] tokens;
        lineNumber = 0;
        content = readText(filename);

        for (index = 0; index < content.length; index++) {
            if (content[index] == '\n') {
                lineNumber++;
                continue;
            }

            if (isWhitespace(content[index])) {
                continue;
            }

            if (content[index] == COMMENT_START) {
                tokens ~= comment();
                continue;
            }

            if (content[index] == STRING_START) {
                tokens ~= getstring();
                continue;
            }

            if (content[index] == PROPERTY_DELIMITER) {
                tokens ~= new PropertyDelimiter(lineNumber);
                continue;
            }

            auto literal = tryLiteral();

            if (literal !is null) {
                tokens ~= literal;
                continue;
            }

            throw new Exception("Unkown type: " ~ content[index]);
        }
        
        return tokens;
    }
}