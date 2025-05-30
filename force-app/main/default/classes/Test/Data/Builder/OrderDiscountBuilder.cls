/**
 * Created by patryk.witkowski_bri on 5/30/2025.
 */

public class OrderDiscountBuilder {
    private final Order_Discount__c orderDiscount;

    public OrderDiscountBuilder() {
        this.orderDiscount = new Order_Discount__c();
    }

    public OrderDiscountBuilder order(String orderId) {
        this.orderDiscount.Order__c = orderId;
        return this;
    }

    public OrderDiscountBuilder discount(String discountId) {
        this.orderDiscount.Discount__c = discountId;
        return this;
    }

    public OrderDiscountBuilder save() {
        insert orderDiscount;
        return this;
    }

    public Order_Discount__c build() {
        return this.orderDiscount;
    }


}