/**
 * Created by patryk.witkowski_bri on 5/9/2025.
 */

@IsTest
private class IntegrationCalloutTest {

    private class SuccessMock implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            Assert.areEqual('callout:SalesforceIntegrationCredentialv2/services/apexrest/integration/product', req.getEndpoint(), 'Endpoint should match');
            Assert.areEqual('application/json', req.getHeader('Content-Type'), 'Content-Type should be JSON');
            Assert.isTrue(req.getHeader('Authorization').startsWith('Bearer '), 'Authorization header should include Bearer token');

            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            res.setBody('{"status":"success","message":"Operation completed"}');
            return res;
        }
    }

    @TestSetup
    static void setup() {
        List<Product2> products = new List<Product2>();
        products.add(new Product2(
                Name = 'Test Product 1',
                ProductCode = 'TEST001',
                Base_Price__c = 100.00,
                IsActive = true,
                ExternalId__c = 'EXT001',
                IsExternal__c = true
        ));
        products.add(new Product2(
                Name = 'Test Product 2',
                ProductCode = 'TEST002',
                Base_Price__c = 200.00,
                IsActive = true,
                ExternalId__c = 'EXT002',
                IsExternal__c = true
        ));
        insert products;

        Pricebook2 pricebook2 = new Pricebook2(Name = 'Event Management Price Book', IsActive = true);
        insert pricebook2;
    }

    @IsTest
    static void testSendProductsSuccess() {
        List<Product2> products = [SELECT Id FROM Product2 WHERE ExternalId__c IN ('EXT001', 'EXT002')];
        List<Id> productIds = new List<Id>{products[0].Id, products[1].Id};

        Test.setMock(HttpCalloutMock.class, new SuccessMock());

        Test.startTest();
        IntegrationCallout.sendProducts(productIds);
        Test.stopTest();

        List<Product_Logger__c> productLoggers = [SELECT Name FROM Product_Logger__c];
        List<PricebookEntry> productEntries = [SELECT Id, Name FROM PricebookEntry];

        Assert.areEqual(2, productLoggers.size(), 'Method should\'ve created a two logs for products');
        Assert.areEqual(4, productEntries.size(), 'Method should\'ve created a four record for created products (2 for each pricebook - standard and custom)');
        Assert.isTrue(true, 'Method should execute without throwing an exception');
    }

    @IsTest
    static void testDeleteProductsSuccess() {
        Product2 prod = [SELECT Id FROM Product2 WHERE ExternalId__c = 'EXT001' LIMIT 1];

        delete prod;

        Test.setMock(HttpCalloutMock.class, new SuccessMock());

        Test.startTest();
        IntegrationCallout.deleteProducts(new Set<Id>{prod.Id});
        Test.stopTest();

        Product2 undeletedProd = [
                SELECT Id, IsDeleted
                FROM Product2
                WHERE Id = :prod.Id
                ALL ROWS
        ];

        List<Product_Logger__c> productLoggers = [
                SELECT Name, Type__c, Method__c, Status__c
                FROM Product_Logger__c
        ];

        for(Product_Logger__c logger : productLoggers) {
            Assert.areEqual('DELETE', logger.Method__c);
            Assert.areEqual('Success', logger.Status__c);
        }

        Assert.areEqual(false, undeletedProd.IsDeleted, 'Product should be undeleted');
    }

    @IsTest
    static void testUpdateProductsSuccess() {
        List<Product2> products = [
                SELECT Id
                FROM Product2
                WHERE ExternalId__c IN ('EXT001', 'EXT002')
        ];
        Set<Id> productIds = new Set<Id>{products[0].Id, products[1].Id};

        Test.setMock(HttpCalloutMock.class, new SuccessMock());

        Test.startTest();
        IntegrationCallout.updateProducts(productIds);
        Test.stopTest();

        Assert.isTrue(true, 'Method should execute without throwing an exception');
    }
}