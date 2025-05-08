/**
 * Created by patryk.witkowski_bri on 4/18/2025.
 */

({
    doInit: function (component, event, helper) {
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
        let data = component.get("v.parentData");
        let opportunityId = component.get("v.opportunityId");
        const price = data.reduce((acc, val) => acc += val.price, 0);
        component.set("v.initialPrice", price);
        helper.applyDiscounts(component, opportunityId);
    },
    handleSubmit: function (component, event, helper) {
        let opportunityId = component.get("v.opportunityId");
        helper.createOrder(component, opportunityId);
    }
})