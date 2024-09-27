namespace Azets.Helpers.Version;

page 51100 "Version List"
{
    ApplicationArea = All;
    Caption = 'Version List';
    PageType = List;
    SourceTable = Version;
    UsageCategory = Lists;
    DelayedInsert = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Version"; Rec."Version (Raw Text)")
                {
                    ApplicationArea = All;
                }
                field(Prefix; Rec.Prefix)
                {
                    ApplicationArea = All;
                }
                field(Major; Rec.Major)
                {
                    ApplicationArea = All;
                }
                field(Minor; Rec.Minor)
                {
                    ApplicationArea = All;
                }
                field(Patch; Rec.Patch)
                {
                    ApplicationArea = All;
                }
                field(Suffix; Rec.Suffix)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
