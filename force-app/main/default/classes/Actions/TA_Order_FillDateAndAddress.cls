/**
 * Created by patryk.witkowski_bri on 4/30/2025.
 */

public class TA_Order_FillDateAndAddress implements TriggerAction.BeforeInsert {
    public void beforeInsert(List<Order> triggerNew) {
        for(Order order : triggerNew) {
            if(order.Event_Date__c == null) {
                order.addError(Utils.ORDER.ERRORS.DateIsNull);
            }
            if(String.isBlank(order.Event_Address__City__s) || String.isBlank(order.Event_Address__PostalCode__s) || String.isBlank(order.Event_Address__CountryCode__s) || String.isBlank(order.Event_Address__Street__s)) {
                order.addError(Utils.ORDER.ERRORS.AddressIncompleteOrEmpty);
            }
        }
    }
}