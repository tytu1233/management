@IsTest
private class IntegrationProductTest {

    @TestSetup
    static void setup() {
        new DataGenerator().createData();
    }

    @IsTest
    static void integrationPOST_Success() {
        List<Product2> products = [SELECT Id, Name, Family, Base_Price__c, IsActive, IsExternal__c FROM Product2];
        String requestBody = JSON.serialize(products);
        RestRequest request = new RestRequest();
        request.httpMethod = 'POST';
        request.requestURI = '/services/apexrest/integration/product';
        request.requestBody = Blob.valueOf(requestBody);

        RestContext.request = request;
        RestContext.response = new RestResponse();

        Test.startTest();
        IntegrationProduct.createProductsFromExternalOrg();
        Test.stopTest();

        RestResponse response = RestContext.response;
        Assert.areEqual(200, response.statusCode, 'Status code should be 200');
        List<Logger.ResponseDTO> responseLogs = (List<Logger.ResponseDTO>) JSON.deserialize(response.responseBody.toString(), List<Logger.ResponseDTO>.class);
        Assert.areEqual(2, responseLogs.size(), 'Size should be 2');
        for(Logger.ResponseDTO log : responseLogs) {
            Assert.areEqual('Product has been created successfully', log.message, 'Message should match');
            Assert.areEqual('Success', log.status, 'Status should be success');
        }
    }

    @IsTest
    static void integrationPostInvalidJSON_Failed() {
        String requestBody = JSON.serialize('{"message": "hello"}');
        RestRequest request = new RestRequest();
        request.httpMethod = 'POST';
        request.requestURI = '/services/apexrest/integration/product';
        request.requestBody = Blob.valueOf(requestBody);

        RestContext.request = request;
        RestContext.response = new RestResponse();

        Test.startTest();
        IntegrationProduct.createProductsFromExternalOrg();
        Test.stopTest();

        RestResponse response = RestContext.response;
        Assert.areEqual(400, response.statusCode, 'Status code should be 400');
        List<Logger.ResponseDTO> responseLogs = (List<Logger.ResponseDTO>) JSON.deserialize(response.responseBody.toString(), List<Logger.ResponseDTO>.class);
        Assert.areEqual(1, responseLogs.size(), 'Size should be 2');
        for(Logger.ResponseDTO log : responseLogs) {
            Assert.areEqual(null, log.recordId, 'Record ID should be null');
            Assert.areEqual('Failed', log.status, 'Status should be failed');
        }
    }

    @IsTest
    static void integrationPUT_Success() {
        List<Product2> products = [SELECT Id, Name, Family, Base_Price__c, IsActive, IsExternal__c FROM Product2];
        String requestBody = JSON.serialize(products);
        RestRequest request = new RestRequest();
        request.httpMethod = 'PUT';
        request.requestURI = '/services/apexrest/integration/product';
        request.requestBody = Blob.valueOf(requestBody);

        RestContext.request = request;
        RestContext.response = new RestResponse();

        Test.startTest();
        IntegrationProduct.updateProductsFromExternalOrg();
        Test.stopTest();

        RestResponse response = RestContext.response;
        Assert.areEqual(200, response.statusCode, 'Status code should be 200');
        List<Logger.ResponseDTO> responseLogs = (List<Logger.ResponseDTO>) JSON.deserialize(response.responseBody.toString(), List<Logger.ResponseDTO>.class);
        Assert.areEqual(2, responseLogs.size(), 'Size should be 2');
        for(Logger.ResponseDTO log : responseLogs) {
            Assert.areEqual('Product has been updated successfully', log.message, 'Message should match');
            Assert.areEqual('Success', log.status, 'Status should be success');
        }
    }

    @IsTest
    static void integrationPUT_Failed() {
        String requestBody = JSON.serialize('[{"message": "failed"}]');
        RestRequest request = new RestRequest();
        request.httpMethod = 'PUT';
        request.requestURI = '/services/apexrest/integration/product';
        request.requestBody = Blob.valueOf(requestBody);

        RestContext.request = request;
        RestContext.response = new RestResponse();

        Test.startTest();
        IntegrationProduct.updateProductsFromExternalOrg();
        Test.stopTest();

        RestResponse response = RestContext.response;
        Assert.areEqual(400, response.statusCode, 'Status code should be 200');
        List<Logger.ResponseDTO> responseLogs = (List<Logger.ResponseDTO>) JSON.deserialize(response.responseBody.toString(), List<Logger.ResponseDTO>.class);
        Assert.areEqual(1, responseLogs.size(), 'Size should be 1');
        for(Logger.ResponseDTO log : responseLogs) {
            Assert.isTrue(log.message.startsWith('Malformed JSON'), 'Message should begin with: Malformed JSON');
            Assert.areEqual('Failed', log.status, 'Status should be failed');
        }
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
                        .external(false)
                        .build()
                );
            }
            return products;
        }

        public override void createData() {
            createPricebook();
            insert createProducts();
        }
    }
}