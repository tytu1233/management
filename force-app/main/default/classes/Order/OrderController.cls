/**
 * Created by patryk.witkowski_bri on 4/24/2025.
 */

public with sharing class OrderController {
    @AuraEnabled
    public static void createOrderWithProducts(Id opportunityId, List<OrderService.ProductOrderDTO> products, Decimal discount, List<Id> discountIds) {
        try {
            OrderService.createOrder(opportunityId, products, discount, discountIds);
        } catch (DmlException ex) {
            throw new AuraHandledException('Order creation failed: ' + ex.getDmlMessage(0));
        } catch(Exception ex) {
            throw new AuraHandledException('Order creation failed: ' + ex.getMessage());
        }
    }

    @AuraEnabled
    public static DiscountService.DiscountOrderDTO calculateOrderDiscount(Decimal initialPrice, Id opportunityId) {
        try {
            return DiscountService.calculateDiscount(initialPrice, opportunityId);
        } catch (Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }

    @AuraEnabled(Cacheable=true)
    public static List<Product2> getOrderProducts(String orderId) {
        return OrderService.getProducts(orderId);
    }
}