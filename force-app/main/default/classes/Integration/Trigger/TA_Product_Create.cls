/**
 * Created by patryk.witkowski_bri on 5/8/2025.
 */

public class TA_Product_Create implements TriggerAction.AfterInsert {
    public void afterInsert(List<Product2> triggerNew) {
        List<Id> productsId = new List<Id>();

        for(Product2 product : triggerNew) {
            productsId.add(product.Id);
        }

        try {
            IntegrationCallout.sendProducts(productsId);
        } catch (Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }
}