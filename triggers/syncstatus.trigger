// ********************** Change History **********************
// 11/10/2016 Harshita - WR-0698-SFDC Workpace - Do not allow Workspace deletion by Profiles other than Admins,GSTS and Cisco deployment support. 
// **************************************************************

trigger syncstatus on AT_Workspace__c (after insert, after update, after delete,before delete) 
{
    Integer count = 0;
    List<Id> opptyId = new List<Id>();
    List<AT_Workspace__c> updatedAtw = new List<AT_Workspace__c>();
    
    if(Trigger.isInsert || Trigger.isUpdate)
    {
        if(!PSSUser_CT.hasAlreadyDone())
        {
            PSSUser_CT.setAlreadyDone();
            for(AT_Workspace__c atw : Trigger.new)
            {
                opptyId.add(atw.Opportunity__c);
            }    
        
            if (opptyId.size() > 0)
            {
               
                //get a list of oppty objects and child workspace
                List<Opportunity> listOppty = [Select Id, 
                        Forecast_Status__c,
                        CloseDate,   
                        Expected_Product__c,
                        Expected_Service__c,
                        Opportunity_Status__c,
                        (Select AT_Forecast_Status__c, 
                        AT_Expected_Book_Date__c, 
                        AT_Expected_Product__c,
                        AT_Expected_Service__c,
                        PSS_Workspace_Status__c,
                        Sync_With_Opportunity__c,
                        Opportunity__c,
                        is_Multi_tech__c  
                        From AT_Workspace__r ORDER BY Id ASC) 
                        From Opportunity Where Id IN :opptyId];
                
                for (Opportunity oppty : listOppty)
                {
                    count = 0;
                    // if workspace count for this oppty is equal to 1
                    if (oppty.AT_Workspace__r.size() == 1)
                    {
                       
                        //copy fields from oppty to workspace
                        AT_Workspace__c ws = oppty.AT_Workspace__r;

                        if(ws.Sync_With_Opportunity__c == true)
                        {
                           
                            ws.Sync_Status__c = 'Sync Enabled';
                            //--code Start-- Real Time sync the workspaces with the oppty
                            if(ws.AT_Forecast_Status__c!=oppty.Forecast_Status__c || ws.AT_Expected_Book_Date__c != oppty.CloseDate || ws.AT_Expected_Product__c != oppty.Expected_Product__c || ws.AT_Expected_Service__c != oppty.Expected_Service__c || ws.PSS_Workspace_Status__c != oppty.Opportunity_Status__c)
                            {
                                System.debug('Delete :: Real Time sync the workspaces with the oppty :: ');
                                ws.AT_Forecast_Status__c = oppty.Forecast_Status__c;
                                ws.AT_Expected_Book_Date__c = oppty.CloseDate;         
                                ws.PSS_Workspace_Status__c = oppty.Opportunity_Status__c;
                                
                                if(ws.Is_Multi_Tech__c == false) { 
                                    ws.Validate_Product_Service_Update__c  = false;                       
                                    ws.AT_Expected_Product__c = oppty.Expected_Product__c;
                                    ws.AT_Expected_Service__c = oppty.Expected_Service__c;   
                                }    
                            }
                            //--Code End--
                            updatedAtw.add(ws);
                        }
                        else if(ws.Sync_With_Opportunity__c == false)
                        {
                            
                            ws.Sync_Status__c = 'Sync Not Requested';
                            updatedAtw.add(ws);
                        }
                       
                    }
                    else if (oppty.AT_Workspace__r.size() > 1)
                    {
                        
                        for(AT_Workspace__c atw1 : oppty.AT_Workspace__r)
                        {
                            if(atw1.Sync_With_Opportunity__c == true)
                    
                                atw1.Sync_Status__c = 'Sync is Disabled';
                            else
                                atw1.Sync_Status__c = 'Sync cannot be Enabled';
                            
                            updatedAtw.add(atw1);
                            
                        }
                    }
                }
            }
        }
    }
 //WR-0698-SFDC Workpace - Do not allow deletion by roles other than Admins and GSTS
    
                    
    if(Trigger.isDelete)
    {   
        if(Trigger.isBefore)         
        { 
            String currentProfileID = UserInfo.getProfileId();           
            for(AT_Workspace__c atw1 : Trigger.old)
            {            
				if(atw1.AT_Team__c != null){
					If (atw1.AT_Team__c.startsWithIgnoreCase('SEC_'))
					{                     
						if(!Utilities.getConstant_CS('Workspace_Delete_ProfileID').contains(currentProfileID)){                    
							String printLabel = Label.Delete_Error_for_Workspace;
							atw1.addError(printLabel);
						}
					}
				}
            }
        }
       
        for(AT_Workspace__c atw : Trigger.old)
        {
            opptyId.add(atw.Opportunity__c);
        }
        
        if (opptyId.size() > 0)
        {
            
            //get a list of oppty objects and child workspace
            List<Opportunity> listOppty = [Select Id, 
                        Forecast_Status__c,
                        CloseDate,   
                        Expected_Product__c,
                        Expected_Service__c,
                        Opportunity_Status__c,
                        (Select AT_Forecast_Status__c, 
                        AT_Expected_Book_Date__c, 
                        AT_Expected_Product__c,
                        AT_Expected_Service__c,
                        PSS_Workspace_Status__c,
                        Sync_With_Opportunity__c,
                        Opportunity__c,
                        is_Multi_tech__c  
                        From AT_Workspace__r ORDER BY Id ASC) 
                        From Opportunity Where Id IN :opptyId];
            
            for (Opportunity oppty : listOppty)
            {    
                count = 0;
                // if workspace count for this oppty is equal to 1
                if (oppty.AT_Workspace__r.size() == 1)
                {
                    //copy fields from oppty to workspace
                    AT_Workspace__c ws = oppty.AT_Workspace__r;

                    if(ws.Sync_With_Opportunity__c == true)
                    {
                        
                        ws.Sync_Status__c = 'Sync Enabled';
                        //--code Start-- Real Time sync the workspaces with the oppty
                        if(ws.AT_Forecast_Status__c!=oppty.Forecast_Status__c || ws.AT_Expected_Book_Date__c != oppty.CloseDate || ws.AT_Expected_Product__c != oppty.Expected_Product__c || ws.AT_Expected_Service__c != oppty.Expected_Service__c || ws.PSS_Workspace_Status__c != oppty.Opportunity_Status__c)
                        {
                            
                            ws.AT_Forecast_Status__c = oppty.Forecast_Status__c;
                            ws.AT_Expected_Book_Date__c = oppty.CloseDate;    
                            ws.PSS_Workspace_Status__c = oppty.Opportunity_Status__c;
                                                        
                            if(ws.Is_Multi_Tech__c == false) {  
                                ws.Validate_Product_Service_Update__c  = false;         
                                ws.AT_Expected_Product__c = oppty.Expected_Product__c;
                                ws.AT_Expected_Service__c = oppty.Expected_Service__c;   
                            } 
                        }
                        //--Code End--
                        updatedAtw.add(ws);
                    }
                    else if(ws.Sync_With_Opportunity__c == false)
                    {
                       ws.Sync_Status__c = 'Sync Not Requested';
                        updatedAtw.add(ws);
                    }
                    
                }
                else if (oppty.AT_Workspace__r.size() > 1)
                {    
                  for(AT_Workspace__c atw1 : oppty.AT_Workspace__r)
                    {
                        if(atw1.Sync_With_Opportunity__c == true)
                     
                            atw1.Sync_Status__c = 'Sync is Disabled';
                        else
                            atw1.Sync_Status__c = 'Sync cannot be Enabled';
                    
                        updatedAtw.add(atw1);
                    }
                }
            }
        }
    }
   
    update updatedAtw;
}