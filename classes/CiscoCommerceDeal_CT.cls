public with sharing class CiscoCommerceDeal_CT {
    public PageReference link {get; protected set;}
    public Boolean addSessionId {get; protected set;}
    public String manageDeal {get;set;} //Added part of GDR
    public String biddingDeal {get;set;}//Added part of GDR
    public CiscoCommerceDeal_CT(ApexPages.StandardSetController controller) {

    }
    public void init() {
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
            
        String pdrDown     = Utilities.getConstant_CS('PDR Down');
        String profileName = [SELECT Name FROM Profile WHERE Id =: UserInfo.getProfileId()].Name;
        addSessionId = false;
        if (pdrDown == 'Yes' && !profileName.startsWith('QA')) {
            link = Page.pdrDown;
            link.getParameters().put('isdtp', 'mn');
        } else {
            String baseUrl      = Utilities.getConstant_CS('PDR URL');
            String hostname = Url.getSalesforceBaseUrl().toExternalForm();
            String teamApproval = ApexPages.currentPage().getParameters().get('teamApproval');
            String dealIdFromEmail = ApexPages.currentPage().getParameters().get('dealIdFromEmail');
            string oppId =  ApexPages.currentPage().getParameters().get('id');
            string dealId = ApexPages.currentPage().getParameters().get('dealId');
            //GDR changes starts here
            string managedeals=ApexPages.currentPage().getParameters().get('manageDeal');
            string biddingdeals=ApexPages.currentPage().getParameters().get('biddingDeal');
            string opptyName=ApexPages.currentPage().getParameters().get('opptyName');
            if(managedeals == 'true')
            {
                manageDeal='true';
            }
            if(biddingdeals == 'true')
            {
               biddingDeal='true';
            }           
            
            if (dealIdFromEmail == null) {
                dealIdFromEmail = '';
            }
            //GDR changes ends here

            link = new PageReference(baseUrl + '/SFDCRequestHandler');
            Map<String, String> urlParemeters = link.getParameters();
            urlParemeters.put('at', 'partnerFunnel');
            urlParemeters.put('userid', UserInfo.getUserId());
            urlParemeters.put('email', UserInfo.getUserEmail());
            urlParemeters.put('url', hostname + '/services/Soap/c/11.0/' + UserInfo.getOrganizationId().substring(0,15));
            urlParemeters.put('hostname', hostname);
            urlParemeters.put('dealIdFromEmail', dealIdFromEmail);
            urlParemeters.put('mode', sfdcmode); //Added to send mode to the CCW team for navigation
            
            if (String.isNotBlank(teamApproval)) {
                urlParemeters.put('filterName', 'teamBasedApproval');
            }
            //GDR Changes starts here
            if(manageDeal == 'true'){
                urlParemeters.put('oppId',oppId);
                urlParemeters.put('dealId',dealId);
                urlParemeters.put('manageDeal',manageDeal);  
                urlParemeters.put('opptyName',opptyName);             
            } 
            if(biddingDeal == 'true'){
                urlParemeters.put('oppId',oppId);
                urlParemeters.put('dealId',dealId);
                urlParemeters.put('biddingDeal',biddingDeal); 
                urlParemeters.put('opptyName',opptyName);                
            } //GDR changes ends here          
                addSessionId = true;
        }
    }
}