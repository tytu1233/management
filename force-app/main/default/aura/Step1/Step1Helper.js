/**
 * Created by patryk.witkowski_bri on 4/22/2025.
 */

({
    fetchProducts: function(component) {
        component.set("v.isLoading", true);
        var action = component.get("c.getProducts");

        action.setParams({
            "categoriesFilter": component.get("v.selectedCategories"),
            "pageSize": component.get("v.pageSize"),
            "pageNumber": component.get("v.pageNumber"),
            "searchQuery": component.get("v.searchText")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            component.set("v.isLoading", false);
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                component.set("v.productsData", result.products);
                component.set("v.totalRecords", result.totalRecords);
                component.set("v.totalPages", result.totalPages);
                component.set("v.isUserSelection", false);
                this.handleSelected(component);
            } else {
                var errors = response.getError();
                var errorMsg = errors && errors[0] && errors[0].message ? errors[0].message : "Unknown error";
                console.error("Error fetching products:", errorMsg);
            }
        });
        $A.enqueueAction(action);
    },

    fetchOpportunityProducts: function (component) {
        let opportunityId = component.get("v.opportunityId");
        let action = component.get("c.getOpportunityProducts");
        let componentEvent = component.getEvent("updateData");
        action.setParams({
            "opportunityId": opportunityId
        });

        action.setCallback(this, function (response){
            let status = response.getState();

            if (status === "SUCCESS") {
                console.log(response.getReturnValue());
                component.set("v.persistData", response.getReturnValue());
                componentEvent.setParams({
                    "products": response.getReturnValue()
                });
                componentEvent.fire();
            }
        });

        $A.enqueueAction(action);
    },

    fetchCategories: function(component) {
        let action = component.get("c.getCategories");
        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.categoriesData", response.getReturnValue());
            } else if (state === "ERROR") {
                let errors = response.getError();
                let errorMsg = errors && errors[0] && errors[0].message ? errors[0].message : "Unknown error";
                console.error("Error fetching categories:", errorMsg);
            }
        });

        $A.enqueueAction(action);
    },
    handleSelected: function(component) {
        let persistData = component.get("v.persistData") || [];
        let currentData = component.get("v.productsData") || [];

        const selectedIds = currentData
                    .filter(row => persistData.some(p => p.productId === row.productId))
                    .map(row => row.productId);
        component.set("v.selectedRowIds", selectedIds);
    }
});