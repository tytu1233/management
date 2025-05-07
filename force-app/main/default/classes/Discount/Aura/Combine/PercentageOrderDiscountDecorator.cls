/**
 * Created by patryk.witkowski_bri on 4/28/2025.
 */

public class PercentageOrderDiscountDecorator extends OrderDiscountDecorator {
    private final Discount__c discount;

    public PercentageOrderDiscountDecorator(DiscountCalculator discountCalculator, Discount__c discount) {
        super(discountCalculator);
        this.discount = discount;
    }

    public override Decimal calculateDiscount() {
        Decimal basePrice = discountCalculator.calculateDiscount();
        return basePrice - (basePrice * discount.Discount_Percentage__c / 100);
    }
}