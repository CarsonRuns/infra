/* *****************************************************
This controller is being used for the visual force page : "NGCC_Leadmassapproval"
This visual force page is called from the Lead list button called "Approve Selected Records".
This fuctionality is implemented for mass Lead approval or rejection or send to sales.
*****************************************************  */
   
public class NGCC_LeadList{
    // SCAVA Helper Method
     public static Boolean flsGet(SObjectField field)
    {
        return field.getDescribe().isCreateable() ? true : false;
    }
    
    // SCAVA Helper Method to validate Update Access at field level
     public static Boolean flsUpdateGet(SObjectField field)
    {
        return field.getDescribe().isUpdateable() ? true : false;
    }
    public list<Wrap> listwrap {get;set;}
    public list<lead> lstLead{get;set;}
    public string Status{get;set;}
    public map<Id,Lead> m = new map<Id,Lead>();
    
    public list<Lead> recordstobeupdated = new list<Lead>();
    //getting the custom settings.
    //NGCC_Approved__c = Approved
    //NGCC_Rejected__c = Rejected
    //NGCC_Cancel__c = Cancel
    //NGCC_Send_to_Sales__c = Send to Sales
    NGCC_Lead_Status__c mc = NGCC_Lead_Status__c.getInstance();
    
        
    public map<string,string> mapLead = new Map<String, String>();
    public boolean show {get;set;}
    // Standard set controller is used to fetch all the leads that are selected before they call this visualforce and this is accessable only for the roles contains <Role name>.
    public NGCC_LeadList(ApexPages.StandardSetController Controller){
        show = false;
        //Checking the user role for Site Manager.
        string pf=UserInfo.getUserRoleId();
        list<UserRole> roles = new list<UserRole>();
        List<Integer> uid= new List<Integer>();
        roles= [select Id,Name from UserRole where name like '%NGCC-CC Site Manager%' ];               
        set<Id> Ids = new Set<Id>();
         for(UserRole u:roles)
         {
             Ids.add(u.Id);
           }
            if(Ids.Contains(pf)){
            show = true;
           }   
         
        listwrap = new list<wrap>();
        lstLead = new list<lead>();
        lstLead = [SELECT Id,Name,Status,Rejected_Reason_Details__c, Lead_Cancel_Reason__c ,QATimeFrame__c,QABudget__c,Company,
             MQL_Created_Date__c,ServicesAmount__c,ProductAmount__c,Description,CustomCountry__c,Main_Technology__c 
             FROM Lead WHERE ID IN:Controller.getSelected()];
        system.debug('****'+lstLead);
        for(Lead l:lstLead)
                {
                 if(l.status == mc.NGCC_Approved__c)
                 m.put(l.Id,l);
                }
        if(lstLead!=null && lstLead.size()>0){
            for(Lead obj : lstLead){
                wrap objwrap = new wrap();
                mapLead.put(obj.Id,obj.Name);
                objwrap.objlead = obj;
                objwrap.status= mc.NGCC_Approved__c;
                
                listwrap.add(objwrap);
            }
        }  
    }

    public class wrap{
       public Lead objlead{get;set;}
       public string status{get;set;} 
    }
// This Save1 method will be executed once the user click on Save button on the custom visual force page to save the changes done for the selected lead record's status picklist. 

