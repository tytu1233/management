/**
 * Created by patryk.witkowski_bri on 5/13/2025.
 */

public with sharing class IntegrationPricebook {
    public static void integrationProductsAddToPricebook(List<Product2> products) {
        String PriceBookId = Utils.PRICE_BOOK.IDS.MomentumEvents;
        String StandardBookId = Utils.PRICE_BOOK.IDS.StandardBook;


        List<PricebookEntry> pricebookStandardEntries = new List<PricebookEntry>();
        List<PricebookEntry> pricebookEntries = new List<PricebookEntry>();

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
    }

    public static void integrationProductsUpdatePricebook(List<Product2> products) {
        Map<Id, Decimal> productIdToBasePrice = new Map<Id, Decimal>();
        for (Product2 product : products) {
            productIdToBasePrice.put(product.Id, product.Base_Price__c);
        }

        List<PricebookEntry> pricebookEntries = [
                SELECT Id, UnitPrice, Product2Id
                FROM PricebookEntry
                WHERE Product2Id IN :productIdToBasePrice.keySet()
        ];

        for (PricebookEntry pricebookEntry : pricebookEntries) {
            pricebookEntry.UnitPrice = productIdToBasePrice.get(pricebookEntry.Product2Id);
        }

        update pricebookEntries;
    }
}