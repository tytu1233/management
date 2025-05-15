/**
 * Created by patryk.witkowski_bri on 5/14/2025.
 */

public class PricebookBuilder {
    private final Pricebook2 pricebook2;

    public PricebookBuilder(String name) {
        this.pricebook2 = new Pricebook2();
        this.pricebook2.Name = name;
    }

    public PricebookBuilder name(String name) {
        this.pricebook2.Name = name;
        return this;
    }

    public PricebookBuilder active(Boolean active) {
        this.pricebook2.IsActive = active;
        return this;
    }

    public Pricebook2 build() {
        return this.pricebook2;
    }
}