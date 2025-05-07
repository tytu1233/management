/**
 * Created by patryk.witkowski_bri on 4/24/2025.
 */

public class DiscountFactory {
    public static DiscountHandler getDiscountHandler(String discountType) {
        if(String.isBlank(discountType)) {
            throw new DiscountService.DiscountServiceException(Utils.DISCOUNT.ERRORS.DiscountTypeNotExist);
        }

        String discountTypeHandler = DiscountService.removeSpacesFromDiscountType(discountType) + 'DiscountHandler';

        Type handlerType = Type.forName(discountTypeHandler);

        if(handlerType == null) {
            throw new DiscountService.DiscountServiceException(Utils.DISCOUNT.ERRORS.ClassNotExist);
        }

        return (DiscountHandler) handlerType.newInstance();
    }
}