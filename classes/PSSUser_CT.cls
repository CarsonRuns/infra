/**
* @release -March 2015
* @author -lakshsur.
* @description - Enhanced to add Fields for Multitech Workspace sync with Opportunity - WR-00949 March'2015.
* @release - JUNE Q4FY14
* @author - majanard
* @description - Enhanced to add Workspace Status and Lost/Cancel reason sync with Opportunity - WR-00458 June'2014.
* @release - FEB Q2FY15
* @description - Restrict the non-Security Workspace as Multi-tech Workspaces (WR-00971).
* @release - May Q4FY15
* @description - Added Workspace Partner & Workspace Competitor (WR-01104).
* @release - Sep 2015
* @WR-01136 - Added check to verify only Security Manager reporting team can create Multi-tech workspace & Code cleanup
* @release -Feb 2016 (WR-01432)
* @author -kikamara.
* @description - Added Workspace Expiration Start & Number of Months to Page Reference

* 05/13/2016 - Added additional fields for Workspace and Workspace Technology clone (WR-0034)

* @author - Nishi Jain
* 18/11/Nov - Modified the logic to insert the Multi-tech workspace on click of Save button.
  @author-risrai
* 4/9/2016-Added additional fields for "Cisco Enterprise Agreement Details"section as per WR-2487.
* 
* @author - P R N Swamy
* 11/13/2017 - Added the "Security/DTG/Software/AS Workspaces" Validation error message condition based on INC0110414.
*                  Also replaced the hard-coded error messages with system labels.
* 11/17/2017 - Added validation for Opportunity Technology, to show the proper error message.
* 
*/

public class PSSUser_CT
{
// SCAVA Helper Method to validate Update Access at field level
     public static Boolean flsUpdateGet(SObjectField field)
    {
        return field.getDescribe().isUpdateable() ? true : false;
    }
     // SCAVA Helper Method to validate Create Access at field level
     public static Boolean flsGet(SObjectField field)
    {
        return field.getDescribe().isCreateable() ? true : false;
    }
/****************************Controller Variables********************************/
    public boolean editwin {get; set;}
    
    public AT_Workspace__c PSS {get;set;}

    public Opportunity oppty {get;set;}
    
    public string tempsubtech {get;set;}
    
    public string tempproduct {get;set;}
    
    public string tempteam {get;set;}
    
    public string tempUseCase {get;set;}
    
    public Boolean NonPSS {get;set;} 
    
    public Boolean closeDtLessCreateDate {get;set;}
    
    public Boolean showSyncChkbox;

    public String ErrorContent {get;set;}
    
    private Map<string,string> ForecastPosn_ID = new Map<string,string>();
    
    // private ApexPages.StandardController controller;
    
    private static boolean blnAlreadyDone = false;
    public string atTeam{set; get;} 
    
    public static boolean hasAlreadyDone(){ return blnAlreadyDone; }

    public static void setAlreadyDone() {blnAlreadyDone = true;} 
     
    public Boolean getError {get;set;}
    
    public boolean isShowAll{get; set;}
    
    public string rAccount {get;set;}
    
