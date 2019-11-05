/*********************** Change History **************************
lakshsur Dec'2014 release - added additional fields for Oppty Parent and Phase Parent Clone.
01-WR-01471  - added additional fields for Oppty Parent and Phase Parent Clone.
02 udkatta - US146612 11/29/2017 - ACV fields in Clone Opportunities
Last ModifiedBy: Swamy P R N on 10.06.2017, WR-3153 
Last ModifiedBy: Bodurais on 25.04.2018, SCAVA scan fixes
Last ModifiedBy: Prithu on 5/8/2019 , ProductFamily Validation
LastModifiedBy: Awnish on 5/13/2019 VDC Changes
*/
global class OpptyClone
{ 
    public static  List<string> returnValue=new List<string>();//create list for return value
    public static string flagValue='N'; //flag value for display popup if not valid product family 
    
    //SCAVA helper method
    public static Boolean flsGet(SObjectField field)
    {
        return field.getDescribe().isCreateable() ? true : false;
    }
    
    
    //***************************** Actual Code Starts************************************************
    //updated on 2 April -2012
    WebService static list<string> clone(String OpportunityID, String RecordType){
        
        try{
            //Defining variables in order to make it easier to change the code against hard coded values.
            String partnerRecordType = Utilities.getConstant_CS('Oppty_PartnerRecord_Type');   // type of the oppty Record Type
            String partnerStatus = Utilities.getConstant_CS('Oppty_Partner_Status');//Getting the opty status
            Integer opptyClonelimit = 250; // limit for possible number of cloned oppties
            List<String> partners = new List<String>();
            
            
            //Using custom setting to control the number of cloned records        
            Org_Constant_CS__c opptyCloneSetting = Org_Constant_CS__c.getValues('Oppty Clone limit'); 
            
            //Using custom setting to get Oppty Parent Record type Id and Account End User Record type
            ObjectRecordTypeIds__c objRecordTypeSetting = ObjectRecordTypeIds__c.getOrgDefaults();
            String partnerParentRT = objRecordTypeSetting.Opportunity_Parent_RecordTypeId__c ;
            String endUserAccRT = objRecordTypeSetting.Account_End_User_RecordTypeId__c ;
            
            
            //System.debug('*****opptyCloneSetting'+ opptyCloneSetting);
            if(opptyCloneSetting!=null)
            {
                opptyClonelimit = integer.valueOf(opptyCloneSetting.Production_Value__c);
            }
            // System.debug('***opptyClonelimit'+ opptyClonelimit);
            
            Opportunity[] rsOpportunity = [SELECT Account.RecordTypeId,DRT_Lead__c, AccountId, AIP_Deviation__c, Cisco_Capital_Financing__c, Cloud_Deal__c, Cloud_Demand_Partner_Service_OfferLookup__c, 
                                           Cloud_Demand_Projected_Value_000_s__c, Cloud_Demand_Term_Months__c, Cloud_Number_of_Units__c, Competitors__c, CurrencyIsoCode, Customer_Use_Case__c,
                                           DealID__c, Description, End_Date__c, Enterprise_Agreement_Opportunity__c, Expected_Product__c, Expected_Service__c, Forecast_Discount__c, Id, Installed_Base__c, Managed_Services__c,
                                           Marketing_Programs__c, Name, Network_Assessment_Conducted__c, New_Franchise__c, Opportunity_Flags__c, OwnerId, Parent_ID__c, Partner_2__c,
                                           Partner_3__c, Partner_Deal_Type__c, Partner_Required__c, Position__c, Primary_Partner__c, Primary_Partner_Role__c,
                                           Public_Sector_Funding__c, Refurbished_Deal__c, Role_2__c, Role_3__c, Sales_Path__c, Sales_Programs__c, Selling_Motion__c, Service_Source__c,
                                           Software_Buying_Program__c, Software_Buying_Program_DurationMonths__c, Software_Offer_Name__c, Software_Offer_Value__c, Software_Type__c,
                                           Partner_4__c, Partner_5__c, Role_4__c, Role_5__c, // to be removed 
                                           Solution_Identifier__c, Solution_Positioning__c, Solutions__c, StageName, Start_Date__c, Territory2Id, Theater__c, Waves__c,Industry_Solution__c  FROM Opportunity WHERE Id = :OpportunityID];
            
            
            if(rsOpportunity.size()==1){
                
                String opptyAccountRT = rsOpportunity[0].Account.RecordTypeId ;
                
                //Checkeing if the account related to Oppty is End User Account
                
                if(!opptyAccountRT.contains(endUserAccRT))
                {
                    System.debug('return==>5');
                    returnValue.add('5');
                    return returnValue;
                } 
                
                //Checking if User Currency Code and Oppty Currency code are different         
                if(rsOpportunity[0].CurrencyIsoCode != UserInfo.getDefaultCurrency())
                { 
                    System.debug('return==>4');
                    //returnValue.add('4');
                    returnValue.add('4');
                    return returnValue; //Opportunity currency code and User Currency codes are different
                }
                //Checking if the Original Oppty is Parent 
                //if(rsOpportunity[0].Parent_ID__c==null){
                
                Opportunity[] rsCloneCount = [SELECT Id FROM Opportunity WHERE Merged_Opportunity__c = :rsOpportunity[0].Id];
                //  System.debug('***rsCloneCount'+ rsCloneCount.size());
                
                //Checking if reached the maximum Limit, to clone this Opportunity
                if(rsCloneCount.size()>=opptyClonelimit){
                    // System.debug('***Returning 3');
                    //returnValue.add('3');
                    returnValue.add('3');
                    return returnValue; // maximum Limit is reached to clone this Opportunity
                }
                else{
                    Integer NewOpptyName=rsCloneCount.size()+1;
                    String strNewOpptyName ='';
                    if(rsOpportunity[0].Name.length()>88){
                        strNewOpptyName = rsOpportunity[0].Name.substring(0,88)+ '- Clone #' + NewOpptyName ;
                    }
                    else{
                        strNewOpptyName = rsOpportunity[0].Name+ '- Clone #' + NewOpptyName ;
                    }
                    
                    // System.debug('***strNewOpptyName'+ strNewOpptyName);
                    Opportunity[] rsOppAlreadyExists=[Select Id, Name from Opportunity where Name = :strNewOpptyName and AccountId = :rsOpportunity[0].AccountId];
                    
                    //System.debug('***rsOppAlreadyExists'+ rsOppAlreadyExists);
                    if(rsOppAlreadyExists.size()>0){
                        if(rsOpportunity[0].Name.length()>66){
                            strNewOpptyName = rsOpportunity[0].Name.substring(0,66)+ '- Clone #' + NewOpptyName +' - ' + System.now();
                        }
                        else{
                            strNewOpptyName = rsOpportunity[0].Name+ '- Clone #' + NewOpptyName +' - ' + System.now();
                        }
                    }
                    // new variables
                    //System.debug('***strNewOpptyName'+ strNewOpptyName);
                    String rsRecordType;
                    //String partnerParentRT = Utilities.getRecordTypeId('Opportunity', 'Parent Opportunity');
                    
                    String rsOwner;
                    String rsPartner;
                    String rsPartnerRole;
                    String partner2;
                    String partner2role;
                    String partner3;
                    String partner3role;
                    String partner4;     // to be removed 
                    String partner4role; // to be removed
                    String partner5;     // to be removed
                    String partner5role; // to be removed
                    
                    //Check to see if coming from Parent Record Type both are 15 digits.
                    if(partnerParentRT.contains(RecordType)){
                        
                        rsRecordType = partnerParentRT;                     
                        rsOwner = UserInfo.getUserId();
                        rsPartner = rsOpportunity[0].Primary_Partner__c;
                        rsPartnerRole = rsOpportunity[0].Primary_Partner_Role__c;
                        partner2 = rsOpportunity[0].Partner_2__c;
                        partner2role = rsOpportunity[0].Role_2__c;
                        partner3 = rsOpportunity[0].Partner_3__c;
                        partner3role = rsOpportunity[0].Role_3__c;
                        partner4 = rsOpportunity[0].Partner_4__c;   // to be removed
                        partner4role = rsOpportunity[0].Role_4__c;  // to be removed
                        partner5 = rsOpportunity[0].Partner_5__c;   // to be removed
                        partner5role = rsOpportunity[0].Role_5__c;  // to be removed
                        
                        // System.debug('***partner5'+partner5);
                        
                        //Checking if Partners are null values
                        if(rsPartner!='' && rsPartner!= null)
                        {
                            partners.add(rsPartner);
                        }
                        if(partner2!='' && partner2!= null)
                        {
                            partners.add(partner2);
                        }
                        if(partner3!='' && partner3!= null)
                        {
                            partners.add(partner3);
                        }
                        if(partner4!='' && partner4!= null)   // to be removed
                        {
                            partners.add(partner4);             // to be removed
                        }
                        if(partner5!='' && partner5!= null)   // to be removed
                        {
                            partners.add(partner5);             // to be removed
                        }
                    }
                    //getting Partners info
                    Map<Id, Account> partnerDetails = new Map<Id, Account>( [SELECT Id, name, RecordType.Name ,  Partner_Account_Status__c FROM Account WHERE Id in :partners]);
                    
                    
                    //Check for the EPSS User. 
                    //If User is EPSS enabled then the owner of the original oppty would also become the owner of new oppty.
                    if(Utilities.checkAdditionalUserPermission('Enable_ePSS')|| Utilities.checkAdditionalUserPermission('Enable_VSS')|| rsOpportunity[0].DRT_Lead__c!=null)
                    {
                        rsOwner = rsOpportunity[0].OwnerId;
                    }  
                    
                    //Creating a new Oppty Record                                
                    Opportunity NewClonedOppty = new Opportunity();
                    //May20: SCAVA fix
                    if(flsGet(Opportunity.AccountId)) {
                        NewClonedOppty.AccountId = rsOpportunity[0].AccountId;
                    }
                    //May20: SCAVA fix
                    if(flsGet(Opportunity.AIP_Deviation__c)) {
                        NewClonedOppty.AIP_Deviation__c= rsOpportunity[0].AIP_Deviation__c;
                    }
                    //May20: SCAVA fix
                    if(flsGet(Opportunity.Cisco_Capital_Financing__c)){
                        NewClonedOppty.Cisco_Capital_Financing__c = rsOpportunity[0].Cisco_Capital_Financing__c;  
                    }
                    //May20: SCAVA fix
                    if(flsGet(Opportunity.CloseDate)){
                        NewClonedOppty.CloseDate=System.today()  + 7;
                    }
                    //May20: SCAVA fix
                    if(flsGet(Opportunity.DealID__c)){
                        NewClonedOppty.DealID__c= ''; 
                    }                 
                    //May20: SCAVA fix
                    if(flsGet(Opportunity.Solution_Positioning__c)){
                        //Add for WR-571
                        //Dec'2014 WR-00881 - Added additional fields for Clone mapping
                        NewClonedOppty.Solution_Positioning__c = rsOpportunity[0].Solution_Positioning__c;
                    }
                    //May20: SCAVA fix
                    if(flsGet(Opportunity.Waves__c)){
                        NewClonedOppty.Waves__c = rsOpportunity[0].Waves__c; 
                    }
                    //May20: SCAVA fix
                    if(flsGet(Opportunity.Opportunity_Flags__c)){
                        NewClonedOppty.Opportunity_Flags__c = rsOpportunity[0].Opportunity_Flags__c;
                    }
                    //May20: SCAVA fix
                    if(flsGet(Opportunity.Cloud_Deal__c)){
                        NewClonedOppty.Cloud_Deal__c = rsOpportunity[0].Cloud_Deal__c;    
                    }
                    //May20: SCAVA fix
                    if(flsGet(Opportunity.Cloud_Demand_Partner_Service_OfferLookup__c)){
                        NewClonedOppty.Cloud_Demand_Partner_Service_OfferLookup__c = rsOpportunity[0].Cloud_Demand_Partner_Service_OfferLookup__c;
                    }
                    //May20: SCAVA fix
                    if(flsGet(Opportunity.Cloud_Demand_Projected_Value_000_s__c)){
                        NewClonedOppty.Cloud_Demand_Projected_Value_000_s__c  = rsOpportunity[0].Cloud_Demand_Projected_Value_000_s__c ;
                    }
                    //May20: SCAVA fix
                    if(flsGet(Opportunity.Cloud_Demand_Term_Months__c)){
                        NewClonedOppty.Cloud_Demand_Term_Months__c = rsOpportunity[0].Cloud_Demand_Term_Months__c;
                    }
                    //May20: SCAVA fix
                    if(flsGet(Opportunity.Cloud_Number_of_Units__c)){
                        NewClonedOppty.Cloud_Number_of_Units__c = rsOpportunity[0].Cloud_Number_of_Units__c;
                    }
                    //May20: SCAVA fix
                    if(flsGet(Opportunity.Competitors__c)){
                        //Removed Commpetitor field from Clone Based on the WR-3153, removed the value which is being assigning.
                        NewClonedOppty.Competitors__c = null;//rsOpportunity[0].Competitors__c;
                    }
                    //May20: SCAVA fix
                    if(flsGet(Opportunity.Customer_Use_Case__c)){
                        NewClonedOppty.Customer_Use_Case__c = rsOpportunity[0].Customer_Use_Case__c;
                    }
                    //May20: SCAVA fix
                    if(flsGet(Opportunity.Description)){
                        NewClonedOppty.Description = rsOpportunity[0].Description;
                    }
                    //May20: SCAVA fix
                    if(flsGet(Opportunity.End_Date__c)){
                        NewClonedOppty.End_Date__c = rsOpportunity[0].End_Date__c;
                    }
                    //May20: SCAVA fix
                    if(flsGet(Opportunity.Enterprise_Agreement_Opportunity__c)){
                        NewClonedOppty.Enterprise_Agreement_Opportunity__c = rsOpportunity[0].Enterprise_Agreement_Opportunity__c; //May20: Adding EA field
                    }
                    //May20: SCAVA fix
                    if(flsGet(Opportunity.Forecast_Discount__c)){
                        NewClonedOppty.Forecast_Discount__c = rsOpportunity[0].Forecast_Discount__c;
                    }
                    //May20: SCAVA fix
                    if(flsGet(Opportunity.Installed_Base__c)){
                        NewClonedOppty.Installed_Base__c = rsOpportunity[0].Installed_Base__c;   
                    }
                    //May20: SCAVA fix
                    if(flsGet(Opportunity.Managed_Services__c)){
                        NewClonedOppty.Managed_Services__c = rsOpportunity[0].Managed_Services__c;
                    }
                    //May20: SCAVA fix
                    if(flsGet(Opportunity.Marketing_Programs__c)){
                        NewClonedOppty.Marketing_Programs__c = rsOpportunity[0].Marketing_Programs__c;
                    }
                    //May20: SCAVA fix
                    if(flsGet(Opportunity.Merged_Opportunity__c)){
                        NewClonedOppty.Merged_Opportunity__c = rsOpportunity[0].Id;
                    }
                    //May20: SCAVA fix
                    if(flsGet(Opportunity.Name)){
                        NewClonedOppty.Name= strNewOpptyName;
                    }
                    //May20: SCAVA fix
                    if(flsGet(Opportunity.New_Franchise__c)){    
                        NewClonedOppty.New_Franchise__c = rsOpportunity[0].New_Franchise__c;
                    }
                    //May20: SCAVA fix
                    if(flsGet(Opportunity.Network_Assessment_Conducted__c)){    
                        NewClonedOppty.Network_Assessment_Conducted__c = rsOpportunity[0].Network_Assessment_Conducted__c; 
                    }
                    //May20: SCAVA fix
                    if(flsGet(Opportunity.Opportunity_Owner_AM__c)){
                        NewClonedOppty.Opportunity_Owner_AM__c = rsOwner;
                    }
                    //May20: SCAVA fix
                    if(flsGet(Opportunity.OwnerId)){
                        NewClonedOppty.OwnerId = rsOwner;  
                    }
                    //May20: SCAVA fix
                    if(flsGet(Opportunity.Partner_Required__c)){   
                        NewClonedOppty.Partner_Required__c = rsOpportunity[0].Partner_Required__c;
                    }
                    //May20: SCAVA fix
                    if(flsGet(Opportunity.Position__c)){        
                        NewClonedOppty.Position__c = rsOpportunity[0].Position__c;
                    }
                    //May20: SCAVA fix
                    if(flsGet(Opportunity.Public_Sector_Funding__c)){
                        NewClonedOppty.Public_Sector_Funding__c = rsOpportunity[0].Public_Sector_Funding__c;
                    }
                    //May20: SCAVA fix
                    if(flsGet(Opportunity.RecordTypeId)){
                        NewClonedOppty.RecordTypeId = rsRecordType;
                    }
                    //May20: SCAVA fix
                    if(flsGet(Opportunity.Refurbished_Deal__c)){
                        NewClonedOppty.Refurbished_Deal__c = rsOpportunity[0].Refurbished_Deal__c;
                    }
                    //May20: SCAVA fix
                    if(flsGet(Opportunity.Sales_Path__c)){
                        NewClonedOppty.Sales_Path__c = rsOpportunity[0].Sales_Path__c;
                    }
                    //May20: SCAVA fix
                    if(flsGet(Opportunity.Sales_Programs__c)){
                        NewClonedOppty.Sales_Programs__c = rsOpportunity[0].Sales_Programs__c;
                    }
                    //May20: SCAVA fix
                    if(flsGet(Opportunity.Selling_Motion__c)){
                        // Added as per WR-01471
                        NewClonedOppty.Selling_Motion__c= rsOpportunity[0].Selling_Motion__c;
                    }
                    //May20: SCAVA fix
                    if(flsGet(Opportunity.Service_Source__c)){
                        NewClonedOppty.Service_Source__c= rsOpportunity[0].Service_Source__c;
                    }
                    //May20: SCAVA fix
                    if(flsGet(Opportunity.StageName)){
                        NewClonedOppty.StageName= Utilities.getOpptyStage1();//'1 - Prospect' ; 
                    }
                    //May20: SCAVA fix
                    if(flsGet(Opportunity.Start_Date__c)){
                        NewClonedOppty.Start_Date__c = rsOpportunity[0].Start_Date__c;
                    }
                    //May20: SCAVA fix
                    if(flsGet(Opportunity.Solutions__c)){
                        NewClonedOppty.Solutions__c = rsOpportunity[0].Solutions__c;
                    }
                    //May20: SCAVA fix
                    if(flsGet(Opportunity.Solution_Identifier__c)){
                        NewClonedOppty.Solution_Identifier__c = rsOpportunity[0].Solution_Identifier__c;
                    }
                    //May20: SCAVA fix
                    if(flsGet(Opportunity.Software_Buying_Program__c)){
                        NewClonedOppty.Software_Buying_Program__c = rsOpportunity[0].Software_Buying_Program__c;
                    }
                    //May20: SCAVA fix
                    if(flsGet(Opportunity.Software_Buying_Program_DurationMonths__c)){
                        NewClonedOppty.Software_Buying_Program_DurationMonths__c = rsOpportunity[0].Software_Buying_Program_DurationMonths__c;
                    }
                    //May20: SCAVA fix
                    if(flsGet(Opportunity.Software_Offer_Name__c)){
                        NewClonedOppty.Software_Offer_Name__c = rsOpportunity[0].Software_Offer_Name__c;
                    }
                    //May20: SCAVA fix
                    if(flsGet(Opportunity.Software_Offer_Value__c)){
                        NewClonedOppty.Software_Offer_Value__c = rsOpportunity[0].Software_Offer_Value__c;
                    }
                    //May20: SCAVA fix
                    if(flsGet(Opportunity.Software_Type__c)){
                        NewClonedOppty.Software_Type__c = rsOpportunity[0].Software_Type__c;
                    }
                    //May20: SCAVA fix
                    if(flsGet(Opportunity.Territory2Id)){
                        NewClonedOppty.Territory2Id= rsOpportunity[0].Territory2Id;
                    }
                    //May20: SCAVA fix
                    if(flsGet(Opportunity.Theater__c)){
                        NewClonedOppty.Theater__c= rsOpportunity[0].Theater__c;
                    }
                    
                     if(flsGet(Opportunity.DRT_Lead__c)){
                        NewClonedOppty.DRT_Lead__c= rsOpportunity[0].DRT_Lead__c;
                    }
                    
                    
                    // Added by Naresh for 08/10/18 Lightning Release  - Start
                    if(flsGet(Opportunity.Industry_Solution__c)){
                        NewClonedOppty.Industry_Solution__c= rsOpportunity[0].Industry_Solution__c;
                    }
                    if(flsGet(Opportunity.Software_Offer_Value__c)){
                        NewClonedOppty.Software_Offer_Value__c= rsOpportunity[0].Software_Offer_Value__c;
                    }
                    
                    // Added by Naresh for 08/10/18 Lightning Release  - End
                    //Added as per WR-01471
                    if(partnerDetails.containsKey(rsPartner) && partnerDetails.get(rsPartner).RecordType.Name== partnerRecordType && partnerDetails.get(rsPartner).Partner_Account_Status__c == partnerStatus)
                    {
                        //May20: SCAVA fix
                        if(flsGet(Opportunity.Primary_Partner__c)){
                            NewClonedOppty.Primary_Partner__c = rsPartner;
                        }
                        //May20: SCAVA fix
                        if(flsGet(Opportunity.Primary_Partner_Role__c)){
                            NewClonedOppty.Primary_Partner_Role__c= rsPartnerRole;
                        }
                    }
                    
                    if(partnerDetails.containsKey(partner2) && partnerDetails.get(partner2).RecordType.Name== partnerRecordType && partnerDetails.get(partner2).Partner_Account_Status__c == partnerStatus)
                    {
                        //May20: SCAVA fix
                        if(flsGet(Opportunity.Partner_2__c)){
                            NewClonedOppty.Partner_2__c = partner2;
                        }
                        //May20: SCAVA fix
                        if(flsGet(Opportunity.Role_2__c)){
                            NewClonedOppty.Role_2__c = partner2role;
                        }
                    }
                    
                    if(partnerDetails.containsKey(partner3) && partnerDetails.get(partner3).RecordType.Name== partnerRecordType && partnerDetails.get(partner3).Partner_Account_Status__c == partnerStatus)
                    {
                        //May20: SCAVA fix
                        if(flsGet(Opportunity.Partner_3__c)){
                            NewClonedOppty.Partner_3__c = partner3;
                        }
                        //May20: SCAVA fix
                        if(flsGet(Opportunity.Role_3__c)){
                            NewClonedOppty.Role_3__c = partner3role;
                        }
                    }
                    
                    if(partnerDetails.containsKey(partner4) && partnerDetails.get(partner4).RecordType.Name== partnerRecordType && partnerDetails.get(partner4).Partner_Account_Status__c == partnerStatus) // to be removed
                    {   
                        //May20: SCAVA fix
                        if(flsGet(Opportunity.Partner_4__c)){
                            NewClonedOppty.Partner_4__c = partner4;   // to be removed
                        }
                        //May20: SCAVA fix
                        if(flsGet(Opportunity.Role_4__c)){
                            NewClonedOppty.Role_4__c = partner4role;  // to be removed
                        }
                    }
                    
                    if(partnerDetails.containsKey(partner5) && partnerDetails.get(partner5).RecordType.Name== partnerRecordType && partnerDetails.get(partner5).Partner_Account_Status__c == partnerStatus) // to be removed
                    {
                        //May20: SCAVA fix
                        if(flsGet(Opportunity.Partner_5__c)){
                            NewClonedOppty.Partner_5__c = partner5;   // to be removed
                        }
                        //May20: SCAVA fix
                        if(flsGet(Opportunity.Role_5__c)){
                            NewClonedOppty.Role_5__c = partner5role;  // to be removed
                        }
                    }
                    
                    Utilities.setSkip(true);//skips certain trigger functionality
                    Utilities.setValidationSkip(true); 
                    system.debug('NewClonedOppty ===>'+NewClonedOppty );
                    insert NewClonedOppty ;
                    
                    
                    //Adding the Sales Team Members
                    Utilities.copySalesTeam(rsOpportunity[0].Id, NewClonedOppty.ID)    ;
                    
                    
                    //Creating Oppty Line Items
                    List<OpportunityLineItem> lstrsOpptyLineItem = [SELECT CurrencyIsoCode, PriceBookEntry.ProductCode, Product_Family__c, Product_Family_Ref__c,  Description,  ListPrice,  Mix__c,  Opportunity_Line_Value__c,
                                                                    OpportunityId,  PricebookEntryId,PricebookEntry.Product2Id, Product_Family_Service_Level_Recurring__c,  Recurring_Percentage__c,  Term_in_Months__c,
                                                                    Product_Family_US__c,  Quantity,  Service_Level__c, Service_Category__c,  SortOrder,  TotalPrice
                                                                    from OpportunityLineItem where PricebookEntry.IsActive=TRUE AND OpportunityId = :OpportunityID ];
                    
                    List<OpportunityLineItem> newOpptyLineItems = new List<OpportunityLineItem>();
                    Integer i;
                    boolean checklineFamily;  //LineItem Insert check
                    
                    for(OpportunityLineItem rsOpptyLineItem:lstrsOpptyLineItem){
                        
                        checklineFamily=false;
                        OpportunityLineItem newOppLine = new OpportunityLineItem(); 
                        newOppLine.Mix__c= rsOpptyLineItem.Mix__c;
                        newOppLine.OpportunityId=NewClonedOppty.Id;
                        newOppLine.PricebookEntryId=rsOpptyLineItem.PricebookEntryId;
                        
                        if(rsOpptyLineItem.PriceBookEntry.ProductCode=='Technology'){
                            if(rsOpptyLineItem.Product_Family__c!=null && rsOpptyLineItem.Product_Family_Ref__c!=null){
                                newOppLine.Product_Family__c=rsOpptyLineItem.Product_Family__c;
                                newOppLine.Product_Family_Ref__c=rsOpptyLineItem.Product_Family_Ref__c;
                                
                            }
                            else if(rsOpptyLineItem.Product_Family__c!=null  && rsOpptyLineItem.Product_Family_Ref__c==null ){
                                
                                newOppLine.Product_Family__c=rsOpptyLineItem.Product_Family__c;
                                Id productRefId=setProductFamily(rsOpptyLineItem.Product_Family__c,rsOpptyLineItem.PricebookEntry.Product2Id);
                                system.debug('Product Id'+productRefId);
                                if(productRefId!=null){   
                                    newOppLine.Product_Family_Ref__c=productRefId;
                                    system.debug('Product_Family_Ref__c Value'+newOppLine.Product_Family_Ref__c);
                                }
                                else{
                                    flagValue='Y';
                                    checklineFamily=true;  
                                }   
                            }
                            
                            else {
                                
                                system.debug('3st Loop Product_Family__ref Value'+rsOpptyLineItem.Product_Family_Ref__c);
                                flagValue='Y';
                                checklineFamily=true;
                            }
                        }
                        
                        newOppLine.Product_Family_Service_Level_Recurring__c = rsOpptyLineItem.Product_Family_Service_Level_Recurring__c; //Added as part QI2 Sprint2 release
                        newOppLine.Product_Family_US__c=rsOpptyLineItem.Product_Family_US__c;
                        newOppLine.Quantity=rsOpptyLineItem.Quantity;
                        newOppLine.Recurring_Percentage__c = rsOpptyLineItem.Recurring_Percentage__c;   //Added as part QI2 Sprint2 release
                        newOppLine.Service_Category__c=rsOpptyLineItem.Service_Category__c;
                        newOppLine.Service_Level__c=rsOpptyLineItem.Service_Level__c;
                        newOppLine.Term_in_Months__c = rsOpptyLineItem.Term_in_Months__c;   //Added as part QI2 Sprint2 release
                        newOppLine.TotalPrice = rsOpptyLineItem.TotalPrice;
                        //Removed from cloning     
                        //Opportunity_Line_Value__c=rsOpptyLineItem.Opportunity_Line_Value__c;
                        system.debug('checklineFamily Value'+checklineFamily);
                        If(!checklineFamily)
                        {                        
                            newOpptyLineItems.add(newOppLine);
                        }
                    } 
                    if(newOpptyLineItems.size() > 0)
                        system.debug('newOpptyLineItems===>'+newOpptyLineItems.size());
                    Insert newOpptyLineItems;
                    returnValue.add(NewClonedOppty.Id);
                    returnValue.add(flagValue);        
                    return returnValue;
                }//rsCloneCount.size()>=opptyClonelimit 
                //    }
                //    else //if(rsOpportunity[0].Parent_ID__c==null)
                //    {
                //    return '2'; // Passed Oppty Id is not the Parent Oppty
                //    }
            }
            else //if(rsOpportunity.size()==1)
            {
                System.debug('return==>1'); 
                returnValue.add('1');   
                return returnValue; // Invalid Opportunity Id passed
            }
        }//end of try
        catch (Exception e)
        {
            
            if(e.getMessage()=='Insert failed. First exception on row 0; first error: FIELD_CUSTOM_VALIDATION_EXCEPTION, The Opportunity Name already Exists for this Account.: [Name]')
            {
                //returnValue.add('Cannot clone the Opportunity because, there exists already an opportunity with the same name.');   
                returnValue.add('Cannot clone the Opportunity because, there exists already an opportunity with the same name.');
                return returnValue;    
            }
            else
            {
                System.debug('return e.getMessage()==>1'+e.getMessage());
                //returnValue.add(e.getMessage());  
                returnValue.add(e.getMessage());  
                return returnValue;
            }
        }
    }//end of webservice
    //Prithu if Product_Family value is present and product_ref null , this method return id based on product_family value
    public static id setProductFamily(string productFamily, Id productId){
        system.debug('productFamily  value method'+productFamily);
        system.debug('productId  value method'+productId); 
        list<Product_Family__c> prodFamily  = new list<Product_Family__c>();
        if(productFamily!=null && productId!=null){ 
            try{ 
                prodFamily=[SELECT Id,product__c,Product_Family_Description__c FROM Product_Family__c where Product_Family_Description__c=:productFamily and product__c=:productId limit 1];
                system.debug('prodFamily List Value Id'+prodFamily[0].id);
            }catch(Exception e){
                system.debug('error==>'+e);
                return null;
            }      
        }
        system.debug('prodFamily==>'+prodFamily); 
        if(prodFamily.size()>0){
            return prodFamily[0].id;
        }else{
            return null;
        }
        
    }
    
}//end of class