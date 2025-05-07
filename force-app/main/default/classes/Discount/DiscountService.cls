/**
 * Created by patryk.witkowski_bri on 4/24/2025.
 */

public class DiscountService {
    public static Discount__c createDiscount(DiscountDTO discountDTO) {
        DiscountValidator.validateDiscountDTO(discountDTO);

        DiscountHandler handler = DiscountFactory.getDiscountHandler(discountDTO.discountType);

        Discount__c discount = handler.createDiscount(discountDTO);

        return discount;
    }

    public static DiscountOrderDTO calculateDiscount(Decimal initialPrice, Id opportunityId) {
        List<Discount_Strategy_Setting__mdt> discountStrategySettings = [
                SELECT Strategy_Types__c
                FROM Discount_Strategy_Setting__mdt
                LIMIT 1
        ];

        if(discountStrategySettings.isEmpty()) {
            throw new DiscountServiceException(Utils.DISCOUNT.ERRORS.DiscountStrategyNotConfigured);
        }

        String discountSetting = discountStrategySettings.get(0).Strategy_Types__c;

        if(discountSetting == null) {
            throw new DiscountServiceException(Utils.DISCOUNT.ERRORS.DiscountModeNotExist);
        }

        List<Discount__c> discounts = [
                SELECT Id, Name, Discount_Amount__c, Discount_Percentage__c, Discount_Type__c, Start_Date__c, End_Date__c
                FROM Discount__c
                WHERE Active__c = TRUE
        ];

        String strategyTypeString = discountSetting + 'DiscountStrategy';

        Type strategyType = Type.forName(strategyTypeString);

        if(strategyType == null) {
            throw new DiscountServiceException(Utils.DISCOUNT.ERRORS.ClassNotExist);
        }

        DiscountStrategy strategy = (DiscountStrategy) strategyType.newInstance();

        //DiscountStrategy strategy = strategies.get(discountSetting);

        List<Opportunity> opportunity = [
                SELECT Event_Date__c
                FROM Opportunity
                WHERE Id = :opportunityId
                LIMIT 1
        ];

        if(opportunity.isEmpty()) {
            throw new AuraHandledException(Utils.OPPORTUNITY.ERRORS.OpportunityNotExist);
        }

        Date eventDate = opportunity.get(0).Event_Date__c.date();

        DiscountOrderDTO discountOrderDTO = strategy.applyDiscount(initialPrice, discounts, eventDate);

        if(discountOrderDTO.priceAfterDiscount < initialPrice * 0.5) {
            discountOrderDTO.priceAfterDiscount = initialPrice * 0.5;
        }

        return discountOrderDTO;
    }

    public static List<Discount__c> getDiscounts() {
            List<Discount__c> discounts = [
                    SELECT Id, Name, Discount_Amount__c, Discount_Percentage__c, Discount_Type__c, Start_Date__c, End_Date__c, Active__c
                    FROM Discount__c
            ];
            return discounts;
    }


    public static Decimal calculateDiscountBasedOnType(Decimal initialPrice, Discount__c discount) {
        if(discount.Discount_Type__c == Utils.DISCOUNT.TYPES.Percentage) {
            return initialPrice - (initialPrice * (discount.Discount_Percentage__c / 100));
        } else if(discount.Discount_Type__c == Utils.DISCOUNT.TYPES.FixedAmount) {
            return initialPrice - discount.Discount_Amount__c;
        }
        return 0.0;
    }

    public static String removeSpacesFromDiscountType(String discountType) {
        return discountType.replaceAll(' ', '');
    }


    public class DiscountServiceException extends Exception {}

    public class DiscountDTO {
        @AuraEnabled public String discountType { set; get; }
        @AuraEnabled public String discountName { set; get; }
        @AuraEnabled public Integer numberDiscount { set; get; }
        @AuraEnabled public String startDate { set; get; }
        @AuraEnabled public String endDate { set; get; }
    }

    public class DiscountOrderDTO {
        @AuraEnabled public Decimal priceAfterDiscount { get; set; }
        @AuraEnabled public Set<Id> discountIds { get; set; }
    }

}