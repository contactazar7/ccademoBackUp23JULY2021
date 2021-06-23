public class IconsForContact1 {
    public contact conrec {get;set;}
    public string accId {get;set;}
    public String contId {get;set;}
    public IconsForContact1 (ApexPages.StandardController controller){
        contId =controller.getRecord().id;

        system.debug('contId===='+contId);
        conrec= new contact();
        if(contId!=null){
 
        conrec= [Select id,Last_Name__c,SQCheck__c,AD8Check__c,Participation_form_submitted__c,Consumer_Participation_form_submitted__c
                 from contact where id=:ApexPages.currentPage().getParameters().get('id')];
        system.debug('Id:'+conrec);
                        }}
                           }