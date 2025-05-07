/**
 * Created by patryk.witkowski_bri on 4/30/2025.
 */

trigger OrderTrigger on Order (
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