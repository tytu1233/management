/**
 * Created by patryk.witkowski_bri on 5/20/2025.
 */

public with sharing class CaseExternalQueueable implements Queueable, Database.AllowsCallouts {
    private final Case_Notification__e caseNotification;

    public CaseExternalQueueable(Case_Notification__e caseNotification) {
        this.caseNotification = caseNotification;
    }

    public void execute(QueueableContext context) {
        try {
            Http http = new Http();
            HttpRequest request = HttpConfiguration.configureRequestPlatform(this.caseNotification);

            HttpResponse response = http.send(request);

            if(response.getStatusCode() == 200) {
                System.debug('Succeed');
            }

        } catch (Exception ex) {
            System.debug('error caught');
            System.debug(ex.getMessage());
        }
    }
}