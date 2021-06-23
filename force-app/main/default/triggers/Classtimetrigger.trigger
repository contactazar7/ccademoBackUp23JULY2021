trigger Classtimetrigger on SFDC_Class__c (before insert) {

   if(trigger.isBefore && (trigger.isInsert || trigger.isUpdate)){
        for(SFDC_Class__c s : trigger.new){
           
            
            if(string.isNotBlank(s.Start_Time1__c)){
                 string tm = s.Start_Time1__c.contains('PM') ? s.Start_Time1__c.remove('PM')  : s.Start_Time1__c.remove('AM');
                     integer hrs = Double.valueOf(tm.split(':')[0]).intValue();
                       integer mit= Double.valueOf(tm.split(':')[1].contains('00') ? '0':tm.split(':')[1]).intValue();
                      integer PmShift = s.Start_Time1__c.contains('PM') ? ( hrs== 12 ? 24 : 12) : ( hrs== 12 ? 12 : 24);
                    Time myTime = Time.newInstance(hrs+PmShift, mit, 0, 0);
                    s.Start_Time__c = myTime;
            }
            
            if(string.isNotBlank(s.End_Time1__c)){
               string tm = s.End_Time1__c.contains('PM') ? s.End_Time1__c.remove('PM')  : s.End_Time1__c.remove('AM');
                     integer hrs = Double.valueOf(tm.split(':')[0]).intValue();
                       integer mit= Double.valueOf(tm.split(':')[1].contains('00') ? '0':tm.split(':')[1]).intValue();
                      integer PmShift = s.End_Time1__c.contains('PM') ? ( hrs== 12 ? 24 : 12) :( hrs== 12 ? 12 : 24);
                    Time myTime = Time.newInstance(hrs+PmShift, mit, 0, 0);
                s.End_Time__c = myTime;
            }
            
        }
    }
 
}