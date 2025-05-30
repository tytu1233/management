/**
 * Created by patryk.witkowski_bri on 5/27/2025.
 */

public class ProductConstants {
    public Ids IDS { get { return new Ids(); } }
    public Error ERROR { get { return new Error(); } }
    public Name NAME { get { return new Name(); } }

    public class Ids {
        public String ComplaintProduct { get {
            ComplaintProductSingleton complaintProductSingleton = ComplaintProductSingleton.getInstance();
            return complaintProductSingleton.getComplaintProductId();
        } }
    }

    public class Error {
        public String ComplaintNotExist { get { return Label.Product_Error_ComplaintNotExist; } }
    }

    public class Name {
        public String Complaint { get { return 'Complaint'; } }
    }
}