    //Multi-tech workspace 
    public Boolean newMtWorkspace {get; set;}
    public List <Workspace_Technology__c> WorkspaceTechList;
    public List<Workspace_Technology__c> toRemove = new List<Workspace_Technology__c>();
    public Id workspaceId = ApexPages.currentPage().getParameters().get('id');
    public Id getId {get; set;}
    public Boolean refreshPage {get; set;}
    public ApexPages.StandardController stdCtrl {get; set;}
    public Boolean mt_refreshPage {get; set;}
    public ApexPages.StandardController mt_stdCtrl {get; set;}
    public String opptyName {get; set;}
    public String opptyId {get; set;}
    public String newWorkspaceId {get; set;}
    public Boolean isMultiTech {get;set;}   
    public User pssUser;
    
/******************************Controller Methods*********************************/
    public PSSUser_CT(ApexPages.StandardController stdcontroller){ 
        boolean isMltitech  = false;
        if(ApexPages.currentPage().getParameters().get('mtOpptyId') != null ){
            isMltitech = true;
            opptyId = ApexPages.currentPage().getParameters().get('mtOpptyId');
            reset();
            addRow();
        }else{
            opptyId = ApexPages.currentPage().getParameters().get('CF00N30000002BozE_lkid');
        }        
        
        stdCtrl = stdcontroller;
        mt_stdCtrl = stdcontroller;        
        refreshPage = false;
        mt_refreshPage = false;
        isShowAll = false;        
        /* Changes start to allow EPSS users to create PSS on an oppty*/        
        NonPss = false;
        getError = false;
        closeDtLessCreateDate = false;
        try{
            validateuser();
        }catch (Exception e){
            System.debug('Workspace User Validation Exception - '+e);
        }
                
       /* Changes end to allow EPSS users to create PSS on an oppty*/  
       PSS = new AT_Workspace__c();
       // majanard - Added Workspace Status and Lost/Cancel reason for mapping - WR-00458.         
       if(ApexPages.currentPage().getParameters().get('id')== null){                
            editwin = false;
            try
            {
                oppty = [select ID,Name,Expected_Product__c,Expected_Service__c,CloseDate,Opportunity_Status__c,Forecast_Status__c, CreatedDate, StageName, Primary_Partner__c, Lost_Cancelled_Reason__c from Opportunity where id = : opptyId];
               PSS.Opportunity__c = oppty.ID;
               
               if(flsUpdateGet(AT_Workspace__c.PSS__c)||flsGet(AT_Workspace__c.PSS__c)) //SCAVA FIX
               {
                PSS.PSS__c = getPSSOwner();
                system.debug('PSS.PSS__c'+PSS.PSS__c );
               }
               if(flsUpdateGet(AT_Workspace__c.AT_Forecast_Status__c)||flsGet(AT_Workspace__c.AT_Forecast_Status__c)) //SCAVA FIX
               {
                PSS.AT_Forecast_Status__c = oppty.Forecast_Status__c;
               }
               if(flsUpdateGet(AT_Workspace__c.AT_Expected_Book_Date__c)||flsGet(AT_Workspace__c.AT_Expected_Book_Date__c))  //SCAVA FIX
               {
                PSS.AT_Expected_Book_Date__c = oppty.CloseDate;
               }
               if(flsUpdateGet(AT_Workspace__c.PSS_Workspace_Status__c)||flsGet(AT_Workspace__c.PSS_Workspace_Status__c)) //SCAVA FIX
               {
                PSS.PSS_Workspace_Status__c = oppty.Opportunity_Status__c;
               }
               if(flsUpdateGet(AT_Workspace__c.Workspace_Stage__c)||flsGet(AT_Workspace__c.Workspace_Stage__c)) //SCAVA FIX
               {
                PSS.Workspace_Stage__c = oppty.StageName;
               }
                String wspName = 'Workspace-' + oppty.name;        
                wspName = wspName.length() > 80 ? wspName.substring(0,80) : wspName; 
                PSS.Name = wspName;
               if(flsUpdateGet(AT_Workspace__c.Workspace_Partner__c)||flsGet(AT_Workspace__c.Workspace_Partner__c)) //SCAVA FIX
               {
                PSS.Workspace_Partner__c=oppty.Primary_Partner__c;
               }
                if(!isMltitech){
                if(flsUpdateGet(AT_Workspace__c.AT_Expected_Product__c)||flsGet(AT_Workspace__c.AT_Expected_Product__c)) //SCAVA FIX
               {
                    PSS.AT_Expected_Product__c = oppty.Expected_Product__c;
               }
                    if(flsUpdateGet(AT_Workspace__c.AT_Expected_Service__c)||flsGet(AT_Workspace__c.AT_Expected_Service__c)) //SCAVA FIX
               {
                    PSS.AT_Expected_Service__c = oppty.Expected_Service__c;
               }
                if(flsUpdateGet(AT_Workspace__c.Workspace_Lost_Cancelled_Reason__c)||flsGet(AT_Workspace__c.Workspace_Lost_Cancelled_Reason__c)) //SCAVA FIX
               {
                    PSS.Workspace_Lost_Cancelled_Reason__c = oppty.Lost_Cancelled_Reason__c;
               }
               if(flsUpdateGet(AT_Workspace__c.Workspace_Value_Range__c)||flsGet(AT_Workspace__c.Workspace_Value_Range__c)) //SCAVA FIX
               {
                    PSS.Workspace_Value_Range__c='Less than 5 Million';
               }
                if(flsUpdateGet(AT_Workspace__c.DCR__c)||flsGet(AT_Workspace__c.DCR__c)) //SCAVA FIX
               {                
                    PSS.DCR__c = getPSSOwner();
               }
               }
                datetime dt = oppty.CreatedDate;
                date opptyCreatedDate = Date.newInstance(dt.year(),dt.month(),dt.day());
                if(oppty.CloseDate < opptyCreatedDate) {
                    closeDtLessCreateDate = true;
                }
            }
            catch(Exception e)
            {
                system.debug(e+' : No Opportunity associated to Workspace');
            }  
            isMultiTech = false;  
        }
        
        if(ApexPages.currentPage().getParameters().get('id')!= null){ 
            editwin = true;
            PSS = [select Name,AT_Competitor__c,AT_Other_Competitor__c,Workspace_Partner__c ,AT_Other_Partner__c,AT_Next_Step__c,AT_Next_Step_Date__c,AT_Team__c,
                    AT_Optional_1__c,AT_Optional_2__c,AT_Comments__c,AT_Flags__c,PSS__c,Opportunity__c,AT_Forecast_Status__c,AT_Expected_Book_Date__c,PSS_Workspace_Status__c,
                    AT_Expected_Product__c,AT_Technology__c,AT_Sub_Technology__c,AT_Product__c,AT_Expected_Service__c,Forecast_Position_ID__c,Application__c,
                    Additional_Use_Case_Info__c,Solution_Offer__c,Business_Driver__c, Sync_With_Opportunity__c, Sync_Status__c, PSS_Additional_Comments__c, Opportunity_Source__c, Workspace_Service_Source__c,  
                    Workspace_Stage__c,Workspace_Win_Loss_Comments__c , Workspace_Lost_Cancelled_Reason__c,Workspace_Value_Range__c , Workspace_Contract_Start_Date__c , Workspace_Contract_Expiration_Date__c , 
                    Number_of_Service_Months__c, is_multi_tech__c, probability__c,DCR__c,DCR_Workspace_Approval_Status__c, Referenceable_Account__c , CSS_Survey_1_Operational_Value__c, CSS_Survey_2_Integration_Value__c,
                    CSS_Survey_4_Technology_Value__c, NCE_Completed_Date__c, CSS_Survey_3_Engagement_Value__c, Customer_POC_Details__c, Software_Buying_Model__c,Enterprise_Agreement_Status__c,Letter_of_Agreement__c,Adoption_Strategy__c,Total_Cost_of_Ownerhip_TCO_Status__c,Customer_Budget_Confirmed__c,Final_Customer_Approver__c,End_User_Info_From_EUIF_Signed__c,Combined_Services_Customer__c
                    from AT_Workspace__c where ID =:ApexPages.currentPage().getParameters().get('id')] ;
             opptyId =  PSS.Opportunity__c;
            if(flsUpdateGet(AT_Workspace__c.AT_Team__c)||flsGet(AT_Workspace__c.AT_Team__c)) //SCAVA FIX
            {
             tempteam = PSS.AT_Team__c; 
             system.debug('tempteam>>'+tempteam); 
            }
          if(flsUpdateGet(AT_Workspace__c.AT_Sub_Technology__c)||flsGet(AT_Workspace__c.AT_Sub_Technology__c))  //SCAVA FIX
            {           
             tempsubtech = PSS.AT_Sub_Technology__c;
            }
            if(flsUpdateGet(AT_Workspace__c.AT_Product__c)||flsGet(AT_Workspace__c.AT_Product__c)) //SCAVA FIX
            {
             tempproduct = PSS.AT_Product__c;
            }
            if(flsUpdateGet(AT_Workspace__c.Additional_Use_Case_Info__c)||flsGet(AT_Workspace__c.Additional_Use_Case_Info__c)) //SCAVA FIX
            {
             tempUseCase = PSS.Additional_Use_Case_Info__c;
            }
            if(flsUpdateGet(AT_Workspace__c.is_multi_tech__c)||flsGet(AT_Workspace__c.is_multi_tech__c)) //SCAVA FIX
            {
             isMultiTech = PSS.is_multi_tech__c;
            }
             
        } 
    
    } 
     
