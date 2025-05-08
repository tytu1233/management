/**
 * Created by patryk.witkowski_bri on 4/28/2025.
 */

public virtual class OrderDiscountDecorator implements DiscountCalculator {
    protected DiscountCalculator discountCalculator;

    public OrderDiscountDecorator(DiscountCalculator discountCalculator) {
        this.discountCalculator = discountCalculator;
    }

    public virtual Decimal calculateDiscount() {
        return discountCalculator.calculateDiscount();
    }
}