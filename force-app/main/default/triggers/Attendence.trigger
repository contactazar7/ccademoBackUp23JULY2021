trigger Attendence on Attendance__c (after insert, after update,after delete) {
    
    set<id>attend=new set<id>();
    set<id> attendId = new set<id>();
    
    list<SFDC_Enrollment__c>updateattend=new list<SFDC_Enrollment__c>();
    list<Roaster__c> RoasterList = new list<Roaster__c>();
    
    if(trigger.isinsert||trigger.Isupdate){
        //if(trigger.Isupdate){
        for(Attendance__c at:trigger.new){
            if(at.Status__c == 'Present' ||  at.Status__c == 'Absent' ){
                attend.add(at.Enrollment__c);
                attendId.add(at.id);
            }
        }
    }
    system.debug('attend '+attend);
    system.debug('attendId '+attendId);
    
    if(trigger.isdelete){
        for(Attendance__c at:trigger.old){
            attend.add(at.Enrollment__c);
        }
        system.debug('demo'+attend);
        
    }
    list<Attendance__c>prasent=new list<Attendance__c>([select id,name,Enrollment__c from Attendance__c where Enrollment__c In:attend and Status__c='Present']);
    list<Attendance__c>absent=new list<Attendance__c>([select id,name,Enrollment__c from Attendance__c where Enrollment__c In:attend and Status__c='Absent']);
    for(SFDC_Enrollment__c sf:[select id,name from SFDC_Enrollment__c where id IN:attend]){
        sf.No_of_student_Present__c=prasent.size();
        sf.No_of_student_Absent__c=absent.size();
        updateattend.add(sf);
        system.debug('the update attend'+updateattend);
    }
    
    /**
    Integer presentint = 0;
    Integer absentint = 0;
    
    for(Attendance__c att:  [select id,Students_RSVP__c,createdDate,name, Class_Name__c, Enrollment_No__c, Roaster_No__c, Contact_Name__c, Class__c,Class__r.id,Class__r.Name, Contact__c, Contact__r.id, Contact__r.Name,Date__c, Enrollment__c, Roaster__c,Roaster__r.id, Status__c, Has_Make_Up_Class__c from Attendance__c where id=:attendId]){
        for(Roaster__c r: [select id, Total_Absent__c, Total_Present__c, Class_Name__c from Roaster__c where id=:att.Roaster__c]){
            system.debug('roster Id '+ r.id);
            system.debug('attendance status '+ att.Status__c);
            system.debug('roster Total_Present '+ r.Total_Present__c);
            system.debug('roster Total_Absent '+ r.Total_Absent__c);
            
            if(att.Status__c == 'Present'){
                presentint = presentint +1;
                
            }
            if(att.Status__c == 'Absent'){
                
                absentint = absentint +1;
            }
            r.Total_Present__c = presentint;
            r.Total_Absent__c = absentint;
            
            RoasterList.add(r);
        }
    } 
    
    if(!RoasterList.isEmpty()){
       update RoasterList; 
    }
    
    **/
        
    if(updateattend.size()>0){
        update updateattend;
    }
}