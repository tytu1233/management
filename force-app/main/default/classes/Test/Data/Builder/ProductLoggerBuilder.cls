/**
 * Created by patryk.witkowski_bri on 5/16/2025.
 */

public class ProductLoggerBuilder {

    private final Product_Logger__c productLogger;

    public ProductLoggerBuilder() {
        this.productLogger = new Product_Logger__c();
    }

    public ProductLoggerBuilder retry(Integer retry) {
        this.productLogger.Retry__c = retry;
        return this;
    }

    public ProductLoggerBuilder method(String method) {
        this.productLogger.Method__c = method;
        return this;
    }

    public ProductLoggerBuilder status(String status) {
        this.productLogger.Status__c = status;
        return this;
    }

    public ProductLoggerBuilder type(String type) {
        this.productLogger.Type__c = type;
        return this;
    }

    public ProductLoggerBuilder productId(String productId) {
        this.productLogger.Product__c = productId;
        return this;
    }

    public ProductLoggerBuilder save() {
        insert this.productLogger;
        return this;
    }

    public Product_Logger__c build() {
        return this.productLogger;
    }
}