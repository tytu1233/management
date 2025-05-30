/**
 * Created by patryk.witkowski_bri on 4/30/2025.
 */

public class DiscountConstants {

    public Errors ERRORS { get { return new Errors(); } }
    public StrategyTypes STRATEGY_TYPES { get { return new StrategyTypes(); } }
    public Types TYPES { get { return new Types(); } }
    public Setting SETTING { get { return new Setting(); } }

    public class Errors {
        public String DiscountNameRequired { get { return Label.Discount_NameRequired; } }
        public String DiscountTypeRequired { get { return Label.Discount_TypeRequired; } }
        public String DiscountTypeNotExist { get { return Label.Discount_TypeNotExist; } }
        public String DiscountValueGreaterThanZero { get { return Label.Discount_ValueGreaterThanZero; } }
        public String DiscountStartBeforeEndDate { get { return Label.Discount_StartBeforeEndDate; } }
        public String DiscountStrategyNotConfigured { get { return Label.Discount_StrategyNotConfigured; } }
        public String DiscountStrategyNotExist { get { return Label.Discount_StrategyNotExist; } }
        public String DiscountPercentageBetweenZeroAndHundred { get { return Label.Discount_PercentageBetweenZeroAndHundred; } }
        public String DiscountFetch { get { return Label.Discount_Fetch; } }
        public String DiscountToOrderFailed { get { return Label.Discount_ToOrderFailed; } }
        public String DiscountModeNotExist { get { return Label.Discount_ModeNotExist; } }
        public String ClassNotExist { get { return Label.Discount_ClassNotExist; } }
        public String SettingErrorUpdate { get { return Label.Discount_Setting_Error_Update; } }
        public String MetadataUpdateFailed { get { return Label.Discount_Metadata_Update_Failed; } }
    }

    public class Types {
        public String Percentage { get { return 'Percentage'; } }
        public String FixedAmount { get { return 'Fixed Amount'; } }
    }

    public class Setting {
        public String SETTING { get { return 'Strategy'; } }
    }

    public class StrategyTypes {
        public String Combine { get { return 'Combine'; } }
        public String Minimum { get { return 'Minimum'; } }
        public String Maximum { get { return 'Maximum'; } }
    }
}