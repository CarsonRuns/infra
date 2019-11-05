public class P360_NewTargetProsController {
    
    private final Assigned_Partner__c assignPartner;
    public static boolean isRejectedClosed = false;
    public static boolean isNoRejectedClosed = false;
    list<Assigned_Partner__c> assignPartnerList;
    String assignPartnerEditUrl;
    PageReference editPageRef;
    public String accountId; // = '0013000000DFbK0AAL';
    public boolean displayPopup {get; set;}
    public boolean isAccountIdNull {get; set;}
    public final string customerAccountElementId = 'CF00N80000004wXYC'; //CF00N80000004wXYC
    public final String tbmTamElementId = 'CF00N80000004wXYM';  //CF00N80000004wXYM             
    public final string PREFIX_TARGET_PROSPECT = 'a1i'; //a1i
    
    PageReference editPageRef2;
    
    public P360_NewTargetProsController() {
        
    }

    public P360_NewTargetProsController(ApexPages.StandardController controller) {
        assignPartner = (Assigned_Partner__c)controller.getRecord();
        
        System.debug('assignPartner: '+assignPartner);
        System.debug('Customer_Account__c '+assignPartner.Customer_Account__c);
        
        accountId = assignPartner.Customer_Account__c;
    }
    
    public PageReference pageRedirect(){
        assignPartnerEditUrl = URL.getSalesforceBaseUrl().toExternalForm()+'/'
                                +accountId; 
        editPageRef = new PageReference(assignPartnerEditUrl);
        displayPopup = false;
        return editPageRef;
    }
    
    public PageReference accountPageRedirect(){
        assignPartnerEditUrl =  URL.getSalesforceBaseUrl().toExternalForm()+'/'+'001/o';
        System.debug('assignPartnerEditUrl: '+assignPartnerEditUrl);
        editPageRef = new PageReference(assignPartnerEditUrl);
        isAccountIdNull = false;
        return editPageRef;
    }
    
    public PageReference getCreateNewValidity(){
        try {
            System.debug('in the validity method');
                    
            If(accountId != null){
                assignPartnerList = [Select Id, Partner_Status__c, Customer_Account__r.Name, 
                                            tbm_tam__r.Name, tbm_tam__c, tbm_tam__r.Id 
                                        From Assigned_Partner__c Where Customer_Account__c =:accountId]; 
            } else {
                isAccountIdNull = true;
            }
            
            if(!assignPartnerList.isEmpty()){
                for(Assigned_Partner__c apObj: assignPartnerList){
                    if(apObj.Partner_Status__c == 'Rejected' || apObj.Partner_Status__c == 'Closed'){
                        isRejectedClosed = true;
                    } else {
                        isNoRejectedClosed = true;
                    }
                }
            } else {
                isNoRejectedClosed = true;
            }
            
            if(isNoRejectedClosed){     
                assignPartnerEditUrl = URL.getSalesforceBaseUrl().toExternalForm()+'/'
                                        +accountId; 
                editPageRef = new PageReference(assignPartnerEditUrl);
                displayPopup = true;
            } else if (isRejectedClosed){
                String accountName = assignPartnerList[0].Customer_Account__r.Name;
                String tbmName = assignPartnerList[0].tbm_tam__r.Name;
                String tbmTamId = assignPartnerList[0].tbm_tam__r.Id;
                
                assignPartnerEditUrl = URL.getSalesforceBaseUrl().toExternalForm()+'/'
                                        + PREFIX_TARGET_PROSPECT + '/e?&nooverride=1&'+customerAccountElementId+'='
                                        +accountName+'&'+customerAccountElementId+'_lkid='+accountId + '&' 
                                        + tbmTamElementId + '=' + tbmName + '&'  + tbmTamElementId + '_lkid=' + tbmTamId  ;
                                        
                editPageRef = new PageReference(assignPartnerEditUrl);
                return editPageRef;
            }
        } catch(Exception e) {
            System.debug('exception was here: '+e);
        }
        
        return null;
    }

}