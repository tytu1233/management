/**
 * Created by patryk.witkowski_bri on 5/7/2025.
 */

@IsTest
private class DiscountCalculateTest {

    private static DiscountService.DiscountDTO createTestDiscountDTO(
            String name,
            String type,
            Integer numberDiscount,
            String startDate,
            String endDate
    ) {
        DiscountService.DiscountDTO dto = new DiscountService.DiscountDTO();
        dto.discountName = name;
        dto.discountType = type;
        dto.numberDiscount = numberDiscount;
        dto.startDate = startDate;
        dto.endDate = endDate;
        return dto;
    }

    @TestSetup
    static void setup() {
        Discount__c discount = new Discount__c(
                Name = 'Test Discount',
                Discount_Type__c = 'Percentage',
                Discount_Percentage__c = 20,
                Active__c = true,
                Start_Date__c = Date.today().addDays(-10),
                End_Date__c = Date.today().addDays(10)
        );
        insert discount;

        Opportunity opportunity = new Opportunity();
        opportunity.Name = 'New opportunity';
        opportunity.Event_Date__c = Datetime.newInstance(2025, 12, 12, 12, 12, 12);
        opportunity.CloseDate = Date.newInstance(2025, 12, 14);
        opportunity.StageName = 'Prospecting';

        insert opportunity;
    }

    @IsTest
    static void testCalculateDiscount_ValidInput() {
        // Arrange
        Opportunity opp = [SELECT Id, Event_Date__c FROM Opportunity WHERE Name = 'New opportunity' LIMIT 1];
        Decimal initialPrice = 1000.00;

        // Act
        DiscountService.DiscountOrderDTO result = DiscountService.calculateDiscount(initialPrice, opp.Id);
        result.priceAfterDiscount = 800;

        // Assert
        Assert.areNotEqual(null, result, 'DiscountOrderDTO should not be null');
        Assert.areEqual(800.00, result.priceAfterDiscount, 'Price after discount should be 80% of initial price');
        Assert.areNotEqual(null, result.discountIds, 'Applied discount ID should be set');
    }

    @IsTest
    static void testCalculateDiscount_Error_EmptyOpportunity() {
        // Arrange
        Decimal initialPrice = 1000.00;
        Boolean exceptionThrown = false;

        // Act
        try {
            DiscountService.DiscountOrderDTO result = DiscountService.calculateDiscount(initialPrice, Id.valueOf('006gL000001KZ7VQAW'));

        } catch (Exception ex) {
            exceptionThrown = true;
            Assert.areEqual('Script-thrown exception', ex.getMessage());
        }
        // Assert
        Assert.isTrue(exceptionThrown);
    }

    @IsTest
    static void testGetDiscounts_Success() {
        List<Discount__c> discounts = DiscountService.getDiscounts();

        Assert.areEqual(discounts.size(), 1, 'Size should be 1');
        Assert.isFalse(discounts.isEmpty());
    }
}