@isTest
public class NGCC_Clone_Controller_Test{
    public static testMethod void callScriptMethod(){
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@cisco.com';
        Profile p = [SELECT Id FROM Profile WHERE Name='Cisco_Deployment_Support' limit 1];
        UserRole ur = [select id,name from userrole where name like '%NGCC-CCM%' limit 1];
        User u = new User(
                            Alias = 'standt', 
                            Email='standarduser@cisco.com',
                            EmailEncodingKey='UTF-8', 
                            LastName='Testing', 
                            LanguageLocaleKey='en_US',
                            LocaleSidKey='en_US', 
                            ProfileId = p.Id,
                            TimeZoneSidKey='America/Los_Angeles',
                            marketing_call_center__c = 'Alea Canada',
                            Theatre__c = 'APJC-APAC',
                            UserName=uniqueUserName,
                            UserRoleId=ur.Id
                            );
                            
        System.runAs(u) {
              CC_Call_Script__c c = new CC_Call_Script__c();
              c.name = 'FY15 APJ Lead';
              c.Theater__c ='APJ';
              c.Status__c = 'Draft';
              c.Default_Call_Script__c = true;
              c.Default_Language__c = 'English: en_US';
              c.Question_Categories__c ='Contact Information,Account Information,Lead Information,Additional Information,Call Information';
              insert c; 
              List<CC_Call_Script_Q_A__c> listScript = new List<CC_Call_Script_Q_A__c >();
              CC_Call_Script_Q_A__c cc = new CC_Call_Script_Q_A__c   ();
              cc.name = 'Test';
              cc.Answer_Options__c = c.Question_Categories__c ;
              cc.Question_Category__c =c.Question_Categories__c ;
              cc.Question_Text__c = 'Text';
              cc.Sequence__c=7;
              cc.Call_Script__c = c.id;
              listScript.add(cc);
              insert listScript;             
              PageReference pageRef = Page.NGCC_Clone;
                pageRef.getParameters().put('id', String.valueOf(c.Id));
                Test.setCurrentPage(pageRef);
               ApexPages.StandardController sc = new ApexPages.StandardController(c);
               NGCC_Clone_Controller n = new NGCC_Clone_Controller(sc);  
               system.debug('Campaign id' + c.Id);             
               n.cloneCallScript();
                CC_Call_Script__c c1 = new CC_Call_Script__c();
              c1.name = 'FY15 APJ Lead';
              c1.Theater__c ='APJ';
              c1.Status__c = 'Draft';
              c1.Default_Call_Script__c = true;
              c1.Default_Language__c = 'English: en_US';
              c1.Question_Categories__c ='Contact Information,Account Information,Lead Information,Additional Information,Call Information';
              insert c1;   
            PageReference pageRef1 = Page.NGCC_Clone;
            pageRef1.getParameters().put('id', null);
            Test.setCurrentPage(pageRef1);   
          ApexPages.StandardController sc1 = new ApexPages.StandardController(c);
          NGCC_Clone_Controller n1 = new NGCC_Clone_Controller(sc1);
          n1.cloneCallScript();
          }
    }
    public static testMethod void callScriptMethodNegitive(){
           CC_Call_Script__c c = new CC_Call_Script__c();
              c.name = 'FY15 APJ Lead';
              c.Theater__c ='APJ';
              c.Status__c = 'Draft';
              c.Default_Call_Script__c = true;
              c.Default_Language__c = 'English: en_US';
              c.Question_Categories__c ='Contact Information,Account Information,Lead Information,Additional Information,Call Information';
              insert c;   
            PageReference pageRef = Page.NGCC_Clone;
            pageRef.getParameters().put('id', String.valueOf(c.Id));
            Test.setCurrentPage(pageRef);   
          ApexPages.StandardController sc = new ApexPages.StandardController(c);
          NGCC_Clone_Controller n = new NGCC_Clone_Controller(sc);
          n.cloneCallScript(); 
          
          CC_Call_Script__c c1 = new CC_Call_Script__c();
              c1.name = 'FY15 APJ Lead';
              c1.Theater__c ='APJ';
              c1.Status__c = 'Draft';
              c1.Default_Call_Script__c = true;
              c1.Default_Language__c = 'English: en_US';
              c1.Question_Categories__c ='Contact Information,Account Information,Lead Information,Additional Information,Call Information';
              insert c1;              
            PageReference pageRef1 = Page.NGCC_Clone;
            pageRef1.getParameters().put('id', null);
            Test.setCurrentPage(pageRef1);   
          ApexPages.StandardController sc1 = new ApexPages.StandardController(c);
          NGCC_Clone_Controller n1 = new NGCC_Clone_Controller(sc1);
          n1.cloneCallScript(); 
    } 
}