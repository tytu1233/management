/**
 * Created by patryk.witkowski_bri on 4/28/2025.
 */

public interface DiscountStrategy {
    DiscountService.DiscountOrderDTO applyDiscount(Decimal initialPrice, List<Discount__c> discounts, Date eventDate);
}