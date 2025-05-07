/**
 * Created by patryk.witkowski_bri on 4/23/2025.
 */

public with sharing class DiscountController {
    @AuraEnabled
    public static List<Discount__c> getDiscounts() {
        try {
            return DiscountService.getDiscounts();
        } catch (Exception ex) {
            throw new AuraHandledException(Utils.DISCOUNT.ERRORS.DiscountFetch);
        }
    }

    @AuraEnabled
    public static void createDiscount(DiscountService.DiscountDTO discountData) {
        try {
            Discount__c discount = DiscountService.createDiscount(discountData);

            insert discount;
        } catch (Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }
}