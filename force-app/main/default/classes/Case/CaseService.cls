/**
 * Created by patryk.witkowski_bri on 5/19/2025.
 */

public with sharing class CaseService {
    public static CaseResponseDTO createCaseAndPublishEvent(CaseEventDTO caseData) {
        CaseResponseDTO caseResponseDTO = new CaseResponseDTO();

        List<Order> orders = [
                SELECT Id
                FROM Order
                WHERE Id = :caseData.orderId
        ];

        Case caseToInsert = new Case(
                Subject = caseData.subject,
                Description = caseData.description,
                Status = 'New',
                Origin = 'Web',
                Order__c = caseData.orderId,
                Priority = caseData.priority
        );

        insert caseToInsert;

        if (orders.isEmpty()) {
            throw new HandledException(Utils.CASES.ERRORS.Case_RecordNotExist);
        }

        orders.get(0).Case__c = caseToInsert.Id;
        update orders;

        caseResponseDTO.caseId = caseToInsert.Id;
        caseResponseDTO.containsExternal = false;
        List<Case_Product__c> caseProducts = new List<Case_Product__c>();

        List<OrderItem> orderItems = [
                SELECT Product2Id, Id, OrderId, Product2.Name, Product2.ExternalId__c, Product2.IsExternal__c
                FROM OrderItem
                WHERE OrderId = :caseData.orderId
                AND Product2Id IN :caseData.selectedItems
        ];

        String productIds = '';

        for (OrderItem orderItem : orderItems) {
            Case_Product__c caseProduct = new Case_Product__c(
                    Case__c = caseToInsert.Id,
                    Product__c = orderItem.Product2Id,
                    Order_Product__c = orderItem.Id,
                    Status__c = Utils.CASES.STATUS.Pending
            );
            if (orderItem.Product2.IsExternal__c) {
                productIds += orderItem.Product2.ExternalId__c + ',';
                caseProduct.ToExternal__c = true;
            }
            caseProducts.add(caseProduct);
        }

        insert caseProducts;

        CaseProductApprovalService.createCaseProductsRequest(caseProducts);

        if (!String.isBlank(productIds)) {
            Case_Notification__e caseNotification = new Case_Notification__e();
            caseNotification.Subject__c = caseData.subject;
            caseNotification.Description__c = caseData.description;
            caseNotification.ExternalId__c = caseToInsert.Id;
            caseNotification.ProductIds__c = productIds.removeEnd(',');
            caseNotification.Priority__c = caseData.priority;

            System.enqueueJob(new CaseExternalQueueable(caseNotification));
            caseResponseDTO.containsExternal = true;
        }
        return caseResponseDTO;
    }

    public class CaseEventDTO {
        @AuraEnabled public String orderId { set; get; }
        @AuraEnabled public String subject { set; get; }
        @AuraEnabled public String priority { set; get; }
        @AuraEnabled public String description { set; get; }
        @AuraEnabled public List<Product2> selectedItems { set; get; }
    }

    public class CaseResponseDTO {
        @AuraEnabled public String caseId { set; get; }
        @AuraEnabled public Boolean containsExternal { set; get; }
    }
}