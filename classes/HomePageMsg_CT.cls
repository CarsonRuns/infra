public with sharing class HomePageMsg_CT 
{


    Integer overDueOpptyCount;
    Map<Id, Id> userTerritories = new Map<Id, Id>();    
    Integer gotUserTerritories = 0;
    @TestVisible   
    String Stage1 = Utilities.getOpptyStage1();
    String Stage2 = Utilities.getOpptyStage2();
    String Stage3 = Utilities.getOpptyStage3();
    String Stage4 = Utilities.getOpptyStage4();
    String Stage5 = Utilities.getOpptyStage5();   
    //String QuoteUnfinalizedViewId = Utilities.getConstant_CS('QuotesPendingFinalznViewId');
   // String OverDuePartnerOpportunitiesViewID = Utilities.getConstant_CS('OverDuePartnerOpportunityViewID');
    String RunRateId = Utilities.getRunRateId();
    String ddPQ = 'Pending Qualification';
    String ddNA1 = 'NA';
    String ddNA2 = 'N/A';
    String Active = 'Active';
    String Booked = 'Booked';
    @TestVisible
    String Yes = 'Yes';
    String No = 'No';
    @TestVisible
    String NotForecastable = 'Not Forecastable';
    String Upside = 'Upside';
    String unifiedComputing = 'Unified Computing';
    Date startDate = Date.newInstance(2009, 3, 1);
    //Datetime jan10 =datetime.newInstance(2010,01,01,00,00,00);
    
    public string WaitingLeadsID {get{return ObjectIds('WaitingLeads');}set;}
    public string AcceptedLeadsID {get{return ObjectIds('AcceptedLeads');}set;}
    //public string MdmQualFormOpptysID {get{return ObjectIds('MdmQualFormOpptys');}set;}
    //public string MissingFieldOpptysID {get{return ObjectIds('MissingFieldOpptys');}set;}
    public string OverDueOpptysID {get{return ObjectIds('OverDueOpptys');}set;}
    public string OverDueOpptysLt30DaysID {get{return ObjectIds('OverDueOpptysLt30Days');}set;}
   // public string OverDuePSSWorkspacesID {get{return ObjectIds('OverDuePSSWorkspaces');}set;}
   // public string OverDuePSSWorkspacesLt30DaysID {get{return ObjectIds('OverDuePSSWorkspacesLt30Days');}set;}
    public string OptyWithEndDatedTerritoryID {get{return ObjectIds('OptyWithEndDatedTerritory');}set;}
    //public string OptywithoutDealId {get{return ObjectIds('OptywithoutDealId');}set;}
    //public string OverDuePartnerOpptysDaysID {get{return ObjectIds('OverDuePartnerOpptysDays');}set;}
    
    public void getUserTerritories()
    {
        if ( gotUserTerritories == 0 )
        {
            for (UserTerritory2Association ut : [Select Territory2Id From UserTerritory2Association where UserId = :UserInfo.getUserId() and IsActive = true] )
            {
                userTerritories.put(ut.Territory2Id, ut.Territory2Id);
            }
            gotUserTerritories = 1;
        }       
    }
    
   /* public String getQuoteUnfinalizedViewId(){
    
    return QuoteUnfinalizedViewId;
    
    }
    */
    /*public String getOverDuePartnerOpportunitiesViewID(){
    
    return OverDuePartnerOpportunitiesViewID;
    
    }
*/
    //Updated to read the Status and RecordTypeID from Custom Settings.
    Integer waitingLeadsCount;
    public Integer getWaitingLeads()
    { 
      //Reading the value from Custom Setting - Lead Status.
      Lead_Status__c LS = Lead_Status__c.getInstance();
      String LS_Waiting = LS.Waiting__c;
      
      //Reading the Record Type IDs from Custom Setting - Org Constants.                    
      String Lead_RType_Closed = Utilities.getConstant_CS('Lead_RType_Closed');
      waitingLeadsCount = [select count() from Lead  
                where
                OwnerId = :UserInfo.getUserId() and    
                            Status= :LS_Waiting and   
                            RecordTypeId != :Lead_RType_Closed and
                            isConverted = FALSE];
        return waitingLeadsCount;
     }             
    
    //Updated for WR-00430 and reading Status and RecordTypeID from Custom Settings.
    Integer acceptedLeadsCount;
    public Integer getAcceptedLeads()
    { 
      //Reading the value from Custom Setting - Lead Status.
      Lead_Status__c LS = Lead_Status__c.getInstance();
      String LS_Accepted = LS.Accepted__c;
      
      //Reading the Record Type IDs from Custom Setting - Org Constants.
      String Lead_RType_Closed = Utilities.getConstant_CS('Lead_RType_Closed');
      String Lead_RType_PG_Lead = Utilities.getConstant_CS('Lead_RType_PG_Lead');
      acceptedLeadsCount = [select count() from Lead  
                where
                OwnerId = :UserInfo.getUserId() and    
                            Status= :LS_Accepted and   
                            Partner_Lead_Status__c = null and
                            RecordTypeId NOT IN (:Lead_RType_Closed,:Lead_RType_PG_Lead)and 
                            isConverted = FALSE];
        return acceptedLeadsCount;
     }
        
    public Integer getOverDueOpptys()
    {
        getUserTerritories();
                                
        overDueOpptyCount = [select count() from Opportunity
                                where
                                Territory2Id in :userTerritories.keyset() and
                                    no_of_days_overdue__c > 30 and 
                                    dealid__c != '' and
                                    StageName != :Stage1 and
                                    Opportunity_Status__c = :Active];
        return overDueOpptyCount;
    }
        
    Integer overDueOpptyLt30Count;
    public Integer getOverDueOpptysLt30Days()
    {
        getUserTerritories();
                                    
        overDueOpptyLt30Count = [select count() from Opportunity
                                    where
                                        Territory2Id in :userTerritories.keyset() and
                                        no_of_days_overdue__c >= 14 and 
                                        no_of_days_overdue__c <= 30 and 
                                        dealid__c != '' and
                                        StageName != :Stage1 and
                                        Opportunity_Status__c = :Active];                                   
                                     
        system.debug('Hello World:::'+overDueOpptyLt30Count);                                                                                                                                                                                                                                                           
        return overDueOpptyLt30Count;
    }
    
  /*  public Integer getMdmQualFormOpptys()
    {
        getMdmQualFormOpptyDetails();                       
                                                                                                                                  
        return mdmQualFormOpptys.size();
    }
    */
  /*  Opportunity[] mdmQualFormOpptys;
    public Opportunity[] getMdmQualFormOpptyDetails()
    {
        if ( mdmQualFormOpptys == null )
        {
            getUserTerritories();
        
            mdmQualFormOpptys = [Select id, name, DealID__c, AccountId, stageName, Opportunity_Status__c, Automate_Movement_to_Stage_3__c,
                                            Forecast_Status__c, closedate   from Opportunity 
                                        where
                                            TerritoryId in :userTerritories.keyset() and
                                            StageName in (:Stage1,:Stage2) and
                                            DD_Status__c != :ddPQ and 
                                            DD_Status__c != :ddNA1 and
                                            DD_Status__c != :ddNA2 and                                      
                                            DD_Status__c != '' and
                                            Automate_Movement_to_Stage_3__c = null and
                                            Opportunity_Status__c = :Active 
                                            limit 100];
        }                                           
                                                                                                                                  
        return mdmQualFormOpptys;
    }*/   
    
    public List<SelectOption> getItems() 
    {
          List<SelectOption> options = new List<SelectOption>(); 
          options.add(new SelectOption(Yes,Yes)); 
          options.add(new SelectOption(No,No)); 

        return options; 
    }

   /* Opportunity[] mdmQualFormOpptysToUpdate = new Opportunity[]{};
    public PageReference MDMAutoMakeUpdates() 
    {
        for (Opportunity o: mdmQualFormOpptys)
        {
           if(o.Automate_Movement_to_Stage_3__c != null)
           {
               if (o.Automate_Movement_to_Stage_3__c == Yes)
               {
                o.stageName = Stage3;
                if (o.Forecast_Status__c == NotForecastable)
                {
                    o.Forecast_Status__c = Upside;  
                }                
               }
               mdmQualFormOpptysToUpdate.add(o);
           }    
        }
        
        PageReference newpage = new PageReference('/home/home.jsp');        
        newpage.setRedirect(true);        

        Utilities.setSkip(true);//skips certain trigger functionality
        Utilities.setValidationSkip(true);

        try
        {
            update(mdmQualFormOpptysToUpdate);
        }
        catch(DmlException e)
        {
            ApexPages.addMessages(e);
            newpage = null;
        }
        return newpage;
    }
     */ 
  //  Integer missingFieldOpptyCount;
   /* public Integer getMissingFieldOpptys()
    {                                    
        missingFieldOpptyCount = [select count() from Opportunity
                                    where
                                        CloseDate > :startDate and                                    
                                        OwnerId = :UserInfo.getUserId() and
                                        StageName IN(:Stage3,:Stage4,:Stage5) and                                                
                                        Partner_Required__c = true and 
                                        Primary_Partner__c = null and
                                        Partner_2__c = null and
                                        Partner_3__c = null and
                                        Partner_4__c = null and
                                        Partner_5__c = null and
                                        Expected_Product__c > 0 and
                                        Opportunity_Status__c = :Active and
                                        Account.Name != 'RUNRATE(FORECASTED)'/*and
                                        Account.CSCSiteID__c != :RunRateId and
                                        Account.CSCID__c != :RunRateId]; */
                                                                                
                                        
                                        
                                        /*OwnerId = :UserInfo.getUserId() and
                                        CreatedDate > 2008-07-27T00:00:00-00:00 and
                                        ((Opportunity_Status__c IN('Cancelled','Lost') and
                                        Lost_Cancelled_Reason__c IN('-','')) or
                                        (Expected_Product__c > 0 and 
                                        ((StageName IN(:Stage2,:Stage3,:Stage4,:Stage5) and
                                        Competitors__c IN ('','Competitors')) or
                                        (StageName IN(:Stage3,:Stage4,:Stage5) and
                                        Forecast_Discount__c = NULL))))];
                                                                          
                                     
                                                                                                                                  
        return missingFieldOpptyCount;
    }
    */
   // Integer unconvertedOpptyCount = 0;
    /*public Integer getUnconvertedOpptys(){
        
        String cecUserName = UserInfo.getUserName().split('@')[0]; 
        String notificationType = 'UNCONVERTED_COUNT_' + cecUserName;
         
        Unconverted_Opportunities__c[] u = [Select Number_of_Unconverted_Opportunities__c from Unconverted_Opportunities__c
                                    Where CEC_User_Name__c = :cecUserName and Notification_Type__c = :notificationType limit 1];
        
        if(u.size() > 0) {  
            
        if (u[0].Number_of_Unconverted_Opportunities__c != NULL )
            unconvertedOpptyCount = integer.valueOf(String.valueOf(u[0].Number_of_Unconverted_Opportunities__c));  
          else
            unconvertedOpptyCount = 0; }
       
        return unconvertedOpptyCount;                           
    }
    */
   // Integer dealsPendingApprovalCount = 0;
   /* public Integer getDealsPendingApproval(){
        
       String cecUserName1 = UserInfo.getUserName().split('@')[0];
       String notificationType1 = 'PENDING_APPROVAL_COUNT_' + cecUserName1;

        Unconverted_Opportunities__c[] uu = [Select Number_of_Unconverted_Opportunities__c from Unconverted_Opportunities__c
                                    Where CEC_User_Name__c = :cecUserName1 and Notification_Type__c = :notificationType1  limit 1];
        
        if(uu.size() > 0)     {  
            if(uu[0].Number_of_Unconverted_Opportunities__c != NULL )
             dealsPendingApprovalCount = integer.valueOf(String.valueOf(uu[0].Number_of_Unconverted_Opportunities__c));  
        else
              dealsPendingApprovalCount = 0;}
                                 
        return dealsPendingApprovalCount;                           
    }
    */
    //Integer unfinalizedQuoteCount = 0;
   /* public Integer getUnfinalizedQuotes(){
        
       String cecUserName2 = UserInfo.getUserName().split('@')[0];
       String notificationType2 = 'UNFINALIZED_QUOTE_COUNT_' + cecUserName2;
       
        Unconverted_Opportunities__c[] uu = [Select Number_of_Unconverted_Opportunities__c from Unconverted_Opportunities__c
                                    Where CEC_User_Name__c = :cecUserName2 and Notification_Type__c = :notificationType2 limit 1];
        
        if(uu.size() > 0)     {  
            if(uu[0].Number_of_Unconverted_Opportunities__c != NULL )
             unfinalizedQuoteCount = integer.valueOf(String.valueOf(uu[0].Number_of_Unconverted_Opportunities__c));  
        else
              unfinalizedQuoteCount = 0;}
                                 
        return unfinalizedQuoteCount;                           
    }
    */
    //Integer overDuePartnerOpptyCount = 0;
    /*public Integer getOverDuePartnerOpptysDays()
    {
        getUserTerritories();
                                    
        overDuePartnerOpptyCount = [select count() from Opportunity
                                    where
                                        TerritoryId in :userTerritories.keyset() and
                                        Opportunity_flags__c = 'Partner Led' and 
                                        dealid__c != '' and
                                        StageName = :Stage1 and
                                        Opportunity_Status__c = :Active];                                   
                                     
        system.debug('Hello World:::'+overDuePartnerOpptyCount);                                                                                                                          
        return overDuePartnerOpptyCount;
    }
*/

    /*This Method returns the number of UCS opportunities which are not requested for SAC Support(i.e., UCS Opportunities
    which do not have their corresponding records in Support Request Object)*/
    
   /* public Integer getNoOfSupportRequestOpptiesNotEnrolled(){
    List<Opportunity> allOpptyLines = [select Id from Opportunity where 
                                      OwnerId=:UserInfo.getUserId() and
                                      Opportunity_Status__c = :Active and
                                      Sales_Support_Reminder__c = 'True'];
                                      
         return (allOpptyLines.size());
         }                              


    Integer overDuePSSWorkspaces;
    public Integer getOverDuePSSWorkspaces(){
    
        if(UserInfo.getProfileId() != '00e30000000rrZwAAI')
            return 0;
        
        overDuePSSWorkspaces = [Select count() From AT_Workspace__c Where PSS__c = :UserInfo.getUserId() and 
                                PSS_Workspace_Status__c = 'Active' and
                                AT_Forecast_Status__c IN ('Commit','Upside') and
                                Forecast_Position_ID__c > '0' and
                                AT_No_of_days_Overdue__c > 30];
                                
        return overDuePSSWorkspaces;                                                             
    }
    
    Integer overDuePSSWorkspacesLt30Days;
    public Integer getOverDuePSSWorkspacesLt30Days(){
    
        if(UserInfo.getProfileId() != '00e30000000rrZwAAI')
            return 0;
        
        overDuePSSWorkspacesLt30Days = [Select count() From AT_Workspace__c Where PSS__c = :UserInfo.getUserId() and 
                                PSS_Workspace_Status__c = 'Active' and
                                AT_Forecast_Status__c IN ('Commit','Upside') and
                                Forecast_Position_ID__c > '0' and
                                AT_No_of_days_Overdue__c >= 14 and
                                AT_No_of_days_Overdue__c <= 30];
                                
        return overDuePSSWorkspacesLt30Days;                                                             
    }
    
    */
    Integer OptyWithEndDatedTerritory;
    Public Integer getOptyWithEndDatedTerritory () { 
    String parentrectype = ObjectRecordTypeIds__c.getInstance().Opportunity_Parent_RecordTypeId__c;
    String partnerparenttrectype = ObjectRecordTypeIds__c.getInstance().Opportunity_Partner_Parent_RecordTypeId__c; 
    
    OptyWithEndDatedTerritory = [SELECT count() FROM Opportunity
                                 WHERE
                                 OwnerId=:UserInfo.getUserId() AND 
                                 (RecordTypeId = :parentrectype  OR
                                 RecordTypeId = :partnerparenttrectype ) AND
                                 Territory2Id IN (SELECT id FROM Territory2 WHERE End_Dated__c = true) 
                                ];
     
    return OptyWithEndDatedTerritory;
    
    }
    
  /*  Integer OptyWithoutDealIdcount;
    Public Integer getOptyWithoutDealIdcount() { 
    
    String parentrectype = ObjectRecordTypeIds__c.getInstance().Opportunity_Parent_RecordTypeId__c;
    OptyWithoutDealIdcount = [SELECT count() FROM Opportunity
                                 WHERE
                                 OwnerId=:UserInfo.getUserId() AND 
                                 DealID__c = '' AND
                                 RecordTypeId = :parentrectype AND
                                 (Opportunity_Status__c = :Active AND
                                 Closedate >= Today)
                                ];
     
    return OptyWithoutDealIdcount;
    
    }
    */
    //Added for P360. User story-US4489 - START
    //To display the count of Target Prospects Expiring in a day
    /*Public String TPsExpiringTodayViewId { 
                   get {return Utilities.getConstant_CS('P360_ProspectExpiringToday_ViewId');}
    }
    Public Integer getTPsExpiringToday(){
     Integer TPsExpiringToday = 0;
     try{
      TPsExpiringToday = [Select Count() from Assigned_Partner__c where Expiration_Date__c = Today 
                         AND OwnerId =: Userinfo.getUserId() AND Assignment_Activated__c = TRUE];
     }Catch(Exception e){
     
     }
     return TPsExpiringToday;
    }
    //Added for P360. User story-US4489 - END

*/
    //Function to get value of passed Object Ids Custom setting
     public ID ObjectIds(string record)
     {
         Object_ID__c ObjectIDs = Object_ID__c.getValues(record);
         return ObjectIDs.IDVal__c;        
     }   
    
    
}