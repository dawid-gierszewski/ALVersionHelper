namespace Azets.Helpers.Version.Test;

using Azets.Helpers.Version;
using System.TestLibraries.Utilities;

codeunit 51201 "Version Comparison Test"
{
    Subtype = Test;

    [Test]
    procedure GreaterThanMajorTest()
    var
        VersionSmaller, VersionBigger : Record "Version";
        VersionSmallerMajor, VersionBiggerMajor : Integer;
        Result: Boolean;
        SimpleVerTok: Label 'V%1.%2', Comment = '%1 = Major, %2 = Minor', Locked = true;
        GratherThanErr: Label 'Version %1 should be greater than Version %2', Locked = true, comment = '%1 - VersionBigger, %2 - VersionSmaller';
    begin
        // [FEATURE] Version Wrapper - Comparison
        // [SCENARIO] Version Comparison - Greater Than (major part of version is different)

        // [GIVEN] Permission set "Version Helper"
        LibraryLowerPermissions.AddPermissionSet('Version Helper');

        // [GIVEN] Two simple versions (only major)
        VersionSmallerMajor := Any.IntegerInRange(5);
        VersionBiggerMajor := VersionSmallerMajor + Any.IntegerInRange(5);
        VersionSmaller.InsertFromRawText(StrSubstNo(SimpleVerTok, VersionSmallerMajor, 0));
        VersionBigger.InsertFromRawText(StrSubstNo(SimpleVerTok, VersionBiggerMajor, 0));

        // [WHEN] Version is compared
        Result := VersionBigger.IsGreaterThan(VersionSmaller);

        // [THEN] Biggerversion indeed is > smaller
        Assert.IsTrue(Result, StrSubstNo(GratherThanErr, VersionBigger."Version (Raw Text)", VersionSmaller."Version (Raw Text)"));
    end;

    [Test]
    procedure GreaterThanPatchTest()
    var
        VersionSmaller, VersionBigger : Record "Version";
        Major, Minor, PatchSmaller, PatchBigger : Integer;
        Result: Boolean;
        SimpleVerTok: Label 'V%1.%2.%3', Comment = '%1 = Major, %2 = Minor, %3 = Patch', Locked = true;
        GratherThanErr: Label 'Version %1 should be greater than Version %2', Locked = true, comment = '%1 - VersionBigger, %2 - VersionSmaller';
    begin
        // [FEATURE] Version Wrapper - Comparison
        // [SCENARIO] Version Comparison - Greater Than (patch part of version is different)

        // [GIVEN] Permission set "Version Helper"
        LibraryLowerPermissions.AddPermissionSet('Version Helper');

        // [GIVEN] Two simple versions (only major)
        Major := Any.IntegerInRange(5);
        Minor := Any.IntegerInRange(5);
        PatchSmaller := Any.IntegerInRange(5);
        PatchBigger := PatchSmaller + Any.IntegerInRange(5);
        VersionSmaller.InsertFromRawText(StrSubstNo(SimpleVerTok, Major, Minor, PatchSmaller));
        VersionBigger.InsertFromRawText(StrSubstNo(SimpleVerTok, Major, Minor, PatchBigger));

        // [WHEN] Version is compared
        Result := VersionBigger.IsGreaterThan(VersionSmaller);

        // [THEN] Biggerversion indeed is > smaller
        Assert.IsTrue(Result, StrSubstNo(GratherThanErr, VersionBigger."Version (Raw Text)", VersionSmaller."Version (Raw Text)"));
    end;

    [Test]
    procedure LessThanMinorTest()
    var
        VersionSmaller, VersionBigger : Record "Version";
        Major, MinorSmaller, MinorBigger : Integer;
        Result: Boolean;
        SimpleVerTok: Label 'V%1.%2', Comment = '%1 = Major, %2 = Minor', Locked = true;
        LessThanErr: Label 'Version %1 should be less than Version %2', Locked = true, comment = '%1 - VersionSmaller, %2 - VersionBigger';
    begin
        // [FEATURE] Version Wrapper - Comparison
        // [SCENARIO] Version Comparison - Less Than (minor part of version is different)

        // [GIVEN] Permission set "Version Helper"
        LibraryLowerPermissions.AddPermissionSet('Version Helper');

        // [GIVEN] Two simple versions (major the same, minor different)
        Major := Any.IntegerInRange(5);
        MinorSmaller := Any.IntegerInRange(5);
        MinorBigger := MinorSmaller + Any.IntegerInRange(5);
        VersionSmaller.InsertFromRawText(StrSubstNo(SimpleVerTok, Major, MinorSmaller));
        VersionBigger.InsertFromRawText(StrSubstNo(SimpleVerTok, Major, MinorBigger));

        // [WHEN] Version is compared
        Result := VersionSmaller.IsLessThan(VersionBigger);

        // [THEN] Smallerversion indeed is < bigger
        Assert.IsTrue(Result, StrSubstNo(LessThanErr, VersionSmaller."Version (Raw Text)", VersionBigger."Version (Raw Text)"));
    end;

    [Test]
    procedure EqualTest()
    var
        Version1, Version2 : Record "Version";
        Version1Raw, Version2Raw : Text;
        Result: Boolean;
        EqualErr: Label 'Version %1 should be equal to Version %2', Locked = true, comment = '%1 - Version1, %2 - Version2';
    begin
        // [FEATURE] Version Wrapper - Comparison
        // [SCENARIO] Version Comparison - Equal

        // [GIVEN] Permission set "Version Helper"
        LibraryLowerPermissions.AddPermissionSet('Version Helper');

        // [GIVEN] Two same versions (only prefix is different)
        Version1Raw := 'V1.2.3';
        Version2Raw := 'ver1.2.3';
        Version1.InsertFromRawText(Version1Raw);
        Version2.InsertFromRawText(Version2Raw);

        // [WHEN] Version is compared
        Result := Version1.IsEqualTo(Version2);

        // [THEN] Smallerversion indeed is < bigger
        Assert.IsTrue(Result, StrSubstNo(EqualErr, Version1."Version (Raw Text)", Version2."Version (Raw Text)"));
    end;

    [Test]
    procedure GetHighestVersionTest()
    var
        TempVersionList: Record Version temporary;
        VersionOperators: Codeunit "Version Operators";
        Version1Raw, Version2Raw, HighestVersionRaw : Text;
        HighestVersionResult: Text;
        HighestVersionErr: Label 'Highest version should be %1 (and not %2)', Locked = true, comment = '%1 - HighestVersionRaw, %2 - HighestVersionResult';
    begin
        // [FEATURE] Version Wrapper - Comparison
        // [SCENARIO] Get highest version from list

        // [GIVEN] Permission set "Version Helper"
        LibraryLowerPermissions.AddPermissionSet('Version Helper');

        // [GIVEN] Two same versions (only prefix is different)
        Version1Raw := 'V1.2.3';
        Version2Raw := '2.2';
        HighestVersionRaw := '2.2.3';
        TempVersionList.InsertFromRawText(Version1Raw);
        TempVersionList.InsertFromRawText(HighestVersionRaw);
        TempVersionList.InsertFromRawText(Version2Raw);

        // [WHEN] Highest version is retrieved
        HighestVersionResult := VersionOperators.GetHighestVersion(TempVersionList);

        // [THEN] Result is the highest version
        Assert.AreEqual(HighestVersionRaw, HighestVersionResult, StrSubstNo(HighestVersionErr, HighestVersionRaw, HighestVersionResult));
    end;

    var
        Assert: Codeunit "Library Assert";
        LibraryLowerPermissions: Codeunit "Library - Lower Permissions";
        Any: Codeunit Any;
}