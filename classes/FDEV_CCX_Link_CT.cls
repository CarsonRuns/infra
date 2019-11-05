public class FDEV_CCX_Link_CT{
    private final Account_Group__c acctGroup;
    public string baseUrl{get;set;}
    public string userName{get;set;}
    
    // The extension constructor initializes the private member
    // variable acct by using the getRecord method from the standard
    // controller.
    public FDEV_CCX_Link_CT(ApexPages.StandardController stdController) {
        this.acctGroup = (Account_Group__c)stdController.getRecord();
        baseUrl = Utilities.getConstant_CS('MSL MH link');
        userName = UserInfo.getName();
    }
}