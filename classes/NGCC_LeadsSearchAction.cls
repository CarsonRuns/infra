/***************************************************************************************************
Name    : NGCC_LeadsSearchAction
Author  : Ghattamaneni Chaithanya
Purpose : This class is used in Custome Engagement Tool, it is responsible to search the Leads in database
Date	: 28-Jan-2019

Modification History: 

*****************************************************************************************************/

public class NGCC_LeadsSearchAction {
    @InvocableMethod(label='Get Lead Records' description='Returns the list of Lead records corresponding to the specified Serch string.')
    public static List<List<Lead>> getLeadRecords(list<String> serachStrings) {
     /*   datetime Last3Mnths = datetime.now().addMonths(-3);
        system.debug(Last3Mnths);
        string serachString = serachStrings[0];
        List<Lead> Leads = new List<Lead>();
        Leads = [SELECT id,Company,CreatedDate,Email,FirstName,LastName,Name,MobilePhone,Phone,Status FROM Lead 
                 WHERE IsConverted=false AND (FirstName=:serachString OR LastName=:serachString OR Email=:serachString OR Company=:serachString OR Phone=:serachString)
                 and CreatedDate>:Last3Mnths ORDER BY CreatedDate Desc];
        if(Leads.size() == 0){
            return null;
        }
        else{
            List<List<Lead>> LeadsList = new List<List<Lead>>();
            LeadsList.add(Leads);
            return LeadsList;
        }*/
        datetime Last3Mnths = datetime.now().addMonths(-3);
        datetime Last1hour = datetime.now().addHours(-1);
        string serachString = serachStrings[0];
        map<id,Lead> Leadmap = new map<id,Lead>();
        for(Lead l : [SELECT id,Company,CreatedDate,Email,FirstName,LastName,Name,MobilePhone,Phone,Status,Campaign_Name__c FROM Lead 
                      WHERE IsConverted=false AND (FirstName=:serachString OR LastName=:serachString OR Name=:serachString or Email=:serachString OR Company=:serachString OR Phone=:serachString)
                      and (CreatedDate>:Last3Mnths and CreatedDate<:Last1hour) ORDER BY CreatedDate Desc]){
                          Leadmap.put(l.id, l);       
                      }
        if(!Leadmap.isEmpty()){
            for(UserRecordAccess leadaccess: [select RecordId,HasEditAccess from UserRecordAccess where UserId =:userinfo.getUserId() and RecordId IN:Leadmap.keySet()]){
                if(leadaccess.HasEditAccess != true){
                    if(Leadmap.containsKey(leadaccess.RecordId)){
                        Leadmap.remove(leadaccess.RecordId);
                    }
                }
            }
        }
        if(Leadmap.isEmpty()){
            return null;
        }
        else{
            List<List<Lead>> LeadsList = new List<List<Lead>>();
            LeadsList.add(Leadmap.values());
            return LeadsList;
        }
    }
}