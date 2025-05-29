/**
 * Created by patryk.witkowski_bri on 5/12/2025.
 */

public with sharing class StandardPriceBookSingleton {

    private static StandardPriceBookSingleton instance = null;
    private final String id;

    private StandardPriceBookSingleton() {
        List<Pricebook2> pb = [
                SELECT Id
                FROM Pricebook2
                WHERE IsStandard = TRUE
                LIMIT 1
        ];

        if(pb.isEmpty()) {
            throw new AuraHandledException('Price Book does not exist');
        }

        this.id = pb.get(0).Id;
    }

    public static StandardPriceBookSingleton getInstance() {
        if(instance == null) {
            instance = new StandardPriceBookSingleton();
        }
        return instance;
    }

    public Id getId() {
        return this.id;
    }
}