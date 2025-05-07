/**
 * Created by patryk.witkowski_bri on 4/28/2025.
 */

public class OrderDiscountFactory {
    public static DiscountCalculator getDecorator(String discountType, DiscountCalculator discountCalculator, Discount__c discount) {
        String discountCreatorHandler = DiscountService.removeSpacesFromDiscountType(discountType) + 'Creator';

        Type orderDiscountType = Type.forName(discountCreatorHandler);

        if(orderDiscountType == null) {
            throw new DiscountService.DiscountServiceException(Utils.DISCOUNT.ERRORS.DiscountTypeNotExist);
        }

        OrderDiscountHandler orderDiscountHandler = (OrderDiscountHandler) orderDiscountType.newInstance();

        return orderDiscountHandler.createDecorator(discountCalculator, discount);
    }
}