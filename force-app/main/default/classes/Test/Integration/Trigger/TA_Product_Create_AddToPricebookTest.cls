/**
 * Created by patryk.witkowski_bri on 5/16/2025.
 */

@IsTest
private class TA_Product_Create_AddToPricebookTest {
    @TestSetup
    static void setup() {
        DataGenerator dataGenerator = new DataGenerator();
        dataGenerator.createData();
    }

    @IsTest
    static void productAddToPriceBook_Success() {
        List<Product2> products = new List<Product2>();
        Boolean thrownException = false;
        Test.startTest();
        try {
            products = new List<Product2>{new DataGenerator().createProduct(), new DataGenerator().createProduct()};
        } catch (Exception ex) {
            System.debug(ex.getMessage());
            thrownException = true;
        }
        Test.stopTest();

        List<PricebookEntry> pricebookEntries = [SELECT Id, Product2Id, UnitPrice FROM PricebookEntry WHERE Product2Id = :products];

        Assert.areEqual(4, pricebookEntries.size(), 'Pricebook entries size should be 4');
        Assert.isFalse(thrownException, 'Exception shouldn\'t be thrown');
        for(PricebookEntry pricebookEntry : [SELECT Id, Product2Id, UnitPrice FROM PricebookEntry WHERE Product2Id = :products]) {
            Assert.areEqual(200, pricebookEntry.UnitPrice, 'Price should be equals to 200');
        }
    }

    @IsTest
    static void productAddToPriceBook_Failed() {
        List<Product2> products = new List<Product2>{new DataGenerator().createProduct(), new DataGenerator().createProduct()};
        Boolean thrownException = false;
        Test.startTest();
        try {
            new TA_Product_Create_AddToPricebook().afterInsert(products);
        } catch (Exception ex) {
            System.debug(ex.getMessage());
            thrownException = true;
        }
        Test.stopTest();

        Assert.isTrue(thrownException, 'Exception should be thrown');
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
        }
    }
}