public class Hours_Duration_Update {
    
    public void calculate_hours(List<CNA_Training__c> cna_id){
        
        Map<Id, CNA_Training__c > cna_map = new Map<Id, CNA_Training__c>([select id, Name, Class_Type__c ,Duration_of_Class__c , Roster__c From CNA_Training__c where id=:cna_id]);
        system.debug('cna_map are '+cna_map);  
        
        set<Id> roster_Id = new set<Id>();
        string cnaId = '';
        
        for(CNA_Training__c c :cna_map.values()){
            roster_Id.add(c.Roster__c);
            cnaId = string.valueOf(c.id);
        }
        system.debug('roster_Id are '+roster_Id);
        
        system.debug('cnaId are '+cnaId);
            
        system.debug('cna_map ids are '+cna_map.get('id'));
        system.debug('cna_map values are '+cna_map.values());
        system.debug('cna_map Keyset() are '+cna_map.values());
        
        
        
        List<Attendance__c > att_recs = [select id, name, CNA_Training__c, Students_RSVP__c,CNA_Hours_number__c,CNA_Minutes_in_number__c, createdDate, hours_rolledUp__c, Class_Type__c,  Class_Name__c, Makeup_Class_status__c, Roaster_No__c, Contact_Name__c, Class__c, Class__r.id, Class__r.Name, Contact__c, Contact__r.id, Contact__r.Name, Date__c, Enrollment__c, Roaster__c, Roaster__r.id, Status__c, Has_Make_Up_Class__c from Attendance__c where Roaster__r.id=:roster_Id and Status__c ='Present'];
        system.debug('att_recs are '+att_recs); 
        system.debug('att_recs size are '+att_recs.size()); 
        for(Attendance__c a:  att_recs){
            if(a.CNA_Training__c <> null ){
                //a.CNA_Training__c = cnaId;
            }
            
        }
        
        //Update att_recs;
        system.debug('att_recs are '+att_recs);
        
    }       
}