    public String getPSSOwner(){
        if (!editWin){
            return Userinfo.getUserID();
        }
        else{
            return PSS.PSS__c;
        }
     }
     
     //US12165 - Method added to Show All fields for  multiTech Workspace
     public void showAllFields(){
        isShowAll = true;
        
     }
     public void hideAllFields(){
        isShowAll = false;
        
     }
     /*
     * Decides the state of the input fields for Workspace Info fields like Forecast Status, 
     * Expected book Date, Expected Product, Expected Service and Workspace Status.
     */     
     public boolean getShowSyncChkbox()
     {
        boolean showSyncChkbox = false;
        Integer workspaceCount = 0;
           
        // get the pss id from the request object
        // when coming to the form for the first time...        
        if (PSS.Opportunity__c != null) 
        {
            // get the count of workspaces for the above opportunity id
            workspaceCount  = [Select count() from AT_Workspace__c a where a.Opportunity__c  = :PSS.Opportunity__c];  
        }   
        else
        {
            // when the save button is clicked            
            // get the parent opportuity Id
            if(ApexPages.currentPage().getParameters().get('id') != null && ApexPages.currentPage().getParameters().get('id') != '')
            {
                String pssId = ApexPages.currentPage().getParameters().get('id');
                AT_Workspace__c pssWorkspace = [Select a.Opportunity__c from AT_Workspace__c a where a.id = :pssId limit 1];
                if(flsUpdateGet(AT_Workspace__c.Opportunity__c)||flsGet(AT_Workspace__c.Opportunity__c)) //SCAVA FIX
                {
                PSS.Opportunity__c = pssWorkspace.Opportunity__c; 
                }
                // get the count of workspaces for the above opportunity id
                workspaceCount  = [Select count() from AT_Workspace__c a where a.Opportunity__c  = :pssWorkspace.Opportunity__c]; 
            }         
        }
        
        // if new workspace, then the count should be 0
        // OR if existing workspace, the count should be 1        
        if (PSS.Id == null){
            if(workspaceCount == 0) {
                showSyncChkbox = true;
            }
        }
        else
        {
            if(workspaceCount == 1) {
                showSyncChkbox = true;
            }
        }        
        return showSyncChkbox;      
     } 
     
        
    //Function to get Forecasting positions from Current User's record  
    public List<SelectOption> getforecastLOV()
    {
        list<SelectOption> forecastLOV = new list<SelectOption>();
        forecastLOV.add(new SelectOption('','-None-'));        
        boolean isInserted = false; 
       if(flsUpdateGet(AT_Workspace__c.AT_Team__c)||flsGet(AT_Workspace__c.AT_Team__c))  //SCAVA FIX
       {        
        if(editwin && PSS.AT_Team__c != null)
        {
            System.debug('Empty');
        } 
      }         
        try
        {            
            string forecastPstns = [select BA_Territories__c from User where ID =:PSS.PSS__c].BA_Territories__c;
            system.debug('forecastPstns:'+forecastPstns );
            String[] forecastPstnsArray=forecastPstns.split('\n');
            system.debug('forecastPstnsArray'+forecastPstnsArray);
            for(integer i=0;i< forecastPstnsArray.size();i++)
            {
            // Updated the SCAVA FIX
            if(flsUpdateGet(AT_Workspace__c.AT_Team__c)||flsGet(AT_Workspace__c.AT_Team__c)) //SCAVA FIX
            {
                if(forecastPstnsArray[i].contains(','))
                {
                    forecastLOV.add(new SelectOption(forecastPstnsArray[i].split(',')[0].trim(),forecastPstnsArray[i].split(',')[0].trim()));
                
                    if(PSS.AT_Team__c != null && editwin && forecastPstnsArray[i].split(',')[0].trim() == PSS.AT_Team__c.trim())
                    {
                        isInserted = true;
                        ForecastPosn_ID.put(forecastPstnsArray[i].split(',')[0].replaceall('\\s+',' ') ,forecastPstnsArray[i].split(',')[1]);
                        system.debug('ForecastPosn_ID'+ForecastPosn_ID);
                    
                    }
            
                    else  {  
                        ForecastPosn_ID.put(forecastPstnsArray[i].split(',')[0].replaceall('\\s+',' ') ,forecastPstnsArray[i].split(',')[1]);
                        }
                }
                
                else
                {
                   // if(flsUpdateGet(AT_Workspace__c.AT_Team__c)||flsGet(AT_Workspace__c.AT_Team__c)) //SCAVA FIX
            
                    if(PSS.AT_Team__c != null && editwin && forecastPstnsArray[i].trim() == PSS.AT_Team__c.trim())
                    {                    
                        isInserted = true;
                        ForecastPosn_ID.put(forecastPstnsArray[i].split(',')[0].replaceall('\\s+',' ') ,forecastPstnsArray[i].split(',')[0]);
                    }
            
                    else {   
                        ForecastPosn_ID.put(forecastPstnsArray[i].replaceall('\\s+',' ') ,'');
                    }    
                    forecastLOV.add(new SelectOption(forecastPstnsArray[i].trim(),forecastPstnsArray[i].trim()));
                    system.debug('forecastLOV:'+forecastLOV);
                }
                }   
            }
           
        }
        catch(Exception e)
        {
            system.debug('No Forecast position');
        }
        return forecastLOV;  
          
    }
    
    
    public void validateuser(){
        String pssProfileId = '00e30000000rrZwAAI'; 
        Boolean isEPSS = Utilities.checkAdditionalUserPermission('Enable_ePSS');
        String SupportProfiles = Utilities.getConstant_CS('Support Profiles');
        String UserProfileName = [select Name from profile where id = :userInfo.getProfileId()].Name;
        Boolean skip = SupportProfiles.contains(UserProfileName);
        
        if(!(pssProfileId == UserInfo.getProfileId()||isEPSS||skip))
            {
            
            NonPss = true;
            if(ApexPages.currentPage().getParameters().get('id')== null){
                ErrorContent = Label.Workspace_Create_PSS_Error;
            }
            else{
                ErrorContent = Label.Workspace_PSS_Edit_Error;
            }
            
        }
    }
    
