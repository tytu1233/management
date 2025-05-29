/**
 * Created by patryk.witkowski_bri on 5/28/2025.
 */

@IsTest
private class TA_CaseProduct_ApprovalEvent_Test {

    @TestSetup
    static void setup() {
        new DataGenerator().createData();
    }

    @IsTest
    static void caseProductsShouldBeUpdated_Success() {
        List<Case> cases = [SELECT Id FROM Case];
        List<Product2> products = [SELECT Id, ExternalId__c FROM Product2];

        List<Case_Product_Approval__e> caseProductApprovals = new List<Case_Product_Approval__e>();
        Case_Product_Approval__e caseProductApproval = new DataGenerator().createCaseProductApproval(cases.get(0).Id, products.get(0).Id);
        caseProductApprovals.add(caseProductApproval);

        Test.startTest();
        EventBus.publish(caseProductApproval);
        Test.stopTest();

        for(Case_Product__c caseProduct : [SELECT Id, Name, Case__c, Product__c, Return_percentage__c, Strategy__c, Status__c, Description__c FROM Case_Product__c]) {
            Assert.areEqual(10, caseProduct.Return_percentage__c, 'Return percentage should be 10');
            Assert.areEqual('success', caseProduct.Description__c, 'Description should be changed to success');
        }
    }


    class DataGenerator extends Factory {
        public Product2 createExternalProduct() {
            Product2 product = prepareProduct()
                    .external(true)
                    .externalId(UUID.randomUUID().toString())
                    .save()
                    .build();
            return product;
        }


        public Case_Product_Approval__e createCaseProductApproval(String caseId, String productId) {
            Case_Product_Approval__e caseProductApproval = prepareCaseProductApproval()
                    .case(caseId)
                    .product(productId)
                    .approvalStatus('[{"productId":"'+productId+'","data":{"strategy":"Partially refund","status":"Approved","percentage":10,"description":"success"},"caseId":"'+caseId+'"}]')
                    .build();
            return caseProductApproval;
        }

        public Case_Product__c createCaseProducts(String caseId, String productId) {
            Case_Product__c caseProduct = prepareCaseProduct()
                    .product(productId)
                    .case(caseId)
                    .save()
                    .build();
            return caseProduct;
        }

        public override void createData() {
            createPricebook();
            Case cases = createCase();
            Product2 product = createExternalProduct();
            product.ExternalId__c = product.Id;
            update product;
            createCaseProducts(cases.Id, product.Id);
        }
    }
}