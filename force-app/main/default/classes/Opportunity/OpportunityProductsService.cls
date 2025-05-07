/**
 * Created by patryk.witkowski_bri on 5/4/2025.
 */

public class OpportunityProductsService {
    public static ProductData getProducts(List<String> categoriesFilter, Integer pageSize, Integer pageNumber, String searchQuery){
        try {
            ProductData productData = new ProductData();

            String query = 'SELECT Id, Name, Base_Price__c, Family FROM Product2 WHERE Family != NULL AND IsActive = TRUE';
            String countQuery = 'SELECT COUNT() FROM Product2 WHERE Family != NULL AND IsActive = TRUE';
            String productNameFilter = '%' + String.escapeSingleQuotes(searchQuery) + '%';

            if (!categoriesFilter.isEmpty()) {
                query += ' AND Family IN :categoriesFilter';
                countQuery += ' AND Family IN :categoriesFilter';
            }

            if(!String.isBlank(searchQuery)) {
                query += ' AND Name LIKE :productNameFilter';
                countQuery += ' AND Name LIKE :productNameFilter';
            }

            Integer totalRecords = Database.countQuery(countQuery);
            productData.totalRecords = totalRecords;
            productData.totalPages = (Integer) Math.ceil((Decimal) totalRecords / pageSize);

            Integer offset = (pageNumber - 1) * pageSize;
            query += ' ORDER BY Name LIMIT :pageSize OFFSET :offset';

            List<ProductDTO> productsWrapped = new List<ProductDTO>();
            for (Product2 product : Database.query(query)) {
                ProductDTO wrap = new ProductDTO();
                wrap.name = product.Name;
                wrap.price = product.Base_Price__c;
                wrap.category = product.Family;
                wrap.productId = product.Id;
                productsWrapped.add(wrap);
            }

            productData.products = productsWrapped;
            return productData;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    public static CategoryData getCategories() {
        try {
            CategoryData categoryData = new CategoryData();
            List<AggregateResult> categories = [
                    SELECT Family
                    FROM Product2
                    WHERE Family != NULL
                    GROUP BY Family
            ];

            List<CategoryDTO> categoriesDTOS = new List<CategoryDTO>();

            for (AggregateResult ar : categories) {
                String family = (String) ar.get('Family');
                CategoryDTO categoryDTO = new CategoryDTO();
                categoryDTO.label = family;
                categoryDTO.value = family;
                categoriesDTOS.add(categoryDTO);
            }
            categoryData.productsCategories = categoriesDTOS;
            return categoryData;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    public static List<ProductDTO> getOpportunityProducts(Id opportunityId) {
        List<OpportunityLineItem> opportunityLineItems = [
                SELECT Product2Id
                FROM OpportunityLineItem
                WHERE OpportunityId = :opportunityId
        ];

        Set<Id> productIds = new Set<Id>();

        for(OpportunityLineItem opportunityLineItem : opportunityLineItems) {
            productIds.add(opportunityLineItem.Product2Id);
        }

        List<Product2> products = [
                SELECT Id, Name, Base_Price__c, Family
                FROM Product2
                WHERE Id IN :productIds
        ];

        List<ProductDTO> productDTOS = new List<ProductDTO>();

        for(Product2 product : products) {
            ProductDTO productDTO = new ProductDTO();
            productDTO.name = product.Name;
            productDTO.price = product.Base_Price__c;
            productDTO.category = product.Family;
            productDTO.productId = product.Id;

            productDTOS.add(productDTO);
        }

        return productDTOS;
    }

    public class ProductDTO {
        @AuraEnabled public Id productId;
        @AuraEnabled public String name;
        @AuraEnabled public String category;
        @AuraEnabled public Decimal price;
    }

    public class CategoryDTO {
        @AuraEnabled public String label;
        @AuraEnabled public String value;
    }

    public class ProductData {
        @AuraEnabled public List<ProductDTO> products;
        @AuraEnabled public Integer totalRecords { get; set; }
        @AuraEnabled public Integer totalPages { get; set; }
    }

    public class CategoryData{
        @AuraEnabled public List<CategoryDTO> productsCategories;
    }
}