public class NBM_After_Create_Update
{   
    
   //Method to update the email field and to provide the sharing level on the Qualification record and its associated Opportunity
   public static void add_sharing_update_email(set<Id> NBMId,Qualification__Share[] manshare ,OpportunityShare[] optyshare ) 
   {
   
       String emailfield = '';   
       System.debug('NBM1:'+NBMId);
       System.debug('NBM2:'+manshare);
       System.debug('NBM3:'+optyshare);
 
       // Map between NBM ID and Queue Name
       Map<Id,String> NBM_Queuename = new Map<Id,String>();
  
       // Map between Queue ID and Queue name 
       Map<String,QueueSobject> Queue_SObjType_ID = new Map<string,QueueSobject>();
 
       Qualification__c[] NBMtoUpdate = new Qualification__c[]{};
        
       list<QueueSobject> que= new list<QueueSobject>(); //Object to hold data of all queues for NBM object
   
       Qualification__c[] NBMS = [ select Id, OwnerId,Theater__c,status__c,Requester_Name__c,RecordTypeId  from Qualification__c where Id in :NBMId ];
   
       //Query to fetch all queues for object-NBM Remodel
       que = [Select q.Queue.Name, q.Queue.Email, q.Queue.Id from QueueSobject q where q.SobjectType = 'Qualification__c'];        
  
       //loop to insert value in Map        
       for(QueueSobject q: que)
       Queue_SObjType_ID.put(q.Queue.Name,q);
   
       System.debug('Queue values:'+Queue_SObjType_ID);
   
       String theater = '';
  
       for ( Integer i=0 ; i< NBMS.size() ; i++ )
       {
           theater = 'Global';
     
           NBM_Queuename.put( NBMS[i].Id,'NBM Review Team '+ theater);
           System.debug('Oh my god:'+NBM_Queuename);
       }
   
       for ( Integer i = 0 ; i < NBMS.size() ; i ++ )
       {  
           If(NBMS[i].Theater__c != null)
           {    
               Qualification__c nr = new Qualification__c ( Id=NBMS[i].Id,ownerid=Queue_SObjType_ID.get(NBM_Queuename.get(NBMS[i].Id)).Queue.Id );
               NBMtoUpdate.add(nr);
           }
       }        
      update NBMtoUpdate;
      upsert manshare;
      upsert optyshare ;
  }
  
  //Method used for providing the Read Access on GSPO record and its associated Opportunity
 public static void GSPOSharing(set<Id> GSPOId) 
 {
     Qualification__Share[] manshare = new Qualification__Share[] {};  
     OpportunityShare[] optyshare = new OpportunityShare[] {} ;
   
     Qualification__c[] qali = [select Id,Opportunity__r.OwnerId,LastModifiedById,OwnerId,Opportunity__c from Qualification__c where Id IN :GSPOId]; 
     System.debug('Hello World');
     
     for(Integer i = 0;i<qali.size();i++)
     {     
         Qualification__Share sh = new Qualification__Share(AccessLevel='Read',ParentId = qali[i].Id,UserOrGroupId = qali[i].Opportunity__r.OwnerId);
         manshare.add(sh);
         
         OpportunityShare osh1 = new OpportunityShare (OpportunityAccessLevel='Read',OpportunityId = qali[i].Opportunity__c ,UserOrGroupId = qali[i].OwnerId );
         optyshare.add(osh1);
     }
     
     try{
     upsert manshare;
     upsert optyshare;
     }
     catch(Exception e){
     }
 }
}