public with sharing class TerritoryLightningQuery{
    public List<AccountShare> Records = new List<AccountShare>();
    public List<Group> Grp = new List<Group>();
    public List<Territory2> Terr {get;set;}
    
    //Added 3/22/2018 (Angela)
    public List<Id> grpID = new List<Id>();
    public List<Id> grpRelatedID = new List<Id>();
    public List<String> terrComma = new List<String>();
    public String territoryName {get;set;}
    
    //Queries name of territory based on account
    public TerritoryLightningQuery(){
        //Selects records based on accountId and if part of territory assignment
        Records = [Select Id, UserOrGroupId from AccountShare where (RowCause = 'Territory' OR RowCause = 'Territory2AssociationManual') And AccountId=:ApexPages.currentPage().getParameters().get('id')];
        system.debug(':::Testlog'+Records);
        //Checks if record is null or not and gets id of group based on type
        if(Records.size() > 0){
            Integer rSize = Records.size();
            
            //Add UserOrGroupId to a list - Added 3/22/2018 (Angela)
            for(integer i=0; i < rSize; i++){
                grpID.add(Records[i].UserOrGroupId);    
            }
            
            Grp = [Select Id, RelatedId from Group where Type = 'Territory' and Id IN :grpID];
        }
        //Error message if no territories
        else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Error: No Associated Territory'));
        }
        //Checks if record is null or not and gets territory name
        if(Grp.size() > 0){
            Integer gSize = Grp.size();
            
            //Add RelatedId to a list - Added 3/22/2018 (Angela)
            for(integer i=0; i < gSize; i++){
                grpRelatedID.add(Grp[i].RelatedId);
            }
            
            Terr = [Select Id, Name from Territory2 where Id IN :grpRelatedID];
            
            //Add comma between multiple territories - Added 3/22/2018 (Angela)
            for(Territory2 t : Terr)
            {
                terrComma.add(t.Name);
            } 
            territoryName = string.join(terrComma, ', ');
        }
    }
}