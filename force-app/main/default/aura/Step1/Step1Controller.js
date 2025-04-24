/**
 * Created by patryk.witkowski_bri on 4/18/2025.
 */

({
    doInit: function (component, event, helper) {
        console.log("ON INIT");
        component.getEvent("updateData").setParams({"products": []}).fire();
        component.set("v.columns", [
            {label: "Product Name", fieldName: "name", type: "text", sortable: false},
            {label: "Category", fieldName: "category", type: "text", sortable: false},
            {
                label: "Price",
                fieldName: "price",
                type: "currency",
                sortable: false,
                typeAttributes: {currencyCode: "USD"}
            }
        ]);
        helper.fetchProducts(component);
        helper.fetchCategories(component);
    },
    handleRowSelection: function (component, event, helper) {
        let selectedRows = event.getParam("selectedRows");
        let persistData = component.get("v.persistData");
        let isUserSelection = component.get("v.isUserSelection");
        let previousSelectedRows = component.get("v.previousSelectedRows") || [];


        selectedRows.forEach(row => {
            if (!persistData.some(item => item.productId === row.productId)) {
                persistData.push(row);
            }
        });

        if (isUserSelection && previousSelectedRows.length > 0) {
            persistData = persistData.filter(item => {
                return !previousSelectedRows.some(prev =>
                    prev.productId === item.productId &&
                    !selectedRows.some(selected => selected.productId === item.productId)
                );
            });
        }

        component.set("v.persistData", persistData);
        component.set("v.previousSelectedRows", selectedRows.slice());
        component.set("v.isUserSelection", true);

        helper.handleSelected(component);
        let componentEvent = component.getEvent("updateData");
        componentEvent.setParams({
            "products": persistData
        });
        componentEvent.fire();
    },
    handleChange: function (component, event, helper) {
        component.set("v.pageNumber", 1);
        component.set("v.selectedCategories", event.getParam('value'));
        helper.fetchProducts(component)
    },
    handleClick: function (component, event, helper) {
        let val = component.get("v.expand");
        component.set("v.expand", !val);
    },

    handlePrevious: function (component, event, helper) {
        var pageNumber = component.get("v.pageNumber");
        component.set("v.pageNumber", pageNumber - 1);
        helper.fetchProducts(component);
    },

    handleNext: function (component, event, helper) {
        var pageNumber = component.get("v.pageNumber");
        component.set("v.pageNumber", pageNumber + 1);
        helper.fetchProducts(component);
    }
})