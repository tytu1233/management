/**
 * Created by patryk.witkowski_bri on 5/8/2025.
 */

public class LogConstants {
    public StatusLog STATUS { get { return new StatusLog(); } }

    public class StatusLog {
        public String SUCCESS { get { return 'Success'; } }
        public String FAILED { get { return 'Failed'; } }
        public String PENDING { get { return 'Pending'; } }
    }
}