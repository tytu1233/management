/**
 * Created by patryk.witkowski_bri on 4/18/2025.
 */

({
    doInit: function(component, event, helper) {
        // Access parentData on initialization
        console.log("Data in step2")
        let parentData = component.get("v.parentData");
        parentData.forEach(obj => console.log(obj));
        component.set("v.parentDataString", JSON.stringify(parentData));
        //component.set("v.parentData", JSON.parse(parentData));
        console.log("PARSED DATA");
        //console.log(JSON.parse(parentData))
        console.log("Parent data in step2: " + parentData);
    },
    getChildData: function(component, event, helper) {
        return component.get("v.childData");
    }
})