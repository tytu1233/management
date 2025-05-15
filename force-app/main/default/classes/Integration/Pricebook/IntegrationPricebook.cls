/**
 * Created by patryk.witkowski_bri on 5/13/2025.
 */

public with sharing class IntegrationPricebook {
    public static void integrationProductsAddToPricebook(List<Product2> products) {
        String PriceBookId = Utils.PRICE_BOOK.IDS.MomentumEvents;
        String StandardBookId = Utils.PRICE_BOOK.IDS.StandardBook;


        List<PricebookEntry> pricebookStandardEntries = new List<PricebookEntry>();
        List<PricebookEntry> pricebookEntries = new List<PricebookEntry>();

        try {
            for (Product2 product : products) {
                PricebookEntry pricebookEntry = new PricebookEntry(
                        IsActive = product.IsActive,
                        Pricebook2Id = StandardBookId,
                        Product2Id = product.Id,
                        UnitPrice = product.Base_Price__c
                );
                pricebookStandardEntries.add(pricebookEntry);
            }
            insert pricebookStandardEntries;
        } catch (Exception ex) {
            throw new AuraHandledException('Failed to insert standard pricebook entries: ' + ex.getMessage());
        }

        try {
            for (Product2 product : products) {
                PricebookEntry pricebookEntry = new PricebookEntry(
                        IsActive = product.IsActive,
                        Pricebook2Id = PriceBookId,
                        Product2Id = product.Id,
                        UnitPrice = product.Base_Price__c
                );
                pricebookEntries.add(pricebookEntry);
            }
            insert pricebookEntries;
        } catch (Exception ex) {
            throw new AuraHandledException('Failed to insert custom pricebook entries: ' + ex.getMessage());
        }
    }

    public static void integrationProductsUpdatePricebook(List<Product2> products) {
        List<PricebookEntry> pricebookEntries = [
                SELECT UnitPrice, Product2.Base_Price__c
                FROM PricebookEntry
                WHERE Product2Id IN :products
        ];

        for (PricebookEntry pricebookEntry : pricebookEntries) {
            pricebookEntry.UnitPrice = pricebookEntry.Product2.Base_Price__c;
        }

        try {
            update pricebookEntries;
        } catch (Exception ex) {
            throw new AuraHandledException('Failed to restore products: ' + ex.getMessage());
        }
    }
}