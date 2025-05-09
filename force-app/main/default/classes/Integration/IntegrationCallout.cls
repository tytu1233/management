/**
 * Created by patryk.witkowski_bri on 5/8/2025.
 */

public with sharing class IntegrationCallout {
    @Future(Callout=true)
    public static void sendProducts(List<Id> productIds) {
        List<Product2> products = [
                SELECT Name, ProductCode, Base_Price__c, IsActive, ExternalId__c
                FROM Product2
                WHERE Id IN :productIds
        ];

        Http http = new Http();
        HttpRequest request = configureRequest('POST', products);
        HttpResponse response = http.send(request);

        if(response.getStatusCode() == 200) {
            System.debug(response.getStatusCode());
            System.debug(response.getBody());
        }
    }

    @Future(Callout=true)
    public static void deleteProducts(Set<Id> productIds) {
        List<Product2> products = [
                SELECT Id, Name, Base_Price__c, IsActive, ExternalId__c
                FROM Product2
                WHERE Id IN :productIds
                ALL ROWS
        ];

        Http http = new Http();
        HttpRequest request = configureRequest('DELETE', products);
        HttpResponse response = http.send(request);

        if (response.getStatusCode() != 200) {
            throw new AuraHandledException('Synchronization with other org was not possible. Please try again');
        }

        try {
            undelete products;
        } catch (Exception ex) {
            System.debug('Undelete failed: ' + ex.getMessage());
            throw new AuraHandledException('Failed to restore products: ' + ex.getMessage());
        }
    }

    @Future(Callout=true)
    public static void updateProducts(Set<Id> productIds) {
        List<Product2> products = [
                SELECT Name, ProductCode, Base_Price__c, IsActive, ExternalId__c
                FROM Product2
                WHERE Id IN :productIds
        ];

        Http http = new Http();
        HttpRequest request = configureRequest('PUT', products);
        HttpResponse response = http.send(request);

        if(response.getStatusCode() != 200) {
            throw new AuraHandledException('Synchronization with other org was not possible. Please try again');
        }
    }

    private static HttpRequest configureRequest(String method, List<Product2> data) {
        String targetEndpoint = 'callout:SalesforceIntegrationCredential/services/apexrest/integration/product';

        HttpRequest request = new HttpRequest();
        request.setMethod(method);
        request.setEndpoint(targetEndpoint);
        request.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());
        request.setHeader('Content-Type', 'application/json');
        request.setBody(JSON.serialize(data));

        return request;
    }
}