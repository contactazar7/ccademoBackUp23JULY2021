trigger Updateclass on Roaster__c (after insert,after update) {
    /**
   List<Id> RosterId = New List<Id>(); 
   for(Roaster__c rc:trigger.new){
        Roaster__c rcoldMap = Trigger.oldMap.get(rc.Id);
       if(rcoldMap.Status__c=='Open' || rc.Status__c=='Completed')
       {
           RosterId.add(rc.Id);
       }
       
    } 
    
   set<id> ccid=new set<id>(); 
    list<SFDC_Class__c>sfdccl=new list<SFDC_Class__c>();
    for(Roaster__c rc:trigger.new){
        ccid.add(rc.Class_Name__c);
    }
    system.debug('the classname is'+ccid);
    list<SFDC_Class__c>classcheck=new list<SFDC_Class__c>([select id,name from SFDC_Class__c where id IN:ccid]);
     list<Roaster__c>rd=new list<Roaster__c>([select id,name,Class_Name__c from Roaster__c where Class_Name__c IN:ccid ]);
    system.debug('the classname is'+rd.size());
    list<Roaster__c>rd1=new list<Roaster__c>([select id,name,Class_Name__c from Roaster__c where Class_Name__c IN:ccid and Status__c='Completed']);
    system.debug('the classname is'+rd1.size());
    for(SFDC_Class__c cc:classcheck){
        if(rd.size()==rd1.size()){
            cc.Class_Status__c='Completed';
            sfdccl.add(cc);
        }
        if(rd.size()!=rd1.size() && rd1.size()>0){
            cc.Class_Status__c='Ongoing'; 
            sfdccl.add(cc);
        }
        
    }
    if(sfdccl.size()>0){
        update sfdccl;
    }

**/
}