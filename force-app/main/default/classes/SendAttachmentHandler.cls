public class SendAttachmentHandler {
    
    @RemoteAction
    public static string SendAttachment(String sEmailAddress, String ClassId){
        String sMessage='';
        try{            
            Messaging.SingleEmailMessage semail = new Messaging.SingleEmailMessage();
            Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
            // Replace Visualforce(AccountDetails) page with your visualforce page
            PageReference pref = page.ClassDetails;
            pref.getParameters().put('id',ClassId);
            pref.setRedirect(true);
            Blob b = pref.getContent();
            attach.setFileName('Class Details.pdf');
            attach.setBody(b);
            semail.setSubject('Class Details');
            semail.setToAddresses(new List<String>{sEmailAddress});
            semail.setPlainTextBody('Please find the attached Class details');
            semail.setFileAttachments(new Messaging.EmailFileAttachment[]{attach});
            Messaging.sendEmail(new Messaging.SingleEmailMessage[]{semail});
            sMessage='SUCCESS';
        }
        catch(Exception ex){
            sMessage=ex.getMessage()+'\n'+ex.getLineNumber()+'\n'+ex.getCause();
        }
        return sMessage;
    }
 }