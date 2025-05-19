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

    protected ProductLoggerBuilder prepareProductLogger() {
        return new ProductLoggerBuilder();
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

    protected ProductBuilder prepareProduct() {
        return new ProductBuilder(
            'Test ' + UUID.randomUUID(),
            25.0
        );
    }

    public virtual Product2 createProduct() {
        Product2 product = prepareProduct()
                .save()
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
                .save()
                .build();
        return pricebook;
    }

    public virtual Opportunity createOpportunity() {
        Opportunity opportunity = prepareOpportunity()
                .save()
                .build();
        return opportunity;
    }

    public virtual Product_Logger__c createProductLogger() {
        Product_Logger__c productLogger = prepareProductLogger()
                .save()
                .build();
        return productLogger;
    }

    public virtual List<Product2> getProducts() {
        return [
                SELECT Id, Name, Base_Price__c, IsActive, ExternalId__c, IsExternal__c
                FROM Product2
        ];
    }

    public virtual List<Discount__c> getDiscounts() {
        return [
                SELECT Id, Name, Start_Date__c, End_Date__c, Active__c, Discount_Type__c, Discount_Amount__c, Discount_Percentage__c
                FROM Discount__c
        ];
    }
}