public class TM2StopGapController{
    
    public String currentRecordId {get;set;}
    public List<String> tList = new List<String>();
    public List<OpportunityShare> optyShareList = new List<OpportunityShare>();
    public List<Opportunity> oList;
    public Database.SaveResult[] srList;
    public String insertedIds;
    
    public TM2StopGapController(ApexPages.StandardController controller) {
        currentRecordId  = ApexPages.CurrentPage().getparameters().get('id');
    }
    public void setIsOptySharecompleted(){
        if(currentRecordId != null && currentRecordId != ''){
            oList = [Select id, OwnerId, territory2.Level_3_Territory__c, territory2.Level_4_Territory__c,
                     territory2.Level_5_Territory__c, territory2.Level_6_Territory__c
                     from Opportunity where id =: currentRecordId];
        }
        List<TM2StopGap__c> tm2List = [Select id from TM2StopGap__c where OpportunityId__c =: currentRecordId 
                                       and isOptySharecompleted__c = True];
        if(tm2List.size() == 0 && oList[0].OwnerId != UserInfo.getUserId() && oList.size() > 0 && oList[0].territory2Id != null)
        {
            
            /*List<Opportunity> oList = [Select id, OwnerId, territory2.Level_3_Territory__c, territory2.Level_4_Territory__c,
territory2.Level_5_Territory__c, territory2.Level_6_Territory__c
from Opportunity where id =: currentRecordId];*/
            
            for(Opportunity o : oList){
                tList.add(o.territory2.Level_3_Territory__c);
                tList.add(o.territory2.Level_4_Territory__c);
                tList.add(o.territory2.Level_5_Territory__c);
                tList.add(o.territory2.Level_6_Territory__c);        
            }
            //  system.debug('--tList--' + tList);          
            //List<Territory2> terrList = [Select Id  FROM Territory2 where Name IN: tList];
            List<Group> grpList = [Select id,DeveloperName, RelatedId,type 
                                   from Group where RelatedId IN (Select Id  FROM Territory2 where Name IN: tList) 
                                   and type = 'Territory'];
            
            //system.debug('--grpList--' + grpList);
            if(grpList.size() > 0){
                for(Group g : grpList){
                    OpportunityShare oShare = new OpportunityShare();
                    oShare.OpportunityAccessLevel = 'Edit';
                    oShare.OpportunityId = currentRecordId;
                    oShare.RowCause = 'Manual';
                    oShare.UserOrGroupId = g.id;
                    optyShareList.add(oShare);
                }
            }
            //system.debug('--optyShareList--' + optyShareList);
            try{
                srList = Database.insert(optyShareList);
                //insert optyShareList;
            }catch(Exception e){}
            
            TM2StopGap__c tm2 = new TM2StopGap__c();
            tm2.OpportunityId__c = currentRecordId;
            tm2.UserId__c = UserInfo.getUserId();
            tm2.isOptySharecompleted__c = True;
            for (Database.SaveResult sr : srList)
            {
                if(insertedIds == null){
                    insertedIds = sr.getId();
                }
                else {
                    insertedIds = insertedids + ',' + sr.getId();
                }
            }
            tm2.OptyShareIds__c= insertedIds;
            try{
                insert tm2;
            }catch(Exception e){}
        }
    }
}