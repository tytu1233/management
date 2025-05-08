/**
 * Created by patryk.witkowski_bri on 5/8/2025.
 */

@RestResource(UrlMapping='/integration/product')
global with sharing class IntegrationProduct {
    @HttpGet
    global static void test() {
        RestResponse response = RestContext.response;

        response.statusCode = 200;
        response.responseBody = Blob.valueOf('Welcome on the target org. Nice to see u!');
    }

    @HttpPost
    global static void createProductsFromExternalOrg() {
        RestRequest request = RestContext.request;
        RestResponse response = RestContext.response;

        List<Product2> responseProducts = (List<Product2>) JSON.deserialize(request.requestBody.toString(), List<Product2>.class);

        System.debug(responseProducts);

    }

    @HttpPut
    global static void deleteProductsFromExternalOrg() {
        RestRequest request = RestContext.request;
        RestResponse response = RestContext.response;

        List<Product2> responseProducts = (List<Product2>) JSON.deserialize(request.requestBody.toString(), List<Product2>.class);

        System.debug(responseProducts);

    }
}