namespace Azets.Helpers.Version.Test;

using Azets.Helpers.Version;
using System.TestLibraries.Utilities;

codeunit 51202 "Version Calculation Test"
{
    Subtype = Test;
    TestPermissions = Restrictive;

    [Test]
    procedure CalculateVerionFromIndividualsComplexTest()
    var
        Version: Record "Version";
        Major, Minor, Patch : Integer;
        Prefix, Suffix : Text;
        SimpleVerTok: Label '%1%2.%3.%4-%5', Comment = '%1 = Prefix, %2 = Major, %3 = Minor, %4 = Patch, %5 = Suffix', Locked = true;
    begin
        // [FEATURE] Version Wrapper - Calculation
        // [SCENARIO] Version - complex version, like V3.14.20240601.1-beta 

        // [GIVEN] Permission set "Version Helper"
        LibraryLowerPermissions.AddPermissionSet('Version Helper');

        // [GIVEN] All individual parts that are making a versions (only major)
        Major := Any.IntegerInRange(5);
        Minor := Any.IntegerInRange(5);
        Patch := Any.IntegerInRange(5);
        Suffix := 'beta';
        Prefix := 'v';

        // [WHEN] All values are validated
        Version.Validate(Major, Major);
        Version.Validate(Minor, Minor);
        Version.Validate(Patch, Patch);
        Version.Validate(Suffix, Suffix);
        Version.Validate(Prefix, Prefix);

        // [THEN] Version (text) is calculated
        Assert.AreEqual(StrSubstNo(SimpleVerTok, Prefix, Major, Minor, Patch, Suffix), Version."Version (Raw Text)", 'Version (text) is not calculated correctly');
    end;

    [Test]
    procedure CalculateVerionFromIndividualsSimpleTest()
    var
        Version: Record "Version";
        Major, Minor, Patch : Integer;
        SimpleVerTok: Label '%1.%2.%3', Comment = '%1 = Major, %2 = Minor, %3 = Patch', Locked = true;
    begin
        // [FEATURE] Version Wrapper - Calculation
        // [SCENARIO] Version - simple version, like 3.1.0 

        // [GIVEN] Permission set "Version Helper"
        LibraryLowerPermissions.AddPermissionSet('Version Helper');

        // [GIVEN] All individual parts that are making a versions (only major)
        Major := Any.IntegerInRange(5);
        Minor := Any.IntegerInRange(5);
        Patch := 0;

        // [WHEN] All values are validated
        Version.Validate(Major, Major);
        Version.Validate(Minor, Minor);
        Version.Validate(Patch, Patch);

        // [THEN] Version (text) is calculated
        Assert.AreEqual(StrSubstNo(SimpleVerTok, Major, Minor, Patch), Version."Version (Raw Text)", 'Version (text) is not calculated correctly');
    end;

    var
        Assert: Codeunit "Library Assert";
        LibraryLowerPermissions: Codeunit "Library - Lower Permissions";
        Any: Codeunit "Any";
}