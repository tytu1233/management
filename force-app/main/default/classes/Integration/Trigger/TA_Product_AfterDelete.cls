/**
 * Created by patryk.witkowski_bri on 5/8/2025.
 */

public with sharing class TA_Product_AfterDelete implements TriggerAction.AfterDelete {
    public void afterDelete(List<Product2> triggerOld) {
        Map<Id, Product2> products = new Map<Id, Product2>([
                SELECT Id, Name, IsActive, ExternalId
                FROM Product2
                WHERE Id IN :triggerOld
                ALL ROWS
        ]);

        try {
            IntegrationCallout.deleteProducts(products.keySet());
        } catch (Exception ex) {
            throw new AuraHandledException('Synchronization with other org was not possible. Please try again');
        }
    }
}