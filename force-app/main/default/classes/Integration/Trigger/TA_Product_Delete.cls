/**
 * Created by patryk.witkowski_bri on 5/8/2025.
 */

public class TA_Product_Delete implements TriggerAction.BeforeDelete {
    public void beforeDelete(List<Product2> triggerOld) {
        List<Product2> products = [
                SELECT Id, Name, IsActive, ExternalId__c
                FROM Product2
                WHERE Id IN :triggerOld AND IsExternal__c = FALSE
        ];

        for(Product2 product : products) {
            product.IsActive = false;
        }

        if(!products.isEmpty()) {
            update products;
        }
    }
}