    public Id getWorkItemId(Id targetObjectId)
                {
                    Id retVal = null;
                    List<ProcessInstanceWorkitem> newList=[Select Id from ProcessInstanceWorkitem LIMIT 1];
                    if(!Test.isRunningTest()){
                    for(ProcessInstanceWorkitem workItem  : [Select p.Id from ProcessInstanceWorkitem p
                        where p.ProcessInstance.TargetObjectId =: targetObjectId])
                    {
                        retVal  =  workItem.Id;
                    }
                   }else{
                        retVal  = newList[0].Id;
                    }
                    return retVal;
                }
  
 

public pageReference save1(){

  PageReference pageRef = null;
  try{
     set<String> setLeads = new set<String>();
     list<lead> records = new List<lead>();
     Boolean rejMsg;
     Boolean canMsg;
            if(listwrap!=null){

                // if Reject reason null then show message. 
                  for(wrap w:listwrap){
                    if(w.Status == mc.NGCC_Rejected__c&& (w.Objlead.Rejected_Reason_Details__c ==Null || w.Objlead.Rejected_Reason_Details__c == '')){
                        rejMsg = true;
                      }
                // if Cancel reason null then show message.       
                    if(w.Status == mc.NGCC_Cancel__c && (w.Objlead.Lead_Cancel_Reason__c ==Null || w.Objlead.Lead_Cancel_Reason__c == '')){
                        canMsg = true;
                      }
                      
        
                      lead newlead = w.objLead;
                      //SCAVA Fix
                      if(flsGet(lead.Status)||flsUpdateGet(lead.Status)){
                      newlead.Status=w.status;
                      }
                      //SCAVA Fix
                      
                      if(w.Objlead.Rejected_Reason_Details__c!= null && w.Status == mc.NGCC_Rejected__c)
                      //SCAVA Fix
                      if(flsGet(lead.Rejected_Reason_Details__c)||flsUpdateGet(lead.Rejected_Reason_Details__c)){
                      newlead.Rejected_Reason_Details__c = w.Objlead.Rejected_Reason_Details__c;
                      }
                     
                      if(w.Objlead.Lead_Cancel_Reason__c!= null && w.Status == mc.NGCC_Cancel__c)
                       //SCAVA Fix
                      if(flsGet(lead.Lead_Cancel_Reason__c)||flsUpdateGet(lead.Lead_Cancel_Reason__c)){
                      newlead.Lead_Cancel_Reason__c = w.Objlead.Lead_Cancel_Reason__c;
                      }
                      
                      
                         if(setLeads.add(newlead.Id)&& (newlead.Status == mc.NGCC_Approved__c ||newlead.Status == mc.NGCC_Send_to_Sales__c || newlead.Status == mc.NGCC_Rejected__c ||newlead.Status == mc.NGCC_Cancel__c) ){
                         //if(setLeads.add(newlead.Id)&& w.Status =='Approved'  ){
                              records.add(newlead);
                            }
        
                    }
                    if (rejMsg != null && rejMsg == true){
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please provide Reject Reason'));
                        return null;
                        }
        
                    if (canMsg != null && canMsg == true){
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please provide Cancel Reason'));
                        return null;
                        }
               
               
                
             
            if(records!=null && records.size()>0){
            system.debug('%%%%'+records);
                for(Lead ld : records){
                        system.debug('^^^^'+ld.Status);
                        Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();
                      // Submit the Leads for for Approval
                        if(ld.Status == mc.NGCC_Approved__c && ld.Status != mc.NGCC_Cancel__c ){
                            req2.setComments('Approving request.');
                            req2.setAction('Approve');
                            req2.setNextApproverIds(new Id[] {UserInfo.getUserId()});
                            system.debug('ZZZZ'+ld.Id);
                            Id workItemId = getWorkItemId(ld.id);
                            system.debug('!!!!!'+workItemId);
                            req2.setWorkitemId(workItemId);
                            Approval.ProcessResult result =  Approval.process(req2);
                           
                            System.assert(result.isSuccess());
                       // Submit the request for Reject     
                        }else if(ld.Status == mc.NGCC_Rejected__c ){
                            req2.setComments('Rejecting request.');
                            req2.setAction('Reject');
                            Id workItemId = getWorkItemId(ld.id);
                            req2.setWorkitemId(workItemId);
                            Approval.ProcessResult result =  Approval.process(req2);
                            System.assert(result.isSuccess());
                            recordstobeupdated.add(ld);
                       // Submit the request for Cancel & Recall the leads from approval process     
                        }else if(ld.Status == mc.NGCC_Cancel__c){
                            req2.setComments('Lead Cancelled.');
                            req2.setAction('Reject');
                            Id workItemId = getWorkItemId(ld.id);
                          
                            req2.setWorkitemId(workItemId);
                            system.debug('approval process'+req2);
                            Approval.ProcessResult result =  Approval.process(req2);
                            
                            System.assert(result.isSuccess()); 
                            recordstobeupdated.add(ld); 
                      // Changing the lead status to 'Send to Sales'     
                        }else if(ld.Status == mc.NGCC_Send_to_Sales__c){
                            
                            if(m.containskey(ld.Id))
                            recordstobeupdated.add(ld);
                            
                        }                
                        
                    }
               }
               
              
             update recordstobeupdated;
             
        }
        
     // Below page refernece is used to return to the same list view once the records are saved.
        pageRef = new PageReference('/00Q?');
          }catch(System.DmlException e) 
             {
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getDmlMessage(0)+ ' ' +mapLead.get(e.getDmlId(0))));
             } 
          return pageRef;
          
     }
 
}