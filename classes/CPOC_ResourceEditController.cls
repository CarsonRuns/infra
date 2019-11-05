/***************************************************************************************************
Name    : CPOC_PersonnelEditController 
Author  : Priyanka Jangid
Purpose : Visualforce Page Controller for custom CPOC Room page  
Created Date: Jan 25 2016              
Modified By :
        Sudi - Aug 17th 2016: Added this extra check during normalization fix.
                              To check the selResource is empty or not to void code execution.  
*****************************************************************************************************/

public class CPOC_ResourceEditController {
    // SCAVA Helper Method
     public static Boolean flsGet(SObjectField field)
    {
        return field.getDescribe().isCreateable() ? true : false;
    }
    

    //Record and controller variables
    private static String TAG = 'CPOC_ResourceEditController';
    public CPOC_Shared_Resource__c resource;    
    
    //Related object list variables
    public CEE__c briefing { get; set; }       
    public List<CPOC_All_Shared_Resources__c> siteResources;
    
    //Page display variables
    public String pageUrl { get; set; }
    public String pageDisplay { get; set; }
    public Boolean isNew { get; set; }
    public String resourceName { get; set; }
    
    //Room variables
    public String selResource { get; set; }
    public string selResName {get;set;}
    public string sResStatus{get;set;}
    public list<CPOC_Shared_Resource__c> lstResources{get;set;}    
    
