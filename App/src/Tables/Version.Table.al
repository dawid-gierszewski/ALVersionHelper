namespace Azets.Helpers.Version;

table 51100 "Version"
{
    DataClassification = CustomerContent;
    Caption = 'Version';
    LookupPageId = "Version List";
    DrillDownPageId = "Version List";

    fields
    {
        field(1; "Version (Raw Text)"; Text[40])
        {
            Caption = 'Version';
            NotBlank = true;
            ToolTip = 'Version in raw text format';

            trigger OnValidate()
            var
                Parser: Codeunit Parser;
            begin
                Parser.Parse("Version (Raw Text)", Rec);
            end;
        }
        field(2; "Prefix"; Text[10])
        {
            Caption = 'Prefix';
            ToolTip = 'Prefix of the version';

            trigger OnValidate()
            var
                Parser: Codeunit Parser;
            begin
                Parser.UpdateVersionNo(Rec);
            end;
        }
        field(3; "Major"; Integer)
        {
            Caption = 'Major';
            MinValue = 0;
            ToolTip = 'Major version number';

            trigger OnValidate()
            var
                Parser: Codeunit Parser;
            begin
                Parser.UpdateVersionNo(Rec);
            end;
        }
        field(4; "Minor"; Integer)
        {
            Caption = 'Minor';
            MinValue = 0;
            ToolTip = 'Minor version number';

            trigger OnValidate()
            var
                Parser: Codeunit Parser;
            begin
                Parser.UpdateVersionNo(Rec);
            end;
        }
        field(5; "Patch"; Integer)
        {
            Caption = 'Patch';
            MinValue = 0;
            ToolTip = 'Patch version number';

            trigger OnValidate()
            var
                Parser: Codeunit Parser;
            begin
                Parser.UpdateVersionNo(Rec);
            end;
        }
        field(6; "Suffix"; Text[10])
        {
            Caption = 'Suffix';
            ToolTip = 'Suffix of the version';

            trigger OnValidate()
            var
                Parser: Codeunit Parser;
            begin
                Parser.UpdateVersionNo(Rec);
            end;
        }
    }

    keys
    {
        key(PK; "Version (Raw Text)")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Major", "Minor", "Patch") { }
    }

    procedure InsertFromRawText(VersionTxt: Text)
    begin
        Rec.Init();
        Rec.Validate("Version (Raw Text)", VersionTxt);
        if Rec.Insert() then;
    end;

    procedure GetNormalizedVersion(): Version
    var
        NormalizedVersion: Version;
    begin
        NormalizedVersion := Version.Create(Rec."Major", Rec."Minor", Rec."Patch");
        exit(NormalizedVersion);
    end;

    procedure IsGreaterThan(Version: Record Version): Boolean
    begin
        exit(VersionOperators.GreaterThan(Rec, Version));
    end;

    procedure IsGreaterThanOrEqualTo(Version: Record Version): Boolean
    begin
        exit(VersionOperators.GreaterThanOrEqualTo(Rec, Version));
    end;

    procedure IsLessThan(Version: Record Version): Boolean
    begin
        exit(VersionOperators.LessThan(Rec, Version));
    end;

    procedure IsLessThanOrEqualTo(Version: Record Version): Boolean
    begin
        exit(VersionOperators.LessThanOrEqualTo(Rec, Version));
    end;

    procedure IsEqualTo(Version: Record Version): Boolean
    begin
        exit(VersionOperators.EqualTo(Rec, Version));
    end;

    procedure IsNotEqualTo(Version: Record Version): Boolean
    begin
        exit(VersionOperators.NotEqualTo(Rec, Version));
    end;

    var
        VersionOperators: Codeunit "Version Operators";
}
