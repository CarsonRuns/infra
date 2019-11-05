// ****************** Change History *******************
//kikamara- WR-01662 Replaced getOrgConstant object to getConstant_CS Custom setting
// ****************** Change History *******************

public class EstimatesTabOverride_CTE {

    public EstimatesTabOverride_CTE(ApexPages.StandardController controller) {

    }

    public EstimatesTabOverride_CTE(ApexPages.StandardSetController controller) {

    }
    public EstimatesTabOverride_CTE(){
    }
           
    public PageReference pdrRedirectURL() {
    try{
        String finalval='';
        String orgid = UserInfo.getOrganizationId(); 
        String hostname = Site.getCurrentSiteUrl(); 
        String sessid = UserInfo.getSessionId();
        String sid = sessid.substring(0,sessid.indexOf('!')); 
        finalval =Utilities.getConstant_CS('Estimates Tab PDR URL');
        System.debug('finalURL: '+finalval);
        
        String userId = UserInfo.getUserId();
        String userName = UserInfo.getUserName();
        User activeUser = [Select Email From User where Username = : userName limit 1];
        String userEmail = activeUser.Email;
        
        String fullUrl = finalval +'SFDCRequestHandler?at=estimateFunnel'+'&userid=' + UserId + '&email='+userEmail+'&sessionid='+sessid+'&url='+ 'https://'+ ApexPages.currentPage().getHeaders().get('Host') +'/services/Soap/c/11.0/'+ sid + '&hostname='+'https://'+ApexPages.currentPage().getHeaders().get('Host')+'&userid='+UserInfo.getUserId()+'&hostname=' + hostname+ '&email='+userEmail+'&sessionid='+UserInfo.getSessionId();
        PageReference fullRUrl = new PageReference(fullUrl);
        System.debug('fullRUrl: '+fullRUrl);
        return fullRUrl;
    }
    catch(exception e){
    throw e;
    }
    }
    
    /*Test Method Begin*/
    private static testMethod void test_EstimatesTabOverride_CTE()
    {    
       Account account = new Account();  
        List<Contact> conList = new List<Contact>();
        conList = [select Id from Contact limit 1];
        test.startTest(); 
        PageReference pageRef = new EstimatesTabOverride_CTE().pdrRedirectURL();
        new EstimatesTabOverride_CTE(new ApexPages.StandardController(account ));
        new EstimatesTabOverride_CTE(new ApexPages.StandardSetController(conList));
        test.stopTest();   
    } 
    /*Test Method End*/
}