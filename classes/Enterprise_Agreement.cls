public with sharing class Enterprise_Agreement {
    @TestVisible
    private String entRedirect = '/app/#/?flow=nextgen';
    
    @TestVisible
    private String entBaseUrl {get; set;}
    
    @TestVisible
    public String entCompleteUrl {get; protected set;}
    
    public PageReference link {get; protected set;}
    
    public String VPN {get; protected set;}
    
    public Enterprise_Agreement() {
        this.entBaseUrl = Utilities.getConstant_CS('ENT BASE');
        this.VPN = Utilities.getConstant_CS('VPN') + '?nocache=' + Datetime.now().getTime();
        this.entCompleteUrl = this.entBaseUrl + this.entRedirect;
        this.link = new PageReference(this.entCompleteUrl);
    }
    
}