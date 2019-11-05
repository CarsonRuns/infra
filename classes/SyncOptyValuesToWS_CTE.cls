/********************************
 Name : SyncOptyValuesToWS_CTE
 Purpose: The Purpose of the class is to update the fields in Opportunity Workspace object ,when the opportunity is synced with  Opportunity Workspace 
 *******************************/   
    public class SyncOptyValuesToWS_CTE {
        
          // SCAVA Helper Method to validate Update Access at field level
    public static Boolean flsUpdate(SObjectField field)
    {
        return field.getDescribe().isUpdateable() ? true : false;
    }
    public List<AT_Workspace__c> selectedWorkspaceList{get;set;}
    public List<AT_Workspace__c> workspaceList{get;set;}
    public AT_Workspace__c workspace{get;set;}
    public boolean isworkspace{get;set;}
    public String errorMsg{get;set;}
    public boolean isDetails{get;set;}
    
    //The extenstion constructor initializes the memebers ,
    // variable workspace by using the getRecord method from the standard controller 
     public SyncOptyValuesToWS_CTE(ApexPages.StandardController controller) {        
        this.workspace = (AT_Workspace__c)controller.getRecord();// it will fetch the current page workspace id
        system.debug('=======>'+workspace.id);
        isDetails = true;
        if(workspace.id != null){
             this.isworkspace = true;
             workspaceList = null;
            this.workspaceList = [Select Name,AT_Expected_Book_Date__c,AT_Forecast_Status__c,Compare_Stat__c,Opportunity__c from AT_Workspace__c where Id =:workspace.id];
           
        }else{
            this.isworkspace = false;
        }   
    }
    
    // it will return the ID of the record(s) that the user has selected 
    public SyncOptyValuesToWS_CTE(ApexPages.StandardSetController controller) {
        selectedWorkspaceList = null;
        selectedWorkspaceList= (List<AT_Workspace__c>)controller.getSelected(); 
        system.debug('selectedWorkspaceList==='+selectedWorkspaceList);        
        if(selectedWorkspaceList!= null && selectedWorkspaceList.size()>0){
            this.isworkspace = true;
            workspaceList = null;
            this.workspaceList = [Select Name,AT_Expected_Book_Date__c,AT_Forecast_Status__c,Compare_Stat__c,Opportunity__c from AT_Workspace__c where Id in:selectedWorkspaceList];
            system.debug('workspaceList==='+workspaceList);
        }else {
            this.isworkspace = false;
            system.debug('isworkspace'+isworkspace);
        }
    }
        // Code we will invoke on page load.
        //The Purpose of this method is to fetch the oppty field values and to,
        //update these field values in opportunity workspace object on clicking the "Update WS from Opportunity" button .
        public PageReference CopyOptyValuesToWS() 
       {
       system.debug('<<Entering..');
        errorMsg ='';
        Set<Id> optyIdList = new Set<Id>();
        List<AT_Workspace__c> wsListToUpdate = new List<AT_Workspace__c>(); 
        if(this.workspaceList!= null && this.workspaceList.size()> 0){
            for(AT_Workspace__c ws :this.workspaceList){
                optyIdList.add(ws.Opportunity__c);
                system.debug('Opty Id ='+optyIdList);
            }
            Map<Id, Opportunity> optys= new Map<Id, Opportunity>([select id,stagename,Competitors__c,Forecast_Status__c,Lost_Cancelled_Reason__c,CloseDate,Opportunity_Status__c,Name from Opportunity where id in: optyIdList]);
            system.debug('workspaceList === '+workspaceList.size());
            for(AT_Workspace__c ws :workspaceList){
                Opportunity opp = optys.get(ws.Opportunity__c);
                //SCAVA FIX for FLS Update
                if(flsUpdate(AT_Workspace__c.AT_Expected_Book_Date__c))
                {
                ws.AT_Expected_Book_Date__c= opp.closedate;
                }
                if(flsUpdate(AT_Workspace__c.Workspace_Stage__c))
                {
                ws.Workspace_Stage__c = opp.StageName;
                }
                if(flsUpdate(AT_Workspace__c.AT_Forecast_Status__c))
                {
                ws.AT_Forecast_Status__c=opp.Forecast_Status__c;
                }
                if(flsUpdate(AT_Workspace__c.PSS_Workspace_Status__c))
                {               
                ws.PSS_Workspace_Status__c = opp.Opportunity_Status__c;
                }

                
                //Nishi- Added the code to handle the validation rules.
                if(opp.Opportunity_Status__c == 'Booked'){
                    ws.Workspace_Lost_Cancelled_Reason__c = 'Booked - Opportunity Booked';
                    //SCAVA FIX
                    if(flsUpdate(AT_Workspace__c.Referenceable_Account__c)){
                    ws.Referenceable_Account__c ='N/A';
                    }
                }else{
                    //SCAVA FIX
                    if(flsUpdate(AT_Workspace__c.Workspace_Lost_Cancelled_Reason__c)){
                    ws.Workspace_Lost_Cancelled_Reason__c = opp.Lost_Cancelled_Reason__c;
                    }
                }
                if(ws.AT_Competitor__c == null && (opp.Opportunity_Status__c == 'Booked' || opp.Opportunity_Status__c == 'Lost' || opp.Opportunity_Status__c == 'Cancelled') ){
                    String strComp = opp.Competitors__c;
                    String[] arrComp = strComp.split(';');
                    if(arrComp.size()> 1){
                        //SCAVA FIX
                    if(flsUpdate(AT_Workspace__c.AT_Competitor__c)){
                        ws.AT_Competitor__c = 'Other-Opportunity Updated';
                    }
                        }else if(arrComp.size()==1){
                        ws.AT_Competitor__c = opp.Competitors__c;
                    }                                             
                }
                User u = [select Alias from User where Id =: UserInfo.getUserId()] ;
                //SCAVA FIX
                if(flsUpdate(AT_Workspace__c.Opportunity_WS_Update_History__c)){
                ws.Opportunity_WS_Update_History__c = 'Opp > WS Sync, ' + System.Now() + ', ' + u.Alias ; }
                wsListToUpdate.add(ws);
                
            }
            // Nishi -- Updated the code to display error message on UI, when user updates the record.
            if(wsListToUpdate.size()>0){
                    Utilities.setSkip(true);
                    Utilities.setValidationSkip(true);
                    try{
                        String err = '';
                         Database.SaveResult[] results;
                         // Database.SaveResult[] results = Database.Update(wsListToUpdate, false);
                         //SCAVA FIX
                        if(AT_Workspace__c.SObjectType.getDescribe().isCreateable() && AT_Workspace__c.SObjectType.getDescribe().isUpdateable()){
                       results = Database.Update(wsListToUpdate, false);
                       }
                        for(Integer i=0;i<results.size();i++){
                          if (!results.get(i).isSuccess()){
                                System.debug('Error: '+ results.get(i).getErrors().get(0).getStatusCode() + '-- ' + results.get(i).getErrors().get(0).getMessage());
                                err = results.get(i).getErrors().get(0).getMessage() + ' Record ID-<a href="/' +wsListToUpdate[i].Id +'">' + wsListToUpdate[i].Id+ '</a>';
                                if(errorMsg != ''){
                                  errorMsg += '<br/>';
                                }
                                errorMsg += err;
                          }
                        }
                    }
                    catch(Exception e){
                    system.debug('Error Message'+e.getMessage());
                    }
            }
        }
        return null;
       
    }
   
    
}