// ****************** Change History *******************
// kikamara - WR-01662 05/13/2016 - Replaced getOrgConstant object to getConstant_CS Custom setting
//    Removed the test method and moved to QuoteSummary_CTE_TEST
// ****************** Change History *******************

public class QuoteSummary_CTE {
    
    String Constant;
   
    public QuoteSummary_CTE(ApexPages.StandardController controller) {
    }
       
    public String getConstant() {    
        Org_Constant_CS__c oc = [SELECT Production_Value__c , Non_Production_Value__c FROM Org_Constant_CS__c WHERE Name = 'PDR URL'];
        return oc.Production_Value__c + ',' + oc.Non_Production_Value__c;
    } 
    
    public String getBaseUrl()
    {    
        return Utilities.getConstant_CS('PDR URL');
    }
    
    String QuoteStatus;
    String PdrDown;
    
    public String getPdrDown(){            
        
       return Utilities.getConstant_CS('PDR Down');
    } 
    public Boolean getprofilecheck(){
        String PdrSkipUser =Utilities.getConstant_CS('PDR_Skip_Users');
        List<String> skipuser = PdrSkipUser.split(',');
        set<string> PdrSkipUsers = new set<string>(skipuser); 
        Boolean profilecheck;
        if(pdrskipusers.contains(userinfo.getUserid().substring(0,15))){ 
            System.debug('INSIDE');
            profilecheck = false;
        }else{
            profilecheck = true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.Quoting_unavailable+' '+System.Label.Quoting_capabilities+' Please try later'));
        }
       return profilecheck; 
    }
    
    public String getQuoteStatus(){
     Id quoteSummaryId= ApexPages.currentPage().getParameters().get('id');
     Quote_Summary__c quoteId = [SELECT Quote_ID__c FROM Quote_Summary__c WHERE id= :quoteSummaryId];
         Quote__c q = [SELECT CCW_Deal_Status_MQ__c FROM Quote__c WHERE DM_Quote_ID__c= :quoteId.Quote_ID__c];
        return q.CCW_Deal_Status_MQ__c;
    }    
}