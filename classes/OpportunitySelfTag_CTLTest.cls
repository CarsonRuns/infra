@isTest
public class OpportunitySelfTag_CTLTest {
@isTest(SeeAllData=true)
public static void addSelfTagTest(){
    Utilities.setIsTestMethod(true);
    Utilities.setValidationSkip(true);
/*User userForTesting = [SELECT Id FROM User WHERE Profile.Name= 'Cisco_Sales' AND IsActive=true
WHERE Profileid =:Utilities.getConstant_CS('PilotProfileId') AND 
(Additional_User_Permissions__c includes ('Enable_ePSS','Enable_VSS')) AND 
(Theatre__c='APJC-APAC' OR Theatre__c='EMEAR') LIMIT 1]; */
//lxPilotUserCheckTest.udpateUsr('Enable_VSS',userForTesting.Id,'APJC-APAC'); 
Profile p = [SELECT Id FROM Profile WHERE Name='Cisco_ADMIN']; 
User u = new User(Alias = 'standt', Email='standarduser100@cisco.com', 
EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
LocaleSidKey='en_US', ProfileId = p.Id, Additional_User_Permissions__c = 'SE User',
TimeZoneSidKey='America/Los_Angeles',Theatre__c='APJC-APAC', 
UserName='standarduser100@cisco.com');
System.runAs(u){
Opportunity opty = [SELECT id from Opportunity LIMIT 1];
Opportunity opty1 = new Opportunity();
//opty1.Adv_Services_AS__c = 0;
opty1.Amount = 14;
opty1.Best_Practice__c = FALSE;
//opty1.Booked_Oppty_Count__c = 1;
//opty1.Closed_Oppty_Count__c = 0;
// opty1.Created_by_Me__c = FALSE;
// opty1.Created_By_PSS__c = 
opty1.Created_Via_Salesforce1__c = FALSE;
opty1.CurrencyIsoCode = 'USD';
//opty1.DealID_Utilized__c = 'Yes';
opty1.Deal_ID_Stack_Has_Error__c = FALSE;
opty1.Discount_Approval__c = 'Product';
//opty1.Discount_Bands__c = 61-65%
//opty1.Discount_Ranges__c = '61-70%';
opty1.Dollar_Amount_Greater_than_5M__c = 'Less than 5 Million';
//opty1.DO_NOT_USE_SS_CONVE_PRODUCT_USD__c = 14;
//opty1.DO_NOT_USE_SS_CONVE_SERVICE_USD__c = 0;
opty1.Email_Partner__c = FALSE;
opty1.Email_Sales_Team__c = FALSE;
opty1.Email_to_Requested_SE__c =TRUE;
// opty1.ExpectedProduct__c = 14000;
//opty1.ExpectedRevenue = 14;
//opty1.ExpectedService__c = 0;
//opty1.ExpectedTotal__c = 14000;
// opty1.Expected_Less_Forecasted_Value_000__c = 14;
//opty1.Expected_Less_Forecasted_Value__c = 14;
opty1.Expected_Product_List_Amount__c = 0;
// opty1.Expected_Product_Range__c = 'a.0 - 100';
opty1.Expected_Product__c = 14;
//opty1.Expected_Total_Value_000_s__c = 14;
//opty1.Fiscal_Month_of_QTR__c = 2;
//opty1.Fiscal_Month__c =11;
//opty1.Fiscal_Period__c ='Q4-2016';
//opty1.Fiscal_Quarter__c =
//opty1.Fiscal_Week_of_Month__c =2; 
opty1.Fiscal_Week__c =46;
//opty1.Fiscal_Year__c =2016;
//opty1.ForecastCategory ='Omitted';
opty1.ForecastCategoryName = 'Omitted';
opty1.Forecast_Discount__c = 65;
opty1.Forecast_Status__c ='Commit';
opty1.FY_Copy__c =2016;
//opty1.FY_Extra_Week__c =1;
//opty1.FY_Start_Date__c = system.today();
//opty1.HasOpenActivity =FALSE;
//opty1.HasOpportunityLineItem =TRUE;
//opty1.HasOverdueTask = FALSE;
opty1.Has_Competitors__c = TRUE;
//opty1.Has_Partners__c = 'Yes';
//opty1.IsClosed = TRUE;
//opty1.IsDeleted = FALSE;
//opty1.IsLocked =FALSE;
opty1.IsSFOneApp__c = FALSE;
//opty1.IsWon = TRUE;
//opty1.I_am_Opportunity_Security_Manager__c = FALSE;
//opty1.I_m_Opportunity_Owner_Manager__c =FALSE;
//opty1.Line_Item_Service_Count__c =0;
//opty1.Line_Item_Tech_Count__c =1;
//opty1.MayEdit =TRUE;
opty1.Name='AP- CARIBBEAN PRODUCE- DANIEL- CORTELCO- 2-TIER- TD';
opty1.Non_standard_Terms_and_Conditions_Prod__c = FALSE;
opty1.Non_standard_Terms_and_Conditions_Srvc__c =FALSE;
opty1.Non_Standard_Terms_and_Conditions__c ='None';
//opty1.No_of_days_Overdue__c = 974;
//opty1.No_of_Days_Past_EBD__c =976;
//opty1.No_Of_Days__c =
//opty1.Opportunity_Count__c = 1;
opty1.Opportunity_Flags__c = 'DSA Placeholder';
opty1.Opportunity_Status__c ='Booked';
//opty1.Opportunity_Visibility_Days__c = 39; 
//opty1.Overdue_Close_Date__c =system.today();
opty1.Partner_Alert_Flag__c =FALSE;
opty1.Partner_Required__c =TRUE;
opty1.Phase_Linked__c =FALSE;
//opty1.Position_Territory_in_Sync__c=TRUE; 
opty1.Position__c ='VS-PR-COM-G-VSAM-09 (PRI GEO NEW)';
//opty1.Primary_Partner_Purchasing_Relationship__c = 'INDIRECT';
opty1.Probability =100;
opty1.Product_Enhancements__c='Not Required'; 
//opty1.Product_Non_Recurring_000s__c =14;
//opty1.Product_Recurring_Offer_ARR_000s__c=0; 
//opty1.Product_Recurring_Offer_MY_000s__c = 0;
//opty1.Product_TCV_000s__c =14;
opty1.Provisioned_Managed_Services__c=FALSE; 
//opty1.Quote_Count__c =1;
//opty1.Recurring_Offer_ARR_000s__c =0;
//opty1.Recurring_Offer_ARR_000__c =0;
//opty1.Recurring_Offer_Multi_Year_000s__c=0; 
//opty1.Recurring_Offer_TCV_000s__c =0;
opty1.RFP__c =FALSE;
//opty1.Sales_Cycle_Length__c =39;
opty1.Services_All_Multiyear__c =FALSE;
//opty1.Service_Non_Recurring_000s__c =0;
//opty1.Service_Recurring_Offer_ARR_000s__c=0; 
//opty1.Service_Recurring_Offer_MY_000s__c =0;
opty1.Service_Source__c ='New';
//opty1.Service_TCV_000s__c =0;
//opty1.Service_Total_Mix__c =0;
opty1.SE_Assigned__c =FALSE;
//opty1.SE_Count__c =0;
opty1.SE_Engaged__c =FALSE;
//opty1.SiteMapIdentifier__c ='AP- CARIBBEAN PRODUCE- DANIEL- CORTELCO- 2-TIER- TD';
opty1.skipValidations__c =TRUE;
//opty1.Solution_Plan__c ='<img src="/servlet/servlet.FileDownload?file=01530000000K9Xb" alt=" " style="height:85px; width:519px;" border="0"/>';
opty1.SP_Internal_IT__c =FALSE;
opty1.StageName ='1 - Prospect';
opty1.Strategic_Funding__c =FALSE;
//opty1.Technology_Total_Mix__c =100;
//opty1.Tech_Services_TS__c =0;
//opty1.Territory_Levels__c ='CORP. REVENUE | Americas | LATIN AMERICA | CANSAC | CANSAC COMMERCIAL | PUERTO RICO COMMERCIAL | PRI GEO NEW | VS-PR-COM-G-VSAM-09 (PRI GEO NEW) | | | |'
opty1.Theater__c ='Americas-LATAM';
opty1.TotalOpportunityQuantity =1;
//opty1.Total_AS_S__c =0;
//opty1.Total_AS_T__c =0;
//opty1.Total_Contract_Value_TCV_000s__c=14; 
//opty1.Total_Non_Recurring_000s__c =14;
//opty1.Total_Recurring_Offers_Yes__c =0;
//opty1.Total_Recurring_Offers__c =0;
//opty1.Total_TS_S__c =0;
//opty1.TSN_Flag_Dummy__c=FALSE; 
opty1.Usage_Metric_Data_Last_Modified_Date__c=system.today(); 
opty1.CloseDate=system.today();
insert opty1;
//System.runAs(userForTesting){
OpportunitySelfTag_CTL.addSelfTag(opty1.id, 'Incubation Specialist', 'Edit');
//} 
} 
} 
}