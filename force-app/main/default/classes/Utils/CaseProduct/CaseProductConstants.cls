/**
 * Created by patryk.witkowski_bri on 5/29/2025.
 */

public class CaseProductConstants {
    public Status STATUS { get { return new Status(); } }
    public Error ERROR { get { return new Error(); } }

    public class Error {
        public String NoRecords { get { return Label.CaseProducts_NoRecords; } }
    }

    public class Status {
        public String Approved { get { return 'Approved'; } }
    }
}