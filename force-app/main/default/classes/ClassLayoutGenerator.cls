/*This class will generate the layout dynamically based on Record Type*/
public class ClassLayoutGenerator {
  //Stores the Object name from URL
  public static String objName = 'SFDC_Class__c';
  //Stores the Record Type Id from URL if there is a Record Type
  public static String recordType = ApexPages.currentPage().getParameters().get('recordType') != null ? 
                                    ApexPages.currentPage().getParameters().get('recordType') : '';
  //Stores the SObject record we are processing
  public SObject controller{get; set;}
  
  public string instructor1 {get; set;}
  public string instructor2 {get; set;}
  //Stores the Layout details 
  public static final HTTPResponse resp;
  //Parses and stores the instance URL from the current URL
  public static String Instance {
    public get {
      if (Instance == null) {
        List<String> parts = System.URL.getSalesforceBaseUrl().getHost().replace('-api','').split('\\.');
        if (parts.size() == 3) Instance = parts[0];
        else if (parts.size() == 5) Instance = parts[1];
        else Instance = null;
      } 
      return Instance;
    } 
    private set;
  }
  
  //This methods returns the base URL of current instance
  public static String GetBaseUrlForInstance() {
     return 'https://' + Instance + '.salesforce.com';
  }
  
  //Return SObject and its values to the Visualforce page for display
  public SObject getSObject() {
    return this.controller;
  }
  
  //Sending a request to REST API to get the describeLayout information using object name and record type and storing the response in resp variable
  static {
    HTTP h = new HTTP();
    HTTPRequest req = new HTTPRequest();
    req.setMethod('GET');
    req.setHeader('Content-Type', 'application/xml;charset=UTF-8');
    req.setHeader('Accept', 'application/xml');
    req.setHeader('Authorization','Bearer '+ UserInfo.getSessionId());
       system.debug('sessionid'+UserInfo.getSessionId());
    req.setEndpoint(Url.getOrgDomainUrl().toExternalForm() + '/services/data/v50.0/sobjects/' + objName + '/describe/layouts/' + recordType);
    system.debug('endpoint'+req);
    resp = h.send(req);
  }
  
  //Describe the constructor
  public ClassLayOutGenerator(ApexPages.StandardController c) { 
    if(!Test.isRunningTest()) 
      c.addFields(new List<String>{'Name'});  
    //Assign Current User as Record Owner
    c.getRecord().put('OwnerId',UserInfo.getUserId());   
    //Get the record
    controller = c.getRecord();
  }
  
  public ClassLayOutGenerator() {
  }
    
