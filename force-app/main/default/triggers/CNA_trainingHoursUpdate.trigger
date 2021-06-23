trigger CNA_trainingHoursUpdate on CNA_Training__c (After insert) {
    
    Trigger_Name__c TN = Trigger_Name__c.getValues('CNA_trainingHoursUpdate');
    if(TN.Active__c == True){
        set<Id> roster_id = new set<Id>();
        string class_type = '';
        
        system.debug('TN isActive =  '+TN.Active__c);
        if(trigger.isInsert && trigger.isAfter){
            
            for(CNA_Training__c c: trigger.new){
                roster_id.add(c.Roster__c);
                class_type = String.valueOf(c.Class_Type__c);
            }
            system.debug('roster_id '+roster_id);
            system.debug('class_type '+class_type);
            
            List<Attendance__c > att_recs = [select id, name, CNA_Training__c, Students_RSVP__c,CNA_Hours_number__c,CNA_Minutes_in_number__c, createdDate, hours_rolledUp__c, Class_Type__c,  Class_Name__c, Makeup_Class_status__c, Roaster_No__c, Contact_Name__c, Class__c, Class__r.id, Class__r.Name, Contact__c, Contact__r.id, Contact__r.Name, Date__c, Enrollment__c, Roaster__c, Roaster__r.id, Status__c, Has_Make_Up_Class__c from Attendance__c where Roaster__r.id=:roster_id and Status__c ='Present' and hours_rolledUp__c = false ];
            system.debug('att_recs '+att_recs);
            
            for(CNA_Training__c c: trigger.new){
                for(Attendance__c a : att_recs) {
                    if(a.Class_Type__c == 'Regular' && c.Class_Type__c == 'Regular' ){
                        if(a.CNA_Training__c == null || a.CNA_Training__c == ''){
                            a.CNA_Training__c = c.Id;
                            a.hours_rolledUp__c = True;
                        }
                    }
                    else if(a.Class_Type__c == 'Make-up' && c.Class_Type__c == 'Make-up'){
                        if(a.CNA_Training__c == null || a.CNA_Training__c == ''){
                            a.CNA_Training__c = c.Id;
                            a.hours_rolledUp__c = True;
                        }
                    }
                    
                }
            }
            update att_recs;
            system.debug('att_recs '+att_recs);
        }  
    }
}