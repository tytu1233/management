/**
 * Created by patryk.witkowski_bri on 5/27/2025.
 */

public class ProductConstants {
    public Ids IDS { get { return new Ids(); } }


    public class Ids {
        public String ComplaintProduct { get {
            ComplaintProductSingleton complaintProductSingleton = ComplaintProductSingleton.getInstance();
            return complaintProductSingleton.getComplaintProductId();
        } }
    }
}