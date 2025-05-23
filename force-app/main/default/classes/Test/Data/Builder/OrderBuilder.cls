/**
 * Created by patryk.witkowski_bri on 5/23/2025.
 */

public class OrderBuilder {

    private final Order order;

    public OrderBuilder(Account account) {
        this.order = new Order();
        this.order.Account = account;
        this.order.EffectiveDate = Date.today();
        this.order.Status = 'Draft';
    }

    public OrderBuilder startDate(Date startDate) {
        this.order.EffectiveDate = startDate;
        return this;
    }

    public OrderBuilder account(Account account) {
        this.order.Account = account;
        return this;
    }

    public OrderBuilder status(String status) {
        this.order.Status = status;
        return this;
    }

    public OrderBuilder eventDate(Datetime eventDate) {
        this.order.Event_Date__c = eventDate;
        return this;
    }

    public OrderBuilder save() {
        insert order;
        return this;
    }

    public Order build() {
        return this.order;
    }
}