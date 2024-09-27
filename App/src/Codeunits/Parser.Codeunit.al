namespace Azets.Helpers.Version;

using System.Utilities;

codeunit 51101 Parser
{
    procedure Parse(VersionString: Text; var Version: Record Version)
    var
        TempMatches: Record "Matches" temporary;
        TempGroups: Record "Groups" temporary;
        RegEx: Codeunit Regex;
        VersionPattern: Text;
        VMinorTxt, VPatchTxt : Text;
    begin
        VersionPattern := '^([^\d\s]+)?(\d+)(?:\.(\d+))?(?:\.(\d+))?-?([a-zA-Z0-9]+)?$';

        RegEx.Match(VersionString, VersionPattern, TempMatches);
        if TempMatches.IsEmpty() then
            Error('Invalid version format. Expected format: [prefix]X[.Y][.Z][-suffix]');

        Version."Version (Raw Text)" := CopyStr(VersionString, 1, MaxStrLen(Version."Version (Raw Text)"));

        RegEx.Groups(TempMatches, TempGroups);

        TempGroups.Get(1);
        Version.Prefix := CopyStr(TempGroups.ReadValue(), 1, MaxStrLen(Version.Prefix));

        TempGroups.Get(2);
        Evaluate(Version.Major, TempGroups.ReadValue());

        TempGroups.Get(3);
        VMinorTxt := TempGroups.ReadValue();
        if VMinorTxt <> '' then
            Evaluate(Version.Minor, VMinorTxt);

        TempGroups.Get(4);
        VPatchTxt := TempGroups.ReadValue();
        if VPatchTxt <> '' then
            Evaluate(Version.Patch, VPatchTxt);

        TempGroups.Get(5);
        Version.Suffix := CopyStr(TempGroups.ReadValue(), 1, MaxStrLen(Version.Suffix));
    end;

    procedure UpdateVersionNo(var Version: Record Version)
    var
        VersionTxt: Text;
        VersionWithSuffixTok: Label '%1%2.%3.%4-%5', Comment = '%1 = Prefix, %2 = Major, %3 = Minor, %4 = Patch, %5 = Suffix', Locked = true;
        VersionWithoutSuffixTok: Label '%1%2.%3.%4', Comment = '%1 = Prefix, %2 = Major, %3 = Minor, %4 = Patch', Locked = true;
    begin
        if Version.Suffix = '' then
            VersionTxt := StrSubstNo(VersionWithoutSuffixTok, Version.Prefix, Version.Major, Version.Minor, Version.Patch)
        else
            VersionTxt := StrSubstNo(VersionWithSuffixTok, Version.Prefix, Version.Major, Version.Minor, Version.Patch, Version.Suffix);

        Version."Version (Raw Text)" := CopyStr(VersionTxt, 1, MaxStrLen(Version."Version (Raw Text)"));
    end;
}