     public void returnResourceAvaibilityStatus(){  
        try{
            // Sudi - Aug 17th 2016 : Added this condition in code as part normalization fix.
            // Checking for selResource is empty or not.
            if(String.isEmpty(selResource)){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING,'Invalid or no Resource selected'));               
            }
            else{
                lstResources = new list<CPOC_Shared_Resource__c>();
                CPOC_All_Shared_Resources__c resSelect = [select Resource_Name__c from CPOC_All_Shared_Resources__c where id=:selResource limit 1];       
                lstResources = [select Customer_Engagements_Events__r.Primary_Account__r.Name,CPOC_Start_Date__c,CPOC_End_date__c,CPOC_All_Shared_Resource__r.Resource_Name__c,Customer_Engagements_Events__r.Request_Status__c from CPOC_Shared_Resource__c
                                                 where Customer_Engagements_Events__r.Request_Status__c in('Submitted','Scheduled','Lab Redirect') AND CPOC_All_Shared_Resource__r.Resource_Name__c =:resSelect.Resource_Name__c
                                                 AND id != :resource.id
                                                 AND ((CPOC_Start_Date__c >=: resource.CPOC_Start_Date__c  AND CPOC_Start_Date__c <=:  resource.CPOC_End_Date__c)
                                                 OR (CPOC_End_Date__c >=: resource.CPOC_Start_Date__c  AND CPOC_End_Date__c <=: resource.CPOC_End_Date__c)
                                                 OR(CPOC_Start_Date__c <=: resource.CPOC_Start_Date__c  AND CPOC_End_Date__c >=: resource.CPOC_End_Date__c) )]; 
                 
                selResName = ((resSelect == null) ? '' : resSelect.Resource_Name__c);        
                sResStatus = ((lstResources.isEmpty()) ? 'Not Booked' : 'Booked');
            }
        }        
        catch(Exception e){            
            ApexPages.addMessages(e);           
        }    
    }
    /*@method: Generic save function*/
    public PageReference doSave(){
        
        if(String.isEmpty(selResource)){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING,'Invalid or no Resource selected'));
            return null;
        }                
        try{
            if(resource.Id == null){
                if(flsGet(CPOC_Shared_Resource__c.CPOC_All_Shared_Resource__c) || (flsUpdateGet(CPOC_Shared_Resource__c.CPOC_All_Shared_Resource__c))){
                resource.CPOC_All_Shared_Resource__c = selResource; 
                }
                insert resource;
            } 
            else{
                update resource;
            }
        } catch(Exception e){            
            ApexPages.addMessages(e);
            return null;
        }             
        
        //Briefing return
        return new PageReference('/'+resource.Customer_Engagements_Events__c);
    }

    /*@Constructor: Controller construction and initialization*/
    public CPOC_ResourceEditController(ApexPages.StandardController stdController){
        List<String> popFields = new List<String>{'Id', 'Name', 'Customer_Engagements_Events__c','CPOC_All_Shared_Resource__c'};
        List<String> locations = new List<String>();
                
        if(!Test.isRunningTest()){
            stdController.addFields(popFields);
        }
        this.resource = (CPOC_Shared_Resource__c)stdController.getRecord();
        this.pageDisplay = 'New CPOC Resource'; //default behavior
        this.pageUrl = ApexPages.currentPage().getUrl();
        this.isNew = true;
        
        //Populate briefing sites
        try{
            briefing = [select Id, CPOC_Location__c, CPOC_Start_Date__c, CPOC_End_Date__c,Requested_Customer_Arrival_Date__c, Requested_Customer_End_Date__c 
                        from CEE__c 
                        where Id =: resource.Customer_Engagements_Events__c]; 
        } catch(Exception e){
            System.debug(TAG + 'Error retrieving Briefing - ' + e.getStackTraceString());
        }
        
        //Populate default variables
        if(this.resource.Id == null){   
            if(flsGet(CPOC_Shared_Resource__c.CPOC_Start_Date__c)||(flsUpdateGet(CPOC_Shared_Resource__c.CPOC_Start_Date__c))) {        
                resource.CPOC_Start_Date__c = briefing.CPOC_Start_Date__c;
                }
            if(flsGet(CPOC_Shared_Resource__c.CPOC_End_date__c)||(flsUpdateGet(CPOC_Shared_Resource__c.CPOC_End_date__c))) {
            resource.CPOC_End_date__c = briefing.CPOC_End_Date__c;
            }
            
        }else {
            isNew = true;
            if(resource.Name != null){
                resourceName = resource.Name;
                pageDisplay = resource.Name;
            }
            selResource = resource.CPOC_All_Shared_Resource__c;
        } 
        
        //Get Personnels - Primary Site OR Briefing Sites
        if(briefing != null){
            locations.add(briefing.CPOC_Location__c);
        }        
        
        try{
            //Get briefing Rooms
            List<Id> oldcpocResources = new List<Id>();
            List<CPOC_Shared_Resource__c> cpocResources = [select Id, Name, CPOC_All_Shared_Resource__c from CPOC_Shared_Resource__c where Customer_Engagements_Events__c =: resource.Customer_Engagements_Events__c
                            and Id !=: resource.Id];
            for(CPOC_Shared_Resource__c cpocResource : cpocResources){
                oldcpocResources.add(cpocResource.CPOC_All_Shared_Resource__c);
            }
            
            //Filter sites by locations and not added already
            siteResources = [select Id, Name, CPOC_Location__c, CPOC_Location__r.Name,Resource_Name__c  from CPOC_All_Shared_Resources__c where CPOC_Location__c IN : locations
                        AND Id NOT IN : oldcpocResources];
        } catch (Exception e){
            System.debug(TAG + 'Error retrieving Resource Options - ' + e.getStackTraceString());
        }
    }
    
    
        /* **********************************************************
           Added By Naresh (nkalahas@cisco.com) on 31/01/2018  to redirect to previous page on cancel
       ************************************************************  */          

       public PageReference doCancel() {
        String url = ApexPages.currentPage().getHeaders().get('Referer');

        
        PageReference pageRef = new PageReference('/' + resource.Customer_Engagements_Events__c );
        pageRef.setRedirect(true);
        return pageRef; 


        }      
    
    /*@method: Getter for Select Room Picklist*/
    public List<SelectOption> getResourceOptions(){
        List<SelectOption> resourceOptions = new List<SelectOption>();
        
        for(CPOC_All_Shared_Resources__c siteResource : siteResources){
            resourceOptions.add(new SelectOption(siteResource.Id, siteResource.Resource_Name__c));
        }
        
        if(resourceOptions.isEmpty()){
            resourceOptions.add(new SelectOption('','No CPOC Resources found for CPOC Lab',true));
        } else {
            resourceOptions.add(new SelectOption('','--None--'));
        }
        
        resourceOptions.sort();
        return resourceOptions;
    }
    // SCAVA Helper Method to validate Update Access at field level
     public static Boolean flsUpdateGet(SObjectField field)
    {
        return field.getDescribe().isUpdateable() ? true : false;
    }
}