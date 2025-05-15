/**
 * Created by patryk.witkowski_bri on 5/8/2025.
 */

public class LogConstants {
    public StatusLog STATUS { get { return new StatusLog(); } }
    public TypeLog TYPE { get { return new TypeLog(); } }

    public class StatusLog {
        public String SUCCESS { get { return 'Success'; } }
        public String FAILED { get { return 'Failed'; } }
        public String PENDING { get { return 'Pending'; } }
    }

    public class TypeLog {
        public String CALLOUT { get { return 'Callout'; } }
        public String REST { get { return 'REST'; } }
    }
}