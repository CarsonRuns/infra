public class OpportunityAssetViewController{
    public String currentRecordId {get;set;}
    public String parameterValue {get;set;}
    public Opportunity opp{get;set;}
    public OppResp resp{get;set;}
    public String viewAssetURL {get;set;}
    public string baseURL {get;set;}
    
    public OpportunityAssetViewController(ApexPages.StandardController controller) {
        
        currentRecordId  = ApexPages.CurrentPage().getparameters().get('id');
        
        //Get Opportunities source ref id and hq id
        opp = [select id, name, source_opp_id__c,Account.HQ_Party_ID__c from opportunity where id =: currentRecordId ];
        
        resp = new OppResp();
        baseURL = Utilities.getConstant_CS('OpptyAssetView');
        
        //Source ref id of oppty cannot be blank
        if(!String.isBlank(opp.source_opp_id__c)){
            
            //Remove all spaces
            resp.sourceref = opp.source_opp_id__c.replaceAll( '\\s+', '');
            
            //Get the BE Value from the source ref id
            String[] sourcerefParse = resp.sourceref.split('-');
            
            if(sourcerefParse.size()>2){
                if(sourcerefParse[1]=='AS' || sourcerefParse[1]=='TS' || sourcerefParse[1]=='SW'){
                  //   viewAssetURL = 'https://rewardstg.cloudapps.cisco.com/qualifications/app/#/sfdc/'+sourcerefParse[1]+'/All/Y/'+resp.sourceref;
                     viewAssetURL = baseURL+sourcerefParse[1]+'/All/Y/'+resp.sourceref;
                  //   System.debug('**viewAsetURL '+viewAssetURL);
                }
            }
        }
        System.debug('**resp**'+viewAssetURL);
    }
    
    public class OppResp{
        String sourceref;
        String hqid;
        public OppResp(){}    
    }
}