/**
 * Created by patryk.witkowski_bri on 5/7/2025.
 */

@IsTest
private class OpportunityProductsServiceTest {

    @TestSetup
    static void setup() {
        Pricebook2 pricebook2 = new Pricebook2(Name = 'Event Management Price Book', IsActive = true);
        insert pricebook2;
    }

    @IsTest
    static void testGetProductsWithFilters() {
        List<Product2> products = new List<Product2>();
        products.add(new Product2(Name = 'Product A', Family = 'Category1', Base_Price__c = 100.0, IsActive = true, IsExternal__c = true));
        products.add(new Product2(Name = 'Product B', Family = 'Category1', Base_Price__c = 200.0, IsActive = true, IsExternal__c = true));
        products.add(new Product2(Name = 'Product C', Family = 'Category2', Base_Price__c = 150.0, IsActive = true, IsExternal__c = true));
        products.add(new Product2(Name = 'Inactive Product', Family = 'Category2', Base_Price__c = 300.0, IsActive = false, IsExternal__c = true));
        products.add(new Product2(Name = 'No Family Product', Family = null, Base_Price__c = 400.0, IsActive = true, IsExternal__c = true));
        insert products;

        List<String> categories = new List<String>{'Category1'};
        Integer pageSize = 1;
        Integer pageNumber = 1;
        String searchQuery = 'Product A';

        Test.startTest();
        OpportunityProductsService.ProductData result = OpportunityProductsService.getProducts(categories, pageSize, pageNumber, searchQuery);
        Test.stopTest();

        Assert.areEqual(1, result.products.size(), 'Should return 1 product');
        Assert.areEqual('Product A', result.products[0].name, 'Product name should match');
        Assert.areEqual(100.0, result.products[0].price, 'Product price should match');
        Assert.areEqual('Category1', result.products[0].category, 'Product category should match');
        Assert.areNotEqual(null, result.products[0].productId, 'Product ID should be set');
        Assert.areEqual(1, result.totalRecords, 'Total records should be 1');
        Assert.areEqual(1, result.totalPages, 'Total pages should be 1');
    }

    @IsTest
    static void testGetCategoriesSuccess() {
        List<Product2> products = new List<Product2>();
        products.add(new Product2(Name = 'Product A', Family = 'Category1', Base_Price__c = 100.0, IsActive = true, IsExternal__c = true));
        products.add(new Product2(Name = 'Product B', Family = 'Category1', Base_Price__c = 200.0, IsActive = true, IsExternal__c = true));
        products.add(new Product2(Name = 'Product C', Family = 'Category2', Base_Price__c = 150.0, IsActive = true, IsExternal__c = true));
        products.add(new Product2(Name = 'Inactive Product', Family = 'Category2', Base_Price__c = 300.0, IsActive = false, IsExternal__c = true));
        products.add(new Product2(Name = 'No Family Product', Family = null, Base_Price__c = 400.0, IsActive = true, IsExternal__c = true));
        insert products;

        Test.startTest();

        OpportunityProductsService.CategoryData result = OpportunityProductsService.getCategories();

        Test.stopTest();

        Assert.areNotEqual(null, result, 'CategoryData should not be null');
        Assert.areNotEqual(null, result.productsCategories, 'Products categories list should not be null');
        Assert.areEqual(2, result.productsCategories.size(), 'Should return 2 unique categories');

        Set<String> expectedCategories = new Set<String>{'Category1', 'Category2'};
        for (OpportunityProductsService.CategoryDTO category : result.productsCategories) {
            Assert.isTrue(expectedCategories.contains(category.label), 'Category label should be Category1 or Category2');
            Assert.areEqual(category.label, category.value, 'Label and value should match');
        }
    }

    @IsTest
    static void opportunityProducts() {

        Account account = new Account(Name = 'Test Account');
        insert account;

        Opportunity opportunity = new Opportunity(
                Name = 'Test Opportunity',
                StageName = 'Prospecting',
                Pricebook2Id = Test.getStandardPricebookId(),
                CloseDate = Date.today().addDays(30),
                Event_Date__c = Datetime.newInstance(2026, 12, 12, 12, 12, 12),
                AccountId = account.Id
        );
        insert opportunity;

        List<Product2> products = new List<Product2>();
        products.add(new Product2(Name = 'Product A', Family = 'Category1', Base_Price__c = 100.0, IsActive = true, IsExternal__c = true));
        products.add(new Product2(Name = 'Product B', Family = 'Category1', Base_Price__c = 200.0, IsActive = true, IsExternal__c = true));
        insert products;

        List<PricebookEntry> pricebookEntries = [SELECT Id, UnitPrice, Product2Id FROM PricebookEntry WHERE Pricebook2Id = :Test.getStandardPricebookId() LIMIT 2];

        List<OpportunityLineItem> oppLineItems = new List<OpportunityLineItem>();
        for (PricebookEntry pbe : pricebookEntries) {
            oppLineItems.add(new OpportunityLineItem(
                    OpportunityId = opportunity.Id,
                    PricebookEntryId = pbe.Id,
                    Quantity = 1,
                    UnitPrice = pbe.UnitPrice
            ));
        }
        insert oppLineItems;

        Opportunity opportunity1 = [SELECT Id FROM Opportunity WHERE Name = 'Test Opportunity' LIMIT 1];

        Test.startTest();

        List<OpportunityProductsService.ProductDTO> result = OpportunityProductsService.getOpportunityProducts(opportunity1.Id);

        Test.stopTest();

        System.assertNotEquals(null, result, 'ProductDTO list should not be null');
        System.assertEquals(2, result.size(), 'Should return 2 products');

        Set<String> expectedNames = new Set<String>{'Product A', 'Product B'};
        for (OpportunityProductsService.ProductDTO productDTO : result) {
            System.assert(expectedNames.contains(productDTO.name), 'Product name should be Product A or Product B');
            System.assertNotEquals(null, productDTO.productId, 'Product ID should not be null');
        }
    }
}