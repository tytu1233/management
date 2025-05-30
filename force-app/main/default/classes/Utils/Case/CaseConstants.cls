/**
 * Created by patryk.witkowski_bri on 5/28/2025.
 */

public class CaseConstants {
    public Errors ERRORS { get { return new Errors(); } }
    public Status STATUS { get { return new Status(); } }

    public class Errors {
        public String Case_FailedCreate { get { return Label.Case_FailedCreate; } }
        public String Case_RecordNotExist { get { return Label.Case_Error_RecordNotExist; } }
    }

    public class Status {
        public String Pending { get { return 'Pending'; } }
        public String Closed { get { return 'Closed'; } }
    }
}