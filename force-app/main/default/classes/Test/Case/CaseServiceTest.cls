/**
 * Created by patryk.witkowski_bri on 5/23/2025.
 */

@IsTest
public class CaseServiceTest {

    @TestSetup
    static void setup() {
        new DataGenerator().createData();
    }

    @IsTest
    static void createCase_Success_NoExternalProducts() {
        List<Order> orders = [SELECT Id, Case__c FROM Order];
        List<Product2> products = [SELECT Id, Name, IsExternal__c FROM Product2];

        CaseService.CaseEventDTO caseEventDTO = new CaseService.CaseEventDTO();
        caseEventDTO.description = 'Test description';
        caseEventDTO.subject = 'Test subject';
        caseEventDTO.priority = 'Medium';
        caseEventDTO.selectedItems = products;
        caseEventDTO.orderId = orders.get(0).Id;

        Test.startTest();
        CaseService.createCaseAndPublishEvent(caseEventDTO);
        Test.stopTest();
        orders = [SELECT Id, Case__c FROM Order];
        List<Case> cases = [SELECT Id FROM Case];


        Assert.areEqual(orders.get(0).Case__c, cases.get(0).Id, 'Case id should be successfully assigned to order');

        List<Case_Product__c> caseProducts = [SELECT Id FROM Case_Product__c];

        Assert.areEqual(1, caseProducts.size(), 'Size of junction object should be equal to one');
    }

    @IsTest
    static void createCase_Success_WithExternalProducts() {
        List<Order> orders = [SELECT Id, Case__c FROM Order];
        new DataGenerator().createExternalProduct();
        List<Product2> products = [SELECT Id, Name, IsExternal__c, ExternalId__c FROM Product2];
        System.debug('SHOW ME WHAT U GOT INSIDE');
        System.debug(products);

        CaseService.CaseEventDTO caseEventDTO = new CaseService.CaseEventDTO();
        caseEventDTO.description = 'Test description';
        caseEventDTO.subject = 'Test subject';
        caseEventDTO.priority = 'Medium';
        caseEventDTO.selectedItems = products;
        caseEventDTO.orderId = orders.get(0).Id;

        Test.startTest();
        CaseService.CaseResponseDTO response =CaseService.createCaseAndPublishEvent(caseEventDTO);
        Test.stopTest();

        orders = [SELECT Id, Case__c FROM Order];
        List<Case> cases = [SELECT Id FROM Case];

        Assert.areEqual(orders.get(0).Case__c, cases.get(0).Id, 'Case id should be successfully assigned to order');

        List<Case_Product__c> caseProducts = [SELECT Id FROM Case_Product__c];

        Assert.areEqual(2, caseProducts.size(), 'Size of junction object should be equal to one');

        Assert.isTrue(response.containsExternal, 'Platform event should be send via API call');
    }

    @IsTest
    static void createCase_NoOrder() {
        delete [SELECT Id, Case__c FROM Order];
        List<Product2> products = [SELECT Id, Name, IsExternal__c FROM Product2];
        Boolean thrownException = false;

        CaseService.CaseEventDTO caseEventDTO = new CaseService.CaseEventDTO();
        caseEventDTO.description = 'Test description';
        caseEventDTO.subject = 'Test subject';
        caseEventDTO.priority = 'Medium';
        caseEventDTO.selectedItems = products;

        Test.startTest();
        try {
            CaseService.createCaseAndPublishEvent(caseEventDTO);
        } catch (Exception ex) {
            thrownException = true;
            Assert.areEqual('There is no such record', ex.getMessage(), 'Message should match');
        }
        Test.stopTest();

        Assert.isTrue(thrownException, 'Exception should\'ve been thrown');
    }

    class DataGenerator extends Factory {

        public override Order createOrder() {
            Account account = createAccount();
            Order order = prepareOrder()
                    .account(account.Id)
                    .build();
            return order;
        }

        public Product2 createExternalProduct() {
            Product2 product = prepareProduct()
                    .external(true)
                    .externalId(UUID.randomUUID().toString())
                    .save()
                    .build();
            return product;
        }

        public override void createData() {
            createPricebook();
            createProduct();
            insert createOrder();
        }
    }
}