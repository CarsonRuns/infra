@isTest
private class Forecast_Tab_10_0_CT_test {
    private static void prepareData() {
        //load custom settings
        User u = new User(Id = UserInfo.getUserId());
        
        System.runAs (u) {
            List<Org_Constant_CS__c> orgConstant = new List<Org_Constant_CS__c>();
            orgConstant.add(new Org_Constant_CS__c(Name='FCST BASE',Non_Production_Value__c='http://wwwin-tools.cisco.com/E-Sales/opmgmt',Production_Value__c='http://wwwin-tools.cisco.com/E-Sales/opmgmt'));
            orgConstant.add(new Org_Constant_CS__c(Name='VPN',Non_Production_Value__c='http://wwwin.cisco.com/WWSales/e-sales/images/fcstTab.gif',Production_Value__c='http://wwwin-tools.cisco.com/E-Sales/opmgmt/images/top_left_esales.gif'));
            orgConstant.add(new Org_Constant_CS__c(Name='ISDC URL',Non_Production_Value__c='https://sandbox2.cloud9analytics.com/CentralApplication/index.jsp?pkg=new',Production_Value__c='https://central.cloud9analytics.com/CentralApplication/index.jsp?pkg=new'));

            insert orgConstant;
            
            
            List<Forecast_Tab_10_0_CS__c> fcTab = new List<Forecast_Tab_10_0_CS__c>();
            fcTab.add(new Forecast_Tab_10_0_CS__c(Name='SFDCValidateURL',EndpointURL__c='/services/Soap/c/',EndpointVersion__c='31.0/'));
            insert fcTab;
        }
    }

    @isTest static void test_method_one() {
        prepareData();
        String FCST_BASE = Utilities.getConstant_CS('FCST BASE');
        String VPN = Utilities.getConstant_CS('VPN');
        String username = UserInfo.getUserName();
        username = username.split('@')[0];//get first part of username
        username = username.replace('qa_', '');
        Url hostname = Url.getSalesforceBaseUrl();
        Test.setCurrentPage(Page.Forecast_Tab_10_0);


        Forecast_Tab_10_0_CT controller = new Forecast_Tab_10_0_CT();

        System.assertEquals(FCST_BASE, controller.FCST_BASE);
        System.assert(controller.VPN.startsWith(VPN + '?nocache='));
        System.assert(controller.appImgUrl.startsWith(FCST_BASE + controller.fcstImage + '?nocache='));
        System.assertNotEquals(null, controller.link);

        PageReference pr = controller.link;
        Map<String, String> urlParameters = pr.getParameters();
        System.assert(pr.getUrl().startsWith(FCST_BASE + controller.fcstRedirect));
        System.assertEquals('SFDC', urlParameters.get('SOURCE_APP'));
        System.assertEquals('MYFCST', urlParameters.get('nextPageCode'));
        System.assertEquals(username, urlParameters.get('SFDCUserId'));
        System.assertEquals(hostname.getHost(), urlParameters.get('SFDCHost'));
        System.assertEquals(hostname.toExternalForm() + '/services/Soap/c/31.0/' + UserInfo.getOrganizationId().substring(0,15), urlParameters.get('SFDCValidateURL'));
    }

    @isTest static void test_method_two() {
        //remove qa_prefix from username
        prepareData();

        Profile pList = [SELECT Id FROM Profile WHERE Name ='Cisco_ADMIN' limit 1];
        User newUser = new User();
        newUser.Alias = 'testusr';
        newUser.Email = 'testusr@cisco.com.test';
        newUser.EmailEncodingKey = 'UTF-8';
        newUser.LastName = 'Test';
        newUser.FirstName = 'cecid';
        newUser.Organization__c = 'Test';
        newUser.LanguageLocaleKey = 'en_US';
        newUser.LocaleSidKey = 'en_US';
        newUser.ProfileId = pList.Id;
        newUser.CommunityNickname = 'testusr';
        newUser.TimeZoneSidKey = 'America/Los_Angeles';
        newUser.UserName = 'qa_testusr@cisco.com.test';
        newUser.Theatre__c = 'Americas-Canada';
        String FCST_BASE = Utilities.getConstant_CS('FCST BASE');
        String VPN = Utilities.getConstant_CS('VPN');
        String username = 'testusr';
        Url hostname = Url.getSalesforceBaseUrl();
        Test.setCurrentPage(Page.Forecast_Tab_10_0);


        Forecast_Tab_10_0_CT controller;
        System.runAs(newUser) {
            controller = new Forecast_Tab_10_0_CT();
        }

        System.assertEquals(FCST_BASE, controller.FCST_BASE);
        System.assert(controller.VPN.startsWith(VPN + '?nocache='));
        System.assert(controller.appImgUrl.startsWith(FCST_BASE + controller.fcstImage + '?nocache='));
        System.assertNotEquals(null, controller.link);

        PageReference pr = controller.link;
        Map<String, String> urlParameters = pr.getParameters();
        System.assert(pr.getUrl().startsWith(FCST_BASE + controller.fcstRedirect));
        System.assertEquals('SFDC', urlParameters.get('SOURCE_APP'));
        System.assertEquals('MYFCST', urlParameters.get('nextPageCode'));
        System.assertEquals(username, urlParameters.get('SFDCUserId'));
        System.assertEquals(hostname.getHost(), urlParameters.get('SFDCHost'));
        System.assertEquals(hostname.toExternalForm() + '/services/Soap/c/31.0/' + UserInfo.getOrganizationId().substring(0,15), urlParameters.get('SFDCValidateURL'));
    }
    
        @isTest static void test_method_isdc() {
        //remove qa_prefix from username
        prepareData();

        Profile pList = [SELECT Id FROM Profile WHERE Name ='Cisco_ADMIN' limit 1];
        User newUser = new User();
        newUser.Alias = 'testusr';
        newUser.Email = 'testusr@cisco.com.test';
        newUser.EmailEncodingKey = 'UTF-8';
        newUser.LastName = 'Test';
        newUser.FirstName = 'cecid';
        newUser.Organization__c = 'Test';
        newUser.LanguageLocaleKey = 'en_US';
        newUser.LocaleSidKey = 'en_US';
        newUser.ProfileId = pList.Id;
        newUser.CommunityNickname = 'testusr';
        newUser.TimeZoneSidKey = 'America/Los_Angeles';
        newUser.UserName = 'qa_testusr@cisco.com.test';
        newUser.Theatre__c = 'Americas-Canada';
        newUser.Additional_User_Permissions__c = 'GSSO HD Forecast User';
        String ISDC_URL = Utilities.getConstant_CS('ISDC URL');
       
        String username = 'testusr';
        Url hostname = Url.getSalesforceBaseUrl();
        Test.setCurrentPage(Page.Forecast_Tab_10_0);


        Forecast_Tab_10_0_CT controller;
        System.runAs(newUser) {
            controller = new Forecast_Tab_10_0_CT();
        }

        System.assertNotEquals(null, controller.link);

        PageReference pr = controller.link;
        Map<String, String> urlParameters = pr.getParameters();
        
        }
}