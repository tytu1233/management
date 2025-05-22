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
        //TODO: NIE SZTYWNE ID, SPRAWDZIC OPROCZ SAMEGO LOGGERA, ZEBY SPRAWDZIC CZY DOBRE DANE ZWROCILO Z MOCKA
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse(200, '[{"status":"Success","recordId":"01tgL0000023o5ZQAQ","message":"Record has been created successfully"}]'));

        Test.startTest();
        System.enqueueJob(new ProductExternalQueueable(products, 'POST'));
        Test.stopTest();

        for(Product_Logger__c productLogger : [SELECT Id, Name, Status__c, Method__c, Product__c, Retry__c FROM Product_Logger__c]) {
            System.debug(productLogger);
            Assert.areEqual('Success', productLogger.Status__c, 'Status should equal to success');
            Assert.areEqual(null, productLogger.Retry__c, 'Retry should be not specified');
        }
    }

    @IsTest
    static void productExternalQueueable_Error() {
        delete [SELECT Id FROM Product_Logger__c];
        List<Product2> products = [SELECT Id, Name, Base_Price__c, IsExternal__c FROM Product2];
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse(400, 'BLAD'));

        Test.startTest();
        System.enqueueJob(new ProductExternalQueueable(products, 'PUT'));
        Test.stopTest();

        for(Product_Logger__c productLogger : [SELECT Id, Name, Status__c, Method__c, Product__c, Retry__c FROM Product_Logger__c]) {
            Assert.areEqual('PUT', productLogger.Method__c, 'Method should match');
            Assert.areEqual('Network problem', productLogger.Status__c, 'Method should be failed');
            Assert.areEqual(1, productLogger.Retry__c, 'Retry should equal to 1');
        }
    }


    class DataGenerator extends Factory {
        public override void createData() {
            createPricebook();
            createProduct();
        }
    }
}