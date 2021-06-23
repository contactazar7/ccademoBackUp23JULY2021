public with sharing class CMController {  
   @AuraEnabled  
   public static string saveContact(Class_Management__c contactRec, string file, string fileName,Id parentId) {  
     string contactId;  
     try{  
       Insert contactRec;  
       parentId= contactRec.Id;  
       String base64File = EncodingUtil.urlDecode(file, 'UTF-8');     
       ContentVersion contentVersionRec = new ContentVersion();  
       contentVersionRec.Title = fileName;  
       contentVersionRec.PathOnClient = '/' + fileName;  
       contentVersionRec.FirstPublishLocationId = contactRec.Id;  
       contentVersionRec.VersionData = EncodingUtil.base64Decode(base64File);  
       contentVersionRec.IsMajorVersion = true;  
       Insert contentVersionRec;  
     } catch(Exception ex){  
       system.debug('Exception===>'+ex.getMessage());  
     }  
     return contactId;  
   }    
 }