/**
 * Created by patryk.witkowski_bri on 5/22/2025.
 */

public with sharing class CaseProductApprovalService {

    public static void createCaseProductsRequest(List<Case_Product__c> caseProducts) {
        List<Approval.ProcessSubmitRequest> processSubmitRequests = new List<Approval.ProcessSubmitRequest>();
        
        Id caseOwner = [
                SELECT OwnerId
                FROM Case
                WHERE Id IN (SELECT Case__c FROM Case_Product__c WHERE Id = :caseProducts.get(0).Id)
        ][0]
                .OwnerId;

        for(Case_Product__c caseProduct : caseProducts) {
            if(!caseProduct.ToExternal__c) {
                Approval.ProcessSubmitRequest request = new Approval.ProcessSubmitRequest();
                request.setComments('look into that refund request');
                request.setProcessDefinitionNameOrId('Case_Product_Approval_Process');
                request.setSkipEntryCriteria(false);
                request.setObjectId(caseProduct.Id);
                request.setNextApproverIds(new List<Id>{
                        caseOwner
                });
                processSubmitRequests.add(request);
            }
        }
        Approval.process(processSubmitRequests);
    }
}