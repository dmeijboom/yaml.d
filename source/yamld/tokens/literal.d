import token: Token;

class Literal : Token
{
    string value;

    this(string c, int line)
    {
        value = c;
        lineNumber = line;
    }
}