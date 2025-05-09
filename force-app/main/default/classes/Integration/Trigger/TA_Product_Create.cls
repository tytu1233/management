/**
 * Created by patryk.witkowski_bri on 5/8/2025.
 */

public class TA_Product_Create implements TriggerAction.AfterInsert {
    public void afterInsert(List<Product2> triggerNew) {
        List<Id> productsId = new List<Id>();

        for(Product2 product : triggerNew) {
            if(!product.IsExternal__c) {
                productsId.add(product.Id);
            }
        }

        try {
            if(!productsId.isEmpty()) {
                IntegrationCallout.sendProducts(productsId);
            }
        } catch (Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }

        String PriceBookId = Utils.PRICE_BOOK.IDS.MomentumEvents;

        List<PricebookEntry> pricebookStandardEntries = new List<PricebookEntry>();
        List<PricebookEntry> pricebookEntries = new List<PricebookEntry>();

        List<Pricebook2> standardPriceBook = [
                SELECT Id
                FROM Pricebook2
                WHERE IsStandard = TRUE
        ];

        for(Product2 product : triggerNew) {
            PricebookEntry pricebookEntry = new PricebookEntry();
            pricebookEntry.IsActive = product.IsActive;
            pricebookEntry.Pricebook2Id = standardPriceBook.get(0).Id;
            pricebookEntry.Product2Id = product.Id;
            pricebookEntry.UnitPrice = product.Base_Price__c;
            pricebookStandardEntries.add(pricebookEntry);
        }

        insert pricebookStandardEntries;

        for(Product2 product : triggerNew) {
            PricebookEntry pricebookEntry = new PricebookEntry();
            pricebookEntry.IsActive = product.IsActive;
            pricebookEntry.Pricebook2Id = PriceBookId;
            pricebookEntry.Product2Id = product.Id;
            pricebookEntry.UnitPrice = product.Base_Price__c;
            pricebookEntries.add(pricebookEntry);
        }

        insert pricebookEntries;
    }
}