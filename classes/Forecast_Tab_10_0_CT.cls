public with sharing class Forecast_Tab_10_0_CT {
    @TestVisible
    private String fcstImage    = '/images/top_left_esales.gif';
    @TestVisible
    private String fcstRedirect = '/servlet/OpmgmtControllerNoAuth';
    
    public String FCST_BASE {get; protected set;}
    public String VPN {get; protected set;}
    public String appImgUrl {get; protected set;}
    public String ISDC_URL {get; protected set;}
    public String NGF_URL {get; protected set;}
    public PageReference link {get; protected set;}
    public Boolean permission_flag_hd_forecast_user {get; protected set;}
    public Boolean permission_flag_ngf_pilot_user {get; protected set;}
    public String base_url {get; protected set;}
    
    public Forecast_Tab_10_0_CT() {
        this.FCST_BASE = Utilities.getConstant_CS('FCST BASE');
        
        this.VPN       = Utilities.getConstant_CS('VPN') + '?nocache=' + Datetime.now().getTime();
        this.appImgUrl = this.FCST_BASE + fcstImage + '?nocache=' + Datetime.now().getTime();
        
        Url hostname = Url.getSalesforceBaseUrl();
        base_url = hostname.toExternalForm();
        
        //Identify if the user is from Security Group and redirect to HD Forecast instead of OMF
        this.ISDC_URL = Utilities.getConstant_CS('ISDC URL');
        permission_flag_hd_forecast_user = Utilities.checkAdditionalUserPermission('GSSO HD Forecast User'); 
        
        //Identify if the user is on NextGen Forecasting Pilot and redirect to HD Forecast instead of OMF
        this.NGF_URL = Utilities.getConstant_CS('NGF Pilot');
        permission_flag_ngf_pilot_user = Utilities.checkAdditionalUserPermission('NextGen Forecasting Pilot User'); 

     if (permission_flag_ngf_pilot_user == true){
             this.link = new PageReference(this.NGF_URL);
        }
        else if ( permission_flag_hd_forecast_user == true){         
            this.link = new PageReference(hostname.toExternalForm() + this.ISDC_URL);
        }
        else {
            String username = UserInfo.getUserName();
            username = username.split('@')[0];//get first part of username
            username = username.replace('qa_', '');
            
            Forecast_Tab_10_0_CS__c forecastCS1=Forecast_Tab_10_0_CS__c.getValues('SFDCValidateURL');
            String csEndpointURL=forecastCS1.EndpointURL__c;
            String csEndpointVersion=forecastCS1.EndpointVersion__c;
            this.link = new PageReference(this.FCST_BASE + this.fcstRedirect);
            Map<String, String> parameters = this.link.getParameters();
            parameters.put('SOURCE_APP', 'SFDC');
            parameters.put('nextPageCode', 'MYFCST');
            parameters.put('SFDCUserId', username);
            parameters.put('SFDCHost', hostname.getHost());
            //      parameters.put('SFDCValidateURL', hostname.toExternalForm() + '/services/Soap/c/31.0/' + UserInfo.getOrganizationId().substring(0,15));
            parameters.put('SFDCValidateURL', hostname.toExternalForm() + csEndpointURL + csEndpointVersion + UserInfo.getOrganizationId().substring(0,15));
        }
        
    }
    
}