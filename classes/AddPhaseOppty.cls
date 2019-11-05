/*********************** Change History **************************
01 WR-01471 03/13/2016 - AIP Deviation and Silling Motion added for Phase creation logic
02 udkatta - US146613 11/29/2017 - ACV fields in Phase Opportunities
03 Bodurais - 25.04.2018, SCAVA scan fixes
04 Awnish - 10.06.2019, Added logic to copy Lead details from Parent Opty
*/

global class AddPhaseOppty
{
    //updated on 3 April 2012
    private static boolean processLineItems = true;

    public static void setProcessLineItems(boolean newStatus){
        processLineItems = newStatus;
    }
    //SCAVA helper method
    public static Boolean flsGet(SObjectField field)
    {
        return field.getDescribe().isCreateable() ? true : false;
    }

    // Actual Code Starts
    static final Integer MAX_NUM_CHILD_PHASES=500;
    WebService static String AddPhase(String OpportunityID, String RecordType){
        try{
            ObjectRecordTypeIds__c objRecordTypeSetting = ObjectRecordTypeIds__c.getOrgDefaults();
            String endUserAccRT = objRecordTypeSetting.Account_End_User_RecordTypeId__c ;
            
            Opportunity[] rsOpportunity = [SELECT Account.RecordTypeId, SE_Status__c, AccountId, AIP_Deviation__c, Big_Bet__c, Campaign_Description__c, Cisco_Capital_Financing__c, Cloud_Deal__c,
                                           Cloud_Demand_Partner_Service_OfferLookup__c, Cloud_Demand_Term_Months__c, Cloud_Number_of_Units__c, Competitors__c, Contractual_Pricing_Letter_Opportunity__c,
                                           Customer_Use_Case__c, DD_Status__c, DealID__c, Description, Discount_Approval__c, eLeads_ID__c, End_Date__c, Enterprise_Agreement_Opportunity__c, Forecast_Discount__c, Global_Deal_ID__c,
                                           Go_to_Market_Segment__c, Id, Installed_Base__c, LeadSource, Managed_Services__c, Marketing_Programs__c, Name, Network_Assessment_Conducted__c,
                                           New_Franchise__c, Non_Standard_Terms_and_Conditions__c, Opportunity_Flags__c, Opportunity_Status__c, OwnerId, Parent_ID__c, Partner_2__c, Partner_3__c,
                                           Partner_Deal_Type__c, Partner_Required__c, Position__c, Primary_Partner__c, Primary_Partner_Role__c, Product_Enhancements__c,
                                           Program_Event_Code__c, Program_Event_Name__c, Project_Budget__c, Provisioned_Managed_Services__c, Public_Sector_Funding__c, Pull_Forward_Date__c,
                                           Refurbished_Deal__c, Role_2__c, Role_3__c,  Sales_Path__c, Sales_Programs__c, Selling_Motion__c, Service_Source__c,
                                           Software_Buying_Program__c, Software_Buying_Program_DurationMonths__c, Software_Offer_Name__c, Software_Offer_Value__c, Software_Type__c,
                                           Solution_Identifier__c, Solution_Positioning__c, Solutions__c, SP_Internal_IT__c, StageName, Start_Date__c, Territory2Id, Theater__c, Waves__c,
                                           Partner_4__c, Partner_5__c, Role_4__c, Role_5__c,Industry_Solution__c,DRT_Lead__c  // to be removed
                                           FROM Opportunity WHERE Id = :OpportunityID];
                                            
            if(rsOpportunity.size()==1){
                if(rsOpportunity[0].Parent_ID__c==null){
                    
                    String opptyAccountRT = rsOpportunity[0].Account.RecordTypeId ;
                    
                    System.debug('@@@@ rsOpportunity account record type'+ opptyAccountRT); 
                    System.debug('@@@@ Account End User Rec type from custom setting'+ endUserAccRT);
                    
                    //Checkeing if the account related to Oppty is End User Account
                    if(!opptyAccountRT.contains(endUserAccRT))
                    {
                        return '4';
                    } 
                
                    Opportunity[] rsPhaseCount = [SELECT Id FROM Opportunity WHERE Parent_ID__c = :rsOpportunity[0].Id];
                    if(rsPhaseCount.size()>=MAX_NUM_CHILD_PHASES){
                        return '3';
                    }
                    else{
                        Integer NewPhaseName=rsPhaseCount.size()+1;
                        String strNewPhaseName ='';
                        if(rsOpportunity[0].Name.length()>88){
                            strNewPhaseName = rsOpportunity[0].Name.substring(0,88)+ '- Phase ' + NewPhaseName ;
                        }
                        else{
                            strNewPhaseName = rsOpportunity[0].Name+ '- Phase ' + NewPhaseName ;
                        }
                        Opportunity[] rsOppAlreadyExists=[Select Id from Opportunity where Name = :strNewPhaseName and AccountId = :rsOpportunity[0].AccountId];
                        if(rsOppAlreadyExists.size()>0){
                            if(rsOpportunity[0].Name.length()>66){
                                strNewPhaseName = rsOpportunity[0].Name.substring(0,66)+ '- Phase ' + NewPhaseName +' - ' + System.now();
                            }
                            else{
                                strNewPhaseName = rsOpportunity[0].Name+ '- Phase ' + NewPhaseName +' - ' + System.now();
                            }
                        }
                        String rsRecordType;
                        String partnerParentRT = Utilities.getRecordTypeId('Opportunity', 'Partner Parent Opportunity');
                        String parentRT = Utilities.getRecordTypeId('Opportunity', 'Parent Opportunity');
                        String partnerphaseRT = Utilities.getRecordTypeId('Opportunity','Partner Phase Opportunity');
                        system.debug('parentRT'+parentRT );
                        String rsOwner;
                        String rsPartner;
                        String rsPartnerRole;
                        String partner2;
                        String partner2role;
                        
                        //Check to see if coming from Partner Parent
                        //Dec''2014 WR-00881 - Adding Parent Oppty for Partner Copy Check
                          // if(partnerParentRT.contains(RecordType) || parentRT.contains(RecordType)){
                       // if((partnerParentRT.contains(RecordType) && parentRT.contains(RecordType))||(partnerParentRT.contains(RecordType))){
                       if(partnerParentRT.contains(RecordType) || partnerphaseRT.contains(RecordType)){
                            rsRecordType = Utilities.getRecordTypeId('Opportunity', 'Partner Phase Opportunity');
                            rsOwner = rsOpportunity[0].OwnerId;
                            
                            rsPartner = rsOpportunity[0].Primary_Partner__c;
                            rsPartnerRole = rsOpportunity[0].Primary_Partner_Role__c;
                        }
                        else {
                            rsRecordType = Utilities.getRecordTypeId('Opportunity', 'Phase Opportunity');
                            rsOwner = UserInfo.getUserId();
                        } 
                        
                        //Dec'2014 WR-00881 - Removed the 'If' condition to copy Partner2 details- if(rsOpportunity[0].Partner_Deal_Type__c != null)
                        partner2 = rsOpportunity[0].Partner_2__c;
                        partner2role = rsOpportunity[0].Role_2__c;
                        
                        //Check for the EPSS User and VDC Lead
                        System.debug('>> '+rsOpportunity[0].DRT_Lead__c);
                        System.debug('>> '+Utilities.checkAdditionalUserPermission('Enable_ePSS'));
                        if(Utilities.checkAdditionalUserPermission('Enable_ePSS') || rsOpportunity[0].DRT_Lead__c!=null)
                        {
                        rsOwner = rsOpportunity[0].OwnerId;
                        }
                        
                    
                        //Dec'2014 WR-00881 - added additional fields to Phase Copy
                        Opportunity NewPhaseOppty = new Opportunity();
                        //May20: SCAVA fix  
                        system.debug('#1:'+ flsGet(Opportunity.Accountid));                      
                        if(flsGet(Opportunity.Accountid)) {
                            NewPhaseOppty.AccountId = rsOpportunity[0].AccountId;
                        }
                        //May20: SCAVA fix
                        system.debug('#2:'+ flsGet(Opportunity.AIP_Deviation__c));
                        if(flsGet(Opportunity.AIP_Deviation__c)) {                         
                            NewPhaseOppty.AIP_Deviation__c= rsOpportunity[0].AIP_Deviation__c;  // added two fields as per WR-01471 
                        }
                        
                        //May20: SCAVA fix
                        system.debug('#3:'+ flsGet(Opportunity.Big_Bet__c));
                        if(flsGet(Opportunity.Big_Bet__c)) {
                            NewPhaseOppty.Big_Bet__c = rsOpportunity[0].Big_Bet__c;
                        }
                        //May20: SCAVA fix
                        system.debug('#4:'+ flsGet(Opportunity.Campaign_Description__c));
                        if(flsGet(Opportunity.Campaign_Description__c)) {
                            NewPhaseOppty.Campaign_Description__c = rsOpportunity[0].Campaign_Description__c; 
                        }
                        //May20: SCAVA fix
                        system.debug('#5:'+ flsGet(Opportunity.Cisco_Capital_Financing__c));
                        if(flsGet(Opportunity.Cisco_Capital_Financing__c)) { 
                            NewPhaseOppty.Cisco_Capital_Financing__c = rsOpportunity[0].Cisco_Capital_Financing__c;  
                        }
                        //May20: SCAVA fix
                        if(flsGet(Opportunity.CloseDate)) {
                            NewPhaseOppty.CloseDate=System.today();   
                        }
                        //May20: SCAVA fix
                        if(flsGet(Opportunity.Cloud_Deal__c)) {
                            NewPhaseOppty.Cloud_Deal__c= rsOpportunity[0].Cloud_Deal__c;  
                        }
                        //May20: SCAVA fix
                        if(flsGet(Opportunity.Cloud_Demand_Partner_Service_OfferLookup__c)) {
                            NewPhaseOppty.Cloud_Demand_Partner_Service_OfferLookup__c= rsOpportunity[0].Cloud_Demand_Partner_Service_OfferLookup__c; 
                        }
                        //May20: SCAVA fix
                        if(flsGet(Opportunity.Cloud_Demand_Term_Months__c)) {
                            NewPhaseOppty.Cloud_Demand_Term_Months__c= rsOpportunity[0].Cloud_Demand_Term_Months__c;  
                        }
                        //May20: SCAVA fix
                        if(flsGet(Opportunity.Cloud_Number_of_Units__c)) {
                            NewPhaseOppty.Cloud_Number_of_Units__c = rsOpportunity[0].Cloud_Number_of_Units__c; 
                        }
                        //May20: SCAVA fix
                        if(flsGet(Opportunity.Competitors__c)) {
                            NewPhaseOppty.Competitors__c= rsOpportunity[0].Competitors__c;    
                        }
                        //May20: SCAVA fix
                        if(flsGet(Opportunity.Contractual_Pricing_Letter_Opportunity__c)) {
                            NewPhaseOppty.Contractual_Pricing_Letter_Opportunity__c = rsOpportunity[0].Contractual_Pricing_Letter_Opportunity__c; 
                        }
                        //May20: SCAVA fix
                        if(flsGet(Opportunity.Customer_Use_Case__c)) {
                            NewPhaseOppty.Customer_Use_Case__c = rsOpportunity[0].Customer_Use_Case__c;   
                        }
                        //May20: SCAVA fix
                        if(flsGet(Opportunity.DD_Status__c)) {
                            NewPhaseOppty.DD_Status__c= rsOpportunity[0].DD_Status__c; 
                        }
                        //May20: SCAVA fix
                        if(flsGet(Opportunity.DealID__c)) {
                            NewPhaseOppty.DealID__c= rsOpportunity[0].DealID__c;  
                        }
                        //May20: SCAVA fix
                        if(flsGet(Opportunity.Description)) {
                            NewPhaseOppty.Description= rsOpportunity[0].Description;  
                        }
                        //May20: SCAVA fix
                        if(flsGet(Opportunity.Discount_Approval__c)) {
                            NewPhaseOppty.Discount_Approval__c = rsOpportunity[0].Discount_Approval__c; 
                        }
                        //May20: SCAVA fix
                        if(flsGet(Opportunity.eLeads_ID__c)) {
                            NewPhaseOppty.eLeads_ID__c= rsOpportunity[0].eLeads_ID__c;   
                        }
                        //May20: SCAVA fix
                        if(flsGet(Opportunity.End_Date__c)) {
                            NewPhaseOppty.End_Date__c= rsOpportunity[0].End_Date__c;  
                        }
                        //May20: SCAVA fix
                        if(flsGet(Opportunity.Enterprise_Agreement_Opportunity__c)){
                            NewPhaseOppty.Enterprise_Agreement_Opportunity__c = rsOpportunity[0].Enterprise_Agreement_Opportunity__c; //May20: Adding EA field
                        }
                        //May20: SCAVA fix
                        if(flsGet(Opportunity.Forecast_Discount__c)) {
                            NewPhaseOppty.Forecast_Discount__c= rsOpportunity[0].Forecast_Discount__c; 
                        }
                        //May20: SCAVA fix
                        if(flsGet(Opportunity.Global_Deal_ID__c)) {
                            NewPhaseOppty.Global_Deal_ID__c = rsOpportunity[0].Global_Deal_ID__c;
                        }
                        //May20: SCAVA fix
                        if(flsGet(Opportunity.Go_to_Market_Segment__c)) {
                            NewPhaseOppty.Go_to_Market_Segment__c= rsOpportunity[0].Go_to_Market_Segment__c; 
                        }
                        //May20: SCAVA fix
                        if(flsGet(Opportunity.Installed_Base__c)) {
                            NewPhaseOppty.Installed_Base__c = rsOpportunity[0].Installed_Base__c;
                        }
                        //May20: SCAVA fix
                        if(flsGet(Opportunity.LeadSource)) {
                            NewPhaseOppty.LeadSource = rsOpportunity[0].LeadSource;
                        }
                        //May20: SCAVA fix
                        if(flsGet(Opportunity.Managed_Services__c)) {
                            NewPhaseOppty.Managed_Services__c= rsOpportunity[0].Managed_Services__c;
                        }
                        //May20: SCAVA fix
                        if(flsGet(Opportunity.Marketing_Programs__c)) {
                            NewPhaseOppty.Marketing_Programs__c= rsOpportunity[0].Marketing_Programs__c;
                        }
                        //May20: SCAVA fix
                        if(flsGet(Opportunity.Name)) {
                            NewPhaseOppty.Name= strNewPhaseName;
                        }
                        //May20: SCAVA fix
                        if(flsGet(Opportunity.Network_Assessment_Conducted__c)) {
                            NewPhaseOppty.Network_Assessment_Conducted__c = rsOpportunity[0].Network_Assessment_Conducted__c;  
                        }
                        //May20: SCAVA fix
                        if(flsGet(Opportunity.New_Franchise__c)) {
                            NewPhaseOppty.New_Franchise__c= rsOpportunity[0].New_Franchise__c;
                        }
                        //May20: SCAVA fix
                        if(flsGet(Opportunity.Non_Standard_Terms_and_Conditions__c)) {
                            NewPhaseOppty.Non_Standard_Terms_and_Conditions__c = rsOpportunity[0].Non_Standard_Terms_and_Conditions__c;
                        }
                        //May20: SCAVA fix
                        if(flsGet(Opportunity.Opportunity_Flags__c)) {
                            NewPhaseOppty.Opportunity_Flags__c = rsOpportunity[0].Opportunity_Flags__c;
                        }
                        //May20: SCAVA fix
                        if(flsGet(Opportunity.Opportunity_Owner_AM__c)) {
                            NewPhaseOppty.Opportunity_Owner_AM__c = rsOwner;
                        }
                        //May20: SCAVA fix
                        if(flsGet(Opportunity.Opportunity_Status__c)) {
                            NewPhaseOppty.Opportunity_Status__c= rsOpportunity[0].Opportunity_Status__c;
                        }
                        //May20: SCAVA fix
                        if(flsGet(Opportunity.OwnerId)) {
                            NewPhaseOppty.OwnerId = rsOwner;
                        }
                        //May20: SCAVA fix
                        if(flsGet(Opportunity.Parent_ID__c)) {
                            NewPhaseOppty.Parent_ID__c = rsOpportunity[0].Id;  
                        }
                        //May20: SCAVA fix
                        if(flsGet(Opportunity.Partner_2__c)) {
                            NewPhaseOppty.Partner_2__c = partner2;
                        }
                        //May20: SCAVA fix
                        if(flsGet(Opportunity.Partner_3__c)) {
                            NewPhaseOppty.Partner_3__c= rsOpportunity[0]. Partner_3__c;
                        }
                        //May20: SCAVA fix
                        if(flsGet(Opportunity.Partner_4__c)) {
                            NewPhaseOppty.Partner_4__c= rsOpportunity[0].Partner_4__c; // to be removed   
                        }
                        //May20: SCAVA fix
                        if(flsGet(Opportunity.Partner_5__c)) {
                            NewPhaseOppty.Partner_5__c= rsOpportunity[0].Partner_5__c; // to be removed   
                        }
                        //May20: SCAVA fix
                        if(flsGet(Opportunity.Partner_Deal_Type__c)) {
                            NewPhaseOppty.Partner_Deal_Type__c = rsOpportunity[0].Partner_Deal_Type__c;
                        }
                        //May20: SCAVA fix
                        if(flsGet(Opportunity.Partner_Required__c)) {
                            NewPhaseOppty.Partner_Required__c = rsOpportunity[0].Partner_Required__c; 
                        }
                        //May20: SCAVA fix
                        if(flsGet(Opportunity.Position__c)) {
                            NewPhaseOppty.Position__c= rsOpportunity[0].Position__c;  
                        }
                        //May20: SCAVA fix
                        if(flsGet(Opportunity.Primary_Partner__c)) {
                            NewPhaseOppty.Primary_Partner__c = rsPartner; 
                        }
                        //May20: SCAVA fix
                        if(flsGet(Opportunity.Primary_Partner_Role__c)) {
                            NewPhaseOppty.Primary_Partner_Role__c= rsPartnerRole; 
                        }
                        //May20: SCAVA fix
                        if(flsGet(Opportunity.Product_Enhancements__c)) {
                            NewPhaseOppty.Product_Enhancements__c = rsOpportunity[0].Product_Enhancements__c; 
                        }
                        //May20: SCAVA fix
                        if(flsGet(Opportunity.Program_Event_Code__c)) {
                            NewPhaseOppty.Program_Event_Code__c = rsOpportunity[0].Program_Event_Code__c;
                        }
                        //May20: SCAVA fix
                        if(flsGet(Opportunity.Program_Event_Name__c)) {
                            NewPhaseOppty.Program_Event_Name__c = rsOpportunity[0].Program_Event_Name__c; 
                        }
                        //May20: SCAVA fix
                        if(flsGet(Opportunity.Project_Budget__c)) {
                            NewPhaseOppty.Project_Budget__c= rsOpportunity[0].Project_Budget__c;  
                        }
                        //May20: SCAVA fix
                        if(flsGet(Opportunity.Provisioned_Managed_Services__c)) {
                            NewPhaseOppty.Provisioned_Managed_Services__c= rsOpportunity[0].Provisioned_Managed_Services__c; 
                        }
                        //May20: SCAVA fix
                        if(flsGet(Opportunity.Public_Sector_Funding__c)) {
                            NewPhaseOppty.Public_Sector_Funding__c = rsOpportunity[0].Public_Sector_Funding__c;  
                        }
                        //May20: SCAVA fix
                        if(flsGet(Opportunity.Pull_Forward_Date__c)) {
                            NewPhaseOppty.Pull_Forward_Date__c= rsOpportunity[0].Pull_Forward_Date__c;    
                        }
                        //May20: SCAVA fix
                        if(flsGet(Opportunity.RecordTypeId)) {
                            NewPhaseOppty.RecordTypeId = rsRecordType;  
                            system.debug('rsRecordType'+rsRecordType);  
                        }
                        //May20: SCAVA fix
                        if(flsGet(Opportunity.Refurbished_Deal__c)) {
                            NewPhaseOppty.Refurbished_Deal__c= rsOpportunity[0].Refurbished_Deal__c;  
                        }
                        //May20: SCAVA fix
                        if(flsGet(Opportunity.Role_2__c)) {
                            NewPhaseOppty.Role_2__c = partner2role;   
                        }
                        //May20: SCAVA fix
                        if(flsGet(Opportunity.Role_3__c)) {
                            NewPhaseOppty.Role_3__c= rsOpportunity[0].Role_3__c;  
                        }
                        //May20: SCAVA fix
                        if(flsGet(Opportunity.Role_4__c)) {
                            NewPhaseOppty.Role_4__c= rsOpportunity[0].Role_4__c; // to be removed  
                        }
                        //May20: SCAVA fix
                        if(flsGet(Opportunity.Role_5__c)) {
                            NewPhaseOppty.Role_5__c= rsOpportunity[0].Role_5__c; // to be removed  
                        }
                        //May20: SCAVA fix
                        if(flsGet(Opportunity.Sales_Path__c)) {
                            NewPhaseOppty.Sales_Path__c= rsOpportunity[0].Sales_Path__c;  
                        }
                        //May20: SCAVA fix
                        if(flsGet(Opportunity.Sales_Programs__c)) {
                            NewPhaseOppty.Sales_Programs__c= rsOpportunity[0].Sales_Programs__c;  
                        }
                        //May20: SCAVA fix
                        if(flsGet(Opportunity.Selling_Motion__c)) {
                            NewPhaseOppty.Selling_Motion__c= rsOpportunity[0].Selling_Motion__c;  
                        }
                        //May20: SCAVA fix
                        if(flsGet(Opportunity.Service_Source__c)) {
                            NewPhaseOppty.Service_Source__c= rsOpportunity[0].Service_Source__c;  
                        }
                        //May20: SCAVA fix
                        if(flsGet(Opportunity.Software_Buying_Program__c)) {
                            NewPhaseOppty.Software_Buying_Program__c= rsOpportunity[0].Software_Buying_Program__c ;
                        }
                        //May20: SCAVA fix
                        if(flsGet(Opportunity.Software_Buying_Program_DurationMonths__c)) {
                            NewPhaseOppty.Software_Buying_Program_DurationMonths__c= rsOpportunity[0].Software_Buying_Program_DurationMonths__c;  
                        }
                        //May20: SCAVA fix
                        if(flsGet(Opportunity.Software_Offer_Name__c)) {
                            NewPhaseOppty.Software_Offer_Name__c= rsOpportunity[0].Software_Offer_Name__c;   
                        }
                        //May20: SCAVA fix
                        if(flsGet(Opportunity.Software_Offer_Value__c)) {
                            NewPhaseOppty.Software_Offer_Value__c= rsOpportunity[0].Software_Offer_Value__c;  
                        }
                        //May20: SCAVA fix
                        if(flsGet(Opportunity.Software_Type__c)) {
                            NewPhaseOppty.Software_Type__c= rsOpportunity[0].Software_Type__c;   
                        }
                        //May20: SCAVA fix
                        if(flsGet(Opportunity.Solution_Identifier__c)) {
                            NewPhaseOppty.Solution_Identifier__c= rsOpportunity[0].Solution_Identifier__c ;  
                        }
                        //May20: SCAVA fix
                        if(flsGet(Opportunity.Solution_Positioning__c)) {
                            NewPhaseOppty.Solution_Positioning__c = rsOpportunity[0].Solution_Positioning__c; 
                        }
                        //May20: SCAVA fix
                        if(flsGet(Opportunity.Solutions__c)) {
                            NewPhaseOppty.Solutions__c= rsOpportunity[0].Solutions__c;    
                        }
                        //May20: SCAVA fix
                        if(flsGet(Opportunity.SP_Internal_IT__c)) {
                            NewPhaseOppty.SP_Internal_IT__c= rsOpportunity[0].SP_Internal_IT__c;  
                        }
                        //May20: SCAVA fix
                        if(flsGet(Opportunity.StageName)) {
                            // Hardcoding Stage to 1 for phase oppty -- Prashanth
                            // NewPhaseOppty.StageName= rsOpportunity[0].StageName;  
                            NewPhaseOppty.StageName= Utilities.getOpptyStage1(); //'1 - Prospect';  

                        }
                        //May20: SCAVA fix
                        if(flsGet(Opportunity.Start_Date__c)) {
                            NewPhaseOppty.Start_Date__c= rsOpportunity[0].Start_Date__c;  
                        }
                        //May20: SCAVA fix
                        if(flsGet(Opportunity.Territory2Id)) {
                            NewPhaseOppty.Territory2Id = rsOpportunity[0].Territory2Id; 
                        }
                        //May20: SCAVA fix
                        if(flsGet(Opportunity.Theater__c)) {
                            NewPhaseOppty.Theater__c= rsOpportunity[0].Theater__c;   
                        }
                        // Added by Naresh for 08/10/18 Lightning Release  - Start
                        if(flsGet(Opportunity.Industry_Solution__c)){
                         NewPhaseOppty.Industry_Solution__c= rsOpportunity[0].Industry_Solution__c;
                        }
                        //May20: SCAVA fix
                        if(flsGet(Opportunity.Waves__c)) {
                            NewPhaseOppty.Waves__c= rsOpportunity[0].Waves__c; 
                        }
                        
                        if(flsGet(Opportunity.SE_Status__c)) {                            
                            NewPhaseOppty.SE_Status__c='No SE Assigned';    
                        }
                        //June10: VDC Lead ID Copy Fix
                        if(flsGet(Opportunity.DRT_Lead__c)) {                            
                            NewPhaseOppty.DRT_Lead__c = rsOpportunity[0].DRT_Lead__c;    
                        }
                        
                        Utilities.setSkip(true);//skips certain trigger functionality
                        Utilities.setValidationSkip(true);                          
                        insert NewPhaseOppty;

                        OpportunityLineItem[] rsOpptyLineItem = [SELECT CurrencyIsoCode, Description, ListPrice, Mix__c, Opportunity_Line_Value__c, OpportunityId, PricebookEntryId,
                                                                 Product_Family__c, Product_Family_Ref__c, Product_Family_Service_Level_Recurring__c, Product_Family_US__c, Quantity,
                                                                 Recurring_Percentage__c, Service_Category__c, Service_Level__c, SortOrder, Term_in_Months__c, TotalPrice from OpportunityLineItem 
                                                                 where PricebookEntry.IsActive=TRUE AND OpportunityId = :OpportunityID ];
                        OpportunityLineItem[] newOpptyLineItems = new OpportunityLineItem[]{};
                        Integer i;
                        for(i=0; i < rsOpptyLineItem.size(); i++){
                            OpportunityLineItem NewOpptyLineItem = new OpportunityLineItem();
                                    // SCAVA Fix
                                    if(flsGet(OpportunityLineItem.Mix__c)) 
                                    {               
                                    NewOpptyLineItem.Mix__c= rsOpptyLineItem[i].Mix__c;   
                                    }
                                    if(flsGet(OpportunityLineItem.OpportunityId)) 
                                    {
                                    NewOpptyLineItem.OpportunityId=NewPhaseOppty.Id;
                                    }
                                    if(flsGet(OpportunityLineItem.PricebookEntryId)) 
                                    {
                                    NewOpptyLineItem.PricebookEntryId=rsOpptyLineItem[i].PricebookEntryId;
                                    }
                                    if(flsGet(OpportunityLineItem.Product_Family__c)) 
                                    {
                                    NewOpptyLineItem.Product_Family__c=rsOpptyLineItem[i].Product_Family__c;
                                    }
                                    if(flsGet(OpportunityLineItem.Product_Family_Ref__c)) 
                                    {
                                    NewOpptyLineItem.Product_Family_Ref__c=rsOpptyLineItem[i].Product_Family_Ref__c;
                                    }
                                    if(flsGet(OpportunityLineItem.Product_Family_Service_Level_Recurring__c)) 
                                    {
                                    NewOpptyLineItem.Product_Family_Service_Level_Recurring__c = rsOpptyLineItem[i].Product_Family_Service_Level_Recurring__c;  //Added as part QI2 Sprint2 release 
                                    }
                                    if(flsGet(OpportunityLineItem.Product_Family_US__c)) 
                                    {
                                    NewOpptyLineItem.Product_Family_US__c=rsOpptyLineItem[i].Product_Family_US__c;
                                    }
                                    if(flsGet(OpportunityLineItem.Quantity)) 
                                    {
                                    NewOpptyLineItem.Quantity=rsOpptyLineItem[i].Quantity;
                                    }
                                    if(flsGet(OpportunityLineItem.Recurring_Percentage__c)) 
                                    {
                                    NewOpptyLineItem.Recurring_Percentage__c = rsOpptyLineItem[i].Recurring_Percentage__c;              //Added as part QI2 Sprint2 release   
                                    }
                                    if(flsGet(OpportunityLineItem.Service_Category__c)) 
                                    {
                                    NewOpptyLineItem.Service_Category__c=rsOpptyLineItem[i].Service_Category__c;
                                    }
                                    if(flsGet(OpportunityLineItem.Service_Level__c)) 
                                    {
                                    NewOpptyLineItem.Service_Level__c=rsOpptyLineItem[i].Service_Level__c;
                                    }
                                    if(flsGet(OpportunityLineItem.Term_in_Months__c)) 
                                    {
                                    NewOpptyLineItem.Term_in_Months__c = rsOpptyLineItem[i].Term_in_Months__c;             //Added as part QI2 Sprint2 release    
                                    }
                                    if(flsGet(OpportunityLineItem.TotalPrice)) 
                                    {
                                    NewOpptyLineItem.TotalPrice = rsOpptyLineItem[i].TotalPrice;    
                                    }
                                    // Removed from copying to parent opty      
                                    //Opportunity_Line_Value__c=rsOpptyLineItem[i].Opportunity_Line_Value__c
                            newOpptyLineItems.add(NewOpptyLineItem);
                        } 
                        if(newOpptyLineItems.size() > 0)
                            Insert newOpptyLineItems;
                            
                return NewPhaseOppty.Id;
            }//if(rsPhaseCount.size()>=MAX_NUM_CHILD_PHASES)
        }
        else //if(rsOpportunity[0].Parent_ID__c==null)
        {
            return '2'; // Passed Oppty Id is that of Phase Oppty,instead of Parent
        }
        }
        else //if(rsOpportunity.size()==1)
        {
            return '1'; // Invalid Opportunity Id passed
        }
        }//end of try
        catch (Exception e)
        {
            if(e.getMessage()=='Insert failed. First exception on row 0; first error: FIELD_CUSTOM_VALIDATION_EXCEPTION, The Opportunity Name already Exists for this Account.: [Name]')
            {
                return 'Cannot create Phase Opportunity because, there exists already an opportunity with the same name.';
            }
            else
            {
                return e.getMessage();
            }
        }
    }//end of webservice
}//end of class