/**
 * Created by patryk.witkowski_bri on 5/19/2025.
 */

public with sharing class CaseService {
    public static CaseResponseDTO createCaseAndPublishEvent(CaseEventDTO caseData) {
        CaseResponseDTO caseResponseDTO = new CaseResponseDTO();

        Case caseToInsert = new Case(
                Subject = caseData.subject,
                Description = caseData.description,
                Status = 'New',
                Origin = 'Web',
                Priority = caseData.priority
        );

        insert caseToInsert;

        caseResponseDTO.caseId = caseToInsert.Id;
        caseResponseDTO.containsExternal = false;
        List<Case_Product__c> caseProducts = new List<Case_Product__c>();

        String productIds = '';

        for(Product2 product : caseData.selectedItems) {
            Case_Product__c caseProduct = new Case_Product__c(
                    Case__c = caseToInsert.Id,
                    Product__c = product.Id
            );
            if(product.IsExternal__c) {
                productIds += product.ExternalId__c + ',';
            }
            caseProducts.add(caseProduct);
        }

        insert caseProducts;

        if(!String.isBlank(productIds)) {
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