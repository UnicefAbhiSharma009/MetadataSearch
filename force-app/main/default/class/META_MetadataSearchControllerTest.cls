/**
 * @description       : Test class of META_MetadataSearchController
 * @author            : Abhishek Sharma <absharma@unicef.org>
 * @last modified on  : 12-29-2025
 * @last modified by  : Abhishek Sharma <absharma@unicef.org>
**/
@IsTest
public class META_MetadataSearchControllerTest {
    /**
     * @testSetup
     * @description Insert test data for all supported metadata types
     */
    @TestSetup
    static void setupTestData() {

        String raw =
        String.valueOf(DateTime.now().getTime()) +
        String.valueOf(Math.abs(Crypto.getRandomInteger()));

        String uniqueId = EncodingUtil.convertToHex(
            Crypto.generateDigest('SHA1', Blob.valueOf(raw))
        ).substring(0, 20);

        PermissionSet ps = new PermissionSet(
            Name  = 'TestPermissionSet_' + uniqueId,
            Label = 'Test Permission Set ' + uniqueId
        );
        insert ps;

        // PermissionSetGroup (unique developer name/label per test run)
        PermissionSetGroup psg = new PermissionSetGroup(DeveloperName = 'TestPSG' + uniqueId, MasterLabel = 'Test PSG ' + uniqueId);
        insert psg;

        // All other metadata types (ApexClass, ApexTrigger, ApexPage, ApexComponent, StaticResource, Report, Dashboard, EmailTemplate)
        // cannot be inserted in test context. Coverage for these relies on whatever metadata exists in the org.
    }
    /**
     * @description Test searchMetadata for each supported type
     */
    @IsTest
    static void testSearchMetadataByType() {
        List<String> types = new List<String>{
            'ApexClass', 'ApexTrigger', 'ApexPage', 'ApexComponent', 'Profile',
            'PermissionSet', 'PermissionSetGroup', 'StaticResource', 'Report',
            'Dashboard', 'EmailTemplate', 'Object', 'Field', 'CustomMetadataType'
        };
        Test.startTest();
        for (String t : types) {
            List<META_MetadataSearchController.MetadataResult> results = META_MetadataSearchController.searchMetadata('Test', t, 50);
            System.assertNotEquals(null, results, 'Results should not be null for type: ' + t);
            // Optionally check that each result has a name and type
            for (META_MetadataSearchController.MetadataResult res : results) {
                System.assertNotEquals(null, res.name, 'Result name should not be null');
                System.assertNotEquals(null, res.type, 'Result type should not be null');
            }
        }
        Test.stopTest();
    }

    /**
     * @description Test searchMetadata for all types (type = null)
     */
    @IsTest
    static void testSearchMetadataAllTypes() {
        Test.startTest();
        List<META_MetadataSearchController.MetadataResult> results = META_MetadataSearchController.searchMetadata('Test', null, 50);
        Test.stopTest();
        System.assertNotEquals(null, results, 'Results should not be null for all types');
        // Do not assert total size, as aggregate can exceed 50 when searching all types
    }

    /**
     * @description Test searchMetadata with blank type
     */
    @IsTest
    static void testSearchMetadataBlankType() {
        Test.startTest();
        List<META_MetadataSearchController.MetadataResult> results = META_MetadataSearchController.searchMetadata('Test', '', 50);
        Test.stopTest();
        System.assertNotEquals(null, results, 'Results should not be null for blank type');
        // Do not assert total size, as aggregate can exceed 50 when searching all types
    }

    /**
     * @description Test searchMetadata with invalid type
     */
    @IsTest
    static void testSearchMetadataInvalidType() {
        Test.startTest();
        List<META_MetadataSearchController.MetadataResult> results = META_MetadataSearchController.searchMetadata('Test', 'InvalidType', 50);
        Test.stopTest();
        System.assertEquals(0, results.size(), 'Results should be empty for invalid type');
    }

    /**
     * @description Test coverage for Test.isRunningTest() dummy data
     */
    @IsTest
    static void testSearchMetadataWithDummyData() {
        // If you add Test.isRunningTest() logic in the controller, test it here
        Test.startTest();
        List<META_MetadataSearchController.MetadataResult> results = META_MetadataSearchController.searchMetadata('Dummy', 'ApexClass', 50);
        Test.stopTest();
        System.assertNotEquals(null, results, 'Results should not be null for dummy data');
    }
}
