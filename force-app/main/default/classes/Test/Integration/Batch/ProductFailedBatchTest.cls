@IsTest
private class ProductFailedBatchTest {
    @TestSetup
    static void setup() {
        new DataGenerator().createData();
    }

    @IsTest
    static void testBatchSuccess() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse(200, '[{"status": "Success"}]'));

        Test.startTest();
        ProductFailedBatch batch = new ProductFailedBatch();
        Database.executeBatch(batch, 2);
        Test.stopTest();
        List<Product_Logger__c> loggers = [
                SELECT Id, Retry__c, Status__c
                FROM Product_Logger__c
                WHERE Status__c = 'Success'
        ];

        Assert.areEqual(2, loggers.size(), 'Both loggers should have status Success');
        for (Product_Logger__c logger : loggers) {
            Assert.areEqual('Success', logger.Status__c, 'Status should be Success');
        }
    }

    @IsTest
    static void testBatchRetryIncrement() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse(400, '[{"status":"Failed","recordId":"01tgL0000023o5ZQAQ","message":"FAILED"}]'));

        Test.startTest();
        ProductFailedBatch batch = new ProductFailedBatch();
        Database.executeBatch(new ProductFailedBatch(), 2);
        Test.stopTest();
        List<Product_Logger__c> loggers = [
                SELECT Id, Retry__c, Status__c
                FROM Product_Logger__c
        ];
        System.debug(batch.productsIdToSend);
        Assert.areEqual(2, loggers.size(), 'Two loggers should be processed');
        Assert.areEqual(2, loggers[0].Retry__c, 'Retry count should increment to 2');
        Assert.areEqual(3, loggers[1].Retry__c, 'Retry count should increment to 3');
        Assert.areEqual(Utils.LOG.STATUS.FAILED, loggers[0].Status__c, 'Status should remain FAILED');
        Assert.areEqual(Utils.LOG.STATUS.NETWORK_PROBLEM, loggers[1].Status__c, 'Status should remain NETWORK_PROBLEM');
    }

    @IsTest
    static void testBatchCalloutException() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse(0, ''));
        Test.startTest();
        ProductFailedBatch batch = new ProductFailedBatch();
        Database.executeBatch(batch, 2);
        Test.stopTest();
        List<Product_Logger__c> loggers = [
                SELECT Id, Retry__c, Status__c
                FROM Product_Logger__c
        ];
        Assert.areEqual(2, loggers[0].Retry__c, 'Retry count should increment to 2');
        Assert.areEqual(3, loggers[1].Retry__c, 'Retry count should increment to 3');
    }

    @IsTest
    static void testBatchInvalidJson() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse(200, '{"invalid": "json"}'));
        Test.startTest();
        ProductFailedBatch batch = new ProductFailedBatch();
        Database.executeBatch(batch, 2);
        Test.stopTest();
        List<Product_Logger__c> loggers = [
                SELECT Id, Retry__c, Status__c
                FROM Product_Logger__c
        ];
        Assert.areEqual(2, loggers[0].Retry__c, 'Retry count should increment to 2');
        Assert.areEqual(3, loggers[1].Retry__c, 'Retry count should increment to 3');
    }

    @IsTest
    static void testBatchEmptyRecords() {
        delete [SELECT Id FROM Product_Logger__c];
        Test.startTest();
        ProductFailedBatch batch = new ProductFailedBatch();
        Database.executeBatch(batch, 2);
        Test.stopTest();
        Assert.areEqual(0, batch.productsIdToSend.size(), 'No products should be added');
    }

    class DataGenerator extends Factory {

        public override Pricebook2 createPricebook() {
            Pricebook2 pricebook = preparePricebook()
                    .name('Event Management Price Book')
                    .active(true)
                    .save()
                    .build();

            return pricebook;
        }

        public List<Product2> createProducts() {
            List<Product2> products = new List<Product2>();

            for(Integer i = 0; i < 2; i++) {
                products.add(
                        prepareProduct()
                        .name('Product ' + i)
                        .family('P' + i)
                        .basePrice(100)
                        .active(true)
                        .external(true)
                        .build()
                );
            }
            return products;
        }

        public void createProductLoggers(List<Product2> products) {
            prepareProductLogger()
                    .method('POST')
                    .retry(1)
                    .status(Utils.LOG.STATUS.FAILED)
                    .type(Utils.LOG.TYPE.CALLOUT)
                    .productId(products.get(0).Id)
                    .save()
                    .build();

            prepareProductLogger()
                    .method('POST')
                    .retry(2)
                    .status(Utils.LOG.STATUS.NETWORK_PROBLEM)
                    .type(Utils.LOG.TYPE.CALLOUT)
                    .productId(products.get(1).Id)
                    .save()
                    .build();
        }
        public override void createData() {
            createPricebook();
            List<Product2> products = createProducts();
            insert products;
            delete [SELECT Id FROM Product_Logger__c];

            createProductLoggers(products);
        }
    }
}