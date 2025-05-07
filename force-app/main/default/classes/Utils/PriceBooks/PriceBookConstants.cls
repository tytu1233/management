/**
 * Created by patryk.witkowski_bri on 4/29/2025.
 */

public class PriceBookConstants {
    public Ids IDS { get { return new Ids(); } }

    public class Ids {
        public String MomentumEvents { get {
            MomentumPriceBookSingleton momentumPriceBookSingleton = MomentumPriceBookSingleton.getInstance();
            return momentumPriceBookSingleton.getPriceBookId();
        } }
    }
}