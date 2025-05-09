/**
 * Created by patryk.witkowski_bri on 5/8/2025.
 */

@RestResource(UrlMapping='/integration/product')
global with sharing class IntegrationProduct {
    @HttpPost
    global static void createProductsFromExternalOrg() {
        RestRequest request = RestContext.request;
        RestResponse response = RestContext.response;
        String responseBody = 'Record has been created successfully';
        Integer code = 200;
        try {
            List<Product2> requestProducts = (List<Product2>) JSON.deserialize(request.requestBody.toString(), List<Product2>.class);
            for(Product2 product : requestProducts) {
                product.Id = null;
                product.IsExternal__c = true;
            }
            insert requestProducts;
        } catch(Exception ex) {
            code = 400;
            responseBody = ex.getMessage();
        }
        response.statusCode = code;
        response.responseBody = Blob.valueOf(responseBody);
    }

    @HttpDelete
    global static void deleteProductsFromExternalOrg() {
        RestRequest request = RestContext.request;
        RestResponse response = RestContext.response;
        String responseBody = 'Record has been deleted successfully';
        Integer code = 200;
        try {
            Set<String> externalIds = new Set<String>();
            List<Product2> requestProducts = (List<Product2>) JSON.deserialize(request.requestBody.toString(), List<Product2>.class);
            for(Product2 product : requestProducts) {
                externalIds.add(product.ExternalId__c);
            }
            List<Product2> updateProds = [SELECT Id, Name, IsActive FROM Product2 WHERE ExternalId__c IN :externalIds];
            for(Product2 product : updateProds) {
                product.IsActive = false;
            }
            update updateProds;
        } catch(Exception ex) {
            code = 400;
            responseBody = ex.getMessage();
        }
        response.statusCode = code;
        response.responseBody = Blob.valueOf(responseBody);
    }

    @HttpPut
    global static void updateProductsFromExternalOrg() {
        RestRequest request = RestContext.request;
        RestResponse response = RestContext.response;
        String responseBody = 'Record has been updated';
        Integer code = 200;
        try {
            List<Product2> requestProducts = (List<Product2>) JSON.deserialize(request.requestBody.toString(), List<Product2>.class);
            upsert requestProducts ExternalId__c;

            //List<PricebookEntry> pricebookEntries = [SELECT UnitPrice FROM PricebookEntry WHERE Product2Id IN :requestProducts];
            //for(Product2 product : requestProducts) {
            //    pri
            //}
        } catch(Exception ex) {
            code = 400;
            responseBody = ex.getMessage();
        }
        response.statusCode = code;
        response.responseBody = Blob.valueOf(responseBody);
    }
}