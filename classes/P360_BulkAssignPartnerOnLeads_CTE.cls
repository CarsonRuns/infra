/**
 * Controller Extension Class to bulk update of Channel Partners on Leads from 
 * Lead list views.
 * 
 * @author Neeta Kamadolli
 */
public class P360_BulkAssignPartnerOnLeads_CTE {
    public boolean leadNotSelected {get; set;}    
    public boolean ChannelPartnerNotSelected{get;set;}
    public Apexpages.StandardSetController controller;
    public String returnURL {get; set;}
    
     // SCAVA FIX , CONVERT BOOLEAN INTO STRING   
     public string leadNotSelected1{
     get{
         leadNotSelected1 = (leadNotSelected)?'true':'false';
         return leadNotSelected1 ;
     }
     private set;
     }
    
   /**
    * Constructor for extension class
    * 
    * @param c The StandardSetController to extend
    * 
    */
    public P360_BulkAssignPartnerOnLeads_CTE(Apexpages.StandardSetController c){
        this.controller = c;
        if(controller.getSelected().size() == 0 || controller.getSelected().size() > 25){
            leadNotSelected = true;
            returnURL = c.cancel().getUrl();
         } else {
            leadNotSelected = false;
         }       

    }
    

   /**
    * Attempts to update the channel partner field on the selected leads. The method
    * allows partial success and sets page messages to display success/failure information.  
    * 
    * @return a PageReference to set view after call completes
    */    
    public PageReference saveLeads() {
        
        //save results allowing partial success
        Database.SaveResult[] saveResults = Database.Update(controller.getSelected(), false);
        
        // get success and failure stats
        Integer failures = 0;
        Integer successes = 0;
        Set<String> errors = new Set<String>();
        for (Database.SaveResult saveResult : saveResults) {
            if (!saveResult.success) {
                failures++;
                for (Database.Error err : saveResult.getErrors()) {
                    errors.add(err.getMessage());
                }
            } else {
                successes++;
            }
        }
        
        // to show number of failed updates and error messages
        if (failures > 0) {
            String result = successes + ' record(s) updated successfully. <br/><br/>';
            
            result += '<font color="red">' + failures + ' record(s) failed to update due to below errors: <ul>';
            for(String msg: errors) {
               result += '<li>' + msg + '</li>';
            }
            result += '</font></ul>';
            
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.INFO, result);
            ApexPages.addMessage(errMsg);
            return null;
        } else {
        // Defect fix as part of this INC1385290
        if(UserInfo.getUiThemeDisplayed()=='Theme4d'||UserInfo.getUiThemeDisplayed()=='Theme4u')
        {
       
        Id filterId = Controller.getFilterId();
            //String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
            String fullUrl =  '/lightning/o/Lead/list?filterName=' + filterId;
            return new PageReference(fullUrl);                
        }
            return new PageReference(ApexPages.currentPage().getParameters().get('retURL'));
        }
    }    
   
    /**
    * NGCC Code Message
    *  
    * Checks Whether the logged user have access to this capability
    */
    
    public boolean getValidateUser(){
        try{
            UserRole usrRole = [Select name from UserRole where Id=: UserInfo.getUserRoleId()LIMIT 1];
                if(usrRole.Name.contains('NGCC'))
                {
                    return true;
                    
                }else{
                    return false;
                }
         }
         catch(Exception e){
           return false;
         }
    }
    
}