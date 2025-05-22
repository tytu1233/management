/**
 * Created by patryk.witkowski_bri on 5/14/2025.
 */

public with sharing class ProductFailedBatch implements Database.Batchable<SObject>, Database.AllowsCallouts, Database.Stateful {

    public final List<Id> productsIdToSend = new List<Id>();

    public Database.QueryLocator start(Database.BatchableContext context) {
        return Database.getQueryLocator([
                SELECT Id, Product__c, Method__c, Retry__c, Status__c
                FROM Product_Logger__c
                WHERE (Status__c = :Utils.LOG.STATUS.FAILED OR Status__c = :Utils.LOG.STATUS.NETWORK_PROBLEM) AND
                Retry__c < 3 AND
                Type__c = :Utils.LOG.TYPE.CALLOUT
        ]);
    }

    public void finish(Database.BatchableContext context) {
        List<Product_Logger__c> failedProducts = [
                SELECT Id, Product__c, Name, Retry__c, Method__c, Status__c
                FROM Product_Logger__c
                WHERE Product__c IN :this.productsIdToSend
                LIMIT 50000
        ];

        if (failedProducts.isEmpty()) {
            System.debug('No records with 3 or more retries found.');
            return;
        }

        RetryEmail retryEmail = new RetryEmail(failedProducts);

        try {
            retryEmail.sendEmail();
        } catch (Exception ex) {
            throw new AuraHandledException('Couldn\'t send emails');
        }

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

                List<Logger.ResponseDTO> productLogs = (List<Logger.ResponseDTO>) JSON.deserialize(response.getBody(), List<Logger.ResponseDTO>.class);

                if(productLogs.get(0).status == 'Failed') {
                    productLogger.Retry__c += 1;
                } else {
                    productLogger.Status__c = productLogs.get(0).status;
                }
            } catch (Exception ex) {
                productLogger.Retry__c += 1;
            }
        }

        update records;

        for(Product_Logger__c productLogger : (List<Product_Logger__c>) records) {
            if(productLogger.Retry__c >= 3) {
                this.productsIdToSend.add(productLogger.Product__c);
            }
        }
    }
}