  //This method returns the form dynamically based on the standard layout details stored in resp variable
  public Component.Apex.Form getEditForm() {    
    string label = Schema.describeSObjects(new List<String>{objName})[0].getLabel();
    //Create the form
    Component.Apex.Form editForm = new Component.Apex.Form();
    editForm.Id = 'editForm';
    //Create a header with title as 'Object Name plus Edit'
    Component.Apex.SectionHeader sectionHeader = new Component.Apex.SectionHeader();
    sectionHeader.title = label + ' Edit';
    sectionHeader.subtitle = controller.get('Name') == null ? ('New ' + label) : String.valueOf(controller.get('Name'));
    //Add the section header to the form
    editForm.childComponents.add(sectionHeader);
    //Create a Page Block with title as 'Object Name plus Edit'
    Component.Apex.PageBlock editPageBlock = new Component.Apex.PageBlock();
    editPageBlock.title = label + ' Edit';
    editPageBlock.mode = 'edit';
    editPageBlock.Id = 'editPageBlock'; 
    //Create Page Messages component and add it to the page block to display messages like validation errors etc.
    Component.Apex.PageMessages msg = new Component.Apex.PageMessages();
    msg.escape = false;
    msg.Id = 'pageMessages';
    
    editPageBlock.childComponents.add(msg);
    
    Component.Apex.ActionRegion ar = new Component.Apex.ActionRegion();
    ar.Id = 'actionRegion';
    
    //Create the required buttons
    Component.Apex.PageBlockButtons pgButtons = new Component.Apex.PageBlockButtons();
    
    Component.Apex.OutPutPanel buttons = new Component.Apex.OutPutPanel();
    buttons.Id = 'buttons';
    
    //Save and Add Contact Button
    Component.Apex.CommandButton save = new Component.Apex.CommandButton();
    save.value = 'Save';
    save.Id = 'save';
    save.expressions.action = '{!save}';
    buttons.childComponents.add(save);  
    
    //Cancel button 
    Component.Apex.CommandButton cancelButton = new Component.Apex.CommandButton();
    cancelButton.value = 'Cancel';
    cancelButton.expressions.action = '{!Cancel}';
    buttons.childComponents.add(cancelButton);
    
    pgButtons.childComponents.add(buttons);
    
    //Add buttons to the Page Block
    editPageBlock.childComponents.add(pgButtons);
        
    //Store the describe layout response into another variable to access
    HTTPResponse res = resp;
    Dom.Document doc = res.getBodyDocument();
        
    //Retrieve the root element for this document.
    Dom.XMLNode el = doc.getRootElement();
    
    //Array to store the editlayout sections
    Dom.XMLNode[] els = new Dom.XMLNode[]{};
    
    //Get all the editLayout sections and store them into the array 
    for(Dom.XMLNode n : recordType != '' ? el.getChildElements() : el.getChildElement('layouts',null).getChildElements()) {
      if(n.getName() == 'editLayoutSections')
        els.add(n);
    }
    
    //To store whether a field is editable or not for new record 
    map<String, String> editable = new map<String, String>();
    //To store whether a field is required or not
    map<string, boolean> required = new map<String, boolean>();
    //Start building the layout
    for(Dom.XMLNode n : els) {
      Integer count = 0;     
      //Create a page block section for eidt layout section
      Component.Apex.PageBlockSection section = new Component.Apex.PageBlockSection();            
      //columns of the page block section
      section.columns = Integer.valueOf(n.getChildElement('columns', null).getText());             
      //Column1 elements
      map<Dom.XMLNode, String> col1 = new map<Dom.XMLNode, String>();    
      //column2 elements
      map<Dom.XMLNode, String> col2 = new map<Dom.XMLNode, String>();      
      //Get the fields and divide them into column1 and column2 and store them in the arrays defined in the above steps
      for(Dom.XMLNode lr : n.getChildElements()) {
        //Get the rows of the section
        If(lr.getName() == 'layoutRows') {
          for(Dom.XMLNode lt : lr.getChildElements()) {
            //Get the items in the row
            If(lt.getName() == 'layoutItems') {                                
              for(Dom.XMLNode lc : lt.getChildElements()) {
                //Get the layoutcomponents of the item
                If(lc.getName() == 'layoutComponents') {                                 
                  //Getting whether the field is editable or not for new record and add it to the map variable 'editable'
                  editable.put(lc.getChildElement('value',null).getText(), lt.getChildElement('editableForNew',null).getText());
                  //Getting whether the field is required or not and adding it to the map variable 'required'
                  required.put(lc.getChildElement('value',null).getText(), Boolean.valueOf(lt.getChildElement('required', null).getText()));
                  //If the layoutcomponent is just one field and not a group of fields
                  if(lc.getChildElement('components',null) == null && Boolean.valueOf(lt.getChildElement('editableForNew',null).getText())) {
                    //If this layout item is first element of the layout row then add layoutComponent to col1 otherwise add to col2
                    if(lt == lr.getChildElements()[0])
                      col1.put(lc,lt.getChildElement('label',null).getText());                     
                    else                     
                      col2.put(lc,lt.getChildElement('label',null).getText());                     
                  }                                  
                }
              }
            }
          }
        }
      }
      
      //title of the page block section
      if(n.getChildElement('useHeading',null).getText() == 'true')
        section.title = n.getChildElement('heading', null).getText(); 
        
      List<Dom.XMLNode> l1 = new List<Dom.XMLNode>(col1.KeySet());
      List<Dom.XMLNode> l2 = new List<Dom.XMLNode>(col2.KeySet());  
      map<string, Schema.SObjectField> fields = Schema.describeSObjects(new list<string>{'SFDC_Class__c'})[0].fields.getMap();     
      //Add the fields to the Page block section based on whether the field is editable for new record or not
      for(integer i = 0; i < (col1.size() > col2.size() ? col1.size() : col2.size()); i++) {       
        //Column1 is having a field,then add a field
        If(i < l1.size()){
          String fieldName = l1[i].getChildElement('value',null).getText();
          //If the field is editable for new record create an input field component
          If(Boolean.valueOf(editable.get(fieldName))) {
             //Page block section item to display label and the field
            Component.Apex.PageBlockSectionItem pi = new Component.Apex.PageBlockSectionItem();  
            pi.helpText = fields.get(fieldName).getDescribe().getInlineHelpText();          
            //Create OutputLabel with value as the label of the field
            Component.Apex.OutPutLabel ol = new Component.Apex.OutPutLabel();
            ol.value = col1.get(l1[i]);
            //Add OutPutLabel to Page Block Scetion Item
            pi.childComponents.add(ol);
            if(fieldName == 'Location__c' || fieldName == 'Instructor_ID__c' || fieldName == 'Instructor_ID_2__c') {          
              Component.Apex.OutputPanel thePanel = new Component.Apex.OutputPanel();
              Component.Apex.InputHidden theHid = new Component.Apex.InputHidden();
              theHid.Id = fieldName;
              theHid.expressions.value = '{!' + objName + '.' + fieldName + '}';
              Component.Apex.InputText theText = new Component.Apex.InputText();
              theText.size = 30;
              theText.expressions.value = fieldName == 'Location__c' ? '{!location}'
                                          : (fieldName == 'Instructor_ID__c' ? '{!instructor1}' : '{!instructor2}');
              theText.Id = fieldName == 'Location__c' ? 'Location' : (fieldName == 'Instructor_ID__c' ? 'instructor1' : 'instructor2');
              theText.onFocus = 'this.blur()';
              theText.disabled = false;
              Component.Apex.OutputLink theLink = new Component.Apex.OutputLink();
              theLink.onclick = 'openLookupPopup(\'{!$Component.' + theText.Id + '}\', \'{!$Component.' + fieldName + '}\'); return false';          
              Component.Apex.Image image = new Component.Apex.Image(value = '/s.gif', StyleClass = 'lookupIcon'); 
              theLink.childComponents.add(image);              
              thePanel.childComponents.add(theHid);
              thePanel.childComponents.add(theText);
              thePanel.childComponents.add(theLink);           
              pi.childComponents.add(thePanel);
            }
            else {
              //Create the input field
              Component.Apex.InputField theField = new Component.Apex.InputField();  
              theField.expressions.value = '{!' + objName + '.' + fieldName + '}';
              theField.tabOrderHint = Integer.valueOf(l1[i].getChildElement('tabOrder',null).getText());               
              if(!Test.isRunningTest())
                theField.required = required.get(fieldName);                     
              theField.Id = fieldName;                             
              //Add InputField to Page Block Scetion Item
              //pi.childComponents.add(ol);
              pi.childComponents.add(theField);                                   
            }
            //Add PageBlockSectionItem to the PageBlockSection
            section.childComponents.add(pi);
          }                   
        } 
        
        //If column1 is not having field, add an empty page block section item
        else if(section.columns == 2) {
          Component.Apex.PageBlockSectionItem pi = new Component.Apex.PageBlockSectionItem();
          section.childComponents.add(pi);
        } 
        
        //Column2 is having a field,then add a field
        if(i < l2.size()) { 
          String fieldName = l2[i].getChildElement('value',null).getText();    
          //If the field is editable for new record create an input field component
          If(Boolean.valueOf(editable.get(fieldName))) {
            //Page block section item to display label and the field
            Component.Apex.PageBlockSectionItem pi = new Component.Apex.PageBlockSectionItem();  
            pi.HelpText = fields.get(fieldName).getDescribe().getInlineHelpText();     
            //Create OutputLabel with value as the label of the field
            Component.Apex.OutPutLabel ol = new Component.Apex.OutPutLabel();
            ol.value = col2.get(l2[i]); 
            //Add OutPutLabel to Page Block Scetion Item
            pi.childComponents.add(ol);
            if(fieldName == 'Location__c' || fieldName == 'Instructor_ID__c' || fieldName == 'Instructor_ID_2__c') {
              Component.Apex.OutputPanel thePanel = new Component.Apex.OutputPanel();
              Component.Apex.InputHidden theHid = new Component.Apex.InputHidden();
              theHid.Id = fieldName;
              theHid.expressions.value = '{!' + objName + '.' + fieldName + '}';
              Component.Apex.InputText theText = new Component.Apex.InputText();
              theText.size = 30;
              theText.expressions.value = fieldName == 'Location__c' ? '{!location}'
                                          : (fieldName == 'Instructor_ID__c' ? '{!instructor1}' : '{!instructor2}');
              theText.Id = fieldName == 'Location__c' ? 'Location' : (fieldName == 'Instructor_ID__c' ? 'instructor1' : 'instructor2');
              theText.onFocus = 'this.blur()';
              theText.disabled = false;                       
              Component.Apex.OutputLink theLink = new Component.Apex.OutputLink();
              theLink.onclick = 'openLookupPopup(\'{!$Component.' + theText.Id + '}\', \'{!$Component.' + fieldName + '}\'); return false';          
              Component.Apex.Image image = new Component.Apex.Image(value = '/s.gif', StyleClass = 'lookupIcon'); 
              theLink.childComponents.add(image);              
              thePanel.childComponents.add(theHid);
              thePanel.childComponents.add(theText);            
              thePanel.childComponents.add(theLink);            
              pi.childComponents.add(thePanel);
            }
            else {     
              //Create the input field
              Component.Apex.InputField theField = new Component.Apex.InputField();  
              theField.expressions.value = '{!' + objName + '.' + fieldName + '}';
              theField.tabOrderHint = Integer.valueOf(l2[i].getChildElement('tabOrder',null).getText()); 
              if(!Test.isRunningTest())
                theField.required = required.get(fieldName);                       
              theField.Id = fieldName;           
              //Add InputField to Page Block Scetion Item
              //pi.childComponents.add(ol);
              pi.childComponents.add(theField);
            }                                   
            //Add PageBlockSectionItem to the PageBlockSection
            section.childComponents.add(pi);
          }                   
        } 
        
        //If column2 is not having field, add an empty page block section item 
        else if(section.columns == 2) {
          Component.Apex.PageBlockSectionItem pi = new Component.Apex.PageBlockSectionItem();
          section.childComponents.add(pi);
        } 
      }    
      //Add the PageBlockSection to PageBlock
      editPageBlock.childComponents.add(section);
    }
    ar.childComponents.add(editPageBlock);
    
    //Add the PageBlock to the form
    editform.childComponents.add(ar);
    
    //Return the form we built
    return editForm; 
  }  
}