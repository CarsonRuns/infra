//kikamara- WR-01662 Replaced getOrgConstant object to getConstant_CS Custom setting

public class QuoteOverview {

    String opptyid = ApexPages.currentPage().getParameters().get('id');
    String opptyType = 'workbench';
    String sessid = UserInfo.getSessionId();
    String sid = sessid.substring(0,sessid.indexOf('!'));
    String hostname = Site.getCurrentSiteUrl(); 
    
    public QuoteOverview(ApexPages.StandardSetController controller) {
        pdrdown = Utilities.getConstant_CS('PDR Down'); // getting PDR DOWN value from custom setting           
        String profileName = [SELECT Name FROM Profile WHERE Id =: UserInfo.getProfileId()].Name;
        String PdrSkipUser =Utilities.getConstant_CS('PDR_Skip_Users');
        List<String> skipuser = PdrSkipUser.split(',');
        set<string> PdrSkipUsers = new set<string>(skipuser); 
       if(profileName.startsWith('QA') || pdrskipusers.contains(userinfo.getUserid().substring(0,15))){
           profilecheck = false;
       }
       else{
           profilecheck = true;
           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.Quoting_unavailable+' '+System.Label.Quoting_capabilities));
       }
           
        //Empty StandardSetController
    }
    public boolean profilecheck {get;set;}
    public string pdrdown {get;set;}  
    public QuoteOverview(ApexPages.StandardController controller) {
        //Empty Standard Controller           
    }

    Quote__c q {get;set;}
   
    public String getIsArchived(){
        List<Quote__c> quotes = [select id from quote__c where quote_flags__c = 'Archived' and opportunity_name__c = :opptyId limit 1];
        if(quotes.size()>0){
            return 'true';
        }
        return 'false';
    }   
    public String getOpptyID(){
            
        return opptyid;
    }
    //String  QuoteStatus;
    public String getQuoteStatus()
    {
        List<Quote__c> quoteList=[SELECT CCW_Deal_Status_MQ__c FROM Quote__c q where q.Opportunity_Name__c=:opptyid ];
        for(Quote__c quote:quoteList)
        {
            if(quote.CCW_Deal_Status_MQ__c=='DELETED') {
                return 'true';
            }
        }
        return 'false';
    }
        
    public PageReference getredir(){
        // Replaced getOrgConstant object to getConstant_CS Custom setting
        String baseUrl = Utilities.getConstant_CS('PDR URL'); 
        string dealtypeValue=''; //Q1FY16 SW project changes
        System.debug('baseurl:'+baseUrl);
        Opportunity oppty = [select DealID__c,Deal_Type__c from Opportunity where Id = :opptyid];
        //SW1003 changes Q1FY16 starts here
        if(oppty.Deal_Type__c ==null){
            dealtypeValue= '';
        }
        else{
            dealtypeValue=string.valueof(oppty.Deal_Type__c);
        }
        //SW1003 changes Q1FY16 ends here
        String userName = UserInfo.getUserName();
        User activeUser = [Select Email From User where Username = : userName limit 1];
        String userEmail = activeUser.Email;
       
        string sfdcmode = ApexPages.currentPage().getParameters().get('mode');
        //Added mode cls or lgt to send to CCW for navigation back and forth
        
        if (sfdcmode == null) 
        {
            if (UserInfo.getUiThemeDisplayed() == 'Theme3') {
                sfdcmode = 'cls'; 
            }
            else 
            {
                sfdcmode = 'lgt';
            }
        }
       
        Pagereference pageredir = new Pagereference(baseUrl + '/SFDCRequestHandler?at=' + opptyType + '&optyNumber='+oppty.DealID__c + '&userid=' + UserInfo.getUserId() + '&email='+userEmail+'&sessionid='+UserInfo.getSessionId()+'&url='+ 'https://'+ ApexPages.currentPage().getHeaders().get('Host') +'/services/Soap/c/11.0/'+ sid + '&hostname=' + 'https://'+ ApexPages.currentPage().getHeaders().get('Host') + '&cancel=' + opptyId+ '&dealType=' + dealtypeValue + '&mode=' + sfdcmode);
        pageredir.setredirect(true);
        return pageredir;
    }
}