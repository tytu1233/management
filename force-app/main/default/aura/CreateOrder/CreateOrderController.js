/**
 * Created by patryk.witkowski_bri on 4/17/2025.
 */

({
    doInit: function(component, event, helper) {
        helper.loadStepComponent(component);
    },

    //CHANGES COMPONENT BASED ON PASSED STEP PARAM
    handleStepChange: function(component, event, helper) {
        let targetStep = event.getParam("step");

        component.set("v.currentStep", targetStep);
        helper.loadStepComponent(component);
    },

    //PRODUCTS FROM STEP 1
    handleUpdateData: function(component, event, helper) {
        let eventData = event.getParam("products");
        component.set("v.data", eventData);
    },

    handleNext: function (component, event, helper) {
        let currentStep = component.get("v.currentStep");
        let nextStep = helper.getNextStep(currentStep);


        let stepChangeEvent = component.getEvent("stepChange");
        stepChangeEvent.setParams({"step": nextStep});
        stepChangeEvent.fire();
    },

    handlePrevious: function(component, event, helper) {
        let currentStep = component.get("v.currentStep");
        let prevStep = helper.getPreviousStep(currentStep);

        let stepChangeEvent = component.getEvent("stepChange");
        stepChangeEvent.setParams({"step": prevStep});
        stepChangeEvent.fire();
    },
})