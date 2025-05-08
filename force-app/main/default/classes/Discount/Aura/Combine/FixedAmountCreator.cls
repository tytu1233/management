/**
 * Created by patryk.witkowski_bri on 4/28/2025.
 */

public class FixedAmountCreator implements OrderDiscountHandler {
    public DiscountCalculator createDecorator(DiscountCalculator discountCalculator, Discount__c discount) {
        return new FixedAmountOrderDiscountDecorator(discountCalculator, discount);
    }
}