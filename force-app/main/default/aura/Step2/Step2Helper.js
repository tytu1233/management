/**
 * Created by patryk.witkowski_bri on 4/25/2025.
 */

({
    createOrder: function (component, opportunityId) {
        let action = component.get("c.createOrderWithProducts");
        component.set("v.disableButton", true);
        let items = component.get("v.parentData");
        let discount = component.get("v.initialPrice") - component.get("v.discountValue");
        let discountIds = component.get("v.discountIds");

        console.log("HELPER ");
        console.log(discountIds);

        action.setParams({
            "opportunityId": opportunityId,
            "products": items,
            "discount": discount,
            "discountIds": discountIds
        });
        action.setCallback(this, function (response) {
            let status = response.getState();
            if (status === "SUCCESS") {
                this.showToast("Success!", "The order has been created successfully.", "success");
                $A.get("e.force:refreshView").fire();
                var dismissActionPanel = $A.get("e.force:closeQuickAction");
                dismissActionPanel.fire();
            }
            if (status === "ERROR") {
                var errors = response.getError();
                var errorMsg = errors && errors[0] && errors[0].message ? errors[0].message : "Unknown error";
                console.log(errorMsg)
                this.showToast("Error!", errorMsg || "There was a problem to create order. Please try again.", "error");
                component.set("v.disableButton", false);
            }
        });

        $A.enqueueAction(action);
    },
    applyDiscounts: function (component, opportunityId) {
        component.set("v.isLoading", true);
        let action = component.get("c.calculateOrderDiscount");
        let price = component.get("v.initialPrice");
        action.setParams({
            "initialPrice": price,
            "opportunityId": opportunityId
        });
        action.setCallback(this, function (response) {
            let status = response.getState();

            if (status === "SUCCESS") {
                console.log(response.getReturnValue());
                component.set("v.finalPrice", response.getReturnValue().priceAfterDiscount);
                component.set("v.discountValue", (price - response.getReturnValue().priceAfterDiscount).toFixed(2));
                component.set("v.discountIds", response.getReturnValue().discountIds);
            }

            if (status === "ERROR") {
                console.log(response.getError());
            }
            component.set("v.isLoading", false);
        });

        $A.enqueueAction(action);
    },
    showToast : function(title, message, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type": type
        });
        toastEvent.fire();
    }
});