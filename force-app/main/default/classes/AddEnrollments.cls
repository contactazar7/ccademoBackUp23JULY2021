public class AddEnrollments {


        public SFDC_Class__c Classes;
        public SFDC_Enrollment__c del;
        public List < SFDC_Enrollment__c > addEnrollmentList {get;set;}
        public List < SFDC_Enrollment__c > delEnrollmentList {get;set;}
        public List < SFDC_Enrollment__c > EnrollmentList {get;set;}
        public Integer totalCount {get;set;}
        public Integer rowIndex {get;set;}
        public List < SFDC_Enrollment__c > delEnrollments {get;set;}
        public Id ClassId = ApexPages.currentPage().getParameters().get('id');
        public AddEnrollments(ApexPages.StandardSetController controller) {
           // Classes = (SFDC_Class__c) controller.getRecord();
                EnrollmentList = [SELECT Id,name,Status__c,Class__c,Contact__c,Pass_DNP__c,Mid_Point_Assessment_Score__c,Final_Assessment_Score1__c FROM SFDC_Enrollment__c where Class__c = :ClassId];
                totalCount = EnrollmentList.size();
                delEnrollmentList = new List < SFDC_Enrollment__c > ();
                delEnrollments = new List < SFDC_Enrollment__c > ();
        }

       /* public void addRow() {
                addEnrollmentList = new List < SFDC_Enrollment__c > ();
                EnrollmentList.add(new SFDC_Enrollment__c(Class__c = ClassId));
        }*/

        public PageReference save() {
                upsert EnrollmentList;
                delete delEnrollmentList;
                //return (new ApexPages.StandardController(Classs)).view();

      /*PageReference secondPage = new PageReference(ApexPages.currentPage().getParameters().get('retURL'));  
      secondPage.setRedirect(true);
      return secondPage;*/ 
        System.debug('the class id is'+ClassId);
               PageReference pageRef = new PageReference('/'+ClassId);
               //pageRef.getParameters().put('id',Classes.Id);
               pageRef.setRedirect(true);
               return pageRef;  
        }
        public void deleteRow() {
                rowIndex = Integer.valueOf(ApexPages.currentPage().getParameters().get('rowIndex'));
                del = EnrollmentList.remove(rowIndex);
                delEnrollmentList.add(del);
        }
}