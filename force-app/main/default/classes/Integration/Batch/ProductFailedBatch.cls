/**
 * Created by patryk.witkowski_bri on 5/14/2025.
 */

public with sharing class ProductFailedBatch implements Database.Batchable<SObject>, Database.AllowsCallouts {
    public Database.QueryLocator start(Database.BatchableContext context) {
        return Database.getQueryLocator([
                SELECT Id, Product__c, Method__c, Retry__c, Status__c
                FROM Product_Logger__c
                WHERE Status__c = :Utils.LOG.STATUS.FAILED AND Retry__c < 3 AND Type__c = :Utils.LOG.TYPE.CALLOUT
        ]);
    }

    public void finish(Database.BatchableContext context) {
    }

    public void execute(Database.BatchableContext context, List<SObject> records) {
        List<Id> productIds = new List<Id>();
        for(Product_Logger__c productLogger : (List<Product_Logger__c>) records) {
            productIds.add(productLogger.Product__c);
        }


        Map<Id, Product2> productMap = new Map<Id, Product2>([
                SELECT Id, Name, ProductCode, Base_Price__c, IsActive, ExternalId__c
                FROM Product2
                WHERE Id IN :productIds
        ]);

        for(Product_Logger__c productLogger : (List<Product_Logger__c>) records) {
            try {
                Http http = new Http();
                HttpRequest request = HttpConfiguration.configureRequest(productLogger.Method__c, new List<Product2>{productMap.get(productLogger.Product__c)});
                HttpResponse response = http.send(request);

                List<Logger.ProductLog> productLogs = (List<Logger.ProductLog>) JSON.deserialize(response.getBody(), List<Logger.ProductLog>.class);
                if(productLogs.get(0).status == 'Failed') {
                    productLogger.Retry__c += 1;
                } else {
                    productLogger.Status__c = productLogs.get(0).status;
                }
            } catch (Exception ex) {
                System.debug(ex.getMessage());
            }
        }

        try {
            update records;
        } catch (Exception ex) {
            System.debug('THERE IS AN ERROR!');
        }
    }
}