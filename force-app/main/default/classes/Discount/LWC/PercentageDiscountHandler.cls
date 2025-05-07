/**
 * Created by patryk.witkowski_bri on 4/24/2025.
 */

public class PercentageDiscountHandler implements DiscountHandler {
    public Discount__c createDiscount(DiscountService.DiscountDTO discountDTO) {

        if(discountDTO.numberDiscount > 100 || discountDTO.numberDiscount <= 0) {
            throw new DiscountService.DiscountServiceException(Utils.DISCOUNT.ERRORS.DiscountPercentageBetweenZeroAndHundred);
        }

        return new Discount__c(
                Name = discountDTO.discountName,
                Discount_Type__c = discountDTO.discountType,
                Discount_Percentage__c = Decimal.valueOf(discountDTO.numberDiscount),
                Start_Date__c = discountDTO.startDate != null ? Date.valueOf(discountDTO.startDate) : null,
                End_Date__c = discountDTO.endDate != null ? Date.valueOf(discountDTO.endDate) : null,
                Active__c = true
        );
    }
}