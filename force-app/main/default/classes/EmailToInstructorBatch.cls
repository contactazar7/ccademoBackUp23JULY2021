global class EmailToInstructorBatch implements Database.Batchable < sobject > {
global Database.QueryLocator start(Database.BatchableContext bc) {
       String Query;
       Query = 'SELECT Name,Id,Start_Date__c,End_Date__c,Instructor_ID__r.Email__c,Instructor_ID__r.Name From SFDC_Class__c ';
       return Database.getquerylocator(Query);
       }

global void execute(Database.BatchableContext bc, List < SFDC_Class__c > classlist) {
    //   List < Messaging.SingleEmailMessage > emails = new List < Messaging.SingleEmailMessage > ();
       Date dt = system.TODAY() + 2;
       for (SFDC_Class__c cl: classlist) {
           if(dt>= cl.Start_Date__c && cl.Start_Date__c!=cl.End_Date__c)
           {
               String sMessage='';
        try{     
            system.debug('date'+cl.Start_Date__c);
            Messaging.SingleEmailMessage semail = new Messaging.SingleEmailMessage();
            Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
            // Replace Visualforce(AccountDetails) page with your visualforce page
            PageReference pref = page.ClassDetails;
            pref.getParameters().put('id',cl.id);
            pref.setRedirect(true);
            Blob b = pref.getContent();
            attach.setFileName('Class Details.pdf');
            attach.setBody(b);
            semail.setSubject('Class Details');
            semail.setToAddresses(new List<String>{cl.Instructor_ID__r.Email__c});
            semail.setPlainTextBody(' Hi '+cl.Instructor_ID__r.Name+', \n We have scheduled a class on '+String.valueOf(cl.Start_Date__c).removeEnd(' 00:00:00')+'. Please kindly send the attached PDF as mail to the student. \n Regards,\n CLTCEC.');
            semail.setFileAttachments(new Messaging.EmailFileAttachment[]{attach});
            Messaging.sendEmail(new Messaging.SingleEmailMessage[]{semail});
             sMessage='SUCCESS';
        }
        catch(Exception ex){
            sMessage=ex.getMessage()+'\n'+ex.getLineNumber()+'\n'+ex.getCause();
        }
       
               if(cl.Start_Date__c!=cl.End_Date__c)
               {
                   cl.Start_Date__c=cl.Start_Date__c+1;
                   system.debug('date'+cl.Start_Date__c);
               }
       // update opplist;
         // SendAttachmentHandler.SendAttachment(cl.Instructor_ID__r.Email__c, cl.id);
                }
           }
      
       }

global void finish(database.BatchableContext bc) {}
}