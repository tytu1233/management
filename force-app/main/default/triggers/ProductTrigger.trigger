/**
 * Created by patryk.witkowski_bri on 5/8/2025.
 */

trigger ProductTrigger on Product2 (
        before insert,
        before update,
        before delete,
        after insert,
        after update,
        after delete,
        after undelete
) {
    new MetadataTriggerHandler().run();
}