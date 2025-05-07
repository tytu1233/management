/**
 * Created by patryk.witkowski_bri on 4/28/2025.
 */

public class CombineDiscountStrategy implements DiscountStrategy {
    public DiscountService.DiscountOrderDTO applyDiscount(Decimal initialPrice, List<Discount__c> discounts, Date eventDate) {
        DiscountService.DiscountOrderDTO discountOrderDTO = new DiscountService.DiscountOrderDTO();
        DiscountCalculator calculator = new OrderDiscountCalculator(initialPrice);
        Set<Id> discountIds = new Set<Id>();
        for(Discount__c discount : discounts) {
            if((discount.Start_Date__c != null || discount.End_Date__c != null) && (eventDate >= discount.Start_Date__c && eventDate <= discount.End_Date__c)) {
                calculator = OrderDiscountFactory.getDecorator(discount.Discount_Type__c, calculator, discount);
                discountIds.add(discount.Id);
            }

            if(discount.Start_Date__c == null || discount.End_Date__c == null) {
                calculator = OrderDiscountFactory.getDecorator(discount.Discount_Type__c, calculator, discount);
                discountIds.add(discount.Id);
            }

            if(calculator.calculateDiscount() < initialPrice * 0.5) {
                break;
            }
            //calculator = OrderDiscountFactory.getDecorator(discount.Discount_Type__c, calculator, discount);
        }
        discountOrderDTO.priceAfterDiscount = calculator.calculateDiscount().setScale(2, RoundingMode.HALF_UP);
        discountOrderDTO.discountIds = discountIds;
        return discountOrderDTO;
    }
}