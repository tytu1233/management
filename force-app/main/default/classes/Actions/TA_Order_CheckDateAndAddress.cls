/**
 * Created by patryk.witkowski_bri on 4/30/2025.
 */

public class TA_Order_CheckDateAndAddress implements TriggerAction.BeforeInsert {
    public void beforeInsert(List<Order> triggerNew) {
        Set<Datetime> orderDates = new Set<Datetime>();

        Set<String> cities = new Set<String>();
        Set<String> streets = new Set<String>();
        Set<String> countries = new Set<String>();
        Set<String> postalCodes = new Set<String>();

        for(Order order : triggerNew) {
            orderDates.add(order.Event_Date__c);
            cities.add(order.Event_Address__City__s);
            streets.add(order.Event_Address__Street__s);
            countries.add(order.Event_Address__CountryCode__s);
            postalCodes.add(order.Event_Address__PostalCode__s);
        }

        if(!orderDates.isEmpty() && !cities.isEmpty()) {
            List<Order> existingOrders = [
                    SELECT Id, Event_Date__c,
                            Event_Address__City__s,
                            Event_Address__Street__s,
                            Event_Address__CountryCode__s,
                            Event_Address__PostalCode__s
                    FROM Order
                    WHERE Event_Date__c IN :orderDates
                    AND Event_Address__City__s IN :cities
                    AND Event_Address__Street__s IN :streets
                    AND Event_Address__CountryCode__s IN :countries
                    AND Event_Address__PostalCode__s IN :postalCodes
            ];

            Map<String, Order> addressDateToOrderMap = new Map<String, Order>();

            for(Order ord : existingOrders) {
                String key = ord.Event_Address__City__s + '|' +
                        ord.Event_Address__Street__s + '|' +
                        ord.Event_Address__CountryCode__s + '|' +
                        ord.Event_Address__PostalCode__s + '|' +
                        String.valueOf(ord.Event_Date__c);
                addressDateToOrderMap.put(key, ord);
            }

            for (Order newOrder : triggerNew) {
                if (newOrder.Event_Date__c != null &&
                        newOrder.Event_Address__City__s != null &&
                        newOrder.Event_Address__Street__s != null &&
                        newOrder.Event_Address__CountryCode__s != null &&
                        newOrder.Event_Address__PostalCode__s != null) {
                    String key = newOrder.Event_Address__City__s + '|' +
                            newOrder.Event_Address__Street__s + '|' +
                            newOrder.Event_Address__CountryCode__s + '|' +
                            newOrder.Event_Address__PostalCode__s + '|' +
                            String.valueOf(newOrder.Event_Date__c);

                    if (addressDateToOrderMap.containsKey(key)) {
                        newOrder.addError(Utils.ORDER.ERRORS.TheSameAddressAndDate);
                    }
                }
            }
        }
    }
}