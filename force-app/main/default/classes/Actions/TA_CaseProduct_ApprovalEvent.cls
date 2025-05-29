/**
 * Created by patryk.witkowski_bri on 5/23/2025.
 */

public with sharing class TA_CaseProduct_ApprovalEvent implements TriggerAction.AfterInsert {
    public void afterInsert(List<Case_Product_Approval__e> triggerNew) {
        List<Wrapper> events = new List<Wrapper>();

        for(Case_Product_Approval__e caseProductApproval : triggerNew) {
            List<Wrapper> caseProductApprovalJSON = (List<Wrapper>) JSON.deserialize(caseProductApproval.Approval_Status__c.toString(), List<Wrapper>.class);
            events.add(caseProductApprovalJSON.get(0));
        }

        Set<Id> caseIds = new Set<Id>();
        Set<Id> productIds = new Set<Id>();
        for (Wrapper wrapper : events) {
                if (String.isNotBlank(wrapper.caseId)) {
                    caseIds.add((Id) wrapper.caseId);
                }
                if (String.isNotBlank(wrapper.productId)) {
                    productIds.add((Id) wrapper.productId);
                }
        }

        Map<String, Id> externalIdToProductId = new Map<String, Id>();
        if (!productIds.isEmpty()) {
            List<Product2> products = [
                        SELECT Id, ExternalId__c
                        FROM Product2
                        WHERE ExternalId__c IN :productIds
                ];

                for (Product2 product : products) {
                    externalIdToProductId.put(product.ExternalId__c, product.Id);
                }
        }

        Map<Id, Case_Product__c> caseProductMap = new Map<Id, Case_Product__c>();
        if (!caseIds.isEmpty()) {
                caseProductMap = new Map<Id, Case_Product__c>([
                        SELECT Id, Name, Product__c, Case__c, Status__c, Strategy__c
                        FROM Case_Product__c
                        WHERE Case__c IN :caseIds AND Product__c IN :externalIdToProductId.values()
                ]);
        }

        for (Wrapper wrapper : events) {
                Id caseId = (Id) wrapper.caseId;
                Id productId = externalIdToProductId.get(wrapper.productId);

                for (Case_Product__c caseProduct : caseProductMap.values()) {
                    if (caseProduct.Case__c == caseId && caseProduct.Product__c == productId) {
                        caseProductMap.get(caseProduct.Id).Strategy__c = wrapper.data?.strategy;
                        caseProductMap.get(caseProduct.Id).Status__c = wrapper.data?.status;
                        caseProductMap.get(caseProduct.Id).Description__c = wrapper.data?.description;
                        caseProductMap.get(caseProduct.Id).Return_percentage__c = wrapper.data?.percentage;
                        break;
                    }
                }
        }

        if (!caseProductMap.isEmpty()) {
                update caseProductMap.values();
        }
    }

    class Wrapper {
        public String productId;
        public String caseId;
        public Data data;
    }

    class Data {
        public String strategy;
        public String status;
        public Decimal percentage;
        public String description;
    }
}