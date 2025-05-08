/**
 * Created by patryk.witkowski_bri on 5/8/2025.
 */

public with sharing class IntegrationCallout {

    public static void checkConnection() {

        String targetEndpoint = 'callout:SalesforceIntegrationCredential/services/apexrest/integration/product';

        Http http = new Http();

        HttpRequest request = new HttpRequest();
        request.setMethod('GET');
        request.setEndpoint(targetEndpoint);
        request.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());
        request.setHeader('Content-Type', 'application/json');

        HttpResponse response = http.send(request);
        System.debug(response.getStatusCode());
        System.debug(response.getBody());
    }
}