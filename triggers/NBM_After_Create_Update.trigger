trigger NBM_After_Create_Update on Qualification__c (after insert,after update) 
{
    //Variable Initialization
    Qualification__c[] NBM = Trigger.new;    
    Set<Id> NId = new Set<Id>();//Used for NBM Records
    Qualification__Share[] manshare = new Qualification__Share[]{};        
    OpportunityShare[] optyshare = new OpportunityShare[] {} ;
    Set<Id> GId = new Set<Id>();//Used for GSPO Records
    
    FOR (Qualification__c n: NBM )    
    {
        //Adding all the NBM records whose theater has been modified or newly created records to the NId Set
        if(n.RecordTypeId == Utilities.getNBMQualificationId())  
        {
            IF ((Trigger.isUpdate && Trigger.oldmap.get(n.Id).theater__c!=Trigger.newmap.get(n.Id).theater__c) || 
            Trigger.isinsert )
            {
                NId.add(n.ID);        
            }
          //Providing Edit access for the Requester on the Qualification record
             IF ((Trigger.isUpdate && Trigger.oldmap.get(n.Id).Requester_Name__c!=Trigger.newmap.get(n.Id).Requester_Name__c) ||
             Trigger.isinsert )
             {
                IF ( n.Requester_Name__c != null )
                {
                     Qualification__Share sh= new Qualification__Share(AccessLevel='Edit',ParentId = n.Id,UserOrGroupId = n.Requester_Name__c);
                     manshare.add(sh);
                }
                Qualification__Share sh1= new Qualification__Share(AccessLevel='Edit',ParentId = n.Id,UserOrGroupId = UserInfo.getUserId());

                manshare.add(sh1);

             }
             //Providing the Read Permission on the Opportunity that is associated to the Queue members
             IF ( n.Opportunity__c != null )
                {  opportunityShare osh1 = new opportunityshare (OpportunityAccessLevel='Read',OpportunityId = n.Opportunity__c ,UserOrGroupId = Utilities.getConstant_CS('NBM Review Team Global Group') );
                   optyshare.add(osh1);
                }
        }
         //Adding all the GSPO Records to GId set
          if(n.RecordTypeId == Utilities.getGSPOrecordtypeId())    
          if(n.Opportunity__c != null)
          GId.add(n.ID);
                   
              
          
     }     
        //Redirecting all the records to the class methods which provides the access to the record
        if(GId.size() > 0)
         NBM_After_Create_Update.GSPOSharing(GId);
        else
        NBM_After_Create_Update.add_sharing_update_email(NId,manshare,optyshare);
        
        
}