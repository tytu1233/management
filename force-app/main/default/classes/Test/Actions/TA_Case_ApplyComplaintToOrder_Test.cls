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
    static void noClosedCase_Success() {
        List<Case> cases = [
                SELECT Id, Status, Order__c
                FROM Case
                WHERE Status = 'New'
        ];

        Test.startTest();
        new TA_Case_ApplyComplaintToOrder().afterUpdate(cases, cases);
        Test.stopTest();
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
    }

    class DataGenerator extends Factory {
        public override Order createOrder() {
            Account account = createAccount();
            Pricebook2 pricebook2 = createPricebook();
            Order order = prepareOrder()
                    .account(account.Id)
                    .pricebook(pricebook2.Id)
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
            PricebookEntry pricebookEntry = [SELECT Id, UnitPrice, Product2Id
            FROM PricebookEntry WHERE Product2Id = :productId AND Pricebook2.IsStandard = FALSE LIMIT 1];
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

        public override void createData() {
            Order order = createOrder();
            createCase();
            Product2 product = createProduct();
            createComplaint();
            Case closedCase = createClosedCase(order.Id);
            OrderItem orderItem = createOrderItem(product.Id, order.Id);
            createCaseProduct(closedCase.Id, product.Id, orderItem.Id);
        }
    }
}