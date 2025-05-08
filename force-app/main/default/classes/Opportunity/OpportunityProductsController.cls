public with sharing class OpportunityProductsController {
    @AuraEnabled
    public static OpportunityProductsService.ProductData getProducts(List<String> categoriesFilter, Integer pageSize, Integer pageNumber, String searchQuery){
        try {
            return OpportunityProductsService.getProducts(categoriesFilter, pageSize, pageNumber, searchQuery);
        } catch (Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }

    @AuraEnabled
    public static List<OpportunityProductsService.ProductDTO> getOpportunityProducts(Id opportunityId) {
        try {
            return OpportunityProductsService.getOpportunityProducts(opportunityId);
        } catch (Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }

    @AuraEnabled(Cacheable=true)
    public static OpportunityProductsService.CategoryData getCategories() {
        try {
            return OpportunityProductsService.getCategories();
        } catch (Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }
}