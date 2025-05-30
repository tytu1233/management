/**
 * Created by patryk.witkowski_bri on 4/30/2025.
 */

public class OrderConstants {

    public Errors ERRORS { get { return new Errors(); } }
    public Status STATUS { get { return new Status(); } }
    public PaymentStatus PAYMENT_STATUS { get { return new PaymentStatus(); } }
    public Stage STAGE { get { return new Stage(); } }

    public class Errors {
        public String PreventCreation { get { return  Label.Prevent_Create_Order; } }
        public String DateIsNull { get { return Label.Order_DateIsNull; } }
        public String AddressIncompleteOrEmpty { get { return Label.Order_AddressIncompleteOrEmpty; } }
        public String TheSameAddressAndDate { get { return Label.Order_TheSameAddressAndDate; } }
        public String FailedUpdate { get { return Label.Order_FailedUpdate; } }
        public String FailedCreate { get { return Label.Order_FailedCreate; } }
        public String FailedProductsAdd { get { return Label.Order_FailedProductsAdd; } }
    }

    public class Status {
        public String Draft { get { return 'Draft'; } }
        public String Activated { get { return 'Activated'; } }
    }

    public class PaymentStatus {
        public String Waiting { get { return 'Waiting'; } }
    }

    public class Stage {
        public String ClosedWon { get { return 'Closed Won'; } }
    }
}