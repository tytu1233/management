@isTest
private class DiscountValidatorTest {
    @isTest
    static void testEmptyName() {
        DiscountService.DiscountDTO discountDto = new DiscountService.DiscountDTO();
        discountDto.discountName = '';
        Boolean exceptionThrown = false;
        try {
            DiscountValidator.validateDiscountDTO(discountDto);
        } catch (DiscountService.DiscountServiceException e) {
            exceptionThrown = true;
            Assert.areEqual('Discount name is required.', e.getMessage(),
                'Discount named should not be empty');
        }
        
        Assert.areEqual(true, exceptionThrown, 'Exception should be thrown');
    }
    
    @isTest
    static void testEmptyType() {
        DiscountService.DiscountDTO discountDto = new DiscountService.DiscountDTO();
        discountDto.discountName = 'Hello';
        discountDto.discountType = '';
        Boolean exceptionThrown = false;
        
        try {
            DiscountValidator.validateDiscountDTO(discountDto);
        } catch (DiscountService.DiscountServiceException e) {
            exceptionThrown = true;
            Assert.areEqual('Discount type is required.', e.getMessage(),
                'Discount type should not be empty');
        }
        
        Assert.areEqual(true, exceptionThrown, 'Exception should be thrown');
    }
    
    @isTest
    static void testEmptyNumber() {
        DiscountService.DiscountDTO discountDto = new DiscountService.DiscountDTO();
        discountDto.discountName = 'Hello';
        discountDto.discountType = 'Hello';
        discountDto.numberDiscount = null;
        Boolean exceptionThrown = false;
        
        try {
            DiscountValidator.validateDiscountDTO(discountDto);
        } catch (DiscountService.DiscountServiceException e) {
            exceptionThrown = true;
            Assert.areEqual('Discount value must be greater than zero.', e.getMessage(),
                'Discount number should not less than 0');
        }
        
        Assert.areEqual(true, exceptionThrown, 'Exception should be thrown');
    }
    
    @isTest
    static void testDates() {
        DiscountService.DiscountDTO discountDto = new DiscountService.DiscountDTO();
        discountDto.discountName = 'Hello';
        discountDto.discountType = 'Hello';
        discountDto.numberDiscount = 50;
        discountDto.startDate = '2025-12-12';
        discountDto.endDate = '2025-11-11';
        Boolean exceptionThrown = false;
        
        try {
            DiscountValidator.validateDiscountDTO(discountDto);
        } catch (DiscountService.DiscountServiceException e) {
            exceptionThrown = true;
            Assert.areEqual('"Start date" must be before "End date".', e.getMessage(),
                'Discount number should not less than 0');
        }
        
        Assert.areEqual(true, exceptionThrown, 'Exception should be thrown');
    }
}