namespace Azets.Helpers.Version;

permissionset 51100 "Version Helper"
{
    Assignable = true;
    Permissions = tabledata Version = RIMD,
        table Version = X,
        codeunit Parser = X,
        codeunit "Version Operators" = X,
        page "Version List" = X;
}