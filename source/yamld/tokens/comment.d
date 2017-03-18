import token: Token;

class Comment : Token
{
    string comment;

    this(string c)
    {
        comment = c;
    }
}