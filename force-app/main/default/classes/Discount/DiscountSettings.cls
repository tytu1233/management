/**
 * Created by patryk.witkowski_bri on 4/24/2025.
 */

public with sharing class DiscountSettings {

    private static final String settingName = 'Strategy';

    @AuraEnabled(Cacheable=true)
    public static List<DiscountDTO> getDiscountsSettings() {
        List<DiscountDTO> discountDTOS = new List<DiscountDTO>();

        List<Discount_Strategy_Setting__mdt> discountStrategySettings = [
                SELECT Strategy_Types__c
                FROM Discount_Strategy_Setting__mdt
                LIMIT 1
        ];

        if(discountStrategySettings.isEmpty()) {
            throw new AuraHandledException(Utils.DISCOUNT.ERRORS.DiscountStrategyNotExist);
        }

        for(Discount_Strategy_Setting__mdt discount : discountStrategySettings) {
            DiscountDTO discountDTO = new DiscountDTO();
            discountDTO.value = discount.Strategy_Types__c;
            discountDTO.label = discount.Strategy_Types__c;
            discountDTOS.add(discountDTO);
        }

        return discountDTOS;
    }

    @AuraEnabled
    public static void updateDiscountSetting(String metadataType) {
        try {
            Metadata.CustomMetadata customMetadata = new Metadata.CustomMetadata();
            customMetadata.fullName = 'Discount_Strategy_Setting__mdt.' + settingName;
            customMetadata.label = settingName;


            Metadata.CustomMetadataValue metadataValue = new Metadata.CustomMetadataValue();
            metadataValue.field = 'Strategy_Types__c';
            metadataValue.value = metadataType;
            customMetadata.values.add(metadataValue);

            Metadata.DeployContainer metadataContainer = new Metadata.DeployContainer();
            metadataContainer.addMetadata(customMetadata);

            CustomMetadataCallback callback = new CustomMetadataCallback();
            Id deploymentId = Metadata.Operations.enqueueDeployment(metadataContainer, callback);

            System.debug('Deployment ID: ' + deploymentId);
        } catch (Exception ex) {
            System.debug('Exception: ' + ex.getMessage());
            throw new AuraHandledException('Couldn\'t update discount settings');
        }
    }

    public class CustomMetadataCallback implements Metadata.DeployCallback {
        public void handleResult(Metadata.DeployResult result, Metadata.DeployCallbackContext context) {
            if (result.status == Metadata.DeployStatus.SUCCEEDED) {
                System.debug('Metadata update successful.');
            } else {
                System.debug('Metadata update failed: ' + result.details.componentFailures);
                throw new AuraHandledException('Metadata update failed');
            }
        }
    }

    public class DiscountDTO {
        @AuraEnabled public String label {get; set;}
        @AuraEnabled public String value {get; set;}
    }
}