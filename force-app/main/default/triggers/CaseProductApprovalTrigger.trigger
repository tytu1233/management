/**
 * Created by patryk.witkowski_bri on 5/23/2025.
 */

trigger CaseProductApprovalTrigger on Case_Product_Approval__e (
        after insert
) {
    new MetadataTriggerHandler().run();
}