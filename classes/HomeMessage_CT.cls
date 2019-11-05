public with sharing class HomeMessage_CT {
    @TestVisible
    private static String prodOrganizationId = '00D300000000QUu';
    
    public String organizationId  {get; protected set;}
    public boolean isProduction {get; protected set;}
    public String userName {get; protected set;}
    public String ciscoEndpoint {get; protected set;}
    
    public Boolean debug { get; set; }

    public HomeMessage_CT() {
        this.organizationId = UserInfo.getOrganizationId().substring(0,15);
        this.isProduction   = organizationId == HomeMessage_CT.prodOrganizationId;
        this.ciscoEndpoint  = Utilities.getConstant_CS('PMT Svc');

        this.username = UserInfo.getUserName();
        this.username = this.username.split('@')[0];//get first part of username
        if (!this.isProduction) {
            this.username += '_' + this.organizationId;
        }
        
        debug = Utilities.getConstant_CS('HomeMessage Debug') != 'NA' ? true : false;
		System.debug(' ### debug flag for home message :' +debug);
    }
}