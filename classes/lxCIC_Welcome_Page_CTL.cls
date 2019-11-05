public class lxCIC_Welcome_Page_CTL {

    @AuraEnabled
    public static map<String,String> getLinkUrls(){
        Map<String,String> links = new Map<String,String>();
     
        links.put('CIC_NDA',Utilities.getConstant_CS('CIC_NDA'));
        links.put('CIC_CustomerTrust',Utilities.getConstant_CS('CIC_CustomerTrust'));
        links.put('CIC_GCOE',Utilities.getConstant_CS('CIC_GCOE'));
        links.put('CIC_GSSO',Utilities.getConstant_CS('CIC_GSSO'));
        links.put('CIC_ITCE',Utilities.getConstant_CS('CIC_ITCE'));
        links.put('CIC_Meraki',Utilities.getConstant_CS('CIC_Meraki'));
        links.put('CIC_GCRT',Utilities.getConstant_CS('CIC_GCRT'));
        
          return links;
      }
    
    @AuraEnabled
    public static oppWrapper getDetails(String oppID){
        system.debug('-------------------oppID-------------'+oppID);
        Opportunity opp = [SELECT Account.LineofBusiness__c, Account.Industry, Account.Geographic_Region__c,
                           Expected_Product__c, Expected_Service__c, DealID__c,StageName FROM Opportunity WHERE id=:oppID];
        User usr = [SELECT FirstName, LastName, Email FROM User WHERE id=:userinfo.getUserId()];
        
        oppWrapper oppWrap = new OppWrapper();
        oppWrap.opp = opp;
        oppWrap.usr = usr;
        System.debug('>>'+oppWrap);
        return oppWrap;
    }
       
    public class oppWrapper{
        @AuraEnabled public Opportunity opp;
        @AuraEnabled public User usr;
    }
}