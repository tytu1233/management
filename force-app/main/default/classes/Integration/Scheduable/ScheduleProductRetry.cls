/**
 * Created by patryk.witkowski_bri on 5/14/2025.
 */

public with sharing class ScheduleProductRetry implements Schedulable {
    //TODO: URUCHOMIC TEGO JOBA, BO JEST WYLACZONY TERAZ
    //System.schedule('Test retry', '0 0 22 * * ?', new ScheduleProductRetry());
    public void execute(SchedulableContext context) {
        Database.executeBatch(new ProductFailedBatch(), 100);
    }
}