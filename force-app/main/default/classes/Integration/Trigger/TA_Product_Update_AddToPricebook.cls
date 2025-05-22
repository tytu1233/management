/**
 * Created by patryk.witkowski_bri on 5/16/2025.
 */

public class TA_Product_Update_AddToPricebook implements TriggerAction.AfterUpdate {
    public void afterUpdate(List<SObject> triggerNew, List<SObject> triggerOld) {
        IntegrationPricebook.integrationProductsUpdatePricebook(triggerNew);
    }
}