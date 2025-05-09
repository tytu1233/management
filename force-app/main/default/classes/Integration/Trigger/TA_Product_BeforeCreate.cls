/**
 * Created by patryk.witkowski_bri on 5/8/2025.
 */

public with sharing class TA_Product_BeforeCreate implements TriggerAction.BeforeInsert {
    public void beforeInsert(List<Product2> triggerNew) {
        for(Product2 product : triggerNew) {
            if(!product.IsExternal__c && String.isBlank(product.ExternalId__c)) {
                product.ExternalId__c = UUID.randomUUID().toString();
            }
        }
    }
}