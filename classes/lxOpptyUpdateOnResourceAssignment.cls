/**************************************
Author          : R.Hari Krishna(ratharik) 
Release         : May Release
Created         : April 09,2019
Functionality   : Class to update Opportunity Status to No SE Assigned from SE Work in Progress and Viceversa

Modification History:
Itrack#        Date        		Author              		Change  
****************************************************************************
US290188    April 09,2019      Hari Krishna(ratharik)    Initial Draft
US304314	June 19,2019	   Manikant Kella(mkella)	 SE Opty List View with BE info and SE IDs
**********************************************/
public class lxOpptyUpdateOnResourceAssignment {
    /*
* Created By: R. Hari Krishna(ratharik)
* Description : change SE Status(US290188)     
*/    
    public static void opportunityStatusUpdate(Set<id> opptyIdsToUpdate) {
        List<Opportunity> updateOppsList = new List<Opportunity>();
        
        if(checkUserPermission()) {    
            List<Opportunity> opptyList = [SELECT Id,SE_Status__c, (SELECT Id,Resource_Status__c FROM Requests_and_Assignments__r
                                                                    WHERE Resource_Status__c = 'Assigned' OR Resource_Status__c = 'Direct Assignment') 
                                           FROM Opportunity
                                           WHERE ID IN : opptyIdsToUpdate];
            
            for(Opportunity opp : opptyList) {
                if(!opp.Requests_and_Assignments__r.isEmpty() && opp.Requests_and_Assignments__r.size() == 1) {
                    if(opp.SE_Status__c == 'No SE Assigned' && getFLSUpdate(Opportunity.SE_Status__c)) {
                        opp.SE_Status__c = 'SE Work in Progress';                     
                        updateOppsList.add(opp);   
                    }                    
                } else if(opp.Requests_and_Assignments__r.isEmpty() && opp.Requests_and_Assignments__r.size() == 0) {
                    opp.SE_Status__c = 'No SE Assigned';                     
                    updateOppsList.add(opp);
                } 
            }
            
            Utilities.setSkip(true);   
            Utilities.setValidationSkip(true);
            //commented by Kavya as Add_Resource_As_OptyTeam trigger was not executing because skipfuture set to true
            //Utilities.setSkipFuture(true);
            try{
            if(!updateOppsList.isEmpty()) {
                update updateOppsList;
            }
            }
            catch(Exception e)
            {
                System.debug('Exception e'+e.getMessage());
            }
        }
    }
    
    //mkella- US304314 Start changes
    //this method is to update oppty SE IDs field with SE IDs from RAE whose status is Assigned and Direct Assignment 
    //after every insert, update, delete operation on RAE records
    public static void opportunitySEIDsUpdate(Set<id> opptyIdsToUpdate) {
        // initiate to update DML operation list
        List<Opportunity> updateSeIdsOppLst = new List<Opportunity>();
        try{
        // check if user has SE permission where records are edited
        //if(checkUserPermission()) {
            // get list SOQL results from RAE trigger
            List<Opportunity> optysLst = [SELECT Id,SE_Status__c, SE_IDs__c, (SELECT Id,Resource_Name__r.Name,Resource_Name__r.UserName,
                                                                              Resource_Status__c FROM Requests_and_Assignments__r) 
                                           FROM Opportunity
                                           WHERE ID IN : opptyIdsToUpdate];
            
            
            for(Opportunity opp : optysLst) {
                if(!opp.Requests_and_Assignments__r.isEmpty()){
                    //assign child RAE records to new variable
                    List <Resource_Request_Assignment__c> raeList = opp.Requests_and_Assignments__r;
                    String seIDsStr;
                    //iterate over RAE list and check if resource status is Assigned or Direct Assigned
                    for (Resource_Request_Assignment__c rae: raeList){
                        if(rae.Resource_Status__c == 'Assigned' || rae.Resource_Status__c == 'Direct Assignment'){
                            // add all resource CEC ids to string
                            String resourceName = rae.Resource_Name__r.UserName.SubStringBefore('@');
                            seIDsStr += resourceName + '; ';
                        }
                    }
                    
                    if(!String.isBlank(seIDsStr)){
                        // remove null string in the start of the sentence which is getting added above
                        seIDsStr = seIDsStr.remove('null');
                        //trim left and right spaces if any
                        seIDsStr = seIDsStr.trim();
                    	//assign string value to oppty SE IDs field
                    	opp.SE_IDs__c = seIDsStr;
                    }
                    else if(String.isBlank(seIDsStr)){
                        // if string result is blank, assign blank value
                        opp.SE_IDs__c = '';
                    }
                    //add it to list to make update DML operation on oppty
                    updateSeIdsOppLst.add(opp);
                }
                // if Requests_and_Assignments__r refers to empty either existing RAE is deleted
                else if(opp.Requests_and_Assignments__r.isEmpty()){
                    opp.SE_IDs__c = '';
                    updateSeIdsOppLst.add(opp);
                }
            }
            // skip all validation rules    
            Utilities.setSkip(true);   
            Utilities.setValidationSkip(true);
             //commented by Kavya as Add_Resource_As_OptyTeam trigger was not executing because skipfuture set to true
			//Utilities.setSkipFuture(true);
            // update DML operation
            if(!updateSeIdsOppLst.isEmpty()) {
                update updateSeIdsOppLst;
            }
        //}
        }catch(Exception e){
            System.debug('Exception in updating SE Opty IDs: '+e.getMessage());
            /*String errorMessage;
            errorMessage = e.getMessage();
            return errorMessage;*/
        }
    }
    //mkella- US304314 End changes
    
    /*
* Created By: R. Hari Krishna(ratharik)
* Description : check User permission
*/
    //Check if the logged in user has the PSS/VSS/SE additional permissions    
    private static Boolean checkUserPermission(){
        User usr = [select id, Additional_User_Permissions__c,ProfileId from user where id=:UserInfo.getUserId() limit 1];        
        if(String.isNotBlank(usr.Additional_User_Permissions__c)) {
            //AM logged in
            if(!(usr.Additional_User_Permissions__c.contains('Enable_ePSS') 
                 || usr.Additional_User_Permissions__c.contains('Enable_VSS') || usr.Additional_User_Permissions__c.contains('SE User'))) {
                     return false;
                 }// SE User logged in
            if(usr.Additional_User_Permissions__c.contains('SE User')) {
                return true;
            }
        }
        return false;
    }
    
    public static Boolean getFLSUpdate(SObjectField field) {
        return field.getDescribe().isUpdateable() ? true : false;
    }
}