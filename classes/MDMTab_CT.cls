// ****************** Change History *******************
//kikamara- WR-01662 Replaced getOrgConstant object to getConstant_CS Custom setting
// ****************** Change History *******************

global without sharing class MDMTab_CT {

    @TestVisible
    public String mdmImgUrl { get; protected set; }

    @TestVisible
    public PageReference urlToOpen { get; protected set;}

    private String baseURL { get; set;}

    private String imageUrlExt = '/images/ezdeal_banner.jpg';

    public String endPointUrl { get; protected set;}
    
    public MDMTab_CT() {

        String opptyId = ApexPages.currentPage().getParameters().get('opptyId');
        Opportunity op;
        String dealId;
        if(opptyId != null) {
            op = [Select Id, DealID__c From Opportunity Where Id = :opptyId];
            dealId  = (op != null && op.DealID__c != null) ? op.DealID__c : '';
        }

        // MDM Image URL
        String redirectUrl = Utilities.getConstant_CS('MDM Redirect');
        System.debug(System.LoggingLevel.INFO, '## MDM Redirect URL : '+redirectUrl);

        String sessionId = UserInfo.getSessionId();

        Url hostname = Url.getSalesforceBaseUrl();
        this.endPointUrl = hostname.toExternalForm() + '/services/Soap/c/9.0/' + UserInfo.getOrganizationId().substring(0,15);
        System.debug(System.LoggingLevel.INFO,'## endPointUrl : '+endPointUrl);

        String userName = UserInfo.getUserName();
        System.debug(System.LoggingLevel.INFO,'## Complete userName : '+userName);
        userName = userName.split('@')[0];// get first part of userName
        System.debug(System.LoggingLevel.INFO,'## userName[0] : '+userName);
        userName = userName.replace('qa_','');
        System.debug(System.LoggingLevel.INFO,'## userName replace qa_ : '+userName);

        // Remove  trailing '&' from redirectUrl
        redirectUrl = redirectUrl.replace('&','');
        System.debug(System.LoggingLevel.INFO, '## MDM Redirect URL without \'&\' : '+redirectUrl);
        
        String [] urlPieces = redirectUrl.split('/');
        System.debug(System.LoggingLevel.INFO, '## urlPieces : '+urlPieces);

        // Form baseUrl from urlPieces
        baseURL = urlPieces[0]+'//'+urlPieces[2]+'/'+urlPieces[3];
        System.debug(System.LoggingLevel.INFO, '## baseURL : '+baseURL);        

        mdmImgUrl = baseURL + imageUrlExt + '?nocache=' + Datetime.now().getTime();
        System.debug(System.LoggingLevel.INFO, '## mdmImgUrl : '+mdmImgUrl);

        // Remove existing parameters
        redirectUrl = redirectUrl.split('\\?')[0];
        System.debug(System.LoggingLevel.INFO, '## redirectUrl after removing parameters : '+redirectUrl);

        this.urlToOpen = new PageReference(redirectUrl);
        Map<String,String> parameters = this.urlToOpen.getParameters();
        parameters.put('application','SFDC');
        parameters.put('uid', userName);
        //parameters.put('sessionId',sessionId);
        parameters.put('url',endPointUrl);
        parameters.put('opty_number',dealId);

        System.debug(System.LoggingLevel.INFO,'## final urlToOpen : '+urlToOpen);
    }
    
}