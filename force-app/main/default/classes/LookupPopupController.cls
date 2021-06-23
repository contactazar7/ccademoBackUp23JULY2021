// Custom controller for lookup popup page
public with sharing class LookupPopupController {
  public String query {get; set;}
  public string objectName {get; set;}
  public List<SObject> records {get; set;}
  public list<string> fields {get; set;} 
  
  public LookupPopupController() {
    runQuery();
  }
   
  public PageReference runQuery() {
    string fieldName = ApexPages.currentPage().getParameters().get('namefield');
    system.debug('Field Name : ' + fieldName);
    fields = fieldName == 'location' ? new list<string>{'Classroom_Name__c', 'Capacity__c'} 
                                        : new list<string>{'First_Name__c', 'Last_Name__c', 'Email_Address__c'};
    objectName = fieldName == 'location' ? 'Locations__c' : 'Instructor__c';//Instructor__c 
    string ins1 = ApexPages.currentPage().getParameters().get('instructor1');
    string ins2 = ApexPages.currentPage().getParameters().get('instructor2');
    string classDays = ApexPages.currentPage().getParameters().get('Days');
    string classTime = ApexPages.currentPage().getParameters().get('classTime');
    string course = ApexPages.currentPage().getParameters().get('course');
    string capacity = ApexPages.currentPage().getParameters().get('capacity');
    
    system.debug('Class Time : ' + classTime);
    if(string.isNotBlank(classTime)) {
      string timeRegExp = '([0-1]?[0-9]:[0-9][0-9] [A|P]M)';
      Pattern MyPattern = Pattern.compile(timeRegExp);
      Matcher MyMatcher = MyPattern.matcher(classTime);
      if(!MyMatcher.matches()) { 
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please make sure that the Class time\'s format is \"HH:MM AM/PM - HH:MM AM/PM\"'));
        return null;
      } 
    } 
    
    set<string> days = string.isNotEmpty(classDays) ? new set<string>(classDays.split(',')) : new set<string>();
    string classTiming = '';
    if(string.isNotBlank(classTime)) {
      Integer sh = Integer.valueOf(classTime.substringBefore('-').trim().substringBefore(':'));
      Integer eh = Integer.valueOf(classTime.substringAfter('-').trim().substringBefore(':'));
      string sm = classTime.substringBefore('-').trim().substringAfter(':').substringBefore(' ');
      string em = classTime.substringAfter('-').trim().substringAfter(':').substringBefore(' ');
      string t = classTime.substringBefore('-').trim().substringAfter(' ');
      system.debug('Start Hour : ' + sh + '\nEnd Hour : ' + eh + '\nAM/PM : ' + t);
      for(Integer i = sh; i < (sh == eh ? sh+12 : (sh > eh && t == 'PM' ? eh+12 : eh)); i++) {
        classTiming += (i < 13 ? i : i - 12) + ':' + sm + ' ' + (t == 'AM' ? (i < 12 ? t : 'PM') : t) + ' - ' 
                       + (i < 12 ? i + 1 : i - 11) + ':' + sm + ' ' + (t == 'AM' ? (i < 11 ? t : 'PM') : t);
        if(i < (eh  - 1))
          classTiming += ';';
      }
      system.debug('Class Timing : ' + classTiming);
    }
    string searchquery = '';
    if(fieldName == 'location') {
      searchQuery = query != null ? 'FIND :query IN ALL FIELDS RETURNING Locations__c (Id, Name, Classroom_Name__c, Capacity__c where Active__c = true and Byteback_Location__c = true'
                                  : 'select Id, Name, Classroom_Name__c, Capacity__c from Locations__c where Active__c = true and Byteback_Location__c = true';
      if(String.isNotBlank(capacity))                            
        searchQuery += (searchQuery.contains('where') ? ' and '  : ' where ') + 'Capacity__c >= ' + Integer.valueOf(capacity);
    }
    else {
      searchQuery = query != null ? 'FIND :query IN ALL FIELDS RETURNING Instructor__c (Id, Name, First_Name__c, Last_Name__c, Email__c where Active__c = true'
                                  : 'select Id, Name, First_Name__c, Last_Name__c, Email__c from Instructor__c where Active__c = true';
      if(String.isNotBlank(ins1)) 
        searchQuery += (searchQuery.contains('where') ? ' and '  : ' where ') + 'Id !=: ins1';
      if(String.isNotBlank(ins2))
        searchQuery += (searchQuery.contains('where') ? ' and ' : ' where ') + 'Id !=: ins2';      
      if(String.isNotBlank(course)) {
        set<Id> instIds = new set<Id>();
        for(Instructor_Course__c ic : [select Instructor__c from Instructor_Course__c where Product__r.Name =: course])
          instIds.add(ic.Instructor__c);
        searchquery += (searchQuery.contains('where') ? ' and ' : ' where ') + 'Id IN: instIds';
      }
    }
    if(!days.isEmpty()) {
      list<string> daysList = new list<string>(days);
      string dayString = '\'' + daysList[0] + '\'';
      for(Integer i = 1; i < daysList.size(); i++)
        dayString += ',\'' + daysList[i] + '\'';
        
      system.debug('Day String : ' + dayString);  
      
      searchQuery += (searchQuery.contains('where') ? ' and ' : ' where ') 
                     + 'Id NOT IN (select ' + (fieldName == 'location' ? 'Location__c' : 'Instructor_ID__c') 
                     + ' from SFDC_Class__c where Days__c IN (' + dayString 
                     + ') and (Class_Status__c = \'Upcoming\' or Class_Status__c = \'Registering\' or Class_Status__c = \'Ongoing\')';
      searchQuery += string.isNotBlank(classTime) ? ' and Start_Time__c =: classTime)' : ')';   
      if(fieldName != 'location') { 
        searchQuery += (searchQuery.contains('where') ? ' and ' : ' where ') 
                       + 'Id NOT IN (select Instructor_ID_2__c from SFDC_Class__c where Days__c IN ('
                       + dayString + ') and (Class_Status__c = \'Upcoming\' or Class_Status__c = \'Registering\' or Class_Status__c = \'Ongoing\')';     
        searchQuery += string.isNotBlank(classTime) ? ' and Start_Time__c =: classTime)' : ')';    
      }
        
      if(days.contains('Mon')) {
        searchQuery += (searchQuery.contains('where') ? ' and ' : ' where ') + 'Available_Monday__c = true';
        if(string.isNotBlank(classTime)) 
          searchQuery += ' and Monday_Available_time__c IN (\'' + classTiming + '\')';                    
      }
      if(days.contains('Tue')) {
        searchQuery += (searchQuery.contains('where') ? ' and ' : ' where ') + 'Available_Tuesday__c = true';
        if(string.isNotBlank(classTime))
          searchQuery += ' and Tuesday_Available_time__c IN (\'' + classTiming + '\')'; 
      }
      if(days.contains('Wed')) {
        searchQuery += (searchQuery.contains('where') ? ' and ' : ' where ') + 'Available_Wednesday__c = true';
        if(string.isNotBlank(classTime))
          searchQuery += ' and Wednesday_Available_time__c IN (\'' + classTiming + '\')'; 
      }
      if(days.contains('Thu')) {
        searchQuery += (searchQuery.contains('where') ? ' and ' : ' where ') + 'Available_Thursday__c = true';
        if(string.isNotBlank(classTime))
          searchQuery += ' and Thursday_Available_time__c IN (\'' + classTiming + '\')'; 
      }
      if(days.contains('Fri')) {
        searchQuery += (searchQuery.contains('where') ? ' and ' : ' where ') + 'Available_Friday__c = true';         
        if(string.isNotBlank(classTime))
          searchQuery += ' and Friday_Available_time__c IN (\'' + classTiming + '\')'; 
      }
      if(days.contains('Sat')) {
        searchQuery += (searchQuery.contains('where') ? ' and ' : ' where ') + 'Available_Saturday__c = true';         
        if(string.isNotBlank(classTime))
          searchQuery += ' and Saturday_Available_time__c IN (\'' + classTiming + '\')'; 
      }
       
    }  
    searchQuery += query != null ? ')' : (searchQuery.contains('where') ? ' order by Name asc limit 10' 
                                          : ' where LastViewedDate != null order by LastViewedDate desc limit 10');
    system.debug('Query: ' + searchQuery);
    records = query != null ? search.query(searchquery)[0] : Database.query(searchQuery);
    return null;
  }
}