/**
 * Created by patryk.witkowski_bri on 5/15/2025.
 */

public class ProductBuilder {

    private final Product2 product;

    public ProductBuilder(String name, Decimal basePrice) {
        this.product = new Product2();
        this.product.Name = name;
        this.product.Base_Price__c = basePrice;
    }

    public ProductBuilder name(String name) {
        this.product.Name = name;
        return this;
    }

    public ProductBuilder basePrice(Decimal price) {
        this.product.Base_Price__c = price;
        return this;
    }

    public ProductBuilder family(String family) {
        this.product.Family = family;
        return this;
    }

    public ProductBuilder active(Boolean active) {
        this.product.IsActive = active;
        return this;
    }

    public ProductBuilder external(Boolean external) {
        this.product.IsExternal__c = external;
        return this;
    }

    public ProductBuilder productCode(String code) {
        this.product.ProductCode = code;
        return this;
    }

    public ProductBuilder save() {
        insert this.product;
        return this;
    }

    public Product2 build() {
        return this.product;
    }

}