   //Function to get string of comma separated Dependant technology/Sub technology
    public string getTechSubtech()
    {
        List<PSS_DependantPickval__c> subtech = PSS_DependantPickval__c.getall().values();
        string techsubtech = '';
       for(integer i=0; i< subtech.size(); i++)
        {
        if(i!=0) {
            techsubtech += ';';
            }
        techsubtech += subtech[i].name.trim();
        string[] subtechArr = new List<string>();
        if(subtech[i].Sub_Technology__c != NULL && subtech[i].Sub_Technology__c != '') {
            subtechArr.addall(subtech[i].Sub_Technology__c.split('\n'));
            }
        if(subtech[i].Sub_Technology_1__c != NULL && subtech[i].Sub_Technology_1__c != '') {
            subtechArr.addall(subtech[i].Sub_Technology_1__c.split('\n'));
            }
        if(subtech[i].Sub_Technology_2__c != NULL && subtech[i].Sub_Technology_2__c != '') {
            subtechArr.addall(subtech[i].Sub_Technology_2__c.split('\n'));
            }
        if(subtech[i].Sub_Technology_3__c != NULL && subtech[i].Sub_Technology_3__c != '') {
            subtechArr.addall(subtech[i].Sub_Technology_3__c.split('\n'));
            }
        if(subtech[i].Sub_Technology_4__c != NULL && subtech[i].Sub_Technology_4__c != '') {
            subtechArr.addall(subtech[i].Sub_Technology_4__c.split('\n'));
            }
        for(string s : subtechArr){
            techsubtech+= '~~';
            techsubtech += s.trim();
        }    
        }
        return techsubtech.trim();
    }
   
    
    //Function to get string of comma separated Dependant sub technology/Product
    public string getSubtechProd()
    {
        List<PSS_Subtech_Product__c> Prod = PSS_Subtech_Product__c.getall().values();
        string SubtechProd= '';
       for(integer i=0; i< Prod.size(); i++)
        {
        if(i!=0) {
            SubtechProd += ';';
            }
        SubtechProd += Prod[i].name.trim();
        string[] ProdArr = new List<string>();
        if(Prod[i].Product__c != NULL && Prod[i].Product__c != '') {
            ProdArr.addall(Prod[i].Product__c.split('\n'));
            }
        if(Prod[i].Product_1__c != NULL && Prod[i].Product_1__c != '') {
                 ProdArr.addall(Prod[i].Product_1__c.split('\n'));
                 }
        if(Prod[i].Product_2__c != NULL && Prod[i].Product_2__c != '') {
                 ProdArr.addall(Prod[i].Product_2__c.split('\n'));
                 }
        if(Prod[i].Product_3__c != NULL && Prod[i].Product_3__c != '') {
                 ProdArr.addall(Prod[i].Product_3__c.split('\n'));
                 }
        if(Prod[i].Product_4__c != NULL && Prod[i].Product_4__c != '') {
                 ProdArr.addall(Prod[i].Product_4__c.split('\n'));
                 }
        for(string s : ProdArr){
            SubtechProd += '~~';
            SubtechProd += s.trim();
        }    
        }
        return SubtechProd.trim();
    }
    
