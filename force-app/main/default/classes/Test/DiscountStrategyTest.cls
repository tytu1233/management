/**
 * Created by patryk.witkowski_bri on 5/7/2025.
 */

@IsTest
private class DiscountStrategyTest {

    @TestSetup
    static void setup() {
        List<Discount__c> discounts = new List<Discount__c>();

        for(Integer i = 0; i < 10; i++) {
            Discount__c discount = new Discount__c(
              Name = 'Test ' + i,
              Discount_Type__c = 'Percentage',
              Start_Date__c = Date.newInstance(2025, 5, 12),
              End_Date__c = Date.newInstance(2025, 5, 17),
              Discount_Percentage__c = 5,
              Active__c = true
            );
            discounts.add(discount);
        }

        for(Integer i = 0; i < 10; i++) {
            Discount__c discount = new Discount__c(
                    Name = 'Test ' + i,
                    Discount_Type__c = 'Fixed Amount',
                    Start_Date__c = Date.newInstance(2025, 5, 12),
                    End_Date__c = Date.newInstance(2025, 5, 17),
                    Discount_Amount__c = 65,
                    Active__c = true
            );
            discounts.add(discount);
        }

        for(Integer i = 0; i < 10; i++) {
            Discount__c discount = new Discount__c(
                    Name = 'Test ' + i,
                    Discount_Type__c = 'Fixed Amount',
                    Discount_Amount__c = 1,
                    Active__c = true
            );
            discounts.add(discount);
        }
        insert discounts;
    }

    @IsTest
    static void test_Maximum_DiscountsNoDateRange() {
        Decimal initialPrice = 100.0;
        Date eventDate = Date.newInstance(2025, 5, 10);

        List<Discount__c> discounts = [SELECT Id, Name, Start_Date__c, End_Date__c, Discount_Amount__c, Discount_Percentage__c, Discount_Type__c FROM Discount__c];

        MaximumDiscountStrategy strategy = new MaximumDiscountStrategy();

        DiscountService.DiscountOrderDTO result;
        Test.startTest();
        {
            DiscountService.DiscountOrderDTO dto = strategy.applyDiscount(initialPrice, discounts, eventDate);
            result = dto;
        }
        Test.stopTest();

        Assert.areEqual(99.0, result.priceAfterDiscount, 'Should select the highest discount (99.0)');
        Assert.areEqual(1, result.discountIds.size(), 'Should include one discount Id');
    }

    @IsTest
    static void test_Maximum_DiscountsWithinDateRange() {
        Decimal initialPrice = 100.0;
        Date eventDate = Date.newInstance(2025, 5, 14);

        List<Discount__c> discounts = [SELECT Id, Name, Start_Date__c, End_Date__c, Discount_Amount__c, Discount_Percentage__c, Discount_Type__c FROM Discount__c];

        MaximumDiscountStrategy strategy = new MaximumDiscountStrategy();

        DiscountService.DiscountOrderDTO result;
        Test.startTest();
        {
            DiscountService.DiscountOrderDTO dto = strategy.applyDiscount(initialPrice, discounts, eventDate);
            result = dto;
        }
        Test.stopTest();

        Assert.areEqual(99.0, result.priceAfterDiscount, 'Should select the highest discount (99.0)');
        Assert.areEqual(1, result.discountIds.size(), 'Should include one discount Id');
    }



    @IsTest
    static void test_MaximumStrategy_EmptyDiscountList() {
        Decimal initialPrice = 100.0;
        Date eventDate = Date.newInstance(2025, 5, 10);
        List<Discount__c> discounts = new List<Discount__c>();

        MaximumDiscountStrategy strategy = new MaximumDiscountStrategy();

        DiscountService.DiscountOrderDTO result;
        Test.startTest();
        {
            DiscountService.DiscountOrderDTO dto = strategy.applyDiscount(initialPrice, discounts, eventDate);
            result = dto;
        }
        Test.stopTest();

        Assert.areEqual(0.0, result.priceAfterDiscount, 'Should return 0.0 for empty discount list');
        Assert.areEqual(1, result.discountIds.size(), 'Should include one null Id');
        Assert.areEqual(null, result.discountIds.iterator().next(), 'Discount Id should be null');
    }

    @IsTest
    static void test_Minimum_DiscountsNoDateRange() {
        Decimal initialPrice = 100.0;
        Date eventDate = Date.newInstance(2025, 5, 10);

        List<Discount__c> discounts = [SELECT Id, Name, Start_Date__c, End_Date__c, Discount_Amount__c, Discount_Percentage__c, Discount_Type__c FROM Discount__c];

        MinimumDiscountStrategy strategy = new MinimumDiscountStrategy();

        DiscountService.DiscountOrderDTO result;
        Test.startTest();
        {
            DiscountService.DiscountOrderDTO dto = strategy.applyDiscount(initialPrice, discounts, eventDate);
            result = dto;
        }
        Test.stopTest();

        Assert.areEqual(99.0, result.priceAfterDiscount, 'Should select the highest discount (99.0)');
        Assert.areEqual(1, result.discountIds.size(), 'Should include one discount Id');
    }

    @IsTest
    static void test_Minimum_DiscountsWithinDateRange() {
        Decimal initialPrice = 100.0;
        Date eventDate = Date.newInstance(2025, 5, 14);

        List<Discount__c> discounts = [SELECT Id, Name, Start_Date__c, End_Date__c, Discount_Amount__c, Discount_Percentage__c, Discount_Type__c FROM Discount__c];

        MinimumDiscountStrategy strategy = new MinimumDiscountStrategy();

        DiscountService.DiscountOrderDTO result;
        Test.startTest();
        {
            DiscountService.DiscountOrderDTO dto = strategy.applyDiscount(initialPrice, discounts, eventDate);
            result = dto;
        }
        Test.stopTest();

        Assert.areEqual(35.0, result.priceAfterDiscount, 'Should select the highest discount (35.0)');
        Assert.areEqual(1, result.discountIds.size(), 'Should include one discount Id');
    }

    @IsTest
    static void test_MinimumStrategy_EmptyDiscountList() {
        Decimal initialPrice = 100.0;
        Date eventDate = Date.newInstance(2025, 5, 10);
        List<Discount__c> discounts = new List<Discount__c>();

        MinimumDiscountStrategy strategy = new MinimumDiscountStrategy();

        DiscountService.DiscountOrderDTO result;
        Test.startTest();
        {
            DiscountService.DiscountOrderDTO dto = strategy.applyDiscount(initialPrice, discounts, eventDate);
            result = dto;
        }
        Test.stopTest();

        Assert.areEqual(0.0, result.priceAfterDiscount, 'Should return 0.0 for empty discount list');
        Assert.areEqual(1, result.discountIds.size(), 'Should include one null Id');
        Assert.areEqual(null, result.discountIds.iterator().next(), 'Discount Id should be null');
    }

}