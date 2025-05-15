/**
 * Created by patryk.witkowski_bri on 5/9/2025.
 */

@IsTest
private class IntegrationProductTest {
    
    private static void setupRestContext(String requestBody) {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/IntegrationProduct';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(requestBody);
        RestContext.request = req;
        RestContext.response = res;
    }

    @IsTest
    static void testCreateProductsFromExternalOrg_Success() {
        Product2 prod1 = new Product2(Name = 'Test Product 1', ProductCode = 'TP1', IsActive = true);
        Product2 prod2 = new Product2(Name = 'Test Product 2', ProductCode = 'TP2', IsActive = true);
        List<Product2> products = new List<Product2>{prod1, prod2};
        String requestBody = JSON.serialize(products);

        setupRestContext(requestBody);

        Test.startTest();
        IntegrationProduct.createProductsFromExternalOrg();
        Test.stopTest();

        RestResponse res = RestContext.response;
        Assert.areEqual(200, res.statusCode, 'Expected status code 200');
        Assert.areEqual('Record has been created successfully', res.responseBody.toString(), 'Expected success message');

        List<Product2> createdProducts = [
                SELECT Id, Name, IsExternal__c
                FROM Product2
                WHERE Name LIKE 'Test Product%'
        ];

        Assert.areEqual(2, createdProducts.size(), 'Expected 2 products to be created');
        for (Product2 prod : createdProducts) {
            Assert.areEqual(true, prod.IsExternal__c, 'Expected IsExternal__c to be true');
        }
    }

    @IsTest
    static void testCreateProductsFromExternalOrg_Failure() {
        String requestBody = 'Invalid JSON';

        setupRestContext(requestBody);

        Test.startTest();
        IntegrationProduct.createProductsFromExternalOrg();
        Test.stopTest();

        RestResponse res = RestContext.response;
        Assert.areEqual(400, res.statusCode, 'Expected status code 400');
    }

    @IsTest
    static void testDeleteProductsFromExternalOrg_Success() {
        Product2 prod1 = new Product2(Name = 'Test Product 1', ProductCode = 'TP1', IsActive = true, ExternalId__c = 'EXT1', IsExternal__c = true);
        Product2 prod2 = new Product2(Name = 'Test Product 2', ProductCode = 'TP2', IsActive = true, ExternalId__c = 'EXT2', IsExternal__c = true);
        insert new List<Product2>{prod1, prod2};

        List<Product2> products = new List<Product2>();
        products.add(new Product2(ExternalId__c = 'EXT1'));
        products.add(new Product2(ExternalId__c = 'EXT2'));
        String requestBody = JSON.serialize(products);

        setupRestContext(requestBody);
        RestContext.request.httpMethod = 'DELETE';

        Test.startTest();
        IntegrationProduct.deleteProductsFromExternalOrg();
        Test.stopTest();

        RestResponse res = RestContext.response;
        Assert.areEqual(200, res.statusCode, 'Expected status code 200');
        Assert.areEqual('Record has been deleted successfully', res.responseBody.toString(), 'Expected success message');

        List<Product2> updatedProducts = [
                SELECT Id, IsActive
                FROM Product2
                WHERE ExternalId__c IN ('EXT1', 'EXT2')
        ];

        Assert.areEqual(2, updatedProducts.size(), 'Expected 2 products to be updated');
        for (Product2 prod : updatedProducts) {
            Assert.areEqual(false, prod.IsActive, 'Expected IsActive to be false');
        }
    }

    @IsTest
    static void testDeleteProductsFromExternalOrg_Failure() {
        String requestBody = 'Invalid JSON';

        setupRestContext(requestBody);
        RestContext.request.httpMethod = 'DELETE';

        Test.startTest();
        IntegrationProduct.deleteProductsFromExternalOrg();
        Test.stopTest();

        RestResponse res = RestContext.response;
        Assert.areEqual(400, res.statusCode, 'Expected status code 400');
        Assert.areNotEqual('Record has been deleted successfully', res.responseBody.toString(), 'Expected error message');
    }

    @IsTest
    static void testUpdateProductsFromExternalOrg_Success() {
        Product2 prod1 = new Product2(Name = 'Test Product 1', ProductCode = 'TP1', IsActive = true, ExternalId__c = 'EXT1', IsExternal__c = true);
        insert prod1;

        List<Product2> products = new List<Product2>();
        Product2 updatedProd = new Product2(Name = 'Updated Product', ProductCode = 'TP1', IsActive = false, ExternalId__c = 'EXT1');
        products.add(updatedProd);
        String requestBody = JSON.serialize(products);

        setupRestContext(requestBody);
        RestContext.request.httpMethod = 'PUT';

        Test.startTest();
        IntegrationProduct.updateProductsFromExternalOrg();
        Test.stopTest();

        RestResponse res = RestContext.response;
        Assert.areEqual(200, res.statusCode, 'Expected status code 200');
        Assert.areEqual('Record has been updated successfully', res.responseBody.toString(), 'Expected success message');

        Product2 updatedProduct = [
                SELECT Id, Name, IsActive
                FROM Product2
                WHERE ExternalId__c = 'EXT1' LIMIT 1
        ];
        Assert.areEqual('Updated Product', updatedProduct.Name, 'Expected Name to be updated');
        Assert.areEqual(false, updatedProduct.IsActive, 'Expected IsActive to be false');
    }

    @IsTest
    static void testUpdateProductsFromExternalOrg_Failure() {
        String requestBody = 'Invalid JSON';

        setupRestContext(requestBody);
        RestContext.request.httpMethod = 'PUT';

        Test.startTest();
        IntegrationProduct.updateProductsFromExternalOrg();
        Test.stopTest();

        RestResponse res = RestContext.response;
        Assert.areEqual(400, res.statusCode, 'Expected status code 400');
        Assert.areNotEqual('Record has been updated', res.responseBody.toString(), 'Expected error message');
    }
}