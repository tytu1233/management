/**
 * Created by patryk.witkowski_bri on 5/8/2025.
 */

public class TA_Product_AfterDelete implements TriggerAction.AfterDelete {
    public void afterDelete(List<Product2> triggerOld) {
        Set<Id> productIds = new Set<Id>();
        for (Product2 product : triggerOld) {
            if (!product.IsExternal__c) {
                //product.addError('Cant delete product Active field was changed to false.');
                productIds.add(product.Id);
            }
        }

        if (!productIds.isEmpty()) {
            IntegrationCallout.deleteProducts(productIds);
        }

    }
}