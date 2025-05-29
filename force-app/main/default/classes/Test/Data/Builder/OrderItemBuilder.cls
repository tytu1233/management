/**
 * Created by patryk.witkowski_bri on 5/28/2025.
 */

public class OrderItemBuilder {
    private final OrderItem orderItem;

    public OrderItemBuilder() {
        this.orderItem = new OrderItem();
    }

    public OrderItemBuilder product(String productId) {
        this.orderItem.Product2Id = productId;
        return this;
    }

    public OrderItemBuilder unitPrice(Decimal unitPrice) {
        this.orderItem.UnitPrice = unitPrice;
        return this;
    }

    public OrderItemBuilder listPrice(Decimal listPrice) {
        this.orderItem.ListPrice = listPrice;
        return this;
    }

    public OrderItemBuilder quantity(Integer quantity) {
        this.orderItem.Quantity = quantity;
        return this;
    }

    public OrderItemBuilder order(String orderId) {
        this.orderItem.OrderId = orderId;
        return this;
    }

    public OrderItemBuilder pricebookEntry(String pricebookEntryId) {
        this.orderItem.PricebookEntryId = pricebookEntryId;
        return this;
    }

    public OrderItemBuilder save() {
        insert this.orderItem;
        return this;
    }

    public OrderItem build() {
        return this.orderItem;
    }
}