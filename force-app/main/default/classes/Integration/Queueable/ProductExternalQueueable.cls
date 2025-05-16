/**
 * Created by patryk.witkowski_bri on 5/14/2025.
 */

public with sharing class ProductExternalQueueable implements Queueable, Database.AllowsCallouts {
    private final List<Product2> products;
    private final String method;

    public ProductExternalQueueable(List<Product2> products, String method) {
        this.products = products;
        this.method = method;
    }

    public void execute(QueueableContext context) {
        Integer diff = products.size() - 101 >= 0 ? products.size() - 101 : -1;
        List<Logger.ProductLog> productLogs = new List<Logger.ProductLog>();
        List<Product2> pricebookProducts = new List<Product2>();

        for(Integer i = products.size() - 1; i > diff; i--) {
            Http http = new Http();
            HttpRequest request = HttpConfiguration.configureRequest(this.method, new List<Product2>{
                    products[i]
            });
            Logger.ProductLog productLog = new Logger.ProductLog();
            try {
                HttpResponse response = http.send(request);
                List<Logger.ResponseDTO> responseBodyLog = (List<Logger.ResponseDTO>) JSON.deserialize(response.getBody(), List<Logger.ResponseDTO>.class);
                productLog = createLog(request.getBody(), products.get(i).Id, responseBodyLog);

                pricebookProducts.add(products.get(i));

            } catch (Exception ex) {
                Logger.ResponseDTO responseDTO = createNetworkProblemResponseLog(products.get(i).Id, ex.getMessage());
                productLog = createLog(request.getBody(), products.get(i).Id, new List<Logger.ResponseDTO>{responseDTO});
            } finally {
                productLogs.add(productLog);
                products.remove(i);
            }
        }

        Logger.logProductCallout(productLogs, this.method);

        if(!products.isEmpty()) {
            System.enqueueJob(new ProductExternalQueueable(products, this.method));
        }
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