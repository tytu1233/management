/**
 * Created by patryk.witkowski_bri on 4/28/2025.
 */

public class PercentageCreator implements OrderDiscountHandler {
    public DiscountCalculator createDecorator(DiscountCalculator discountCalculator, Discount__c discount) {
        return new PercentageOrderDiscountDecorator(discountCalculator, discount);
    }
}