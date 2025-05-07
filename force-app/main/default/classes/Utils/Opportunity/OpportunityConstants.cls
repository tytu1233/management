/**
 * Created by patryk.witkowski_bri on 4/30/2025.
 */

public class OpportunityConstants {

    public Errors ERRORS { get { return new Errors(); } }

    public class Errors {
        public String OpportunityNotExist { get { return Label.Opportunity_NotExist; } }
        public String OpportunityFailedUpdate { get { return Label.Opportunity_FailedUpdate; } }

    }
}