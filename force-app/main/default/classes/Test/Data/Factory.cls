/**
 * Created by patryk.witkowski_bri on 5/14/2025.
 */

//TODO: POMYSLEC NAD QUEROWANIEM REKORDKOW, ZE GET DISCOUNTS ITD (TEZ MAJA BYC VIRTUALNE)
public abstract class Factory {

    public abstract void createData();

    protected DiscountBuilder prepareDiscount() {
        return new DiscountBuilder(
                'Test ' + UUID.randomUUID()
        );
    }

    protected PricebookBuilder preparePricebook() {
        return new PricebookBuilder(
                'Pricebook ' + UUID.randomUUID()
        );
    }

    protected OpportunityBuilder prepareOpportunity() {
        return new OpportunityBuilder(
                'Opportunity ' + UUID.randomUUID(),
                Datetime.now().addDays(10),
                Date.today().addDays(10),
                'Kowalska',
                'Kielce',
                '25-124'
        );
    }

    public ProductBuilder prepareProduct() {
        return new ProductBuilder(
            'Test ' + UUID.randomUUID(),
            25.0
        );
    }

    public virtual Product2 createProduct() {
        Product2 product = prepareProduct()
                .build();
        return product;
    }

    public virtual Discount__c createDiscount() {
        Discount__c discount = prepareDiscount()
                .save()
                .build();
        return discount;
    }

    public virtual Pricebook2 createPricebook() {
        Pricebook2 pricebook = preparePricebook()
                .build();
        return pricebook;
    }

    public virtual Opportunity createOpportunity() {
        Opportunity opportunity = prepareOpportunity()
                .build();
        return opportunity;
    }
}