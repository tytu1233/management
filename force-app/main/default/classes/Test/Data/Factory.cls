/**
 * Created by patryk.witkowski_bri on 5/14/2025.
 */

public abstract class Factory {

    public abstract void createData();

    protected DiscountBuilder prepareDiscount() {
        return new DiscountBuilder('Test ' + UUID.randomUUID())
                .name('Test Discount')
                .discountType('Percentage')
                .percentage(20)
                .active(true)
                .startDate(Date.today().addDays(-10))
                .endDate(Date.today().addDays(10));
    }

    protected ProductLoggerBuilder prepareProductLogger() {
        return new ProductLoggerBuilder();
    }

    protected OrderItemBuilder prepareOrderItem() {
        return new OrderItemBuilder()
                .quantity(1)
                .unitPrice(200.0)
                .listPrice(200.0);
    }

    protected AccountBuilder prepareAccount() {
        return new AccountBuilder();
    }

    protected CaseProductBuilder prepareCaseProduct() {
        return new CaseProductBuilder()
                .name('Test ' + UUID.randomUUID())
                .strategy('Partially refund')
                .status('Approved')
                .returnPercentage(5);
    }

    protected OrderDiscountBuilder prepareOrderDiscount() {
        return new OrderDiscountBuilder();
    }

    protected PricebookBuilder preparePricebook() {
        return new PricebookBuilder(
                'Event Management Price Book'
        )
        .active(true);
    }

    protected OrderBuilder prepareOrder() {
        return new OrderBuilder(
                'Kowalska',
                'Kielce',
                '25-124')
                .finalPrice(5000.0)
                .startDate(Date.today())
                .eventDate(Datetime.now().addDays(10))
                .payment('Waiting');
    }

    protected OpportunityBuilder prepareOpportunity() {
        return new OpportunityBuilder(
                'Opportunity ' + UUID.randomUUID(),
                Datetime.now().addDays(10),
                Date.today().addDays(10),
                'Kowalska',
                'Kielce',
                '25-124'
        )
        .stage('Prospecting');
    }

    protected CaseBuilder prepareCase() {
        return new CaseBuilder()
                .priority('Medium')
                .subject('Test subject ' + UUID.randomUUID())
                .description('Test description ' + UUID.randomUUID());
    }

    protected CaseProductApprovalBuilder prepareCaseProductApproval() {
        return new CaseProductApprovalBuilder();
    }

    protected ProductBuilder prepareProduct() {
        return new ProductBuilder(
            'Test ' + UUID.randomUUID(),
            200.0
            )
            .active(true)
            .external(false)
            .family('Family ' + UUID.randomUUID())
            .productCode('CODE ' + UUID.randomUUID());
    }

    public virtual Product2 createProduct() {
        Product2 product = prepareProduct()
                .save()
                .build();
        return product;
    }

    public virtual Case createCase() {
        Case caseToInsert = prepareCase()
                .save()
                .build();
        return caseToInsert;
    }

    public virtual OrderItem createOrderItem() {
        OrderItem orderItem = prepareOrderItem()
                .save()
                .build();
        return orderItem;
    }

    public virtual Order_Discount__c createOrderDiscount(String orderId, String discountId) {
        Order_Discount__c orderDiscount = prepareOrderDiscount()
                .discount(discountId)
                .order(orderId)
                .save()
                .build();

        return orderDiscount;
    }

    public virtual Case_Product_Approval__e createCaseProductApproval() {
        Case_Product_Approval__e caseProductApproval = prepareCaseProductApproval()
                .build();
        return caseProductApproval;
    }

    public virtual Account createAccount() {
        Account account = prepareAccount()
                .save()
                .build();
        return account;
    }

    public virtual Order createOrder() {
        Order order = prepareOrder()
                .save()
                .build();
        return order;
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