/**
 * Created by patryk.witkowski_bri on 5/15/2025.
 */

public class HttpConfiguration {
    public static HttpRequest configureRequest(String method, List<Product2> data) {
        String targetEndpoint = 'callout:SalesforceIntegrationCredentialv2/services/apexrest/integration/product';

        HttpRequest request = new HttpRequest();
        request.setMethod(method);
        request.setEndpoint(targetEndpoint);
        request.setBody(JSON.serialize(data));

        return request;
    }

    public static HttpRequest configureRequestPlatform(Case_Notification__e caseNotification) {
        String targetEndpoint = 'callout:SalesforceIntegrationCredentialv2/services/data/v63.0/sobjects/Case_Notification__e';
        String method = 'POST';

        HttpRequest request = new HttpRequest();
        request.setMethod(method);
        request.setEndpoint(targetEndpoint);
        request.setBody(JSON.serialize(caseNotification));

        return request;
    }
}