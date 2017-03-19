import token: Token;

class Comment : Token
{
    string comment;

    this(string c, int line)
    {
        comment = c;
        lineNumber = line;
    }
}