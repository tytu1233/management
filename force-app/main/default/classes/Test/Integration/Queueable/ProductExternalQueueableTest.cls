/**
 * Created by patryk.witkowski_bri on 5/16/2025.
 */

@IsTest
private class ProductExternalQueueableTest {

    @TestSetup
    static void setup() {
        DataGenerator dataGenerator = new DataGenerator();
        dataGenerator.createData();
    }

    @IsTest
    static void productExternalQueueable_Success() {
        delete [SELECT Id FROM Product_Logger__c];
        List<Product2> products = [SELECT Id, Name, Base_Price__c, IsExternal__c FROM Product2];

        System.debug([SELECT Id, Name, Status__c, Method__c FROM Product_Logger__c]);
        Test.setMock(HttpCalloutMock.class, new MockHttpSuccess());

        Test.startTest();
        System.enqueueJob(new ProductExternalQueueable(products, 'POST'));
        Test.stopTest();

        System.debug('AFTERCALL');
        System.debug([SELECT Id, Name, Status__c, Method__c, Product__c FROM Product_Logger__c]);
    }

    @IsTest
    static void productExternalQueueable_Error() {
        delete [SELECT Id FROM Product_Logger__c];
        List<Product2> products = [SELECT Id, Name, Base_Price__c, IsExternal__c FROM Product2];
        Test.setMock(HttpCalloutMock.class, new MockHttpFailed());

        Test.startTest();
        System.enqueueJob(new ProductExternalQueueable(products, 'PUT'));
        Test.stopTest();

        System.debug([SELECT Retry__c, Id, Name, Status__c, Method__c, Product__c FROM Product_Logger__c]);

        for(Product_Logger__c productLogger : [SELECT Id, Name, Status__c, Method__c, Product__c, Retry__c FROM Product_Logger__c]) {
            Assert.areEqual('PUT', productLogger.Method__c, 'Method should match');
            Assert.areEqual('Network problem', productLogger.Status__c, 'Method should be failed');
            Assert.areEqual(1, productLogger.Retry__c, 'Retry should equal to 1');
        }
    }


    class DataGenerator extends Factory {
        public override Product2 createProduct() {
            Product2 product = prepareProduct()
                    .productCode('TEST001')
                    .basePrice(200.00)
                    .active(true)
                    .external(false)
                    .save()
                    .build();
            return product;
        }

        public override Pricebook2 createPricebook() {
            Pricebook2 pricebook = preparePricebook()
                    .name('Event Management Price Book')
                    .active(true)
                    .save()
                    .build();

            return pricebook;
        }

        public override void createData() {
            //TODO: ZROBIC SAVEY - TO MA WYWOLYWAC SAME CREATE DATA METODKI
            createPricebook();
            createProduct();
        }
    }
}