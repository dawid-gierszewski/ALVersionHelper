namespace Azets.Helpers.Version.Test;

using Azets.Helpers.Version;
using System.TestLibraries.Utilities;

codeunit 51203 "Version List Page Test"
{
    Subtype = Test;
    TestPermissions = Restrictive;

    [Test]
    procedure EnterVersionOnUITest()
    var
        VersionListPage: TestPage "Version List";
    begin
        // [FEATURE] Version Wrapper - Comparison
        // [SCENARIO] Enter version on the page (full version with prefix and suffix)

        // [GIVEN] Permission set "Version Helper"
        LibraryLowerPermissions.AddPermissionSet('Version Helper');

        // [GIVEN] Page is open
        VersionListPage.OpenNew();

        // [WHEN] 
        VersionListPage.Version.SetValue('V1.2.3-beta');

        // [THEN] Prefix is "v"
        Assert.AreEqual('V', VersionListPage.Prefix.Value, 'Prefix is not "v"');
        // [THEN] Major is "1"
        Assert.AreEqual('1', VersionListPage.Major.Value, 'Major is not "1"');
        // [THEN] Minor is "2"
        Assert.AreEqual('2', VersionListPage.Minor.Value, 'Minor is not "2"');
        // [THEN] Patch is "3"
        Assert.AreEqual('3', VersionListPage.Patch.Value, 'Patch is not "3"');
        // [THEN] Suffix is "beta"
        Assert.AreEqual('beta', VersionListPage.Suffix.Value, 'Suffix is not "beta"');
    end;

    [Test]
    procedure EnterSingleFieldsAndGetVersionCalcualtedUITest()
    var
        VersionListPage: TestPage "Version List";
    begin
        // [FEATURE] Version Wrapper - Comparison
        // [SCENARIO] Enter parts of the version, like major, minor on the page

        // [GIVEN] Permission set "Version Helper"
        LibraryLowerPermissions.AddPermissionSet('Version Helper');

        // [GIVEN] Page is open
        VersionListPage.OpenNew();

        // [WHEN] 
        VersionListPage.Major.SetValue('1');
        VersionListPage.Minor.SetValue('2');

        // [THEN] Version is calculated
        Assert.AreEqual('1.2.0', VersionListPage.Version.Value, 'Version is not calculated correctly');
    end;

    var
        Assert: Codeunit "Library Assert";
        LibraryLowerPermissions: Codeunit "Library - Lower Permissions";
}