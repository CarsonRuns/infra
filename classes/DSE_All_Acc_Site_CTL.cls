/*********************************************************************************************************************************
Name    : DSE_All_Acc_Site_CTL
Author  : Mukesh Srivastava
Purpose : Rest Controller to get all accounts which are associated to OEID
Created Date:  1/18/2016 
Modification History: 
                      
**********************************************************************************************************************************/
@RestResource(urlMapping = '/dse/allaccounts')
global without sharing class DSE_All_Acc_Site_CTL{
    @HttpPost
    global static DSE_RestAPIResponseHandler getAllOERelatedAccounts(DSE_Utilities.DSE_Request req) {
        DSE_Utilities dse_accounts = new DSE_Utilities();
               
        return dse_accounts.getAccountsDetail(req);
    }
}