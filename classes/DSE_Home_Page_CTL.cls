/*********************************************************************************************************************************
Name    : DSE_Home_Page_CTL 
Author  : Mukesh Srivastava
Purpose : Controller to get all the OEId releated account updated in last 2 days with DSE time stamp.
Created Date:  1/18/2016 
Modification History: 
   #Release                     Cec       Date         Change
   1.Tac_Visibility_Release  katandon (6/17/2016) - Added 'tachomevisibility'
                      
**********************************************************************************************************************************/
public with sharing class DSE_Home_Page_CTL {
    public String tzCode {get;set;}            // Getting the logged in user time zode
    public String localeformat {get;set;}      // Getting the logged in localebase date time format
    public String locale {get;set;}
    public String mtoken {get;set;}
    public Boolean tachomevisibility {get;set;}
       
    public Set<String> getSetOEIDs(){
        Set<String> oeIDs = new Set<String>();
            for(Account lstAcc: [SELECT OE_Id__c from Account Where LastModifiedDate = LAST_N_DAYS: 3 AND OE_Id__c like '_____%' AND DSE_Time_Stamp__c = LAST_N_DAYS:2 ORDER BY LastModifiedDate desc]){
                oeIDs.add(lstAcc.OE_Id__c);
            }         
         return oeIDs;                         // Return Set of OEIDs updated in Last two days
    }

    
    public void init(){
        DSE_Utilities util= new DSE_Utilities();
        localeformat = util.getlocaleformat();
        tzCode = util.getTimeZoneCode(); 
        locale = util.getlocale();
        mtoken = util.getMuleToken();
        tachomevisibility = util.getTacHomeVisibility();
    }

}