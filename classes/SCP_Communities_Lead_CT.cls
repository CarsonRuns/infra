/********** Change History **********
 01 WR-01521 03/13/2016 - Added logic to check if user has accepted the TnC for LnP Access & LnP Dialog methods are added

********** Change History **********/
public with sharing class SCP_Communities_Lead_CT {
    public Lead lead;
    
    public Boolean isPA {
        get {
            return (prmFilterUtility.isPA);
        }
    }
    
    public SCP_Communities_Lead_CT(ApexPages.StandardController stdLeadCT) {
        this.lead = (Lead)stdLeadCT.getRecord();
    }
    
    public PageReference initiateDeal(){
        //System.Debug('*************************START SCP_Communities_Lead_CT.initiateDeal()************************************');
        //System.Debug('Estimated_Deal_Value_USD__c: ' + this.lead.Estimated_Deal_Value_USD__c);
        /*
        if( this.lead.Estimated_Deal_Value_USD__c == 0 ){
            ApexPages.Message warningMessage = new ApexPages.Message(ApexPages.Severity.ERROR, 'Error Summary', 'Error Detail');
            ApexPages.addMessage(warningMessage);
        }*/
        PageReference pg = new PageReference('/apex/SCP_Communities_leadInitDeal');
        pg.getParameters().put('Id',this.lead.Id);
        pg.setRedirect(true);
        pg.getParameters().put('retURL','/'+this.lead.Id+'/d');
        //System.Debug('**************************END SCP_Communities_Lead_CT.initiateDeal()************************************');
        return pg;
    }
    
    public PageReference redirect(){
        PageReference viewLeadPage = null;
        Profile p = [select name from Profile where id = 
                :UserInfo.getProfileId()];
        if (!'POC - Partner Community'.equals(p.name) && !'Partner360_Portal_Profile'.equals(p.name)){
            viewLeadPage =  New PageReference('/'+lead.Id + '/d?nooverride=1');
            viewLeadPage.setRedirect(true);
        }
        
        return viewLeadPage;
    }
    
    public PageReference addEditPSR() {
        String url = '/apex/SCP_Communities_psrFilterLookup';
        PageReference psrLookup = new PageReference(url);
        psrLookup.getParameters().put('Id',this.lead.Id);
        psrLookup.setRedirect(true);
        System.debug(System.LoggingLevel.INFO, '$$$$ psrLookup : '+psrLookup+' Page.SCP_Communities_psrFilterLookup : '+Page.SCP_Communities_psrFilterLookup);
        return psrLookup;    
    }
    
     //*********** WR-01521 - LnP Dialog Start*************
    public boolean getIsChekAccesLead(){
       //This method will check if the user has ever accepted the TnC or if accepted earlier, is it matching the current reset date and return the boolean parameter to page to display the popup or not.
       List<user> usList = [select id, LnP_TC_Accepted__c, LnP_T_C_Acepted_Date__c, LnP_TC_Reset_Date__c from User where id=:UserInfo.getUserId() limit 1];     
        LnP_Constants__c cs = LnP_Constants__c.getInstance();
        Date resetDate = cs.Reset_Date__c;
        if(resetDate != null){             
            if(!usList.isEmpty()){
                Date acceptedDate;
                if(usList[0].LnP_T_C_Acepted_Date__c != null){
                    acceptedDate = usList[0].LnP_T_C_Acepted_Date__c;
                }   
                Date custResetdDate; 
                if(usList[0].LnP_TC_Reset_Date__c != null){
                    custResetdDate = usList[0].LnP_TC_Reset_Date__c;
                }                
                if(usList[0].LnP_TC_Accepted__c){
                    if(( acceptedDate >= custResetdDate && acceptedDate >= resetDate)){
                        return true;
                    }else{
                        return false;
                    }
                }
            }
            return false;
        } else {
            return true;
        }
    } 
  
        @RemoteAction
        //This method is being executed by the Page when the user accepts the TnC popup
        public static boolean updateTC(){
         LnP_Constants__c cs = LnP_Constants__c.getInstance();
            List<user> usList = [select id, LnP_TC_Accepted__c, LnP_T_C_Acepted_Date__c, LnP_TC_Reset_Date__c from User where id=:UserInfo.getUserId()];
            if(!usList.isEmpty()){
                Date resetDate = cs.Reset_Date__c;
                usList[0].LnP_TC_Accepted__c = true;
                usList[0].LnP_T_C_Acepted_Date__c = system.today();
                if(usList[0].LnP_TC_Reset_Date__c == null || (usList[0].LnP_T_C_Acepted_Date__c >= resetDate && usList[0].LnP_TC_Reset_Date__c <= resetDate)){  
                    usList[0].LnP_TC_Reset_Date__c = resetDate;
                }   
                update usList;
                return true;    
            }
            return false;       
        } 
    //*********** WR-01521 - LnP Dialog End*************
}