/**
* @release - JUNE Q4FY14
* @author - majanard
* @description - Enhanced to add Workspace Status and Lost/Cancel reason sync with Opportunity - WR-00458 June'2014.
*/ 

//*********** Change History ****************************
// 12/09: Removed the code to update Opportunity Theater
// 12/11: Remove future method
// 11/12 updated as per Wr-0603(updating the Workspace_Lost_Cancelled_Reason__c with "Booked - Opportunity Booked" when opty status is booked)  
// 11/21: kikamara: Updated as per WR-0602 ( Updating the workspace competitor)
// 11/21: kikamara: Updated as per WR-0700 Added new fied Referenceable_Account__c and made it mandatorydatory for SEC 
///*******************************************************

public class OpptyFutureClass {

// SCAVA Helper Method to validate Update Access at field level
     public static Boolean flsUpdateGet(SObjectField field)
    {
        return field.getDescribe().isUpdateable() ? true : false;
    }
    
    public static void updateOpptys(ID[] newNamedOpptys, ID[] statusOpptys) {     
        if(newNamedOpptys.size() > 0){
          Quote__c[] quotesToUpdate = new Quote__c[]{};
          for(Quote__c quotes : [Select Id, Name, Opportunity_Name__r.Name From Quote__c Where Opportunity_Name__c IN :newNamedOpptys]){
              String optyName = quotes.Opportunity_Name__r.Name; 
              if (optyName.length() > 74) 
                optyName = optyName.substring(0,73);
              
              Quote__c tempQuote = new Quote__c(Id=quotes.Id, Name=optyName + ' Quote');    
              quotesToUpdate.add(tempQuote);
          }
          if(quotesToUpdate.size()>0){
              Utilities.setValidationSkip(true);//skips validation rules
              Utilities.setSkip(true);//skips certain trigger functionality
              Utilities.setskipFuture(true);//skips more future calls              
              update quotesToUpdate;
          }
        }
          // Added Lost Reason update as part of WR-00458.
        if(statusOpptys.size()>0){
            AT_Workspace__c[] workspaceUpdates = new AT_Workspace__c[]{};
            for(AT_Workspace__c w : [Select Id, Opportunity__r.Opportunity_Status__c, Opportunity__r.Lost_Cancelled_Reason__c,Referenceable_Account__c , AT_Team__c , Opportunity__r.Competitors__c ,AT_Competitor__c ,Sync_With_Opportunity__c From AT_Workspace__c Where Opportunity__c IN :statusOpptys]){
                if(!w.Sync_With_Opportunity__c){    
                   if(w.AT_Team__c != null){
                        if(!w.AT_Team__c.touppercase().startsWith('SEC')){  
                          w.PSS_Workspace_Status__c = w.Opportunity__r.Opportunity_Status__c;
                          w.Workspace_Lost_Cancelled_Reason__c = w.Opportunity__r.Lost_Cancelled_Reason__c;                   
                        }
                    }else{
                    if(flsUpdateGet(AT_Workspace__c.PSS_Workspace_Status__c))           //SCAVA FIX 
                    {
                        w.PSS_Workspace_Status__c = w.Opportunity__r.Opportunity_Status__c;
                    }
                    if(flsUpdateGet(AT_Workspace__c.Workspace_Lost_Cancelled_Reason__c))           //SCAVA FIX 
                    {
                        w.Workspace_Lost_Cancelled_Reason__c = w.Opportunity__r.Lost_Cancelled_Reason__c;
                    }               
                    workspaceUpdates.add(w);
                } 
            }
            if(workspaceUpdates.size()>0){
              Utilities.setValidationSkip(true);//skips validation rules
              Utilities.setSkip(true);//skips certain trigger functionality
              Utilities.setskipFuture(true);//skips more future calls              
              update workspaceUpdates;
            }
        }
    }
  }
    public static void syncWorkspaceWithOpty(ID[] allOptyIds)
    {
        List<AT_Workspace__c> finalUpdateList = new List<AT_Workspace__c>();    
        if (allOptyIds.size() > 0)
        {
           //get a list of oppty objects and child workspace
           List<Opportunity> listOppty = [Select Id, 
                            Forecast_Status__c,
                            CloseDate,   
                            Expected_Product__c,
                            Expected_Service__c,
                            Opportunity_Status__c,
                            StageName,
                            Lost_Cancelled_Reason__c,
                            (Select AT_Forecast_Status__c, 
                            AT_Expected_Book_Date__c, 
                            AT_Expected_Product__c,
                            AT_Expected_Service__c,
                            PSS_Workspace_Status__c,
                            Sync_With_Opportunity__c,
                            Opportunity__c,
                            Is_Multi_Tech__c  
                            From AT_Workspace__r) 
                            From Opportunity Where Id IN :allOptyIds];
    
            for (Opportunity oppty : listOppty)
            { 
                // if workspace count for this oppty is equal to 1, copy the fields from Opty to workspace
                if (oppty.AT_Workspace__r.size() == 1)
                {
                     //copy fields from oppty to workspace
                     AT_Workspace__c ws = [Select AT_Forecast_Status__c,AT_Expected_Book_Date__c,AT_Expected_Product__c,AT_Expected_Service__c,
                     PSS_Workspace_Status__c,Workspace_Stage__c,Workspace_Lost_Cancelled_Reason__c,Is_Multi_Tech__c, Sync_With_Opportunity__c ,Opportunity__r.Competitors__c, AT_Competitor__c ,Opportunity__r.Opportunity_Status__c, Referenceable_Account__c from AT_Workspace__c where id=: oppty.AT_Workspace__r][0];
                    
                    if (ws.Sync_With_Opportunity__c)
                    {           
                        // check if the fields differ in the oppty and workspace
                        // if (!workspaceInSync(ws))
                        // majanard - Added Workspace Status and Lost/Cancel reason for mapping - WR-00458.
                        if(
                        ws.AT_Forecast_Status__c != oppty.Forecast_Status__c || 
                        ws.AT_Expected_Book_Date__c != oppty.CloseDate || 
                        ws.AT_Expected_Product__c != oppty.Expected_Product__c || 
                        ws.AT_Expected_Service__c != oppty.Expected_Service__c || 
                        ws.PSS_Workspace_Status__c != oppty.Opportunity_Status__c  || 
                        ws.Workspace_Stage__c != oppty.StageName || 
                        ws.Workspace_Lost_Cancelled_Reason__c != oppty.Lost_Cancelled_Reason__c) {                            
                            if(ws.Is_Multi_Tech__c == false) {
                            if(flsUpdateGet(AT_Workspace__c.Validate_Product_Service_Update__c))           //SCAVA FIX 
                            {
                                ws.Validate_Product_Service_Update__c  = false; 
                            }
                                if(flsUpdateGet(AT_Workspace__c.AT_Expected_Product__c))           //SCAVA FIX 
                                {
                                ws.AT_Expected_Product__c = oppty.Expected_Product__c;
                                }
                                if(flsUpdateGet(AT_Workspace__c.AT_Expected_Service__c))           //SCAVA FIX 
                                {
                                ws.AT_Expected_Service__c = oppty.Expected_Service__c; 
                                }                               
                            } 
                            if(flsUpdateGet(AT_Workspace__c.AT_Forecast_Status__c))           //SCAVA FIX 
                            {                           
                            ws.AT_Forecast_Status__c = oppty.Forecast_Status__c;
                            }
                            if(flsUpdateGet(AT_Workspace__c.AT_Expected_Book_Date__c))           //SCAVA FIX 
                            {
                            ws.AT_Expected_Book_Date__c = oppty.CloseDate;
                            }
                            if(flsUpdateGet(AT_Workspace__c.PSS_Workspace_Status__c))           //SCAVA FIX 
                            {
                            ws.PSS_Workspace_Status__c = oppty.Opportunity_Status__c; 
                            }
                            if(flsUpdateGet(AT_Workspace__c.Workspace_Stage__c))           //SCAVA FIX 
                            {                       
                            ws.Workspace_Stage__c = oppty.StageName;
                            }
                            //updated as per WR-00458-0603(updating the Workspace_Lost_Cancelled_Reason__c with "Booked - Opportunity Booked" when opty status is booked)
                            // Updated as per WR-0700( Updating Referenceable_Account__c)
                            if(oppty.Opportunity_Status__c == 'Booked'){
                                ws.Workspace_Lost_Cancelled_Reason__c = 'Booked - Opportunity Booked';
                                if(flsUpdateGet(AT_Workspace__c.Referenceable_Account__c))           //SCAVA FIX 
                                {
                                ws.Referenceable_Account__c ='N/A';
                                }
                            }else{
                            if(flsUpdateGet(AT_Workspace__c.Workspace_Lost_Cancelled_Reason__c))           //SCAVA FIX 
                            {
                                ws.Workspace_Lost_Cancelled_Reason__c = oppty.Lost_Cancelled_Reason__c;
                            }
                            }
                            // Updated as per WR-0602(Updating the workspace Competitors__c)
                            if(ws.AT_Competitor__c == null && (ws.Opportunity__r.Opportunity_Status__c == 'Booked' || ws.Opportunity__r.Opportunity_Status__c == 'Lost' || ws.Opportunity__r.Opportunity_Status__c == 'Cancelled') ){
                                String strComp = ws.Opportunity__r.Competitors__c;
                                String[] arrComp = strComp.split(';');
                                if(arrComp.size()> 1){
                                if(flsUpdateGet(AT_Workspace__c.AT_Competitor__c))           //SCAVA FIX 
                                {
                                    ws.AT_Competitor__c = 'Other-Opportunity Updated';
                                }
                                }else if(arrComp.size()==1){
                                    ws.AT_Competitor__c = ws.Opportunity__r.Competitors__c;
                                }                                             
                            }
                            finalUpdateList.add(ws);
                        }
                    }
                }
            }
    
        } 
        // update the workspaces
        if(finalUpdateList.size() > 0)
        {
            Utilities.setValidationSkip(true);//skips validation rules
            Utilities.setSkip(true);//skips certain trigger functionality
            Utilities.setskipFuture(true);//skips more future calls              
            update finalUpdateList;
        }
   } 
   //test method
   public static testMethod void test_getDealId(){ 
     List<id> opt = new List<id>(); 
        Opportunity o = new Opportunity(name='Test',StageName='1 - Prospect',CloseDate=System.today(),Expected_Product__c=10.0,DealID__c='123', Opportunity_Status__c='Active');
        Insert o;   
        opt.add(o.id);
        Quote__c q = new Quote__c(Opportunity_Name__c = o.Id);     
        Insert q;     
        Opportunity op = new Opportunity(Id=o.Id,name='Test2',Opportunity_Status__c='Booked');     
        Update op;
        List<id> opts = new List<id>();  
        opts.add(op.id);
        AT_Workspace__c atw = new AT_Workspace__c();
        atw.Opportunity__c = o.id;
        atw.AT_Competitor__c ='test';
        atw.AT_Team__c ='test';
        atw.Sync_With_Opportunity__c = true;
        insert atw;
        syncWorkspaceWithOpty(opt);
        
        List<id> oppty = new List<id>();
        Opportunity opty = new Opportunity(name='Test',StageName='1 - Prospect',CloseDate=System.today(),Expected_Product__c=10.0,DealID__c='123', Opportunity_Status__c='Active');
        Insert opty;   
        oppty.add(opty.id);
        Quote__c q1 = new Quote__c(Opportunity_Name__c = opty.Id);     
        Insert q1;     
        Opportunity optys = new Opportunity(Id=o.Id,name='Test2',Opportunity_Status__c='Booked');     
        Update optys;
        List<id> opts1 = new List<id>();  
        opts1.add(optys.id);
        AT_Workspace__c atw1 = new AT_Workspace__c();
        atw1.Opportunity__c = opty.id;
        atw1.AT_Competitor__c ='test';
        atw1.AT_Team__c ='test'; 
        atw1.Sync_With_Opportunity__c = false;  
        insert atw1;      
        
        updateOpptys(opts1, oppty);
        
    }
}