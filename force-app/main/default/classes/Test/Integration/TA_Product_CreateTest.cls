/**
 * Created by patryk.witkowski_bri on 5/9/2025.
 */
@IsTest
private class TA_Product_CreateTest {
    @IsTest
    static void testAfterInsertSuccess() {
        Product2 prod1 = new Product2(
                Name = 'Test Product 1',
                ProductCode = 'TEST001',
                Base_Price__c = 100.00,
                IsActive = true,
                IsExternal__c = false
        );
        Product2 prod2 = new Product2(
                Name = 'Test Product 2',
                ProductCode = 'TEST002',
                Base_Price__c = 200.00,
                IsActive = true,
                IsExternal__c = false
        );
        List<Product2> products = new List<Product2>{prod1, prod2};

        Test.startTest();
        insert products;
        Test.stopTest();

        List<Product2> products2 = [
                SELECT Id, ExternalId__c, IsExternal__c
                FROM Product2
        ];

        Assert.areEqual(2, products2.size(), 'Two products should be inserted');
        for (Product2 entry : products2) {
            Assert.areEqual(false, entry.IsExternal__c, 'Product shouldn\'t be from external source');
            Assert.areEqual(true, String.isNotBlank(entry.ExternalId__c), 'Product should have ExternalId');
        }
    }
}