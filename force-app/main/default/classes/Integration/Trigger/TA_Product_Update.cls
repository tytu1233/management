/**
 * Created by patryk.witkowski_bri on 5/8/2025.
 */

public class TA_Product_Update implements TriggerAction.AfterUpdate {
    public void afterUpdate(List<Product2> triggerNew, List<Product2> triggerOld) {
        Set<Id> productIds = new Set<Id>();

        for(Product2 product : triggerOld) {
            productIds.add(product.Id);
        }

        try {
            IntegrationCallout.updateProducts(productIds);
        } catch (Exception ex) {
            throw new AuraHandledException('Cant update the record');
        }
    }
}