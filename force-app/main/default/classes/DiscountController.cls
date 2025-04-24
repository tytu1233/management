/**
 * Created by patryk.witkowski_bri on 4/23/2025.
 */

public with sharing class DiscountController {
    @AuraEnabled(Cacheable=true)
    public static List<Discount__c> getDiscounts() {
        return [SELECT Id, Name, Discount_Amount__c, Discount_Percentage__c, Discount_Type__c FROM Discount__c];
    }
}