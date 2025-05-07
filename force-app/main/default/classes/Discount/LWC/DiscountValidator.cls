/**
 * Created by patryk.witkowski_bri on 4/24/2025.
 */

public class DiscountValidator {
    public static void validateDiscountDTO(DiscountService.DiscountDTO discountDTO) {
        if (String.isBlank(discountDTO.discountName)) {
            throw new DiscountService.DiscountServiceException(Utils.DISCOUNT.ERRORS.DiscountNameRequired);
        }

        if (String.isBlank(discountDTO.discountType)) {
            throw new DiscountService.DiscountServiceException(Utils.DISCOUNT.ERRORS.DiscountTypeRequired);
        }

        if (discountDTO.numberDiscount == null || discountDTO.numberDiscount <= 0) {
            throw new DiscountService.DiscountServiceException(Utils.DISCOUNT.ERRORS.DiscountValueGreaterThanZero);
        }

        if(discountDTO.startDate != null && discountDTO.endDate != null) {
            Date startDate = Date.valueOf(discountDTO.startDate);
            Date endDate = Date.valueOf(discountDTO.endDate);

            if(startDate > endDate) {
                throw new DiscountService.DiscountServiceException(Utils.DISCOUNT.ERRORS.DiscountStartBeforeEndDate);
            }
        }
    }
}