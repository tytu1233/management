/**
 * Created by patryk.witkowski_bri on 5/8/2025.
 */

public with sharing class TA_Product_Delete implements TriggerAction.BeforeDelete {
    public void beforeDelete(List<Product2> triggerOld) {
//        List<Product2> products = [
//                SELECT Id, Name, IsActive
//                FROM Product2
//                WHERE Id IN :triggerOld
//        ];
//
//        for(Product2 product : products) {
//            product.IsActive = false;
//        }
//
//        update products;
//
//        for (Product2 prod : triggerOld) {
//            //prod.addError('Can\'t delete product. Active flag will be set on FALSE');
//        }
    }
}