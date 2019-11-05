/*********************************************************************************************************************************
Name    : DSE_Token_Refresher 
Author  : Mukesh Srivastava
Purpose : Schedular class which will fire every 30 minutes to get the latest token from Ping for Mule Calls and put in Salesforce org platform cache
Created Date:  1/18/2016 
Modification History: 
                      
**********************************************************************************************************************************/
global class DSE_Token_Refresher implements Schedulable {
    global void execute(SchedulableContext SC) {
        tokenHttpcallout();        
    }

    public static void tokenHttpcallout(){
        
        DSE_Utilities.tokenHttpcallout();
        
    }
}