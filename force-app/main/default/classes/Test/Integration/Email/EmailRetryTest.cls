/**
 * Created by patryk.witkowski_bri on 5/16/2025.
 */

@IsTest
private class EmailRetryTest {
    @TestSetup
    static void setup() {
        new DataGenerator().createData();
    }

    @IsTest
    static void testSendEmailWithMultipleRecords() {
        List<Product_Logger__c> loggers = [
                SELECT Id, Product__c, Method__c, Retry__c, Status__c
                FROM Product_Logger__c
                WHERE Retry__c >= 3
        ];

        RetryEmail retryEmail = new RetryEmail(loggers);

        Test.startTest();
        retryEmail.sendEmail();
        Integer invocations = Limits.getEmailInvocations();
        Test.stopTest();

        Assert.areEqual(1, invocations, 'Only one email should be sent');
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

        public Product_Logger__c createProductLoggerWithProduct(String productId) {
            Product_Logger__c productLogger = prepareProductLogger()
                    .method('POST')
                    .productId(productId)
                    .retry(4)
                    .status('Failed')
                    .save()
                    .build();

            return productLogger;
        }

        public override void createData() {
            createPricebook();
            Id productId = createProduct().Id;
            createProductLoggerWithProduct(productId);
        }
    }
}