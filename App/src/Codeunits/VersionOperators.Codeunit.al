namespace Azets.Helpers.Version;
codeunit 51100 "Version Operators"
{
    procedure SplitVersion(Version: Text[30]; var Major: Integer; var Minor: Integer)
    var
        VersionPrefixTok: Label 'V';
        VersionSeparatorTok: Label '.';
        VersionSplit: List of [Text];
        VersionEmptyErr: Label 'Version evaluated to empty.';
        VersionTooSpecificErr: Label 'Version is too specific. Version should be in the format "V1" or "V1.0".';
    begin
        if Version.StartsWith(VersionPrefixTok) then
            Version := DelChr(Version, '=', VersionPrefixTok);

        if Version.Contains(VersionSeparatorTok) then
            VersionSplit := Version.Split(VersionSeparatorTok);

        case VersionSplit.Count of
            0:
                Error(VersionEmptyErr);
            1:
                Evaluate(Major, VersionSplit.Get(1));
            2:
                begin
                    Evaluate(Major, VersionSplit.Get(1));
                    Evaluate(Minor, VersionSplit.Get(2));
                end;
            else
                Error(VersionTooSpecificErr);
        end;
    end;

    // Will return true if 'Version To Compare' is larger and false if base 'Version' is larger
    procedure LargerThan(Version: Text[30]; VersionToCompare: Text[30]; var SameVersion: Boolean): Boolean
    var
        Major: Integer;
        Minor: Integer;
        MajorToCompare: Integer;
        MinorToCompare: Integer;
    begin
        if Version = VersionToCompare then begin
            SameVersion := true;
            exit(false);
        end;

        SplitVersion(Version, Major, Minor);
        SplitVersion(VersionToCompare, MajorToCompare, MinorToCompare);

        if MajorToCompare > Major then
            exit(true)
        else
            exit(false);

        if Major = MajorToCompare then
            exit(MinorToCompare > Minor);
    end;

    procedure GetHighestVersion(var VersionList: Record Version temporary) LatestVersion: Text[40]
    var
        TempHighestVersion: Record Version temporary;
    begin
        TempHighestVersion.Init();
        TempHighestVersion.Insert();
        if VersionList.FindSet() then
            repeat
                if VersionList.IsGreaterThan(TempHighestVersion) then begin
                    TempHighestVersion.Delete();
                    TempHighestVersion.Init();
                    TempHighestVersion.TransferFields(VersionList);
                    TempHighestVersion.Insert();
                end;
            until VersionList.Next() = 0;
        exit(TempHighestVersion."Version (Raw Text)");
    end;

    procedure GreaterThanOrEqualTo(Version1: Record Version; Version2: Record Version): Boolean
    begin
        exit(Version1.GetNormalizedVersion() >= Version2.GetNormalizedVersion());
    end;

    procedure GreaterThan(Version1: Record Version; Version2: Record Version): Boolean
    begin
        exit(Version1.GetNormalizedVersion() > Version2.GetNormalizedVersion());
    end;

    procedure LessThan(Version1: Record Version; Version2: Record Version): Boolean
    begin
        exit(Version1.GetNormalizedVersion() < Version2.GetNormalizedVersion());
    end;

    procedure LessThanOrEqualTo(Version1: Record Version; Version2: Record Version): Boolean
    begin
        exit(Version1.GetNormalizedVersion() <= Version2.GetNormalizedVersion());
    end;

    procedure EqualTo(Version1: Record Version; Version2: Record Version): Boolean
    begin
        exit(Version1.GetNormalizedVersion() = Version2.GetNormalizedVersion());
    end;

    procedure NotEqualTo(Version1: Record Version; Version2: Record Version): Boolean
    begin
        exit(Version1.GetNormalizedVersion() <> Version2.GetNormalizedVersion());
    end;

}