/**
 * Created by patryk.witkowski_bri on 4/28/2025.
 */

public interface OrderDiscountHandler {
    DiscountCalculator createDecorator(DiscountCalculator discountCalculator, Discount__c discount);
}