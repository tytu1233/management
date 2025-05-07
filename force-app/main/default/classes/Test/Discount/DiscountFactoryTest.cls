@isTest
private class DiscountFactoryTest {
    @isTest
    static void testGetFixedAmountDiscountHandler() {
        String discountType = 'Fixed Amount';
        
        DiscountHandler handler = DiscountFactory.getDiscountHandler(discountType);

        Assert.areNotEqual(null, handler, 'Handler should not be null');
        Assert.areEqual(true, handler instanceof FixedAmountDiscountHandler,
                'Handler should be an instance of FixedAmountDiscountHandler');
    }
    
    @isTest
    static void testGetPercentageDiscountHandler() {
        String discountType = 'Percentage';
        
        DiscountHandler handler = DiscountFactory.getDiscountHandler(discountType);

        Assert.areNotEqual(null, handler, 'Handler should not be null');
        Assert.areEqual(true, handler instanceof PercentageDiscountHandler,
                'Handler should be an instance of PercentageDiscountHandler');
    }
    
    @isTest
    static void testInvalidDiscountType() {
        String discountType = 'Invalid Discount';
        Boolean exceptionThrown = false;
        
        try {
            DiscountFactory.getDiscountHandler(discountType);
        } catch (DiscountService.DiscountServiceException e) {
            exceptionThrown = true;
            Assert.areEqual('Class for given strategy wasn\'t created.', e.getMessage(),
                    'Exception message should match');
        }

        Assert.areEqual(true, exceptionThrown, 'Exception should be thrown for invalid discount type');
    }
    
    @isTest
    static void testBlankDiscountType() {
        String discountType = '';
        Boolean exceptionThrown = false;
        
        try {
            DiscountFactory.getDiscountHandler(discountType);
        } catch (DiscountService.DiscountServiceException e) {
            exceptionThrown = true;
            Assert.areEqual('There is no such discount type.', e.getMessage(),
                    'Exception message should match');
        }

        Assert.areEqual(true, exceptionThrown, 'Exception should be thrown for blank discount type');
    }
    
    @isTest
    static void testNullDiscountType() {
        String discountType = null;
        Boolean exceptionThrown = false;
        
        try {
            DiscountFactory.getDiscountHandler(discountType);
        } catch (DiscountService.DiscountServiceException e) {
            exceptionThrown = true;
            Assert.areEqual('There is no such discount type.', e.getMessage(),
                    'Exception message should match');
        }
        
        Assert.areEqual(true, exceptionThrown, 'Exception should be thrown for null discount type');
    }
}