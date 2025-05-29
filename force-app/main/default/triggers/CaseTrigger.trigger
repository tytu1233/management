/**
 * Created by patryk.witkowski_bri on 5/27/2025.
 */

trigger CaseTrigger on Case (
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