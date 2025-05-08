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
}