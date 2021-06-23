({
    // Function called on initial page loading to get contact list from server
	getContactsList : function(component, event, helper) {
        // Helper function - fetchContacts called for interaction with server
		helper.fetchContacts(component, event, helper);
        		helper.fetchEnrolledClass(component, event, helper);
        		helper.attendence(component, event, helper);
        		helper.Providerandaffiliation(component, event, helper);
        helper.consumerclas(component, event, helper);
        helper.consumerandparticiaptionaffi(component, event, helper);

	},

    // Function used to create a new Contact
    newContact: function(component, event, helper) {
        // Global event force:createRecord is used
        var createContact = $A.get("e.force:createRecord");
        // Parameters like apiName and defaultValues are set
        createContact.setParams({
            "entityApiName": "Contact",
            "defaultFieldValues": {
                "AccountId": component.get("v.recordId")
            }
        });
        // Event fired and new contact dialog open
        createContact.fire();
    },

    // Function used to update the contacts
    editContacts: function(component, event, helper) {
                    component.set("v.hiderecordeditform", true);

        component.set("v.hidetable",false);
        // Getting the button element
        var btn = event.getSource();
        // Getting the value in the name attribute
        var name = btn.get('v.name');
        // Getting the record view form and the record edit form elements
        //var recordViewForm = component.find('recordViewForm');
        var recordEditForm = component.find('recordEditForm'); 
        // If button is edit
        if(name=='edit') {
            // Hiding the recordView Form and making the recordEdit form visible
          // $A.util.addClass(recordViewForm,'formHide');
            $A.util.removeClass(recordEditForm,'formHide');
            // Changing the button name and label
            btn.set('v.name','save');
            btn.set('v.label','Save');
            //component.set("v.cancebuttonenable", true);

        }
        else if(name=='save') {
           
            // Calling saveContacts if the button is save
            helper.saveContacts(component, event, helper);
        }
    },
   
gotoURL : function (component, event, helper) {
       var caseIdData = event.currentTarget.getAttribute("data-target");


    alert("ss"+caseIdData);

    var urlEvent = $A.get("e.force:navigateToURL");
    urlEvent.setParams({
      "url": "https://cube84ectest.tfaforms.net/10?PID=" +caseIdData
    });
    urlEvent.fire();
},
   redirectFunction : function(component, event, helper)
{
    var caseIdData = event.currentTarget.getAttribute("data-target");
       alert("ss"+caseIdData);

}
})