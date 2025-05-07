/**
 * Created by patryk.witkowski_bri on 5/7/2025.
 */
@IsTest
private class DiscountHandlerTest {

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


    @IsTest
    static void createPercentageDiscount_Error() {
        Boolean exceptionThrown = false;
        DiscountService.DiscountDTO discountDTO = new DiscountService.DiscountDTO();
        discountDTO.discountName = 'New';
        discountDTO.discountType = 'Percentage';
        discountDTO.numberDiscount = 150;

        PercentageDiscountHandler percentageDiscountHandler = new PercentageDiscountHandler();

        try {
            percentageDiscountHandler.createDiscount(discountDTO);
        } catch (Exception ex) {
            exceptionThrown = true;
            Assert.areEqual(Label.Discount_PercentageBetweenZeroAndHundred, Label.Discount_PercentageBetweenZeroAndHundred, 'Message should match');
        }

        Assert.isTrue(exceptionThrown, 'Exception should be thrown');
    }

    @IsTest
    static void createPercentageDiscount_Success() {
        // Arrange
        PercentageDiscountHandler handler = new PercentageDiscountHandler();
        DiscountService.DiscountDTO dto = createTestDiscountDTO(
                'Test Discount',
                'Percentage',
                50,
                '2025-01-01',
                '2025-12-31'
        );

        // Act
        Test.startTest();
        Discount__c result = handler.createDiscount(dto);
        Test.stopTest();

        // Assert
        Assert.areNotEqual(null, result, 'Discount should not be null');
        Assert.areEqual('Test Discount', result.Name, 'Discount name should match');
        Assert.areEqual('Percentage', result.Discount_Type__c, 'Discount type should match');
        Assert.areEqual(50.0, result.Discount_Percentage__c, 'Discount percentage should match');
        Assert.areEqual(Date.valueOf('2025-01-01'), result.Start_Date__c, 'Start date should match');
        Assert.areEqual(Date.valueOf('2025-12-31'), result.End_Date__c, 'End date should match');
        Assert.areEqual(true, result.Active__c, 'Discount should be active');
    }

    @IsTest
    static void createFixedAmountDiscount_Success() {
        // Arrange
        FixedAmountDiscountHandler handler = new FixedAmountDiscountHandler();
        DiscountService.DiscountDTO dto = createTestDiscountDTO(
                'Test Discount',
                'Fixed Amount',
                50,
                '2025-01-01',
                '2025-12-31'
        );

        // Act
        Test.startTest();
        Discount__c result = handler.createDiscount(dto);
        Test.stopTest();

        // Assert
        Assert.areNotEqual(null, result, 'Discount should not be null');
        Assert.areEqual('Test Discount', result.Name, 'Discount name should match');
        Assert.areEqual('Fixed Amount', result.Discount_Type__c, 'Discount type should match');
        Assert.areEqual(50.0, result.Discount_Amount__c, 'Discount percentage should match');
        Assert.areEqual(Date.valueOf('2025-01-01'), result.Start_Date__c, 'Start date should match');
        Assert.areEqual(Date.valueOf('2025-12-31'), result.End_Date__c, 'End date should match');
        Assert.areEqual(true, result.Active__c, 'Discount should be active');
    }

    @IsTest
    static void createCreateDiscountService_Success() {
        // Arrange
        FixedAmountDiscountHandler handler = new FixedAmountDiscountHandler();
        DiscountService.DiscountDTO dto = createTestDiscountDTO(
                'Test Discount',
                'Fixed Amount',
                50,
                '2025-01-01',
                '2025-12-31'
        );

        // Act
        Test.startTest();
        Discount__c result = DiscountService.createDiscount(dto);
        Test.stopTest();

        // Assert
        Assert.areNotEqual(null, result, 'Discount should not be null');
        Assert.areEqual('Test Discount', result.Name, 'Discount name should match');
        Assert.areEqual('Fixed Amount', result.Discount_Type__c, 'Discount type should match');
        Assert.areEqual(50.0, result.Discount_Amount__c, 'Discount percentage should match');
        Assert.areEqual(Date.valueOf('2025-01-01'), result.Start_Date__c, 'Start date should match');
        Assert.areEqual(Date.valueOf('2025-12-31'), result.End_Date__c, 'End date should match');
        Assert.areEqual(true, result.Active__c, 'Discount should be active');
    }
}