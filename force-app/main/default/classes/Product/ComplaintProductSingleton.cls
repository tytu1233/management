/**
 * Created by patryk.witkowski_bri on 5/27/2025.
 */

public class ComplaintProductSingleton {
    private static ComplaintProductSingleton instance = null;
    private final Id complaintProductId;

    private ComplaintProductSingleton() {
        List<Product2> pbE = [
                SELECT Id
                FROM Product2
                WHERE Name = :Utils.PRODUCT.NAME.Complaint
                AND IsActive = FALSE
                LIMIT 1
        ];

        if(pbE.isEmpty()) {
            throw new HandledException(Utils.PRODUCT.ERROR.ComplaintNotExist);
        }
        this.complaintProductId = pbE.get(0).Id;
    }

    public static ComplaintProductSingleton getInstance() {
        if(instance == null) {
            instance = new ComplaintProductSingleton();
        }
        return instance;
    }

    public Id getComplaintProductId() {
        return complaintProductId;
    }
}