/*********************************************************************************************************************************
Name    : DSE_Main_CTE 
Author  : Mukesh Srivastava
Purpose : Controller Extension to provide required user related info to all DSE page specially for OS and TAC
Created Date:  1/18/2016 
Modification History: 
                      
**********************************************************************************************************************************/
public without sharing class DSE_Main_CTE {
    public String tzCode {get;set;}            // Getting the logged in user time zode
    public String localeformat {get;set;}      // Getting the logged in localebase date time format
    public String locale {get;set;}            // Getting the logged in locale
    public string OEId;    
    public String childAccountId;
    public Boolean bVisiblity {get;set;}
    public Account OEAccount{get;set;}
    public String mtoken{get;set;}
    
    //Controller
    public DSE_Main_CTE(ApexPages.StandardController controller) {
        OEId= ApexPages.currentPage().getParameters().get('Id'); // URL Parameter
        childAccountId = ApexPages.currentPage().getParameters().get('childAccId'); // URL Parameter
        bVisiblity = false; // flag to indicate whether user has access to record or not
        
        OEAccount(); // Getting other detail for Record
        
          // DSE Utilities Class initiation for get generic user related information
        DSE_Utilities util= new DSE_Utilities();
        tzCode  = util.getTimeZoneCode();     // User timezone
        localeformat = util.getlocaleformat();// User localedatetime format
        locale = util.getlocale();            // User locale code
        mtoken= util.getMuleToken();
               
    }
    
    //@Method: To validate if the logged in user has access to any of associate site account for OE account
    public pagereference getValidateUser(){
        try{
            Account acc = [SELECT Id, Name,ParentId, UserRecordAccess.HasReadAccess, UserRecordAccess.MaxAccessLevel 
                              FROM Account where Id =: childAccountId];
                             
                if(acc.ParentId == OEId && acc.UserRecordAccess.HasReadAccess){
                    bVisiblity = true;
                    OEAccount();
                    
                }
                return null;
         }
         catch(Exception e){
           return null;
         }
    }
    
    //@Method: To get the OE account detail as OE will be restricted to all user and we need to get at system context level
    public PageReference OEAccount() {
       OEAccount = new Account();
       string queryString = 'SELECT ';
                for (Schema.FieldSetMember f: SObjectType.Account.FieldSets.OE_Account_Fields.getFields()) {
                    queryString += f.getFieldPath() + ', ';
                }
               //queryString += 'Id FROM Account Where Id=\'' + OEId + '\'';
               //if(OEId != '')
               //SCAVA FIX
         if(OEId != null){  
            queryString += 'Id FROM Account Where Id=\'' + String.escapeSingleQuotes(OEId) + '\'';
            OEAccount = Database.Query(queryString);
            system.debug('OEAccount'+OEAccount);
          }
        return null;
    }
    

}