/**
 * Created by patryk.witkowski_bri on 5/9/2025.
 */
@IsTest
private class TA_Product_CreateTest {
    @TestSetup
    static void setup() {
        DataGenerator factoryProducts = new DataGenerator();
        factoryProducts.createData();
    }

    @IsTest
    static void testAfterInsertSuccess() {

        List<Product2> products = new List<Product2>{new DataGenerator().createProduct(), new DataGenerator().createProduct()};

        Test.setMock(HttpCalloutMock.class, new MockHttpResponse(200, '[{"status":"Success","recordId":"01tgL0000023o5ZQAQ","message":"Record has been created successfully"}]'));

        Test.startTest();
        TA_Product_Create handler = new TA_Product_Create();
        handler.afterInsert(products);
        Test.stopTest();

        for(Product2 product : products) {
            Assert.isFalse(product.hasErrors(), 'Products shouldn\'t have errors');
            Assert.areEqual(0, product.getErrors().size(), 'No errors');
        }
    }

    class DataGenerator extends Factory {
        public override void createData() {
            createPricebook();
            createProduct();
        }
    }
}