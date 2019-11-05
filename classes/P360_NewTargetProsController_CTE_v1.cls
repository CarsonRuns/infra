public class P360_NewTargetProsController_CTE_v1{
    
    private final Assigned_Partner__c assignPartner;
    public static boolean isRejectedClosed = false;
    public static boolean isNoRejectedClosed = false;
    list<Assigned_Partner__c> assignPartnerList;
    String assignPartnerEditUrl;
    PageReference editPageRef;
    public String accountId; // = '0013000000DFbK0AAL';
    public boolean displayPopup {get; set;}
    public boolean isAccountIdNull {get; set;}
    //public final string customerAccountElementId = 'CF00N80000004wXYC';
    //SCAVA FIX
    public final string customerAccountElement_Id = 'CF00N80000004wXYC'; //CF00N80000004wXYC
    public final String tbmTamElementId = 'CF00N80000004wXYM';  //CF00N80000004wXYM             
    public final string PREFIX_TARGET_PROSPECT = 'a1i'; //a1i
    public String accountName1;
    
    PageReference editPageRef2;
    
    public P360_NewTargetProsController_CTE_v1() {
        
    }

    public P360_NewTargetProsController_CTE_v1(ApexPages.StandardController controller) {
        assignPartner = (Assigned_Partner__c)controller.getRecord();
        
        System.debug('assignPartner: '+assignPartner);
        System.debug('Customer_Account__c '+assignPartner.Customer_Account__c);
        
        accountId = assignPartner.Customer_Account__c;
        //accountName1=assignPartner.Customer_Account__r.name;
        system.debug('RecordID'+accountId);
    }
    
    public PageReference accountPageRedirect(){
        assignPartnerEditUrl =  URL.getSalesforceBaseUrl().toExternalForm()+'/'+'001/o';
        System.debug('assignPartnerEditUrl: '+assignPartnerEditUrl);
        editPageRef = new PageReference(assignPartnerEditUrl);
        isAccountIdNull = false;
        return editPageRef;
    }
    
    public PageReference pageRedirect(){
        assignPartnerEditUrl = URL.getSalesforceBaseUrl().toExternalForm()+'/'
                                +accountId; 
        editPageRef = new PageReference(assignPartnerEditUrl);
        displayPopup = false;
        return editPageRef;
    }
    
    public PageReference getCreateNewValidity(){
        try {
        // SCAVA FIX
            string customerAccountElementId  = string.escapeSingleQuotes(customerAccountElement_Id);
            System.debug('in the validity method');
                List<User> ulist=[Select Additional_User_Permissions__c from User where Id =: UserInfo.getUserId() Limit 1];    
                
                If(accountId != null){
                    If(ulist[0].Additional_User_Permissions__c !=null && ulist[0].Additional_User_Permissions__c.Contains(Label.P360_Enable_Target_Prospect_Creation)){
                        assignPartnerList = [Select Id, Partner_Status__c, Customer_Account__r.Name, 
                                                    tbm_tam__r.Name, tbm_tam__c, tbm_tam__r.Id 
                                                From Assigned_Partner__c Where Customer_Account__c =:accountId]; 
                        if(!assignPartnerList.IsEmpty())
                        {
                            String accountName = assignPartnerList[0].Customer_Account__r.Name;
                            accountName = EncodingUtil.urlEncode(accountName, 'UTF-8');
                            String tbmName = assignPartnerList[0].tbm_tam__r.Name;
                            String tbmTamId = assignPartnerList[0].tbm_tam__r.Id;

                            assignPartnerEditUrl = URL.getSalesforceBaseUrl().toExternalForm()+'/'
                                                + PREFIX_TARGET_PROSPECT + '/e?&nooverride=1&'+customerAccountElementId+'='
                                                +accountName+'&'+customerAccountElementId+'_lkid='+accountId + '&' 
                                                + tbmTamElementId + '=' + tbmName + '&'  + tbmTamElementId + '_lkid=' + tbmTamId  ;
                            system.debug('New URL '+  assignPartnerEditUrl);                  
                            if(assignPartnerEditUrl.startsWith('https')){
                               assignPartnerEditUrl = assignPartnerEditUrl.replaceFirst('https',''); 
                            }
                            editPageRef = new PageReference('https'+assignPartnerEditUrl);
                            return editPageRef;
                            
                        }
                         
                        else
                        {
                        
                        string accname = ApexPages.currentPage().getParameters().get(customerAccountElementId);
                        accname= EncodingUtil.urlEncode(accname, 'UTF-8');
                        
                            assignPartnerEditUrl=URL.getSalesforceBaseUrl().toExternalForm()+'/'
                                                + PREFIX_TARGET_PROSPECT + '/e?&nooverride=1&'+customerAccountElementId+'='
                                                + accname+'&'+customerAccountElementId+'_lkid='+accountId;
                            if(assignPartnerEditUrl.startsWith('https')){
                               assignPartnerEditUrl = assignPartnerEditUrl.replaceFirst('https',''); 
                            }
                            editPageRef = new PageReference('https'+assignPartnerEditUrl);
                            system.debug('New URL'+assignPartnerEditUrl);
                            return editPageRef;
                         }
               } 
               else
               {
                   displayPopup= true;
               } 
            }  
            else {               
                isAccountIdNull = true;              
            }
            
        } catch(Exception e) {
            System.debug('exception was here: '+e);
        }
        
        return null;
    }

}