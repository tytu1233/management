/**
 * Created by patryk.witkowski_bri on 4/28/2025.
 */

public class FixedAmountOrderDiscountDecorator extends OrderDiscountDecorator {
    private final Discount__c discount;

    public FixedAmountOrderDiscountDecorator(DiscountCalculator discountCalculator, Discount__c discount) {
        super(discountCalculator);
        this.discount = discount;
    }

    public override Decimal calculateDiscount() {
        Decimal basePrice = discountCalculator.calculateDiscount();
        return basePrice - discount.Discount_Amount__c;
    }
}