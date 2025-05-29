/**
 * Created by patryk.witkowski_bri on 5/16/2025.
 */

@IsTest
private class TA_Product_Update_AddToPricebookTest {
    @TestSetup
    static void setup() {
        DataGenerator dataGenerator = new DataGenerator();
        dataGenerator.createData();
    }

    @IsTest
    static void productAddToPriceBook_Success() {
        new DataGenerator().createPricebook();
        List<Product2> products = [SELECT Id, Base_Price__c FROM Product2 LIMIT 1];
        products.get(0).Base_Price__c = 250;
        String productId = products.get(0).Id;

        Test.startTest();
        new TA_Product_Update_AddToPricebook().afterUpdate(products, new List<Product2>{});
        Test.stopTest();

        for(PricebookEntry pricebookEntry : [SELECT Id, Product2Id, UnitPrice FROM PricebookEntry WHERE Product2Id = :productId]) {
            Assert.areEqual(250, pricebookEntry.UnitPrice, 'Price should be changed');
        }

    }

    class DataGenerator extends Factory {

        public override Pricebook2 createPricebook() {
            Pricebook2 pricebook = preparePricebook()
                    .name('Event Management Price Book')
                    .active(true)
                    .save()
                    .build();
            return pricebook;
        }

        public override Product2 createProduct() {
            Product2 product = prepareProduct()
                    .basePrice(200)
                    .save()
                    .build();
            return product;
        }

        public override void createData() {
            createPricebook();
            createProduct();
        }
    }
}