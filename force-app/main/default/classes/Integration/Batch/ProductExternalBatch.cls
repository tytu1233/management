/**
 * Created by patryk.witkowski_bri on 5/13/2025.
 */

public with sharing class ProductExternalBatch implements Database.Batchable<SObject>, Database.AllowsCallouts {
    private final List<Id> productsIds;
    private final String method;

    public ProductExternalBatch(String method, List<Id> productsIds) {
        this.method = method;
        this.productsIds = productsIds;
    }

    public Database.QueryLocator start(Database.BatchableContext context) {
        return Database.getQueryLocator([
                SELECT Id, Name, ProductCode, Base_Price__c, IsActive, ExternalId__c
                FROM Product2
                WHERE Id IN :productsIds
        ]);
    }

    public void finish(Database.BatchableContext context) {
        System.debug('JOB DONE');
    }

    public void execute(Database.BatchableContext context, List<SObject> records) {
        List<Product_Logger__c> productLoggers = new List<Product_Logger__c>();

        Http http = new Http();
        HttpRequest request = HttpConfiguration.configureRequest(this.method, records);
        HttpResponse response = http.send(request);

        if(response.getStatusCode() != 200) {

        } else {
            List<Logger.ProductLog> productLogs = (List<Logger.ProductLog>) JSON.deserialize(response.getBody(), List<Logger.ProductLog>.class);
            //Logger.logProductCallout(productLogs);
        }
    }
}