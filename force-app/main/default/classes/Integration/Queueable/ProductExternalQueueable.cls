/**
 * Created by patryk.witkowski_bri on 5/14/2025.
 */

public with sharing class ProductExternalQueueable implements Queueable, Database.AllowsCallouts {
    private final List<Product2> products;
    private final String method;
    private String status;

    public ProductExternalQueueable(List<Product2> products, String method) {
        this.products = products;
        this.method = method;
    }

    public void execute(QueueableContext context) {
        Integer diff = products.size() - 101 >= 0 ? products.size() - 101 : -1;
        List<Logger.ProductLog> productLogs = new List<Logger.ProductLog>();
        List<Product2> pricebookProducts = new List<Product2>();

        try {

            for(Integer i = products.size() - 1; i > diff; i--) {
                Http http = new Http();
                HttpRequest request = HttpConfiguration.configureRequest(this.method, new List<Product2>{products[i]});
                HttpResponse response = http.send(request);

                List<Logger.ResponseDTO> responseBodyLog = (List<Logger.ResponseDTO>) JSON.deserialize(response.getBody(), List<Logger.ResponseDTO>.class);
                Logger.ProductLog productLog = createLog(request.getBody(), products.get(i).Id, responseBodyLog);

                productLogs.add(productLog);
                pricebookProducts.add(products.get(i));

                products.remove(i);
            }
            if(!products.isEmpty()) {
                System.enqueueJob(new ProductExternalQueueable(products, this.method));
            }

        } catch (Exception ex) {
            status = Utils.LOG.STATUS.FAILED;
        } finally {
            if(this.method == 'POST') {
                IntegrationPricebook.integrationProductsAddToPricebook(pricebookProducts);
            } else if(this.method == 'PUT') {
                IntegrationPricebook.integrationProductsUpdatePricebook(pricebookProducts);
            }
            Logger.logProductCallout(productLogs, this.method);
        }
    }

    private static Logger.ProductLog createLog(String requestBody, String recordId, List<Logger.ResponseDTO> responseBodyLog) {
        Logger.ProductLog productLog = new Logger.ProductLog();
        productLog.recordId = recordId;
        productLog.requestBody = requestBody;
        productLog.responseBody = responseBodyLog;
        return productLog;
    }
}