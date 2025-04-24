/**
 * Created by patryk.witkowski_bri on 4/17/2025.
 */

({
    stepMap: {
        step1: 'c:Step1',
        step2: 'c:Step2',
    },

    loadStepComponent: function(component) {
        console.log("current data after changes")
        let currentStep = component.get("v.currentStep");
        console.log('Current step:' + currentStep)
        let componentName = this.stepMap[currentStep];
        let currentData = component.get("v.data");
        console.log("Current data: " + currentData)
        $A.createComponent(
            componentName,
            {
                step: currentStep,
                parentData: currentData
            },
            function(newComponent, status, errorMessage) {
                if (status === "SUCCESS") {
                    console.log('Successfully created component: ' + componentName);
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