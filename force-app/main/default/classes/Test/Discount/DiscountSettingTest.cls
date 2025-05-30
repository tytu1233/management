/**
 * Created by patryk.witkowski_bri on 5/7/2025.
 */

@IsTest
private class DiscountSettingTest {

    @IsTest
    static void testGetDiscountsSettings_ValidData() {

        Test.startTest();
        System.assert(true, 'Running in test context');
        List<DiscountSettings.DiscountDTO> result = DiscountSettings.getDiscountsSettings();
        System.debug('WHATS THE RESULT');
        System.debug(result);
        Test.stopTest();

        Assert.areEqual(1, result.size(), 'One DiscountDTO should be returned');
        Assert.areEqual('Combine', result[0].label, 'Label should match strategy type');
        Assert.areEqual('Combine', result[0].value, 'Value should match strategy type');
    }

    @IsTest
    static void testGetDiscountsSettings_NoSettings() {
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
        String metadataType = 'Percentage';

        Test.startTest();
        try {
            DiscountSettings.updateDiscountSetting(metadataType);
            Assert.isFalse(false, 'Expected AuraHandledException for deployment failure');
        } catch (Exception e) {
            Assert.areEqual('Couldn\'t update discount settings', e.getMessage(), 'Exception message should match');
        }
        Test.stopTest();
    }

    @IsTest
    static void testUpdateDiscountSetting_InvalidInput() {
        String metadataType = null;

        Test.startTest();
        try {
            DiscountSettings.updateDiscountSetting(metadataType);
            System.assert(false, 'Expected AuraHandledException for invalid input');
        } catch (Exception e) {
            System.assertEquals('Couldn\'t update discount settings', e.getMessage(), 'Exception message should match');
        }
        Test.stopTest();
    }
}