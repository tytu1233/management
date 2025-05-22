/**
 * Created by patryk.witkowski_bri on 5/16/2025.
 */

public class TA_Product_Create_AddToPricebook implements TriggerAction.AfterInsert {
    public void afterInsert(List<SObject> triggerNew) {
        IntegrationPricebook.integrationProductsAddToPricebook(triggerNew);
    }
}