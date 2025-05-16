/**
 * Created by patryk.witkowski_bri on 5/8/2025.
 */

@RestResource(UrlMapping='/integration/product')
global with sharing class IntegrationProduct {
    @HttpPost
    global static void createProductsFromExternalOrg() {
        RestRequest request = RestContext.request;
        RestResponse response = RestContext.response;

        Integer code = 200;
        String recordId = null;
        List<Product2> productsToPricebook = new List<Product2>();
        List<Logger.ResponseDTO> responseLogs = new List<Logger.ResponseDTO>();
        List<Logger.ProductLog> productLogs = new List<Logger.ProductLog>();

        try {
            String requestBodyString = request.requestBody.toString();
            List<Object> requestJsonList = (List<Object>) JSON.deserializeUntyped(requestBodyString);
            List<Product2> requestProducts = (List<Product2>) JSON.deserialize(requestBodyString, List<Product2>.class);

            for(Product2 product : requestProducts) {
                product.ExternalId__c = product.Id;
                product.Id = null;
                product.IsExternal__c = true;
            }

            Database.SaveResult[] srList = Database.insert(requestProducts, false);
            Integer index = 0;

            for(Database.SaveResult result : srList) {
                recordId = requestProducts[index].ExternalId__c;
                Logger.ResponseDTO responseDTO = Logger.responseBodyReturn(result.getId(), result.isSuccess(), 'Product has been created successfully');
                Logger.ProductLog productLog = createLog(requestJsonList.get(index).toString(), result.getId(), new List<Logger.ResponseDTO>{responseDTO});

                productLogs.add(productLog);
                responseLogs.add(responseDTO);
                index++;
            }

            //TODO: ZMIENIC JAK BEDZIE BLAD ZEBY SIE NIE WYWOLYWALO
            //IntegrationPricebook.integrationProductsAddToPricebook(requestProducts);
        } catch(Exception ex) {
            code = 400;
            Logger.ResponseDTO responseError = Logger.responseBodyReturn(recordId, false, ex.getMessage());
            responseLogs = new List<Logger.ResponseDTO>{responseError};
        } finally {
            response.statusCode = code;
            response.responseBody = Blob.valueOf(JSON.serialize(responseLogs));
            Logger.logProductRest(productLogs, 'POST');
        }
    }

    @HttpPut
    global static void updateProductsFromExternalOrg() {
        RestRequest request = RestContext.request;
        RestResponse response = RestContext.response;

        Integer code = 200;
        String recordId = null;
        List<Logger.ResponseDTO> responseLogs = new List<Logger.ResponseDTO>();

        try {
            List<Product2> requestProducts = (List<Product2>) JSON.deserialize(request.requestBody.toString(), List<Product2>.class);

            for(Product2 product : requestProducts) {
                product.ExternalId__c = product.Id;
                product.Id = null;
                product.IsExternal__c = true;
            }

            Database.UpsertResult[] srList = Database.upsert(requestProducts, Product2.ExternalId__c, false);
            Integer index = 0;
            for(Database.UpsertResult result : srList) {
                Logger.ResponseDTO responseDTO = Logger.responseBodyReturn(recordId, result.isSuccess(), 'Product has been updated successfully');
                responseLogs.add(responseDTO);
                index++;
            }
        } catch(Exception ex) {
            code = 400;
            Logger.ResponseDTO responseError = Logger.responseBodyReturn(recordId, false, ex.getMessage());
            responseLogs = new List<Logger.ResponseDTO>{responseError};
        }
        response.statusCode = code;
        response.responseBody = Blob.valueOf(JSON.serialize(responseLogs));
    }

    private static Logger.ProductLog createLog(String requestBody, String recordId, List<Logger.ResponseDTO> responseBodyLog) {
        Logger.ProductLog productLog = new Logger.ProductLog();
        productLog.recordId = recordId;
        productLog.requestBody = requestBody;
        productLog.responseBody = responseBodyLog;
        return productLog;
    }
}