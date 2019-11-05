/***************************************************************************************************
Name    : CPOC_PersonnelEditController 
Author  : Priyanka Jangid
Purpose : Visualforce Page Controller for custom CPOC Room page  
Created Date: Jan 25 2016            
Modified By :
        Sudi - Aug 17th 2016: Added this extra check during normalization fix.
                              To check the selPersonnel is empty or not to void code execution.  
*****************************************************************************************************/

public class CPOC_PersonnelEditController {

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

    //Record and controller variables
    private static String TAG = 'CPOC_PersonnelEditController';
    public CPOC_Personnel__c personnel;    
    
    
    //Related object list variables
    public CEE__c briefing { get; set; }       
    public List<Personnel__c> sitePersonnels;
    
    //Page display variables
    public String pageUrl { get; set; }
    public String pageDisplay { get; set; }
    public Boolean isNew { get; set; }
    public String personnelName { get; set; }
    
    //Room variables
    public String selPersonnel { get; set; }
    public string selPerName {get;set;}
    public string sPerStatus{get;set;}
    public list<CPOC_Personnel__c> lstPersonals{get;set;}    
    
     public void returnPersonalAvaibilityStatus(){ 
         try{
            // Sudi - Aug 17th 2016 : Added this condition in code as part normalization fix.
            // Checking for selPersonnel is empty or not.
            if(String.isEmpty(selPersonnel)){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING,'Invalid or no Personnel selected'));               
            }
            else{
                lstPersonals = new list<CPOC_Personnel__c>();
                Personnel__c perSelect = [select User__r.Name,User__c from Personnel__c where id=:selPersonnel limit 1];
                lstPersonals = [select Customer_Engagements_Events__r.Primary_Account__r.Name,CPOC_Start_Date__c,CPOC_End_date__c,Personnel__r.User__r.Name,Customer_Engagements_Events__r.Request_Status__c from CPOC_Personnel__c
                                                 where Customer_Engagements_Events__r.Request_Status__c in('Submitted','Scheduled','Lab Redirect') AND Personnel__r.User__c =:perSelect.User__c
                                                 AND id != :personnel.id
                                                 AND ((CPOC_Start_Date__c >=: personnel.CPOC_Start_Date__c  AND CPOC_Start_Date__c <=:  personnel.CPOC_End_date__c)
                                                 OR (CPOC_End_Date__c >=: personnel.CPOC_Start_Date__c  AND CPOC_End_Date__c <=: personnel.CPOC_End_date__c)
                                                 OR(CPOC_Start_Date__c <=: personnel.CPOC_Start_Date__c  AND CPOC_End_Date__c >=: personnel.CPOC_End_date__c) )]; 
                
                selPerName = ((perSelect == null) ? '' : perSelect.User__r.Name);
                sPerStatus = ((lstPersonals.isEmpty()) ? 'Not Booked' : 'Booked');
            }
        }
        catch(Exception e){            
            ApexPages.addMessages(e);           
        }    
    }
    /*@method: Generic save function*/
    public PageReference doSave(){
        
        if(String.isEmpty(selPersonnel)){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING,'Invalid or no Personnel selected'));
            return null;
        }                
        try{
            if(personnel.Id == null){
            
            if(flsUpdateGet(CPOC_Personnel__c.Personnel__c)||flsGet(CPOC_Personnel__c.Personnel__c)) //SCAVA FIX
            {
                personnel.Personnel__c = selPersonnel;
            }
                insert personnel;
            } 
            else{
                update personnel;
            }
        } catch(Exception e){            
            ApexPages.addMessages(e);
            return null;
        }             
        
        //Briefing return
        return new PageReference('/'+personnel.Customer_Engagements_Events__c);
    }

    /*@Constructor: Controller construction and initialization*/
    public CPOC_PersonnelEditController(ApexPages.StandardController stdController){
        List<String> popFields = new List<String>{'Id', 'Name', 'Customer_Engagements_Events__c','Personnel__c'};
        List<String> locations = new List<String>();
               
        if(!Test.isRunningTest()){
            stdController.addFields(popFields);
        }
        this.personnel = (CPOC_Personnel__c)stdController.getRecord();
        this.pageDisplay = 'New CPOC Personnel'; //default behavior
        this.pageUrl = ApexPages.currentPage().getUrl();
        this.isNew = true;
        
        //Populate briefing sites
        try{
            briefing = [select Id, CPOC_Location__c, CPOC_Start_Date__c, CPOC_End_Date__c,Requested_Customer_Arrival_Date__c, Requested_Customer_End_Date__c
                        from CEE__c 
                        where Id =: personnel.Customer_Engagements_Events__c];
        } catch(Exception e){
            System.debug(TAG + 'Error retrieving Briefing - ' + e.getStackTraceString());
        }
        
        //Populate default variables
        if(this.personnel.Id == null){ 
            if(flsUpdateGet(CPOC_Personnel__c.CPOC_Start_Date__c) || flsGet(CPOC_Personnel__c.CPOC_Start_Date__c))          //SCAVA FIX 
            {           
            personnel.CPOC_Start_Date__c = briefing.CPOC_Start_Date__c;
            }
            if(flsUpdateGet(CPOC_Personnel__c.CPOC_End_date__c) || flsGet(CPOC_Personnel__c.CPOC_End_date__c))              //SCAVA FIX
            {
            personnel.CPOC_End_date__c = briefing.CPOC_End_Date__c;
            }
            
        }else {
            isNew = true;
            if(personnel.Name != null){
                personnelName = personnel.Name;
                pageDisplay = personnel.Name;
            }
            selPersonnel = personnel.Personnel__c;
        } 
        
        //Get Personnels - Primary Site OR Briefing Sites
        if(briefing != null){
            locations.add(briefing.CPOC_Location__c);
        }
        System.debug(TAG + 'location - ' + locations);
        
        try{
            //Get briefing Rooms
            List<Id> oldcpocPersonnels = new List<Id>();
            List<CPOC_Personnel__c> cpocPersonnels = [select Id, Name, Personnel__c from CPOC_Personnel__c where Customer_Engagements_Events__c =: personnel.Customer_Engagements_Events__c
                            and Id !=: personnel.Id];
            for(CPOC_Personnel__c cpocPersonnel : cpocPersonnels){
                oldcpocPersonnels.add(cpocPersonnel.Personnel__c);
            }
            
            //Filter sites by locations and not added already
            sitePersonnels = [select Id, Name, CPOC_Location__c, CPOC_Location__r.Name,User__r.name, Is_Active__c  from Personnel__c where CPOC_Location__c IN : locations
                        AND Id NOT IN : oldcpocPersonnels AND Is_Active__c = TRUE ];
        } catch (Exception e){
            System.debug(TAG + 'Error retrieving Room Options - ' + e.getStackTraceString());
        }
    }
    
        /* **********************************************************
           Added By Naresh (nkalahas@cisco.com) on 31/01/2018  to redirect to previous page on cancel
       ************************************************************  */          

       public PageReference doCancel() {
        String url = ApexPages.currentPage().getHeaders().get('Referer');

        
        PageReference pageRef = new PageReference('/' + personnel.Customer_Engagements_Events__c );
        pageRef.setRedirect(true);
        return pageRef; 


        }  
    
    /*@method: Getter for Select Room Picklist*/
    public List<SelectOption> getPersonnelOptions(){
        List<SelectOption> personnelOptions = new List<SelectOption>();
        
        for(Personnel__c sitePersonnel : sitePersonnels){
            personnelOptions.add(new SelectOption(sitePersonnel.Id, sitePersonnel.User__r.name));
        }
        
        if(personnelOptions.isEmpty()){
           personnelOptions.add(new SelectOption('','No CPOC Personnel found for CPOC Lab',true));
        } else {
            personnelOptions.add(new SelectOption('','--None--'));
        }
        
        personnelOptions.sort();
        return personnelOptions;
    }
}