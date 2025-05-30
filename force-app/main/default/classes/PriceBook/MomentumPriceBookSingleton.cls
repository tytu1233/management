/**
 * Created by patryk.witkowski_bri on 5/5/2025.
 */

public with sharing class MomentumPriceBookSingleton {

    private static MomentumPriceBookSingleton instance = null;
    private final Id priceBookId;

    private MomentumPriceBookSingleton() {
        List<Pricebook2> pb = [
                SELECT Id
                FROM Pricebook2
                WHERE Name = :Utils.PRICE_BOOK.NAME.MomentumEventPriceBook
                AND IsActive = TRUE
                LIMIT 1
        ];
        if(pb.isEmpty()) {
            throw new AuraHandledException(Utils.PRICE_BOOK.ERROR.NotExist);
        }
        this.priceBookId = pb.get(0).Id;
    }

    public static MomentumPriceBookSingleton getInstance() {
        if(instance == null) {
            instance = new MomentumPriceBookSingleton();
        }
        return instance;
    }

    public Id getPriceBookId() {
        return this.priceBookId;
    }
}