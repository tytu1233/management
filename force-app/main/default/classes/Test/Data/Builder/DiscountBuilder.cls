/**
 * Created by patryk.witkowski_bri on 5/14/2025.
 */

public class DiscountBuilder {

    private final Discount__c discount;

    public DiscountBuilder(String name) {
        this.discount = new Discount__c();
        this.discount.Name = name;
    }

    public DiscountBuilder name(String name) {
        this.discount.Name = name;
        return this;
    }

    public DiscountBuilder discountType(String type) {
        this.discount.Discount_Type__c = type;
        return this;
    }

    public DiscountBuilder percentage(Decimal percentage) {
        this.discount.Discount_Percentage__c = percentage;
        return this;
    }

    public DiscountBuilder fixedAmount(Decimal fixedAmount) {
        this.discount.Discount_Amount__c = fixedAmount;
        return this;
    }

    public DiscountBuilder active(Boolean active) {
        this.discount.Active__c = active;
        return this;
    }

    public DiscountBuilder startDate(Date startDate) {
        this.discount.Start_Date__c = startDate;
        return this;
    }

    public DiscountBuilder endDate(Date endDate) {
        this.discount.End_Date__c = endDate;
        return this;
    }

    public DiscountBuilder save() {
        insert this.discount;
        return this;
    }

    public Discount__c build() {
        return this.discount;
    }
}