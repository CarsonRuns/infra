@isTest(seealldata=true)
public class LE_Test_cls{
    static testMethod void test_unit(){
        DATE vCloseDate=system.today();
        try{
        Opportunity o = new Opportunity(name='abc',StageName='2 - Qualification',CloseDate= vCloseDate.adddays(2));
        insert o;
        Apexpages.currentPage().getParameters().put('id',o.id);
        ApexPages.StandardController controller = new ApexPages.StandardController(o);
        Engage_Resource er = new Engage_Resource(controller);  
        er.redirct();
        }catch(Exception e){
            system.debug('Exception ::'+e.getMessage());
        }      
    }
    static testMethod void initTests(){
        test.startTest();
        DATE vCloseDate=system.today();
        List<Opportunity> lstOpty = new List<Opportunity>();
        Opportunity o = new Opportunity(name='abc',StageName='2 - Qualification',CloseDate= vCloseDate.adddays(2));
        insert o;
        lstOpty.add(o);
        ApexPages.StandardSetController controller = new ApexPages.StandardSetController(lstOpty);
        CiscoCommerceDeal_CT pCt = new CiscoCommerceDeal_CT(controller );
        pCt.manageDeal = 'true';
        pCt.init();         
        test.stopTest();
    } 
    static testMethod void testGet5() {
         Account act = new Account(name='TestVC');
        insert act;
        
        User currentUser = [select defaultCurrencyIsoCode from User where Id = :UserInfo.getUserId()];
    
        //Query for Pricebook2
        String defaultPricebookId;
        Pricebook2[] pricebook2 = [select id from Pricebook2 where name = 'Standard Price Book'];
        
            
        PricebookEntry[] priceEntry = [Select Id from PricebookEntry where pricebook2Id =: pricebook2[0].Id and IsActive = true and CurrencyIsoCode =: currentUser.defaultCurrencyIsoCode limit 10] ;
        
        Date vCloseDate = System.today() + 15 ;
        Opportunity oppty1 = new Opportunity(name='Test1',StageName='1 - Identify',CloseDate = vCloseDate,Expected_Product__c=2,
                                         Pricebook2Id=pricebook2[0].Id,CurrencyIsoCode=currentUser.defaultCurrencyIsoCode,
                                         Cloud_Demand_Model__c='IaaS',Cloud_Demand_Term_Months__c=13,Cloud_Demand_Units__c='CPU',
                                          Cloud_Number_of_Units__c=2500,Cloud_Demand_Proxy__c='12',AccountId = act.Id);
        insert  oppty1;
        
        
            
        string retURLAccount = '/' + oppty1.Id ; 
                
        String rc1 = '012Q00000004ru6';
        CEE__c ce1 = new CEE__c(Primary_Account__c = act.Id,RecordTypeId = rc1);
        
        ApexPages.currentPage().getParameters().put('RecordType',rc1);
        ApexPages.currentPage().getParameters().put('retURL',retURLAccount);
        
        string strId = System.Label.OPPORTUNITY_CESID + '_lkid' ;
        ApexPages.currentPage().getParameters().put(strId,oppty1.Id);
        
        ApexPages.StandardController sc1 = new ApexPages.standardController(ce1);        
        CEERedirectExtension redir2 = new CEERedirectExtension(sc1);       
        redir2.redirectToPage();
  }
  static testMethod void unit2() {
        try{
            Account act = new Account(name='TestVC');
            insert act;
            Technology_Profile__c th = new Technology_Profile__c(FK_Account__c=act.id);
            insert th;
        }catch(Exception e){
            system.debug('Exception ::'+e.getMessage());
        }
   }     
    
}