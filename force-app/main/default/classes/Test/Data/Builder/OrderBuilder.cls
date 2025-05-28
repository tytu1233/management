/**
 * Created by patryk.witkowski_bri on 5/23/2025.
 */

public class OrderBuilder {

    private final Order order;

    public OrderBuilder(String street, String city, String postalCode) {
        this.order = new Order();
        this.order.EffectiveDate = Date.today();
        this.order.Status = 'Draft';
        this.order.Event_Address__Street__s = street;
        this.order.Event_Address__City__s = city;
        this.order.Event_Address__PostalCode__s = postalCode;
    }

    public OrderBuilder startDate(Date startDate) {
        this.order.EffectiveDate = startDate;
        return this;
    }

    public OrderBuilder pricebook(String pricebookId) {
        this.order.Pricebook2Id = pricebookId;
        return this;
    }

    public OrderBuilder account(String accountID) {
        this.order.AccountId = accountID;
        return this;
    }

    public OrderBuilder street(String street) {
        this.order.Event_Address__Street__s = street;
        return this;
    }

    public OrderBuilder country(String country) {
        this.order.Event_Address__CountryCode__s = country;
        return this;
    }

    public OrderBuilder city(String city) {
        this.order.Event_Address__City__s = city;
        return this;
    }

    public OrderBuilder postalCode(String postalCode) {
        this.order.Event_Address__PostalCode__s = postalCode;
        return this;
    }

    public OrderBuilder status(String status) {
        this.order.Status = status;
        return this;
    }

    public OrderBuilder payment(String payment) {
        this.order.Payment_Status__c = payment;
        return this;
    }

    public OrderBuilder eventDate(Datetime eventDate) {
        this.order.Event_Date__c = eventDate;
        return this;
    }

    public OrderBuilder finalPrice(Decimal finalPrice) {
        this.order.Final_Price__c = finalPrice;
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