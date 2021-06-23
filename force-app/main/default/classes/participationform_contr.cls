public class participationform_contr {
    public static string seekerfirstname{get;set;}
    public static string seekerlastname{get;set;}
    public static integer seekerage {get;set;}
    public static string seekeremail{get;set;}
    public static string seekerphone{get;set;}
    public static Boolean participation {get;set;}
    public static Boolean C_Interested_in_availing_services_with_CLT{get;set;}
    public static Boolean Acknowledgement_Checkbox {get;set;}
    public static string selectvals{get;set;}
    public static Boolean success {get;set;}
    public static string educationsqual{get;set;}
    
    public static string C_Need_Provider_for_how_many_days{get;set;}
    public static time C_What_are_the_timings{get;set;}
    public Lead__c lead{get;set;}
    
    //provider fields
    public static Boolean consumerform1 {get;set;}
    public static Boolean consumerthankyoupage {get;set;}
    
    public participationform_contr(){
        consumerform1 = true;
        consumerthankyoupage = false;
    }
    
    public static void submit(){
        
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
            && seekerage <> 0 && (selectvals.contains('Male') || selectvals.contains('Female') || selectvals.contains('Other')) && (Acknowledgement_Checkbox == true)){
               consumerform1 = false;
               consumerthankyoupage = true;
               system.debug('consumerform1= '+consumerform1);
               system.debug('seekerfirstname= '+seekerfirstname);
               system.debug('seekerlastname= '+seekerlastname);
               system.debug('seekerage= '+seekerage);
               system.debug('seekeremail= '+seekeremail);
               system.debug('seekerphone= '+seekerphone);
               system.debug('selectvals= '+selectvals);
               //system.debug('educationsqual= '+educationsqual);
               
               try{
                   List<Lead__c> leadlst = [Select Id,Name,FirstName__c,LastName__c,Email__c ,isConvert__c, MobilePhone__c,Age__c,Education_Qualification__c,Gender__c,
                                            Interested_in_availing_services_with_CLT__c,Ailment__c,Need_Provider_for_how_many_days__c,What_are_the_timings__c,Acknowledgement_Checkbox__c From Lead__c where Email__c=:seekeremail OR MobilePhone__c =:seekerphone];
                   Lead__c lead = new Lead__c();
                   system.debug('leadlst-'+leadlst);
                   
                   if(!leadlst.isEmpty()){
                       for(Lead__c l: leadlst){
                          // l.Name = seekerfirstname+''+seekerlastname;
                           l.FirstName__c = seekerfirstname;
                           l.LastName__c = seekerlastname;
                           l.Age__c = seekerage;
                           l.Email__c = seekeremail;
                           l.MobilePhone__c =  seekerphone;  
                           l.Phone__c = seekerphone;
                           l.Interested_in_availing_services_with_CLT__c  = C_Interested_in_availing_services_with_CLT;
                           l.Gender__c = selectvals;
                           //l.Education_Qualification__c = educationsqual;
                           l.Acknowledgement_Checkbox__c = Acknowledgement_Checkbox;
                           l.isConvert__c = true;
                       }
                   }
                   update leadlst;
                   system.debug('leadlst==='+leadlst);
                   success = true;
                   if(success){
                       consumerform1 = false;
                       consumerthankyoupage = true;
                       system.debug('consumerform1= '+consumerform1);
                       system.debug('consumerthankyoupage= '+consumerthankyoupage);
                   }
               }catch(DMLException ex){
                   success = false;
                   ApexPages.addMessages(ex);
               }
           }else{
               consumerform1 = true;
               consumerthankyoupage = false;
               system.debug('consumerform1= '+consumerform1);
               system.debug('consumerthankyoupage= '+consumerthankyoupage);
               
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
               } else if(Acknowledgement_Checkbox == false){
                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please accept the acknowledgement checkbox '));
               }
           }
    }
}