/**
 * Created by patryk.witkowski_bri on 5/19/2025.
 */

public with sharing class CaseController {
    @AuraEnabled
    public static CaseService.CaseResponseDTO createCaseAndPublishEvent(CaseService.CaseEventDTO caseData) {
        try {
            return CaseService.createCaseAndPublishEvent(caseData);
        } catch (Exception ex) {
            throw new AuraHandledException('Couldn\'t create case or publish the event');
        }
    }
}