trigger MClass_Roster on Make_Up_Class__c (After Insert){
    
    List<Attendance__c> makeUp_attd = new List<Attendance__c>();
    
    for(Make_Up_Class__c m: trigger.new){
        for(Attendance__c a: [Select Id, Name, Status__c, Class__c, Class__r.id, Roaster__c, Roaster__r.id, Enrollment__c,Enrollment__r.id, Contact__c, Contact__r.id, Has_Make_Up_Class__c, Date__c From Attendance__c where Roaster__r.id=:m.Roster_Name__c]){
            if(a.Status__c == 'Absent'){
            Attendance__c at = new Attendance__c();
                at.Status__c = 'Scheduled';
                at.Has_Make_Up_Class__c = True;
                at.Class__c = a.Class__r.id;
                at.Date__c = m.Class_Scheduled_Date__c;
                at.Roaster__c = a.Roaster__r.id;
                at.Enrollment__c = a.Enrollment__r.id;
                at.Contact__c = a.Contact__r.id;
                at.Make_Up_Class__c = m.Id;
                at.Class_Type__c = 'Make-up';
                makeUp_attd.add(at);
            }
        }
    }
    Insert makeUp_attd;
}