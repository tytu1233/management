/**
 * Created by patryk.witkowski_bri on 4/29/2025.
 */

public with sharing class OrderService {
    public static void createOrder(Id opportunityId, List<ProductOrderDTO> products, Decimal discount, List<Id> discountIds) {
            List<Opportunity> opportunity = [
                    SELECT AccountId, Event_Date__c, Event_Address__Street__s, Event_Address__City__s, Event_Address__CountryCode__s, Event_Address__StateCode__s, Event_Address__PostalCode__s
                    FROM Opportunity
                    WHERE Id = :opportunityId
                    LIMIT 1
            ];

            if (opportunity.isEmpty()) {
                throw new AuraHandledException(Utils.OPPORTUNITY.ERRORS.OpportunityNotExist);
            }

            Order order = new Order(
                    AccountId = opportunity.get(0).AccountId,
                    Event_Date__c = opportunity.get(0).Event_Date__c,
                    Event_Address__Street__s = opportunity.get(0).Event_Address__Street__s,
                    Event_Address__City__s = opportunity.get(0).Event_Address__City__s,
                    Event_Address__CountryCode__s = opportunity.get(0).Event_Address__CountryCode__s,
                    Event_Address__PostalCode__s = opportunity.get(0).Event_Address__PostalCode__s,
                    Event_Address__StateCode__s = opportunity.get(0).Event_Address__StateCode__s,
                    Status = 'Draft',
                    OpportunityId = opportunityId,
                    Pricebook2Id = Id.valueOf(Utils.PRICE_BOOK.IDS.MomentumEvents),
                    EffectiveDate = Date.today(),
                    Payment_Status__c = 'Waiting'
            );

            insert order;

            Set<Id> productIds = new Set<Id>();

            List<Order_Discount__c> orderDiscounts = new List<Order_Discount__c>();

            for (Id discountId : discountIds) {
                Order_Discount__c orderDiscount = new Order_Discount__c();
                orderDiscount.Order__c = order.Id;
                orderDiscount.Discount__c = discountId;
                orderDiscounts.add(orderDiscount);
            }

            insert orderDiscounts;

            for (ProductOrderDTO product : products) {
                productIds.add(Id.valueOf(product.productId));
            }
            List<PricebookEntry> pricebookEntries = [
                    SELECT Id, UnitPrice, Product2Id
                    FROM PricebookEntry
                    WHERE Pricebook2Id = :Id.valueOf(Utils.PRICE_BOOK.IDS.MomentumEvents)
                    AND Product2Id IN :productIds
                    AND IsActive = TRUE
            ];

            List<OrderItem> orderItems = new List<OrderItem>();

            for (PricebookEntry pricebookEntry : pricebookEntries) {
                OrderItem orderItem = new OrderItem(
                        UnitPrice = pricebookEntry.UnitPrice,
                        PricebookEntryId = pricebookEntry.Id,
                        Quantity = 1,
                        OrderId = order.Id
                );
                orderItems.add(orderItem);
            }

            insert orderItems;

            List<Order> orderToUpdate = [
                    SELECT Status, Total_Discount__c, TotalAmount
                    FROM Order
                    WHERE Id = :order.Id
            ];

            if (orderToUpdate.isEmpty()) {
                throw new AuraHandledException(Utils.ORDER.ERRORS.FailedUpdate);
            }

            orderToUpdate.get(0).Status = 'Activated';
            orderToUpdate.get(0).Total_Discount__c = discount;
            orderToUpdate.get(0).Final_Price__c = orderToUpdate.get(0).TotalAmount - discount;

            update orderToUpdate.get(0);

            opportunity.get(0).StageName = 'Closed Won';

            update opportunity.get(0);
    }

    public static List<Product2> getProducts(String orderId) {
        List<OrderItem> orderItems = [SELECT Product2Id FROM OrderItem WHERE OrderId = :orderId];

        Set<Id> productIds = new Set<Id>();

        for(OrderItem orderItem : orderItems) {
            productIds.add(orderItem.Product2Id);
        }

        return [SELECT Id, Name, Base_Price__c, IsExternal__c, ExternalId__c FROM Product2 WHERE Id IN :productIds];
    }

    public class ProductOrderDTO {
        @AuraEnabled public String productId { get; set; }
        @AuraEnabled public String category { get; set; }
        @AuraEnabled public String price { get; set; }
    }
}