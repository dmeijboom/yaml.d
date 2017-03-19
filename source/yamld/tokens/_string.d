import token: Token;

class String : Token
{
    string value;

    this(string v, int line)
    {
        value = v;
        lineNumber = line;
    }
}