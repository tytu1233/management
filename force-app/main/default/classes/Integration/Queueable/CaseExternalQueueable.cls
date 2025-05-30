/**
 * Created by patryk.witkowski_bri on 5/20/2025.
 */

public with sharing class CaseExternalQueueable implements Queueable, Database.AllowsCallouts {
    private final Case_Notification__e caseNotification;

    public CaseExternalQueueable(Case_Notification__e caseNotification) {
        this.caseNotification = caseNotification;
    }

    public void execute(QueueableContext context) {
        List<Logger.ProductLog> caseLogs = new List<Logger.ProductLog>();
        Logger.ProductLog caseLog = new Logger.ProductLog();
        Http http = new Http();
        HttpRequest request = HttpConfiguration.configureRequestPlatform(this.caseNotification);
        try {

            http.send(request);
        } catch (Exception ex) {
            Logger.ResponseDTO responseDTO = createNetworkProblemResponseLog(this.caseNotification.Id, ex.getMessage());
            caseLog = createLog(request.getBody(), this.caseNotification.Id, new List<Logger.ResponseDTO>{responseDTO});
        } finally {
            caseLogs.add(caseLog);
        }
        //Logger.logProductCallout(caseLogs, 'POST');
    }

    private static Logger.ProductLog createLog(String requestBody, String recordId, List<Logger.ResponseDTO> responseBodyLog) {
        Logger.ProductLog productLog = new Logger.ProductLog();
        productLog.recordId = recordId;
        productLog.requestBody = requestBody;
        productLog.responseBody = responseBodyLog;
        return productLog;
    }

    private static Logger.ResponseDTO createNetworkProblemResponseLog(String recordId, String message) {
        Logger.ResponseDTO responseDTO = new Logger.ResponseDTO();
        responseDTO.recordId = recordId;
        responseDTO.status = Utils.LOG.STATUS.NETWORK_PROBLEM;
        responseDTO.message = message;
        return responseDTO;
    }
}