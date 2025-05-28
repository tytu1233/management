/**
 * Created by patryk.witkowski_bri on 5/28/2025.
 */

public class CaseProductApprovalBuilder {
    private final Case_Product_Approval__e caseProductApproval;

    public CaseProductApprovalBuilder() {
        this.caseProductApproval = new Case_Product_Approval__e();
    }

    public CaseProductApprovalBuilder approvalStatus(String approvalStatus) {
        this.caseProductApproval.Approval_Status__c = approvalStatus;
        return this;
    }

    public CaseProductApprovalBuilder case(String caseId) {
        this.caseProductApproval.CaseId__c = caseId;
        return this;
    }

    public CaseProductApprovalBuilder product(String productId) {
        this.caseProductApproval.ProductId__c = productId;
        return this;
    }

    public Case_Product_Approval__e build() {
        return this.caseProductApproval;
    }
}