    //Function to get string of comma separated Dependant sub technology/Customer Use Case
    public string getTechUseCase()
    {
        List<PSS_Tech_UseCase__c> temp = PSS_Tech_UseCase__c.getall().values();
        string techUseCase= '';
       for(integer i=0; i< temp.size(); i++)
        {
        if(i!=0) {
            techUseCase += ';';
            }
        techUseCase += temp[i].name.trim();
        string[] UseCaseArr = new List<string>();
        if(Temp[i].Constant1__c != NULL && Temp[i].Constant1__c != '') {
                 UseCaseArr.addall(Temp[i].Constant1__c.split('\n'));
                 }
        if(Temp[i].Constant2__c != NULL && Temp[i].Constant2__c != '') {
                 UseCaseArr.addall(Temp[i].Constant2__c.split('\n'));
                 }
        if(Temp[i].Constant3__c != NULL && Temp[i].Constant3__c != '') {
                 UseCaseArr.addall(Temp[i].Constant3__c.split('\n'));
                 }
        if(Temp[i].Constant4__c != NULL && Temp[i].Constant4__c != '') {
                 UseCaseArr.addall(Temp[i].Constant4__c.split('\n'));
                 }
        if(Temp[i].Constant5__c != NULL && Temp[i].Constant5__c != '') {
                 UseCaseArr.addall(Temp[i].Constant5__c.split('\n'));
                 }
        for(string s : UseCaseArr){
            techUseCase += '~~';
            techUseCase += s.trim();
        }    
        }
        return techUseCase.trim();
    }
    
    public PageReference cancel() {
        Pagereference pageref ;               
        if(PSS.Id != null) {
            pageref = new Pagereference('/'+ PSS.Id);
        }
        else{
            pageref = new Pagereference('/'+ opptyId);
        }
        return pageref;     
    }
    
