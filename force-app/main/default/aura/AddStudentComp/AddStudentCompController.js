({
    fetchclassMgmntDetails : function(component, event, helper) {
        var action = component.get("c.fetchStudent");
        action.setParams({
            "classId":component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.classMgmntList", response.getReturnValue());
                
            }
        });
        $A.enqueueAction(action);
        
    }
    
})