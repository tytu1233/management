/**
 * Created by patryk.witkowski_bri on 5/7/2025.
 */

@IsTest
private class OrderServiceTest {
        @TestSetup
        static void setupTestData() {
            Account acc = new Account(Name = 'Test Account');
            insert acc;

            Opportunity opp = new Opportunity(
                    Name = 'Test Opportunity',
                    AccountId = acc.Id,
                    StageName = 'Prospecting',
                    CloseDate = Date.today().addDays(10),
                    Event_Date__c = Datetime.newInstance(2025, 12, 12, 12, 12, 12),
                    Event_Address__Street__s = '123 Test St',
                    Event_Address__City__s = 'Test City',
                    Event_Address__CountryCode__s = 'US',
                    Event_Address__StateCode__s = 'CA',
                    Event_Address__PostalCode__s = '12345'
            );
            insert opp;

            Product2 prod = new Product2(
                    Name = 'Test Product',
                    IsActive = true
            );
            insert prod;

            Id standardPricebookId = Test.getStandardPricebookId();

            PricebookEntry standardPbe = new PricebookEntry(
                    Pricebook2Id = standardPricebookId,
                    Product2Id = prod.Id,
                    UnitPrice = 100.00,
                    IsActive = true
            );
            insert standardPbe;

            Pricebook2 customPB = new Pricebook2(
                    Name = 'Event Management Price Book',
                    IsActive = true
            );
            insert customPB;

            PricebookEntry customPbe = new PricebookEntry(
                    Pricebook2Id = customPB.Id,
                    Product2Id = prod.Id,
                    UnitPrice = 100.00,
                    IsActive = true
            );
            insert customPbe;

            Discount__c discount = new Discount__c(
                    Name = 'Test Discount',
                    Active__c = true
            );
            insert discount;
        }

    @IsTest
    static void testCreateOrderSuccess() {
        Opportunity opp = [SELECT Id FROM Opportunity WHERE Name = 'Test Opportunity' LIMIT 1];
        Product2 prod = [SELECT Id FROM Product2 WHERE Name = 'Test Product' LIMIT 1];
        Discount__c discount = [SELECT Id FROM Discount__c WHERE Name = 'Test Discount' LIMIT 1];

        List<OrderService.ProductOrderDTO> products = new List<OrderService.ProductOrderDTO>();
        OrderService.ProductOrderDTO productDTO = new OrderService.ProductOrderDTO();
        productDTO.productId = prod.Id;
        products.add(productDTO);

        Decimal discountAmount = 10.00;
        List<Id> discountIds = new List<Id>{discount.Id};

        Test.startTest();
        OrderService.createOrder(opp.Id, products, discountAmount, discountIds);
        Test.stopTest();

        Order createdOrder = [
                SELECT Id, Status, Total_Discount__c, Final_Price__c, TotalAmount, OpportunityId, Payment_Status__c
                FROM Order
                WHERE OpportunityId = :opp.Id
                LIMIT 1
        ];
        Assert.areEqual('Activated', createdOrder.Status, 'Order status should be Activated');
        Assert.areEqual(discountAmount, createdOrder.Total_Discount__c, 'Discount amount should match');
        Assert.areEqual(createdOrder.TotalAmount - discountAmount, createdOrder.Final_Price__c, 'Final price should be correct');
        Assert.areEqual('Waiting', createdOrder.Payment_Status__c, 'Payment status should be Waiting');

        List<OrderItem> orderItems = [
                SELECT Id, Quantity, UnitPrice
                FROM OrderItem
                WHERE OrderId = :createdOrder.Id
        ];
        Assert.areEqual(1, orderItems.size(), 'One OrderItem should be created');
        Assert.areEqual(1, orderItems[0].Quantity, 'OrderItem quantity should be 1');

        List<Order_Discount__c> orderDiscounts = [
                SELECT Id
                FROM Order_Discount__c
                WHERE Order__c = :createdOrder.Id
        ];
        Assert.areEqual(1, orderDiscounts.size(), 'One Order_Discount__c record should be created');

        Opportunity updatedOpp = [
                SELECT StageName
                FROM Opportunity
                WHERE Id = :opp.Id
        ];
        Assert.areEqual('Closed Won', updatedOpp.StageName, 'Opportunity stage should be Closed Won');
    }

    @IsTest
    static void testCreateOrderOpportunityNotExist() {
        Id invalidOppId = '006000000000000AAA';
        List<OrderService.ProductOrderDTO> products = new List<OrderService.ProductOrderDTO>();
        Decimal discountAmount = 10.00;
        List<Id> discountIds = new List<Id>();

        Test.startTest();
        try {
            OrderService.createOrder(invalidOppId, products, discountAmount, discountIds);
        } catch (AuraHandledException e) {
            Assert.areEqual('Script-thrown exception', e.getMessage(), 'Exception message should match');
        }
        Test.stopTest();
    }

    @IsTest
    static void testCreateOrderNoDiscounts() {
        Opportunity opp = [SELECT Id FROM Opportunity WHERE Name = 'Test Opportunity' LIMIT 1];
        Product2 prod = [SELECT Id FROM Product2 WHERE Name = 'Test Product' LIMIT 1];

        List<OrderService.ProductOrderDTO> products = new List<OrderService.ProductOrderDTO>();
        OrderService.ProductOrderDTO productDTO = new OrderService.ProductOrderDTO();
        productDTO.productId = prod.Id;
        products.add(productDTO);

        Decimal discountAmount = 10.00;
        List<Id> discountIds = new List<Id>();

        Test.startTest();
        OrderService.createOrder(opp.Id, products, discountAmount, discountIds);
        Test.stopTest();

        Order createdOrder = [
                SELECT Id, Status, Total_Discount__c
                FROM Order
                WHERE OpportunityId = :opp.Id
                LIMIT 1
        ];
        Assert.areEqual('Activated', createdOrder.Status, 'Order status should be Activated');
        Assert.areEqual(discountAmount, createdOrder.Total_Discount__c, 'Discount amount should match');

        List<Order_Discount__c> orderDiscounts = [
                SELECT Id
                FROM Order_Discount__c
                WHERE Order__c = :createdOrder.Id
        ];
        Assert.areEqual(0, orderDiscounts.size(), 'No Order_Discount__c records should be created');
    }
}