/**
 * Created by patryk.witkowski_bri on 5/13/2025.
 */

public with sharing class Logger {

    public static void logProductCallout(List<ProductLog> productLogs, String method) {
        List<Product_Logger__c> productLoggers = new List<Product_Logger__c>();

        for (ProductLog product : productLogs) {
            Product_Logger__c productLogger = new Product_Logger__c();
            productLogger.Timestamp__c = Datetime.now();
            productLogger.Product__c = product.recordId;
            productLogger.Request_Body__c = product.requestBody;
            productLogger.Response_Body__c = JSON.serialize(product.responseBody);
            productLogger.Status__c = (String) product.responseBody.get(0).status;
            productLogger.Type__c = 'Callout';
            productLogger.Retry__c = product.responseBody.get(0).status == 'Failed' ? 1 : null;
            productLogger.Method__c = method;
            productLogger.Name = product.recordId + ' ' + Datetime.now();
            productLoggers.add(productLogger);
        }
        insert productLoggers;
    }

    public static void logProductRest(List<ProductLog> productLogs, String method) {
        List<Product_Logger__c> productLoggers = new List<Product_Logger__c>();

        for(ProductLog product : productLogs) {
            Product_Logger__c productLogger = new Product_Logger__c();
            productLogger.Timestamp__c = Datetime.now();
            productLogger.Product__c = product.recordId;
            productLogger.Request_Body__c = product.requestBody;
            productLogger.Response_Body__c = JSON.serialize(product.responseBody);
            productLogger.Status__c = (String) product.responseBody.get(0).status;
            productLogger.Type__c = 'REST';
            productLogger.Method__c = method;
            productLogger.Name = product.recordId + ' ' + Datetime.now();
            productLoggers.add(productLogger);
        }
        insert productLoggers;
    }

    public static ResponseDTO responseBodyReturn(String recordId, Boolean isSuccess, String message) {
        ResponseDTO responseDTO = new ResponseDTO();
        responseDTO.recordId = recordId;
        if(isSuccess) {
            responseDTO.status = Utils.LOG.STATUS.SUCCESS;
            responseDTO.message = message;
        } else {
            responseDTO.status = Utils.LOG.STATUS.FAILED;
            responseDTO.message = message;
        }
        return responseDTO;
    }

    public class ProductLog {
        public String recordId {get; set;}
        public String requestBody {get; set;}
        public List<ResponseDTO> responseBody {get; set;}
        public String status {get; set;}
        public String method {get; set;}
    }

    public class ResponseDTO {
        public String message {get; set;}
        public String recordId {get; set;}
        public String status {get; set;}
    }
}