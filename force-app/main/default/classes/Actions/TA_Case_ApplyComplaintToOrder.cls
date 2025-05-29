/**
 * Created by patryk.witkowski_bri on 5/27/2025.
 */

public with sharing class TA_Case_ApplyComplaintToOrder implements TriggerAction.AfterUpdate {
    public void afterUpdate(List<SObject> triggerNew, List<SObject> triggerOld) {
        //key is an ID OF case, value is a order id
        Map<Id, Id> orderMapCase = new Map<Id, Id>();
        for(Case caseItem : (List <Case>) triggerNew) {
            if(caseItem.Status.equalsIgnoreCase(Utils.CASES.STATUS.Closed) && caseItem.Order__c != null) {
                orderMapCase.put(caseItem.Id, caseItem.Order__c);
            }
        }

        if(orderMapCase.isEmpty()) {
            return;
        }

        List<Case_Product__c> caseProducts = [
                SELECT Id, Name, Case__c, Product__c, Return_percentage__c, Order_Product__c, Order_Product__r.OrderId, Order_Product__r.UnitPrice
                FROM Case_Product__c
                WHERE Case__c IN :orderMapCase.keySet() AND Status__c = :Utils.CASE_PRODUCT.STATUS.Approved
        ];

        if(caseProducts.isEmpty()) {
            throw new HandledException('No case products records');
        }

        Map<Id, Decimal> orderPriceAdjustments = new Map<Id, Decimal>();


        for(Case_Product__c cp : caseProducts) {
            Decimal adjustment = (cp.Order_Product__r.UnitPrice * (cp.Return_percentage__c / 100.0));
            Decimal currentAdjustment = orderPriceAdjustments.get(cp.Order_Product__r.OrderId) ?? 0;
            orderPriceAdjustments.put(cp.Order_Product__r.OrderId, currentAdjustment + adjustment);
        }
        //id of order and its list of discounts
        Map<Id, List<Decimal>> orderDiscountsMap = new Map<Id, List<Decimal>>();

        for(Order_Discount__c orderDiscount : [
                SELECT Order__c, Discount__r.Discount_Percentage__c, Discount__r.Discount_Amount__c
                FROM Order_Discount__c
                WHERE Order__c IN :orderPriceAdjustments.keySet()
        ]) {
            if(orderDiscountsMap.get(orderDiscount.Order__c) == null) {
                orderDiscountsMap.put(orderDiscount.Order__c, new List<Decimal>());
            }

            if(orderDiscount.Discount__r.Discount_Percentage__c != null) {
                orderDiscountsMap.get(orderDiscount.Order__c).add(orderDiscount.Discount__r.Discount_Percentage__c / 100);
            }

            if(orderDiscount.Discount__r.Discount_Amount__c != null) {
                orderDiscountsMap.get(orderDiscount.Order__c).add(orderDiscount.Discount__r.Discount_Amount__c);
            }
        }

        for (Id orderId : orderDiscountsMap.keySet()) {
            List<Decimal> discounts = orderDiscountsMap.get(orderId);
            Decimal currentAdjustment = orderPriceAdjustments.get(orderId) != null ? orderPriceAdjustments.get(orderId) : 0;
            for (Decimal discount : discounts) {
                if (discount < 1.0) {
                    currentAdjustment *= (1 - discount);
                } else {
                    currentAdjustment -= (discount / discounts.size());
                }
            }

            orderPriceAdjustments.put(orderId, currentAdjustment);
        }


        List<PricebookEntry> pricebookEntries = [
                SELECT Id, Pricebook2Id, Product2Id
                FROM PricebookEntry
                WHERE Product2Id = :Utils.PRODUCT.IDS.ComplaintProduct
                AND Pricebook2Id = :Utils.PRICE_BOOK.IDS.MomentumEvents
                LIMIT 1
        ];

        Map<Id, Order> orderMap = new Map<Id, Order>([
                SELECT Id, Final_Price__c, Pricebook2Id, Status
                FROM Order
                WHERE Id IN :orderPriceAdjustments.keySet()
        ]);

        for(Order order : orderMap.values()) {
            if(order.Status != Utils.ORDER.STATUS.Draft) {
                order.Status = Utils.ORDER.STATUS.Draft;
            }
        }

        if(!orderMap.values().isEmpty()) {
            update orderMap.values();
        }


        List<Order> ordersToUpdate = new List<Order>();
        List<OrderItem> orderItemsToInsert = new List<OrderItem>();

        for (Id orderId : orderPriceAdjustments.keySet()) {
            Decimal adjustment = orderPriceAdjustments.get(orderId) * -1;
            Order order = orderMap.get(orderId);

            OrderItem orderItem = new OrderItem(
                    OrderId = orderId,
                    PricebookEntryId = pricebookEntries.get(0).Id,
                    Quantity = 1,
                    UnitPrice = adjustment
            );
            orderItemsToInsert.add(orderItem);

            ordersToUpdate.add(new Order(
                    Id = orderId,
                    Status = Utils.ORDER.STATUS.Activated,
                    Final_Price__c = order.Final_Price__c + adjustment
            ));
        }

        try {
            if (!orderItemsToInsert.isEmpty()) {
                insert orderItemsToInsert;
            }
            if (!ordersToUpdate.isEmpty()) {
                update ordersToUpdate;
            }
        } catch (Exception e) {
            System.debug('Error updating Order or OrderItems: ' + e.getMessage());
            throw new HandledException(e.getMessage());
        }
    }
}