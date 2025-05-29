/**
 * Created by patryk.witkowski_bri on 4/28/2025.
 */

public class MaximumDiscountStrategy implements DiscountStrategy {
    public DiscountService.DiscountOrderDTO applyDiscount(Decimal initialPrice, List<Discount__c> discounts, Date eventDate) {
        Decimal maximumPrice = 0.0;
        Decimal currentPrice = 0.0;
        Id discountID = null;
        DiscountService.DiscountOrderDTO discountOrderDTO = new DiscountService.DiscountOrderDTO();
        for(Discount__c discount : discounts) {
            if((discount.Start_Date__c != null || discount.End_Date__c != null) && (eventDate >= discount.Start_Date__c && eventDate <= discount.End_Date__c)) {
                currentPrice = DiscountService.calculateDiscountBasedOnType(initialPrice, discount);
            }

            if(discount.Start_Date__c == null || discount.End_Date__c == null) {
                currentPrice = DiscountService.calculateDiscountBasedOnType(initialPrice, discount);
            }
            if(currentPrice > maximumPrice) {
                maximumPrice = currentPrice;
                discountID = discount.Id;
            }
        }
        discountOrderDTO.priceAfterDiscount = maximumPrice.setScale(2, RoundingMode.HALF_UP);
        discountOrderDTO.discountIds = new Set<Id> {discountID};
        return discountOrderDTO;
    }
}