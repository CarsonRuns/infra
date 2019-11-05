public class RedirectExtension{

    public List<Opportunity> accountID {get;set;}
    private String overrideURL = ApexPages.currentPage().getUrl();
    private String opptyURLlabel = Utilities.getConstant_CS('CEEOpptyURLabel');
    private String opptyNamelabel = Utilities.getConstant_CS('CEEOpptyNamelabel');
    private String acctURLlabel = Utilities.getConstant_CS('CEEAcctURLLabel');
    private String acctNamelabel = Utilities.getConstant_CS('CEEAcctNameLabel');
    private String redirectID = Utilities.getConstant_CS('CEERedirectBack');
    private static final String TAG = 'RedirectExtension - ';

    public RedirectExtension(ApexPages.StandardController controller) { }

    public PageReference redirectToPage() {
        Account accObj;
        Opportunity oppObj ;
        List<Opportunity> oppObjList = new List<Opportunity>();
        string url = null;
        String recordId = null;
        String returnUrl = null;
        
        //Grab records
        String selectedRecordType = ApexPages.currentPage().getParameters().get('RecordType');
        System.debug(TAG + '*selectedRecordType *'+selectedRecordType );

        //Grab return URL for custom page reference
        returnUrl = ApexPages.currentPage().getParameters().get('retURL');
        System.debug(TAG + '**returnUrl**'+returnUrl);
        PageReference pageref1 ;
        
        //Run workflow for Jiffle record type
        if(selectedRecordType == System.Label.Jiffle_RecordType){
            if(returnUrl.startsWith(System.label.Account_Prefix)){
                String strId = System.Label.ACCOUNT_CESID + '_lkid' ;
                recordId = ApexPages.currentPage().getParameters().get(strId);
                pageref1 = new PageReference('/apex/SfdcToJiffle?id='+recordId);  
            
            } else if (returnUrl.startsWith(System.label.Opportunity_Prefix)){
                String strId = System.Label.OPPORTUNITY_CESID + '_lkid' ;
                recordId = ApexPages.currentPage().getParameters().get(strId);
                //pageref1 = new PageReference('/apex/SfdcToJiffle?id='+recordId); 
                System.debug(TAG + 'RecordId in Opportunity IF in RedirectExtension-->'+ recordId);

                try{
                    oppObjList = [SELECT Id, Opportunity_Status__c FROM Opportunity WHERE Id =: recordId LIMIT 1];
                    if(!oppObjList.isEmpty() && oppObjList != NULL) {
                        if(oppObjList[0].Opportunity_Status__c == 'Active') 
                            pageref1 = new PageReference('/apex/SfdcToJiffle?id='+recordId);
                        else {
                            ApexPages.Message msg = new Apexpages.Message(ApexPages.Severity.Info, System.Label.NonActiveOpportunityMessage);
                            ApexPages.addmessage(msg);                
                        }
                    }   
                } catch (Exception e){
                    System.debug(TAG + 'Error retrieving Opportunity list - ' + e.getStackTraceString());
                }         

            } else if (returnUrl.startsWith(system.label.CEE_Prefix) ){           
                System.debug(TAG + 'Inside Jiffle Record selection ');
                ApexPages.Message msg = new Apexpages.Message(ApexPages.Severity.Info,System.Label.JiffleMessage );
                ApexPages.addmessage(msg);
                
                //return null; 
                //pageref1 = new PageReference('/apex/SfdcToJiffle');  
            }

            //pageref1.setredirect(true);
            return pageref1;
        
        //Run workflow for everything but Jiffle record type
        } else {
            
            PageReference pageRef = null;   
            
            //DEBUG ONLY - uncomment for Jiffle record type as solo record type
            //ApexPages.Message msg = new Apexpages.Message(ApexPages.Severity.Info,System.Label.OtherRecordTypeMessage );
            //ApexPages.addmessage(msg);
            
            //String pageRef = '/a3D/o?RecordType='+ ApexPages.currentPage().getParameters().get('RecordType') + '&';
            pageRef = new pageReference ('/a3D/o?RecordType='+ ApexPages.currentPage().getParameters().get('RecordType') + '&');

            //new briefing request from oppty
            try{
                if(overrideURL.contains(opptyURLlabel)){        
                    accountID = [select accountid, account.name, id, name from opportunity where id =:ApexPages.currentPage().getParameters().get(opptyURLlabel)];            
                    pageRef =  new pagereference(redirectID + 'RecordType='+ ApexPages.currentPage().getParameters().get('RecordType') + '&' + acctNamelabel + '=' + EncodingUtil.urlEncode((accountID[0].account.name), 'UTF-8') + '&' + acctURLlabel + '=' + accountID[0].accountid + '&' + opptyNamelabel + '=' + EncodingUtil.urlEncode((accountID[0].name),'UTF-8') + '&' + opptyURLlabel + '=' + accountID[0].id + '&retURL=' + ApexPages.currentPage().getParameters().get('retURL') + '&nooverride=1');        
                }        
                //new briefing request from account
                else if(overrideURL.contains(acctURLlabel)){
                    pageRef = new pagereference(redirectID + 'RecordType='+ ApexPages.currentPage().getParameters().get('RecordType') + '&' + acctNamelabel + '=' + EncodingUtil.urlEncode(ApexPages.currentPage().getParameters().get(acctNamelabel), 'UTF-8') + '&' + acctURLlabel + '=' + ApexPages.currentPage().getParameters().get(acctURLlabel) + '&retURL=' + ApexPages.currentPage().getParameters().get('retURL') + '&nooverride=1');
                }        
                //new briefing request from CEE tab
                else {
                    pageRef = new pagereference(redirectID + 'RecordType='+ ApexPages.currentPage().getParameters().get('RecordType') + '&' + 'retURL=' + ApexPages.currentPage().getParameters().get('retURL') + '&nooverride=1');
                }   
            } catch (Exception e){
                System.debug(TAG + 'Error in CEE/OBX record type - ' + e.getStackTraceString());
            }    
            return pageRef;  
        }
        return null ;

    }

}