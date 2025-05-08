/**
 * Created by patryk.witkowski_bri on 4/17/2025.
 */

({
    stepMap: {
        step1: 'c:Step1',
        step2: 'c:Step2',
    },

    loadStepComponent: function(component) {
        let currentStep = component.get("v.currentStep");
        let opportunityId = component.get("v.recordId");
        let componentName = this.stepMap[currentStep];
        let currentData = component.get("v.data");

        $A.createComponent(
            componentName,
            {
                step: currentStep,
                parentData: currentData,
                opportunityId: opportunityId
            },
            function(newComponent, status, errorMessage) {
                if (status === "SUCCESS") {
                    component.set("v.stepComponent", newComponent);
                } else {
                    console.error('Error creating component: ' + componentName + ', Error: ' + errorMessage);
                }
            }
        );
    },

    getNextStep: function(currentStep) {
        switch (currentStep) {
            case "step1":
                return "step2";
            default:
                return currentStep;
        }
    },

    getPreviousStep: function(currentStep) {
        switch (currentStep) {
            case "step2":
                return "step1";
            default:
                return currentStep;
        }
    }
})