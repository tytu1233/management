/**
 * Created by patryk.witkowski_bri on 5/9/2025.
 */

global class MockHttpResponseGenerator implements HttpCalloutMock {
    global HttpResponse respond(HttpRequest req) {
        System.assertEquals('callout:SalesforceIntegrationCredentialv2/services/apexrest/integration/product', req.getEndpoint());
        System.assertEquals('POST', req.getMethod());

        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"example":"test"}');
        res.setStatusCode(400);
        return res;
    }
}