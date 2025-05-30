/**
 * Created by patryk.witkowski_bri on 4/29/2025.
 */

public class PriceBookConstants {
    public Ids IDS { get { return new Ids(); } }
    public Error ERROR { get { return new Error(); } }
    public Name NAME { get { return new Name(); } }

    public class Ids {
        public String MomentumEvents { get {
            MomentumPriceBookSingleton momentumPriceBookSingleton = MomentumPriceBookSingleton.getInstance();
            return momentumPriceBookSingleton.getPriceBookId();
        } }

        public String StandardBook { get {
            if(Test.isRunningTest()) return Test.getStandardPricebookId();
            StandardPriceBookSingleton standardPriceBookSingleton = StandardPriceBookSingleton.getInstance();
            return standardPriceBookSingleton.getId();
        } }
    }

    public class Error {
        public String NotExist { get { return Label.PriceBook_Error_NotExist; } }
    }

    public class Name {
        public String MomentumEventPriceBook { get { return 'Event Management Price Book'; } }
    }
}