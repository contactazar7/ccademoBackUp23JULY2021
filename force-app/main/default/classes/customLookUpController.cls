public class customLookUpController {
  @AuraEnabled
 public static List < Instructor__c > fetchinstructors2(String searchKeyWord) {
          system.debug('cou'+searchKeyWord);
  String searchKey = searchKeyWord + '%';

  List < Instructor__c > returnList = new List < Instructor__c > ();
  List < Instructor__c > lstOfAccount = [select id,Name,Type_of_Instructor__c,First_Name__c,Last_Name__c from Instructor__c where Name LIKE: searchKey ];
   

  for (Instructor__c acc: lstOfAccount) {
   returnList.add(acc);
  }
  return returnList;
 }
     @AuraEnabled
 public static List < SFDC_Class__c > editrecords(String id) {
     return[select id,Class_Days__c,Instructor_ID__r.Name,Instructor_ID_2__r.Name,Instructor_Id_2_Type__c,Class_type__c,Name,Monday_Start_Time__c,Monday_End_Time2__c,Monday_End_Time__c,Monday_Start_Time1__c,RecordTypeId,Sunday_End_Time__c,Sunday_Start_Time__c,Saturday_Start_Time1__c,Saturday_End_Time2__c,Friday_Start_Time1__c,Friday_End_Time2__c,Thursday_Start_Time1__c,Thursday_End_Time2__c,Wednesday_Start_Time1__c,Wednesday_End_Time2__c,Tuesday_Start_Time1__c,Tuesday_End_Time2__c,Tuesday_Start_Time__c,Tuesday_End_Time__c,Wednesday_Start_Time__c,Wednesday_End_Time__c,Thursday_Start_Time__c,Thursday_End_Time__c,Friday_Start_Time__c,Friday_End_Time__c,Saturday_Start_Time__c,Saturday_End_Time__c,Sunday_Start_Time1__c,Sunday_End_Time1__c from SFDC_Class__c where Id =: id ]; 
 }
}