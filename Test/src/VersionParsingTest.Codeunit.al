namespace Azets.Helpers.Version.Test;

using Azets.Helpers.Version;
using System.TestLibraries.Utilities;

codeunit 51200 "Version Parsing Test"
{
    Subtype = Test;
    TestPermissions = Restrictive;

    [Test]
    procedure ParseVersionSimpleTest()
    var
        VersionRec: Record "Version";
        VersionRaw: Text;
        VersionResult: Version;
        Prefix: Text;
        Major, Minor : Integer;
    begin
        // [FEATURE] Version Wrapper - Parsing
        // [SCENARIO] Version - Simple Version, like V5.1 

        // [GIVEN] Permission set "Version Helper"
        LibraryLowerPermissions.AddPermissionSet('Version Helper');

        // [GIVEN] Simple version raw text, like "V5.1"        
        Prefix := 'V';
        Major := Any.IntegerInRange(10);
        Minor := Any.IntegerInRange(10);
        VersionRaw := StrSubstNo('%1%2.%3', Prefix, Major, Minor);

        // [WHEN] Version is parsed
        VersionRec.InsertFromRawText(VersionRaw);

        // [THEN] Version is created
        Assert.IsTrue(VersionRec.Get(VersionRaw), 'Version record not created');
        // [THEN] Major is matching
        VersionResult := VersionRec.GetNormalizedVersion();
        Assert.AreEqual(Major, VersionResult.Major(), 'Major version not valid');
        // [THEN] Minor is matching
        Assert.AreEqual(Minor, VersionResult.Minor(), 'Minor version not valid');
        // [THEN] Patch is 0
        Assert.AreEqual(0, VersionResult.Build(), 'Patch version not valid');
        // [THEN] Prefix is matching
        Assert.AreEqual(Prefix, VersionRec.Prefix, 'Prefix version not valid');
        // [THEN] Suffix is empty
        Assert.AreEqual('', VersionRec.Suffix, 'Suffix version not valid');
    end;

    [Test]
    procedure ParseVersionComplexTest()
    var
        VersionRec: Record "Version";
        VersionRaw: Text;
        VersionResult: Version;
        Prefix, Suffix : Text;
        Major, Minor, Patch : Integer;
        VersionTok: Label '%1%2.%3.%4-%5', Comment = '%1 = Prefix, %2 = Major, %3 = Minor, %4 = Patch, %5 = Suffix';
    begin
        // [FEATURE] Version Wrapper - Parsing
        // [SCENARIO] Version - complex version, like V3.14.20240601.1-beta 

        // [GIVEN] Permission set "Version Helper"
        LibraryLowerPermissions.AddPermissionSet('Version Helper');

        // [GIVEN] Version is complex, like V5.14.566.133-beta
        Prefix := 'V';
        Major := Any.IntegerInRange(10);
        Minor := Any.IntegerInRange(10);
        Patch := Any.IntegerInRange(10);
        Suffix := Any.AlphabeticText(10);
        VersionRaw := StrSubstNo(VersionTok, Prefix, Major, Minor, Patch, Suffix);

        // [WHEN] Version is parsed
        VersionRec.InsertFromRawText(VersionRaw);

        // [THEN] Version is created
        Assert.IsTrue(VersionRec.Get(VersionRaw), 'Version record not created');
        // [THEN] Prefix is matching
        Assert.AreEqual(Prefix, VersionRec.Prefix, 'Prefix version not valid');
        // [THEN] Major is matching
        VersionResult := VersionRec.GetNormalizedVersion();
        Assert.AreEqual(Major, VersionResult.Major(), 'Major version not valid');
        // [THEN] Minor is matching
        Assert.AreEqual(Minor, VersionResult.Minor(), 'Minor version not valid');
        // [THEN] Patch is matching
        Assert.AreEqual(Patch, VersionResult.Build(), 'Patch version not valid');
        // [THEN] Suffix is matching
        Assert.AreEqual(Suffix, VersionRec.Suffix, 'Suffix version not valid');
    end;

    [Test]
    procedure ParseInvalidVersionShouldFail()
    var
        VersionRec: Record "Version";
        InvalidVersion: Text;
    begin
        // [FEATURE] Version Wrapper - Parsing
        // [SCENARIO] Parsing an invalid version string should fail

        // [GIVEN] Permission set "Version Helper"
        LibraryLowerPermissions.AddPermissionSet('Version Helper');

        // [GIVEN] An invalid version string
        InvalidVersion := 'NotAVersion';

        // [WHEN] Attempting to parse the invalid version
        asserterror VersionRec.InsertFromRawText(InvalidVersion);

        // [THEN] An error should be thrown
        Assert.ExpectedError('Invalid version format');
    end;

    [Test]
    procedure ErrorWhenParsingNegativeVersion()
    var
        VersionRec: Record "Version";
        NegativeVersion: Text;
    begin
        // [FEATURE] Version Wrapper - Parsing
        // [SCENARIO] Parsing a version with negative numbers should result in an error

        // [GIVEN] Permission set "Version Helper"
        LibraryLowerPermissions.AddPermissionSet('Version Helper');

        // [GIVEN] A version string with negative numbers
        NegativeVersion := 'V-1.-2';

        // [WHEN] Attempting to parse the negative version
        asserterror VersionRec.InsertFromRawText(NegativeVersion);

        // [THEN] An error should be thrown
        Assert.ExpectedError('Invalid version format');
    end;

    var
        Assert: Codeunit "Library Assert";
        LibraryLowerPermissions: Codeunit "Library - Lower Permissions";
        Any: Codeunit "Any";
}