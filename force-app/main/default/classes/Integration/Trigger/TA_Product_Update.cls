/**
 * Created by patryk.witkowski_bri on 5/8/2025.
 */

public class TA_Product_Update implements TriggerAction.AfterUpdate {
    public void afterUpdate(List<Product2> triggerNew, List<Product2> triggerOld) {
        Set<Id> productIds = new Set<Id>();

        for(Product2 product : triggerOld) {
            if(!product.IsExternal__c) {
                productIds.add(product.Id);
            }
        }

        try {
            if(!productIds.isEmpty()) {
                IntegrationCallout.updateProducts(productIds);
            }
        } catch (Exception ex) {
            throw new AuraHandledException('Cant update the record');
        }


        List<PricebookEntry> pricebookEntries = [
                SELECT UnitPrice, Product2.Base_Price__c
                FROM PricebookEntry
                WHERE Product2Id IN : triggerOld
        ];

        for(PricebookEntry pricebookEntry : pricebookEntries) {
            pricebookEntry.UnitPrice = pricebookEntry.Product2.Base_Price__c;
        }

        update pricebookEntries;
    }
}