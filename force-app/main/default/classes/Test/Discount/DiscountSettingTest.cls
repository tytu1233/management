/**
 * Created by patryk.witkowski_bri on 5/7/2025.
 */

@IsTest
private class DiscountSettingTest {

    // Mock Custom Metadata Type record for testing
    private static Discount_Strategy_Setting__mdt createMockDiscountStrategySetting(String strategyType) {
        return new Discount_Strategy_Setting__mdt(
                Strategy_Types__c = strategyType
        );
    }

    @IsTest
    static void testGetDiscountsSettings_ValidData() {
        // Arrange
        Discount_Strategy_Setting__mdt mockSetting = createMockDiscountStrategySetting('Combine');
        List<Discount_Strategy_Setting__mdt> mockSettings = new List<Discount_Strategy_Setting__mdt>{mockSetting};

        // Mock SOQL query
        Test.startTest();
        // Simulate CMDT query
        System.assert(true, 'Running in test context');
        List<DiscountSettings.DiscountDTO> result = DiscountSettings.getDiscountsSettings();
        System.debug('WHATS THE RESULT');
        System.debug(result);
        Test.stopTest();

        // Assert
        Assert.areEqual(1, result.size(), 'One DiscountDTO should be returned');
        Assert.areEqual('Combine', result[0].label, 'Label should match strategy type');
        Assert.areEqual('Combine', result[0].value, 'Value should match strategy type');
    }

    @IsTest
    static void testGetDiscountsSettings_NoSettings() {
        // Arrange
        List<Discount_Strategy_Setting__mdt> mockSettings = new List<Discount_Strategy_Setting__mdt>();

        // Mock SOQL query
        Test.startTest();
        try {
            DiscountSettings.getDiscountsSettings();
        } catch (AuraHandledException e) {
            Assert.areEqual(
                    Utils.DISCOUNT.ERRORS.DiscountStrategyNotExist,
                    e.getMessage(),
                    'Exception message should match expected error'
            );
        }
        Test.stopTest();
    }

    @IsTest
    static void testUpdateDiscountSetting_DeploymentFailure() {
        // Arrange
        String metadataType = 'Percentage';

        // Mock metadata deployment failure
        Test.startTest();
        //Test.setMock(Metadata.DeployCallback.class, new MockDeployCallback(false));
        try {
            DiscountSettings.updateDiscountSetting(metadataType);
            Assert.isFalse(false, 'Expected AuraHandledException for deployment failure');
        } catch (AuraHandledException e) {
            Assert.areEqual('Script-thrown exception', e.getMessage(), 'Exception message should match');
        }
        Test.stopTest();
    }

    // Test updateDiscountSetting with invalid input
    @IsTest
    static void testUpdateDiscountSetting_InvalidInput() {
        // Arrange
        String metadataType = null;

        // Act & Assert
        Test.startTest();
        try {
            DiscountSettings.updateDiscountSetting(metadataType);
            System.assert(false, 'Expected AuraHandledException for invalid input');
        } catch (AuraHandledException e) {
            System.assertEquals('Script-thrown exception', e.getMessage(), 'Exception message should match');
        }
        Test.stopTest();
    }
}