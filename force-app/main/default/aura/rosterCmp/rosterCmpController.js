({
    init : function(component, event, helper) {
        var pageReference = {
            type: 'standard__component',
            attributes: {
                componentName: 'c__markRosterattendance',
            },
            state: {
                //"Id": "001XXXXXXXXXXXX"
                "Id": "a0A5g000000okHm"
            }
        };
        component.set("v.pageReference", pageReference);
     },
     handleClick: function(component, event, helper) {
        var navService = component.find("navService");
        var pageReference = component.get("v.pageReference");
        event.preventDefault();
        navService.navigate(pageReference);
    }
})