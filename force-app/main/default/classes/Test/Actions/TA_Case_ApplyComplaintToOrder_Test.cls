/**
 * Created by patryk.witkowski_bri on 5/28/2025.
 */

@IsTest
public class TA_Case_ApplyComplaintToOrder_Test {

    @TestSetup
    static void setup() {
        new DataGenerator().createData();
    }

    @IsTest
    static void noClosedCase_Error() {
        List<Case> cases = [
                SELECT Id, Status, Order__c
                FROM Case
                WHERE Status = 'New'
        ];

        Test.startTest();
        new TA_Case_ApplyComplaintToOrder().afterUpdate(cases, cases);
        Test.stopTest();

        List<Case_Product__c> caseProducts = [SELECT Id FROM Case_Product__c WHERE Case__c = :cases.get(0).Id];

        Assert.areEqual(0, caseProducts.size(), 'Case Products shouldn\'t be assosiated with any case');

    }

    @IsTest
    static void closedCase_Success() {
        List<Case> cases = [
                SELECT Id, Status, Order__c
                FROM Case
                WHERE Status = 'Closed'
        ];

        Test.startTest();
        new TA_Case_ApplyComplaintToOrder().afterUpdate(cases, cases);
        Test.stopTest();

        List<Order> orders = [SELECT Id, Final_Price__c FROM Order];
        List<OrderItem> orderItems = [SELECT UnitPrice FROM OrderItem WHERE OrderId = :orders.get(0).Id];

        Assert.areEqual(2, orderItems.size(), 'Order Item should contains complaint product');
        Assert.areEqual(4995.00, Math.floor(orders.get(0).Final_Price__c), 'Final price should be approximetly reduced by 5');
    }


    @IsTest
    static void closedCaseNoCaseProducts_Error() {
        List<Case_Product__c> caseProducts = [SELECT Case__c FROM Case_Product__c];
        List<Case> cases = [
                SELECT Id, Status, Order__c
                FROM Case
                WHERE Status = 'Closed' AND Id != :caseProducts.get(0).Case__c
        ];

        Boolean thrownException = false;

        Test.startTest();
        try {
            new TA_Case_ApplyComplaintToOrder().afterUpdate(cases, cases);
        } catch (Exception ex) {
            thrownException = true;
            Assert.areEqual('No case products records', ex.getMessage(), 'Exception message should match');
        }
        Test.stopTest();

        Assert.isTrue(thrownException, 'Exception should be thrown');
    }

    class DataGenerator extends Factory {
        public override Order createOrder() {
            Account account = createAccount();
            Pricebook2 pricebook2 = createPricebook();
            Order order = prepareOrder()
                    .account(account.Id)
                    .pricebook(pricebook2.Id)
                    .city(UUID.randomUUID().toString())
                    .save()
                    .build();
            return order;
        }

        public Case createClosedCase(String orderId) {
            Case cases = prepareCase()
                    .status('Closed')
                    .origin('Web')
                    .order(orderId)
                    .save()
                    .build();

            return cases;
        }

        public Case_Product__c createCaseProduct(String caseId, String productId, String orderItemId) {
            Case_Product__c caseProduct = prepareCaseProduct()
                    .case(caseId)
                    .product(productId)
                    .orderItem(orderItemId)
                    .status('Approved')
                    .save()
                    .build();
            return caseProduct;
        }

        public OrderItem createOrderItem(String productId, String orderId) {
            PricebookEntry pricebookEntry = [
                    SELECT Id, UnitPrice, Product2Id
                    FROM PricebookEntry
                    WHERE Product2Id = :productId AND Pricebook2.IsStandard = FALSE
                    LIMIT 1];
            OrderItem orderItem = prepareOrderItem()
                    .product(productId)
                    .pricebookEntry(pricebookEntry.Id)
                    .order(orderId)
                    .save()
                    .build();

            return orderItem;
        }

        public Product2 createComplaint() {
            Product2 product2 = prepareProduct()
                    .name('Complaint')
                    .active(false)
                    .save()
                    .build();
            return product2;
        }

        public Discount__c createFixedAmountDiscount() {
            Discount__c discount = prepareDiscount()
                    .fixedAmount(5)
                    .discountType(Utils.DISCOUNT.TYPES.FixedAmount)
                    .save()
                    .build();
            return discount;
        }

        public override void createData() {
            Order order = createOrder();
            Order order2 = createOrder();
            Discount__c discount = createDiscount();
            Discount__c discount2 = createFixedAmountDiscount();
            createOrderDiscount(order.Id, discount.Id);
            createOrderDiscount(order.Id, discount2.Id);
            createCase();
            Product2 product = createProduct();
            createComplaint();
            Case closedCase = createClosedCase(order.Id);
            createClosedCase(order2.Id);
            OrderItem orderItem = createOrderItem(product.Id, order.Id);
            createCaseProduct(closedCase.Id, product.Id, orderItem.Id);
        }
    }
}