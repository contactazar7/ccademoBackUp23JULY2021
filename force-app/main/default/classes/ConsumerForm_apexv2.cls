public class ConsumerForm_apexv2 {
    
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
    public static string selectvals{get;set;}
    public static Boolean success {get;set;}
    public Lead__c lead{get;set;}
    public List<Lead__c> leadlst{get;set;}
    
    
    //provider fields
    public static string educationsqual{get;set;}
    
    public static Boolean consumerform1 {get;set;}
    public static Boolean consumerform2 {get;set;}
    public static Boolean consumerform3 {get;set;}
    public static Boolean consumerform4 {get;set;}
    public static Boolean consumerthankyoupage {get;set;}
    
    public ConsumerForm_apexv2(){
        
        consumerform1 = true;
        consumerform2 = false;
        consumerform3 = false;
        consumerform4 = false;
        consumerthankyoupage = false;
        
        participation = false;
        Lead__c leadlist = new Lead__c();
        //hideConsumerform1= false;
        
    }
    
    public static void consumerfrm_1_nxt(){
        
        system.debug('seekerfirstname= '+seekerfirstname);
        system.debug('seekerlastname= '+seekerlastname);
        system.debug('seekerage= '+seekerage);
        system.debug('seekeremail= '+seekeremail);
        system.debug('seekerphone= '+seekerphone);
        system.debug('selectvals= '+selectvals);
        system.debug('educationsqual= '+educationsqual);
        system.debug('C_Interested_in_availing_services_with_CLT='+C_Interested_in_availing_services_with_CLT);
        
        if(string.isNotBlank(seekerfirstname) && string.isNotBlank(seekerlastname) && string.isNotBlank(seekeremail) 
           && string.isNotBlank(seekerphone) && string.isNotBlank(string.valueOf(seekerage))  && (C_Interested_in_availing_services_with_CLT == true) 
           && string.isNotBlank(educationsqual)  && seekerage <> 0 && (selectvals.contains('Male') 
           || selectvals.contains('Female') || selectvals.contains('Other'))){
               consumerform1 = false;
               consumerform2 = true;
               system.debug('consumerform1= '+consumerform1);
               system.debug('consumerform2= '+consumerform2);
               system.debug('seekerfirstname= '+seekerfirstname);
               system.debug('seekerlastname= '+seekerlastname);
               system.debug('seekerage= '+seekerage);
               system.debug('seekeremail= '+seekeremail);
               system.debug('seekerphone= '+seekerphone);
               system.debug('selectvals= '+selectvals);
               system.debug('educationsqual= '+educationsqual);
               
           }else{
               consumerform1 = true;
               consumerform2 = false;
               system.debug('consumerform1= '+consumerform1);
               system.debug('consumerform2= '+consumerform2);
               
               if(string.isBlank(seekerfirstname)){
                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please enter your firstname'));
               }else if(string.isBlank(seekerlastname)){
                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please enter your lastname'));
               }else if(seekerage == 0){
                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please enter your age'));
                   
               }else if(selectvals.contains('ChooseYourGender')){
                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please choose your gender'));
               }else if(string.isBlank(seekeremail)){
                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please enter email Id'));
               }else if(string.isBlank(seekerphone)){
                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please enter personal phone number'));
               }else if(C_Interested_in_availing_services_with_CLT == false){
                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Are you interested in availing services in CLTCEC '));
               }else if(string.isBlank(educationsqual)){
                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please provide your Education Qualification '));
               }
           }
    }
    
    public void consumerfrm_2_prev(){
        system.debug('show this when called from the previous');
        system.debug('consumerform1 '+consumerform1);
        system.debug('consumerform2 '+consumerform2);
        system.debug('seekerfirstname= '+seekerfirstname);
        system.debug('seekerlastname= '+seekerlastname);
        system.debug('seekerage= '+seekerage);
        system.debug('seekeremail= '+seekeremail);
        system.debug('seekerphone= '+seekerphone);
        consumerform1 = true;
        consumerform2 = false;
        
    }
    
    public void consumerfrm_2_nxt(){
        system.debug('show this when called from the next');
        system.debug('seekerfirstname= '+seekerfirstname);
        system.debug('seekerlastname= '+seekerlastname);
        system.debug('seekerage= '+seekerage);
        system.debug('seekeremail= '+seekeremail);
        system.debug('seekerphone= '+seekerphone);
        if((C_Interested_in_availing_services_with_CLT == true) && string.isNotBlank(ailment) && string.isNotBlank(C_Need_Provider_for_how_many_days)){
            system.debug('show this when called from the next from inside if');
            consumerform1 = false;
            consumerform2 = false;
            consumerform3 = true;
            consumerform4 = false;
            
            system.debug('consumerform1 '+consumerform1);
            system.debug('consumerform2 '+consumerform2);
            system.debug('consumerform3 '+consumerform2);
            system.debug('consumerform4 '+consumerform2);
            
            system.debug('seekerfirstname= '+seekerfirstname);
            system.debug('seekerlastname= '+seekerlastname);
            system.debug('seekerage= '+seekerage);
            system.debug('seekeremail= '+seekeremail);
            system.debug('seekerphone= '+seekerphone);
            system.debug('C_Interested_in_availing_services_with_CLT = '+C_Interested_in_availing_services_with_CLT);
            system.debug('ailment= '+ailment);
            system.debug('C_Need_Provider_for_how_many_days= '+C_Need_Provider_for_how_many_days);
        }else if(C_Interested_in_availing_services_with_CLT == false){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please let us know Are you interested in availing services with CLT?'));
        }else if(string.isBlank(ailment)){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please mention your Health Problem!'));
        }
        else if(string.isBlank(C_Need_Provider_for_how_many_days)){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please mention How many day you would require a care?'));
        }
    }
    
    public void consumerfrm_3_prev(){
        system.debug('show this when called from the consumerfrm_3_prev');
        system.debug('consumerform1 '+consumerform1);
        system.debug('consumerform2 '+consumerform2);
        system.debug('seekerfirstname= '+seekerfirstname);
        system.debug('seekerlastname= '+seekerlastname);
        system.debug('seekerage= '+seekerage);
        system.debug('seekeremail= '+seekeremail);
        system.debug('seekerphone= '+seekerphone);
        consumerform1 = false;
        consumerform2 = true;
        consumerform3 = false;
        consumerform4 = false;
        
    }
    
    public void consumerfrm_3_nxt(){
        system.debug('show this when called from the consumerfrm_3_nxt ');
        system.debug('seekerfirstname= '+seekerfirstname);
        system.debug('seekerlastname= '+seekerlastname);
        system.debug('seekerage= '+seekerage);
        system.debug('seekeremail= '+seekeremail);
        system.debug('seekerphone= '+seekerphone);
        system.debug('C_Interested_in_availing_services_with_CLT = '+C_Interested_in_availing_services_with_CLT);
        system.debug('ailment= '+ailment);
        system.debug('C_Need_Provider_for_how_many_days= '+C_Need_Provider_for_how_many_days);
        
        
        
        if(string.isNotBlank(consent_form_seekrName) && string.isNotBlank(consent_form_seekrparentName) && string.isNotBlank(consent_form_seekrresident) && string.isNotBlank(consent_form_seekrtreatment) && string.isNotBlank(consent_form_seekrrelatedName) && string.isNotBlank(consent_form_seekrRelated)){
            system.debug('show this when called from the next from inside if consumerfrm_3_nxt');
            
            consumerform1 = false;
            consumerform2 = false;
            consumerform3 = false;
            consumerform4 = true;
            
            
            system.debug('consumerform1 '+consumerform1);
            system.debug('consumerform2 '+consumerform2);
            system.debug('consumerform3 '+consumerform2);
            system.debug('consumerform4 '+consumerform2);
            
            system.debug('seekerfirstname= '+seekerfirstname);
            system.debug('seekerlastname= '+seekerlastname);
            system.debug('seekerage= '+seekerage);
            system.debug('seekeremail= '+seekeremail);
            system.debug('seekerphone= '+seekerphone);
            system.debug('C_Interested_in_availing_services_with_CLT = '+C_Interested_in_availing_services_with_CLT);
            system.debug('ailment= '+ailment);
            system.debug('C_Need_Provider_for_how_many_days= '+C_Need_Provider_for_how_many_days);
        }else if(string.isBlank(consent_form_seekrName)){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please mention your HealthSeeker Name'));
        }
        else if(string.isBlank(consent_form_seekrparentName)){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please mention HealthSeeker Parent/Gaurdian Name'));
        }
        else if(string.isBlank(consent_form_seekrresident)){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please mention Your current residing address'));
        }
        else if(string.isBlank(consent_form_seekrtreatment)){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please mention HealthSeeker care!'));
        }
        else if(string.isBlank(consent_form_seekrrelatedName)){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please mention HealthSeeker Name/Gaurdian Name'));
        }
        else if(string.isBlank(consent_form_seekrRelated)){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please mention HealthSeeker related'));
        }
        
    }
    
    public void consumerfrm_4_prev(){
        system.debug('show this when called from the consumerfrm_4_prev');
        system.debug('consumerform1 '+consumerform1);
        system.debug('consumerform2 '+consumerform2);
        system.debug('seekerfirstname= '+seekerfirstname);
        system.debug('seekerlastname= '+seekerlastname);
        system.debug('seekerage= '+seekerage);
        system.debug('seekeremail= '+seekeremail);
        system.debug('seekerphone= '+seekerphone);
        consumerform1 = false;
        consumerform2 = false;
        consumerform3 = true;
        consumerform4 = false;
        
    }
    
    public void submit(){
        
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
                    l.Phone__c = seekerphone;
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
                    l.Gender__c = selectvals;
                    //l.isConvert__c = true;
                }
            }
            update leadlst;
            system.debug('leadlst==='+leadlst);
            success = true;
            if(success){
                consumerform1 = false;
                consumerform2 = false;
                consumerform3 = false;
                consumerform4 = false;
                consumerthankyoupage = true;
            }
        }catch(DMLException ex){
            success = false;
            ApexPages.addMessages(ex);
        }
    }
}