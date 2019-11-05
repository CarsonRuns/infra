public class OpptyAssetViewController {

    @AuraEnabled
    public static String assetViewController (String recId) {
        String parameterValue ;
        Opportunity opp;
        String sourceref;
        String viewAssetURL ;
        string baseURL ;
        
        opp = [select id, name, source_opp_id__c, Renewal_Offer_Type__c, Account.HQ_Party_ID__c from opportunity where id =: recId ];
        
        baseURL = Utilities.getConstant_CS('OpptyAssetView');
        
        //Source ref id of oppty cannot be blank
        if(!String.isBlank(opp.source_opp_id__c)){
            
            //Remove all spaces
            sourceref = opp.source_opp_id__c.replaceAll( '\\s+', '');
            
            //Get the BE Value from the source ref id
            String[] sourcerefParse = sourceref.split('-');
            Id acc18dig = opp.account.id;
            
            /*
            if(sourcerefParse.size()>2){
                if(sourcerefParse[1]=='AS' || sourcerefParse[1]=='TS' || sourcerefParse[1]=='SW'){
                    viewAssetURL = baseURL+sourcerefParse[1]+'/All/Y/'+sourceref;
                    if(Renewals_Portfolio__c.getInstance().Asset_URL_Append_Account__c){
                        viewAssetURL = viewAssetURL+'/'+acc18dig;
                    }
                    System.debug('**viewAsetURL '+viewAssetURL);
                }
            }
            */
            viewAssetURL = baseURL+opp.Renewal_Offer_Type__c+'/All/N/'+sourceref;
            if(Renewals_Portfolio__c.getInstance().Asset_URL_Append_Account__c){
                viewAssetURL = viewAssetURL+'/'+acc18dig;
            }
            System.debug('**viewAsetURL '+viewAssetURL);
            
        }
        return viewAssetURL;
    }
}