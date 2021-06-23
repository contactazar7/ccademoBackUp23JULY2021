public with sharing class generatePDFcnt {
    
    public ID parentId {get;set;}
    public String pdfName {get;set;}
    
    public static void savePdf(id parentId) {
        
        contact cnt = [select id,Name,FirstName, LastName, Email,Age__c,Phone_number__c,Gender__c From contact where id=:parentId];
        system.debug('contact id '+cnt);
        
        PageReference pdf = Page.contactPDF;
        pdf.getParameters().put('id',parentId);
        
        Attachment attach = new Attachment();
        
        Blob body;
        
        try {
            
            body = pdf.getContent();
            
        } catch (VisualforceException e) {
            body = Blob.valueOf('Some Text');
        }
        
        attach.Body = body;
        attach.Name = cnt.Name;
        attach.IsPrivate = false;
        attach.ParentId = cnt.id;
        insert attach;
        
        
    }
    
}