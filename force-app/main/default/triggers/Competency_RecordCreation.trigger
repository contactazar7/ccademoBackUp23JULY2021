trigger Competency_RecordCreation on SFDC_Class__c (After update) {

    list<Competency_Check__c> lstcmp= new list<Competency_Check__c>();
    list<SFDC_Class__c> clst=[select id,name,competency_created__c,Competency_Dup_Check__c,(SELECT  Id, Name,Status__c FROM Enrollments__r),Is_it_a_CNA_Other_class__c,Class_Category__c from SFDC_Class__c where id IN : Trigger.new];
     if(checkRecursive.runOnce())
    {
       
    system.debug('ssajhds'+clst.size());
    for(SFDC_Class__c cl:clst)
    {
         if(cl.competency_created__c==true && cl.Competency_Dup_Check__c==true)
        {
        for(SFDC_Enrollment__c en:cl.Enrollments__r)
        {
             if(cl.Is_it_a_CNA_Other_class__c=='No')
             {
                 if(en.Status__c=='Enrolled')
                 {
                     Competency_Check__c cmpc=new Competency_Check__c();
                     cmpc.RecordTypeId='0125g000000QUnCAAW';
                     cmpc.Enrollment__c=en.id;
                     cmpc.Class__c=cl.id;
                     lstcmp.add(cmpc);
                 }
             }
             
        }
      }
        cl.Competency_Dup_Check__c=False;
    }
    
    if(lstcmp.size()>0)
    {
         insert lstcmp;
    }
    } 
}