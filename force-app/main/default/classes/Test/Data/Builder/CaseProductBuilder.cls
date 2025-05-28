/**
 * Created by patryk.witkowski_bri on 5/28/2025.
 */

public class CaseProductBuilder {
    private final Case_Product__c caseProduct;

    public CaseProductBuilder() {
        this.caseProduct = new Case_Product__c();
    }

    public CaseProductBuilder orderItem(String orderItemId) {
        this.caseProduct.Order_Product__c = orderItemId;
        return this;
    }

    public CaseProductBuilder name(String name) {
        this.caseProduct.Name = name;
        return this;
    }

    public CaseProductBuilder product(String productId) {
        this.caseProduct.Product__c = productId;
        return this;
    }

    public CaseProductBuilder case(String caseId) {
        this.caseProduct.Case__c = caseId;
        return this;
    }

    public CaseProductBuilder status(String status) {
        this.caseProduct.Status__c = status;
        return this;
    }

    public CaseProductBuilder strategy(String strategy) {
        this.caseProduct.Strategy__c = strategy;
        return this;
    }

    public CaseProductBuilder returnPercentage(Integer percentage) {
        this.caseProduct.Return_percentage__c = percentage;
        return this;
    }

    public CaseProductBuilder save() {
        insert this.caseProduct;
        return this;
    }

    public Case_Product__c build() {
        return this.caseProduct;
    }
}