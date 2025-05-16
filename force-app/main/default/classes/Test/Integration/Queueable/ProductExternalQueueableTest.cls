/**
 * Created by patryk.witkowski_bri on 5/16/2025.
 */

@IsTest
private class ProductExternalQueueableTest {

    @TestSetup
    static void setup() {
        DataGenerator dataGenerator = new DataGenerator();
        dataGenerator.createData();
    }

    @IsTest
    static void productExternalQueueableSuccess() {
        List<Product2> products = new List<Product2>();
        Test.setMock(HttpCalloutMock.class, new MockHttpSuccess());

        Test.startTest();
        System.enqueueJob(new ProductExternalQueueable(products, 'POST'));
        Test.stopTest();
    }


    class DataGenerator extends Factory {
        public override Product2 createProduct() {
            Product2 product = prepareProduct()
                    .productCode('TEST001')
                    .basePrice(200.00)
                    .active(true)
                    .external(false)
                    .build();
            return product;
        }

        public override void createData() {
            //TODO: ZROBIC SAVEY - TO MA WYWOLYWAC SAME CREATE DATA METODKI
            insert preparePricebook()
                    .name('Event Management Price Book')
                    .active(true)
                    .build();

        }
    }
}