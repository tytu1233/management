/**
 * Created by patryk.witkowski_bri on 4/24/2025.
 */

public class FixedAmountDiscountHandler implements DiscountHandler {
    public Discount__c createDiscount(DiscountService.DiscountDTO discountDTO) {
        return new Discount__c(
                Name = discountDTO.discountName,
                Discount_Type__c = discountDTO.discountType,
                Discount_Amount__c = Decimal.valueOf(discountDTO.numberDiscount),
                Start_Date__c = discountDTO.startDate != null ? Date.valueOf(discountDTO.startDate) : null,
                End_Date__c = discountDTO.endDate != null ? Date.valueOf(discountDTO.endDate) : null,
                Active__c = true
        );
    }
}