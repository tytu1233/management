/**
 * Created by patryk.witkowski_bri on 4/28/2025.
 */

public class OrderDiscountCalculator implements DiscountCalculator {

    private final Decimal initialPrice;

    public OrderDiscountCalculator(Decimal initialPrice) {
        this.initialPrice = initialPrice;
    }

    public Decimal calculateDiscount() {
        return initialPrice;
    }
}