/**
 * Created by patryk.witkowski_bri on 5/8/2025.
 */

public class TA_Product_Update implements TriggerAction.AfterUpdate {
    public void afterUpdate(List<Product2> triggerNew, List<Product2> triggerOld) {
        List<Product2> products = new List<Product2>();

        for(Product2 product : triggerNew) {
            if(!product.IsExternal__c) {
                products.add(product);
            }
        }

        if(!products.isEmpty()) {
            System.enqueueJob(new ProductExternalQueueable(products, 'PUT'));
        }
    }
}