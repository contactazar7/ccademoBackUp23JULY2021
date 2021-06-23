public class ConsumerForm_apex {
    
    
    
    String s = 'Other';
    public String getString() {
        return s;
    }
    
    public String setString(String s) {
        this.s = s;
        system.debug('s=='+s);
        return s;
    }
    
    public static string seekerfirstname{get;set;}
    public static string seekerlastname{get;set;}
    public static integer seekerage {get;set;}
    public static string seekeremail{get;set;}
    public static string seekerphone{get;set;}
    public static Boolean participation {get;set;}
    public static string ailment{get;set;}
    public static Boolean C_Interested_in_availing_services_with_CLT{get;set;}
    public static string C_Need_Provider_for_how_many_days{get;set;}
    public static time C_What_are_the_timings{get;set;}
    public static integer consent_form_seekrAged{get;set;}
    public static string consent_form_seekrName {get;set;}
    public static string consent_form_seekrparentName{get;set;}
    public static string consent_form_seekrRelated{get;set;}
    public static string consent_form_seekrresident{get;set;}
    public static string consent_form_seekrtreatment{get;set;}
    public static string consent_form_seekrrelatedName{get;set;}
    public static Boolean Acknowledgement_Checkbox {get;set;}
    public static string gender{get;set;}
    public static string selectvals{get;set;}
    public static Boolean success {get;set;}
    public Lead__c lead{get;set;}
    public List<Lead__c> leadlst{get;set;}
    
    public Boolean consumerform1 {get;set;}
    public Boolean consumerformone {get;set;}
    public Boolean consumerform2 {get;set;}
    public Boolean consumerformtwo {get;set;}
    public Boolean consumerform3 {get;set;}
    public Boolean consumerform4 {get;set;}
    
    //public Boolean hideConsumerform1 {get;set;}
    public ConsumerForm_apex(){
        
        consumerform1 = true;
        consumerformone = true;
        consumerform2 = false;
        consumerformtwo = false;
        consumerform3 = false;
        consumerform4 = false;
        
        participation = false;
        Lead__c leadlist = new Lead__c();
        //hideConsumerform1= false;
        
    }
    
    public void consumerfrm_1_nxt(){
        
        
        system.debug('seekerfirstname= '+seekerfirstname);
        system.debug('seekerlastname= '+seekerlastname);
        system.debug('seekerage= '+seekerage);
        system.debug('seekeremail= '+seekeremail);
        system.debug('seekerphone= '+seekerphone);
        
        if(string.isNotBlank(seekerfirstname) && string.isNotBlank(seekerlastname) && string.isNotBlank(seekeremail) && string.isNotBlank(seekerphone)){
            consumerform1 = false;
            consumerform2 = true;
            system.debug('consumerform1= '+consumerform1);
            system.debug('consumerform2= '+consumerform2);
            
            system.debug('seekerfirstname= '+seekerfirstname);
            system.debug('seekerlastname= '+seekerlastname);
            system.debug('seekerage= '+seekerage);
            system.debug('seekeremail= '+seekeremail);
            system.debug('seekerphone= '+seekerphone);
        }else{
            consumerform1 = true;
            consumerform2 = false;
            system.debug('consumerform1= '+consumerform1);
            system.debug('consumerform2= '+consumerform2);
            
            if(string.isBlank(seekerfirstname)){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please enter your firstname'));
            }else if(string.isBlank(seekerlastname)){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please enter your lastname'));
            }
            else if(string.isBlank(seekeremail)){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please enter email Id'));
            }else if(string.isBlank(seekeremail)){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please enter email Id'));
            }else if(string.isBlank(seekerphone)){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please enter personal phone number'));
            }
        }
        
        consumerformone = consumerform1;
        consumerformtwo = consumerform2;
        system.debug('consumerformone '+consumerformone);
        system.debug('consumerformtwo '+consumerformtwo);
    }
    
    public void consumerfrm_2_prev(){
        
        consumerform1 = true;
        consumerform2 = false;
        
        
    }
    
    
    
    public PageReference step1_consumer(){
        system.debug('selectvals= '+selectvals);
        system.debug('seekerfirstname= '+seekerfirstname);
        system.debug('seekerlastname= '+seekerlastname);
        system.debug('seekerage= '+seekerage);
        system.debug('seekeremail= '+seekeremail);
        system.debug('seekerphone= '+seekerphone);
        system.debug('ailment= '+ailment);
        system.debug('Acknowledgement_Checkbox= '+Acknowledgement_Checkbox);
        system.debug('consent_form_seekrAged= '+consent_form_seekrAged);
        system.debug('consent_form_seekrName= '+consent_form_seekrName);
        system.debug('consent_form_seekrparentName= '+consent_form_seekrparentName);
        system.debug('consent_form_seekrRelated= '+consent_form_seekrRelated);
        system.debug('consent_form_seekrresident= '+consent_form_seekrresident);
        system.debug('consent_form_seekrtreatment= '+consent_form_seekrtreatment);
        system.debug('consent_form_seekrrelatedName= '+consent_form_seekrrelatedName);
        system.debug('Acknowledgement_Checkbox= '+Acknowledgement_Checkbox);
        system.debug('gender= '+gender);
        system.debug('C_Interested_in_availing_services_with_CLT = '+C_Interested_in_availing_services_with_CLT);
        system.debug('C_Need_Provider_for_how_many_days= '+C_Need_Provider_for_how_many_days);
        system.debug('C_What_are_the_timings= '+C_What_are_the_timings);
        
        try{
            leadlst = [Select Id,Name,FirstName__c,LastName__c,Email__c ,isConvert__c, MobilePhone__c,Age__c,
                       consent_form_seekrName__c,consent_form_seekrparentName__c,consent_form_seekrAged__c,consent_form_seekrresident__c,
                       consent_form_seekrtreatment__c,consent_form_seekrrelatedName__c,consent_form_seekrRelated__c,Interested_in_availing_services_with_CLT__c,
                       Ailment__c,Need_Provider_for_how_many_days__c,What_are_the_timings__c,Acknowledgement_Checkbox__c From Lead__c where Email__c=:seekeremail OR MobilePhone__c =:seekerphone];
            Lead__c lead = new Lead__c();
            system.debug('leadlst-'+leadlst);
            
            if(!leadlst.isEmpty()){
                for(Lead__c l: leadlst){
                    //l.Name = seekerfirstname+''+seekerlastname;
                    l.FirstName__c = seekerfirstname;
                    l.LastName__c = seekerlastname;
                    l.Age__c = seekerage;
                    l.Email__c = seekeremail;
                    l.MobilePhone__c =  seekerphone;  
                    l.consent_form_seekrName__c = seekerfirstname+''+seekerlastname;
                    l.consent_form_seekrparentName__c = consent_form_seekrparentName;
                    l.consent_form_seekrAged__c = consent_form_seekrAged;
                    l.consent_form_seekrresident__c = consent_form_seekrresident;
                    l.consent_form_seekrtreatment__c = consent_form_seekrtreatment;
                    l.consent_form_seekrrelatedName__c =consent_form_seekrrelatedName;
                    l.consent_form_seekrRelated__c = consent_form_seekrRelated;
                    l.Interested_in_availing_services_with_CLT__c  = C_Interested_in_availing_services_with_CLT;
                    l.Ailment__c = ailment;
                    l.Need_Provider_for_how_many_days__c =C_Need_Provider_for_how_many_days;
                    l.What_are_the_timings__c =C_What_are_the_timings; 
                    l.Acknowledgement_Checkbox__c = Acknowledgement_Checkbox;	
                }
            }
            update leadlst;
            system.debug('leadlst==='+leadlst);
            success = true;
        }catch(DMLException ex){
            success = false;
            ApexPages.addMessages(ex);
        }
        return null;
    }
}