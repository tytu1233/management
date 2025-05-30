/**
 * Created by patryk.witkowski_bri on 5/30/2025.
 */

public class ApprovalConstants {
    public Name NAME { get { return new Name(); } }
    public Comment COMMENT { get { return new Comment(); } }

    public class Name {
        public String CaseProductApproval { get { return 'Case_Product_Approval_Process'; } }
    }

    public class Comment {
        public String CaseProductComment { get { return 'Please look into that approval ASAP'; } }
    }
}