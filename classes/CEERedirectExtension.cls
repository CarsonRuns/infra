/************************************************************************************************************************************
Name    : CEERedirectExtension
Author  : Mukesh Srivastava
Purpose : This Class Redirection during creation of new CEE record
Created Date: 4/12/2015
Modification History: 

*************************************************************************************************************************************/
public class CEERedirectExtension{
    private String acctURLlabel = Utilities.getConstant_CS('CEEAcctURLLabel');
    private String acctNamelabel = Utilities.getConstant_CS('CEEAcctNameLabel');
    public CEE__c ceeRec { get; set; }
    // Constructor
    public CEERedirectExtension(ApexPages.StandardController controller){  
         this.ceeRec = (CEE__c)controller.getRecord();   
    }
    
    //@ Method to redirect users to new RecordType Redirection page
    public PageReference redirectToPage() {
        String strURL = ApexPages.currentPage().getUrl();
        String strRetURL = ApexPages.currentPage().getParameters().get('retURL');
        System.debug('strURL'+strURL);
        //Komal - Lightning 08/10/2018 Release --Change to allow Lightning Desktop and Lightning Console themes
        if(UserInfo.getUiThemeDisplayed() == 'Theme4d' || UserInfo.getUiThemeDisplayed() == 'Theme4u'){
            string  strOpptyId = ApexPages.currentPage().getParameters().get('CF00N80000004zDjm_lkid');
            system.debug('strOpptyId====>'+strOpptyId);
            if(strOpptyId != '' &&  strOpptyId != null){
                if(strOpptyId.substring(0, 3) == '006'){
                    Opportunity opptyObj = [Select Id,AccountId,Account.Name,Opportunity_Status__c from Opportunity Where Id =: strOpptyId  Limit 1];
                    strURL = strURL+'&'+acctURLlabel+'='+opptyObj.AccountId+'&'+acctNamelabel+'='+opptyObj.Account.Name;
                }
            }
            strURL = strURL.replace('CEERecordTypeSelection','CEENewRecordTypeRedirect'); 
        }   
        else{
            if(strRetURL.substring(1, 4) == '006'){
                String strOpptyId = strRetURL.substring(1,16);
                Opportunity opptyObj = [Select Id,AccountId,Account.Name,Opportunity_Status__c from Opportunity Where Id =: strOpptyId  Limit 1];
                strURL = strURL+'&'+acctURLlabel+'='+opptyObj.AccountId+'&'+acctNamelabel+'='+opptyObj.Account.Name;
            }
            strURL = strURL.replace('CEERecordTypeSelection','CEENewRecordTypeRedirect'); 
        }   
        PageReference pg= new PageReference(strURL);        
        pg.getParameters().put('strURLRedirect', strURL);  
        pg.setRedirect(true);
        return pg;
    }
}