    public PageReference save()
    {   
       if(flsUpdateGet(AT_Workspace__c.AT_Team__c )||flsGet(AT_Workspace__c.AT_Team__c ))  //SCAVA FIX
        {
            PSS.AT_Team__c = tempteam;
            system.debug('PSS.AT_Team__c'+PSS.AT_Team__c);
        }
        if(flsUpdateGet(AT_Workspace__c.Forecast_Position_ID__c)||flsGet(AT_Workspace__c.Forecast_Position_ID__c))  //SCAVA FIX
        {
            PSS.Forecast_Position_ID__c = ForecastPosn_ID.get(PSS.AT_Team__c);
            system.debug('PSS.Forecast_Position_ID__c'+PSS.Forecast_Position_ID__c);
        }
        if(flsUpdateGet(AT_Workspace__c.AT_Sub_Technology__c)||flsGet(AT_Workspace__c.AT_Sub_Technology__c))  //SCAVA FIX
        {
            PSS.AT_Sub_Technology__c = tempsubtech;
        }
        if(flsUpdateGet(AT_Workspace__c.AT_Product__c )||flsGet(AT_Workspace__c.AT_Product__c))  //SCAVA FIX
        {
            PSS.AT_Product__c = tempproduct;
        }
        if(flsUpdateGet(AT_Workspace__c.Additional_Use_Case_Info__c)||flsGet(AT_Workspace__c.Additional_Use_Case_Info__c))  //SCAVA FIX
        {
            PSS.Additional_Use_Case_Info__c = tempUseCase;  
        }
        
        // if the sync with checkbox is checked, copy certain values from the oppty to workspace
        if (PSS.Sync_With_Opportunity__c && getShowSyncChkbox())
        {
            // majanard - Added Workspace Status and Lost/Cancel reason for mapping - WR-00458.          
            oppty = [select ID,Name,Expected_Product__c,Expected_Service__c,CloseDate,Opportunity_Status__c,Forecast_Status__c, StageName,  Lost_Cancelled_Reason__c
                     from Opportunity 
                        where id = :PSS.Opportunity__c];
           if(flsUpdateGet(AT_Workspace__c.AT_Forecast_Status__c)||flsGet(AT_Workspace__c.AT_Forecast_Status__c)) //SCAVA FIX
            {
            PSS.AT_Forecast_Status__c = oppty.Forecast_Status__c;
            }
            if(flsUpdateGet(AT_Workspace__c.AT_Expected_Book_Date__c)||flsGet(AT_Workspace__c.AT_Expected_Book_Date__c)) //SCAVA FIX
            {
            PSS.AT_Expected_Book_Date__c = oppty.CloseDate;
            }
            if(flsUpdateGet(AT_Workspace__c.AT_Expected_Product__c)||flsGet(AT_Workspace__c.AT_Expected_Product__c)) //SCAVA FIX
            {
            PSS.AT_Expected_Product__c = oppty.Expected_Product__c;
            }
            if(flsUpdateGet(AT_Workspace__c.AT_Expected_Service__c)||flsGet(AT_Workspace__c.AT_Expected_Service__c)) //SCAVA FIX
            {
            PSS.AT_Expected_Service__c = oppty.Expected_Service__c;
            } 
            if(flsUpdateGet(AT_Workspace__c.PSS_Workspace_Status__c)||flsGet(AT_Workspace__c.PSS_Workspace_Status__c)) //SCAVA FIX
            {           
            PSS.PSS_Workspace_Status__c = oppty.Opportunity_Status__c;
            }
            if(flsUpdateGet(AT_Workspace__c.Workspace_Stage__c)||flsGet(AT_Workspace__c.Workspace_Stage__c)) //SCAVA FIX
            {
            PSS.Workspace_Stage__c = oppty.StageName;
            }
            if(flsUpdateGet(AT_Workspace__c.Workspace_Lost_Cancelled_Reason__c)||flsGet(AT_Workspace__c.Workspace_Lost_Cancelled_Reason__c)) //SCAVA FIX
            {
            PSS.Workspace_Lost_Cancelled_Reason__c = oppty.Lost_Cancelled_Reason__c;
            }
        }
        
        //Insert Workspace record; If any failure, capture the exception and display the error on Workspace UI.               
        try
        {
            upsert PSS;
        }
        catch(Exception e)
            {    
                if(e.getMessage().contains(Label.Workspace_PSS_Owner_Error)) {
                    apexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Workspace_PSS_Owner_Error));
                }
                //Nov'14 majanard - Validation for Security Workspace error message
                else  if(e.getMessage().contains(Label.Workspace_Security_Error_Validation)){
                         apexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Workspace_Security_Error));
                         getError = true;  
                }
                //Added condition based on Incident - INC0110414.  
                else if(e.getMessage().contains(Label.Workspace_Security_DTG_Software_AS_Workspaces_Validation_Condition)){                       
                         apexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Workspace_Security_DTG_Software_AS_Workspaces_Validation));
                         getError = true;  
                }
                else {
                // Nov'14 majanard - Any new Validation Rule with Error Message = Top of Page will display with below error prefix.
                    apexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Workspace_Insert_Error));
                }
                return null;
            }
        
        Pagereference pageref = new Pagereference('/'+ PSS.ID);
        return pageref;
    }
    
    public PageReference saveWorkspace(){
        getError = false;
       //@WR-01136
       //Get the security manager IDs from Custom Setting.
       String SecurityManagerID = Utilities.getConstant_CS('SecurityManagerID');
       List<User> pssUserLst = [select Reporting_Up_Manager_Chain__c from User where ID =:PSS.PSS__c limit 1];
       system.debug('pssUserLst'+pssUserLst);
       if(!pssUserLst.isEmpty()){
          pssUser = pssUserLst[0];
        }
        List<String> SMIDs = new List<String>();
        if(String.isNotEmpty(SecurityManagerID)) {
            if(SecurityManagerID.contains(',')) {
               SMIDs = SecurityManagerID.split(',');
            }
            else {
               SMIDs.add(SecurityManagerID) ;
           }
        } 
        boolean isSMCheck = false;
        if(pssUser.Reporting_Up_Manager_Chain__c != null && pssUser.Reporting_Up_Manager_Chain__c != '' && !SMIDs.isEmpty()){
            for(String s :SMIDs) {
                if(pssUser.Reporting_Up_Manager_Chain__c.contains(s)) {
                    isSMCheck = true;
                    break;
                }
            }
            if(!isSMCheck) {
                apexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Workspace_No_Security_Manager_Reporting));
                return null;   
            } 
        }
        if(WorkspaceTechList.isEmpty()) {            
            apexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Workspace_Multitech_Error));
            return null;
        }  
        //sournaga - added changes for WR-01110
        else{
            workspaceValidation__c wrkValidation = workspaceValidation__c.getInstance(UserInfo.getProfileId());
            if(!wrkValidation.Workspace_SkipValidation__c){
                decimal amt=0;
                for(Workspace_Technology__c wt : WorkspaceTechList){
                            amt += wt.Expected_000__c;           
                }
                if(flsUpdateGet(AT_Workspace__c.Workspace_Value_Range__c)||flsGet(AT_Workspace__c.Workspace_Value_Range__c)) //SCAVA FIX
                {
                     if((PSS.Workspace_Value_Range__c=='Less than 5 Million' && amt>=5000) || (PSS.Workspace_Value_Range__c=='05 Million-10 Million' &&( amt<5000 || amt>=10000)) || (PSS.Workspace_Value_Range__c=='10 Million-50 Million' && (amt<10000 || amt >=50000)) || (PSS.Workspace_Value_Range__c=='50 Million-100 Million' &&( amt <50000 || amt >=100000)) || (PSS.Workspace_Value_Range__c=='100 Million-500 Million' && (amt <100000 || amt>=500000)) || (PSS.Workspace_Value_Range__c=='Above 500 Million' && amt<500000 ))
                     {
                    apexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Worskspace_Value_Range_Error));
                    return null;
                     }     
                }
            }
            if(PSS.probability__c != null && (PSS.probability__c > 100 || PSS.probability__c < 0)) {
               apexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Workspace_Probability_Error));
                return null;
            }
            List<Workspace_Technology__c> workspaceRecInsertList = new List<Workspace_Technology__c>();           
           if(flsUpdateGet(AT_Workspace__c.AT_Team__c)||flsGet(AT_Workspace__c.AT_Team__c)) //SCAVA FIX
            {
                PSS.AT_Team__c = tempteam;
            }
            if(flsUpdateGet(AT_Workspace__c.Forecast_Position_ID__c)||flsGet(AT_Workspace__c.Forecast_Position_ID__c)) //SCAVA FIX
            {
                PSS.Forecast_Position_ID__c = ForecastPosn_ID.get(PSS.AT_Team__c);
                system.debug('PSS.Forecast_Position_ID__c'+PSS.Forecast_Position_ID__c);
            }
            // majanard - Added Workspace Status and Lost/Cancel reason for mapping - WR-00458. 
            System.debug('##PSS.Opportunity__c## '+PSS);         
            oppty = [select ID,Name,Expected_Product__c,Expected_Service__c,CloseDate,Opportunity_Status__c,Forecast_Status__c, StageName,  Lost_Cancelled_Reason__c
                     from Opportunity 
                        where id = :PSS.Opportunity__c]; 
            if(flsUpdateGet(AT_Workspace__c.Is_Multi_Tech__c)||flsGet(AT_Workspace__c.Is_Multi_Tech__c)) //SCAVA FIX
            {
                PSS.Is_Multi_Tech__c = true;
            }
            if (PSS.Sync_With_Opportunity__c && getShowSyncChkbox()){
                if(flsUpdateGet(AT_Workspace__c.AT_Forecast_Status__c)||flsGet(AT_Workspace__c.AT_Forecast_Status__c)) //SCAVA FIX
                {
                PSS.AT_Forecast_Status__c = oppty.Forecast_Status__c;
                }
                if(flsUpdateGet(AT_Workspace__c.AT_Expected_Book_Date__c)||flsGet(AT_Workspace__c.AT_Expected_Book_Date__c)) //SCAVA FIX
                {
                PSS.AT_Expected_Book_Date__c = oppty.CloseDate;
                }
                if(flsUpdateGet(AT_Workspace__c.PSS_Workspace_Status__c)||flsGet(AT_Workspace__c.PSS_Workspace_Status__c)) //SCAVA FIX
                {
                PSS.PSS_Workspace_Status__c = oppty.Opportunity_Status__c;
                }
                if(flsUpdateGet(AT_Workspace__c.Workspace_Stage__c)||flsGet(AT_Workspace__c.Workspace_Stage__c)) //SCAVA FIX
                {
                PSS.Workspace_Stage__c = oppty.StageName;
                }
                if(flsUpdateGet(AT_Workspace__c.Validate_Product_Service_Update__c)||flsGet(AT_Workspace__c.Validate_Product_Service_Update__c)) //SCAVA FIX
                {
                    PSS.Validate_Product_Service_Update__c = true;
                }
                if(flsUpdateGet(AT_Workspace__c.Workspace_Lost_Cancelled_Reason__c)||flsGet(AT_Workspace__c.Workspace_Lost_Cancelled_Reason__c)) //SCAVA FIX
                {
                PSS.Workspace_Lost_Cancelled_Reason__c = oppty.Lost_Cancelled_Reason__c;                
                }
            }
            try
            {
                upsert PSS;
                newWorkspaceId = PSS.Id;                
                for(Workspace_Technology__c wt : WorkspaceTechList){                    
                    if(wt.Id == null){
                        Workspace_Technology__c newWorkspaceRec = wt.clone(false);
                        if(flsUpdateGet(Workspace_Technology__c.Workspace__c)||flsGet(Workspace_Technology__c.Workspace__c)) //SCAVA FIX
                        {
                            newWorkspaceRec.Workspace__c = newWorkspaceId;
                        }
                        workspaceRecInsertList.add(newWorkspaceRec);
                    }
                    else{
                        workspaceRecInsertList.add(wt);
                    }                    
                }
                upsert workspaceRecInsertList;
                if(toRemove.size() > 0){
                //SCAVA FIX
                    if (Workspace_Technology__c.sObjectType.getDescribe().isDeletable())
                    {
                    delete toRemove;
                    }
                    refreshPage = true;
                }
            }
            catch(Exception e){
                if(e.getMessage().contains(Label.Workspace_PSS_Owner_Error)) {
                    apexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Workspace_PSS_Owner_Error));
                    System.debug('Debug 1');
                    //return null;
                }   
                //Nov'14 majanard - Validation for Security Workspace error message
                else  if(e.getMessage().contains(Label.Workspace_Security_Error_Validation)){
                    apexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Workspace_Security_Error));
                    //getError = true; 
                    //return null;  
                }
                else  if(e.getMessage().contains(Label.Workspace_Security_Error_Condition)){
                    apexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Workspace_Security_Error));
                    //getError = true;
                    //return null;  
                }
                else if(e.getMessage().contains(Label.Workspace_Referenceable_Account_is_mandatory)){
                    apexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.Workspace_Referenceable_Account_is_mandatory));
                    //return null;
                }
                // Validation for Opportunity Technology
                else if(e.getMessage().contains(Label.Workspace_Technology_Security_Validation)){
                    apexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.Workspace_Technology_Security_Error));
                    //return null;
                }
                else {
                    // Nov'14 majanard - Any new Validation Rule with Error Message = Top of Page will display with below error prefix.
                    System.debug('Error-->' + e.getMessage());
                    apexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Workspace_Insert_Error));
                }
                return null;
            }
            Pagereference pageref = new Pagereference('/'+ newWorkspaceId);
            return pageref;
        }
        
        
    }
    
    public PageReference reset()  { 
        //Updated Technology_Specialist__c field for WR-00808
        WorkspaceTechList = [SELECT Id, Workspace__c, Business_Entity__c, Business_Sub_Entity__c, 
            Product_Family__c, Expected_000__c , Service_Source__c, Comments__c, Model__c, Technology_Specialist__c,  Distibutor__c, Partner__c
            FROM Workspace_Technology__c 
            WHERE Workspace__c =: workspaceId ];
        return null; 
    }

    public List <Workspace_Technology__c> getWorkspaceTechs() {
        if(WorkspaceTechList == null) {
            reset();
        }       
        return WorkspaceTechList;
    }

  
    public PageReference deleteRow() {         
        Integer index = Integer.valueOf(ApexPages.currentPage().getParameters().get('rowIndex'));  
        if(ApexPages.currentPage().getParameters().get('rowToDelete') != ''){                
            toRemove.add(WorkspaceTechList.get(index));                   
        }  
         WorkspaceTechList.remove(index);
        System.debug('#####WorkspaceTechList-->' + WorkspaceTechList);
        return null;
    }   
    
    public PageReference addRow() {       
        WorkspaceTechList.add(new Workspace_Technology__c(Business_Entity__c='',Business_Sub_Entity__c='',Product_Family__c='',Expected_000__c=null,Service_Source__c=''));        
        return null; 
    }
    
    
      /**
* @author      			: R. Hari Krishna
* @ #US/Defect			: DE220165
* @description 			: Checks record is of type multiTech or not 
* @Create/Modify Date   : Dec 06,2018
* @param       			: workspace Record Id
* @return      			: boolean
**/
    @AuraEnabled public static Boolean multiTechDetail(String owsId){                
        return [Select id,is_multi_tech__c from AT_Workspace__c where ID =:owsId].is_multi_tech__c;      
    }
    
}