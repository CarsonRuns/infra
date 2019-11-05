@isTest
private class HomeMessage_CT_Test
{
    private static void prepareData() {
        //load custom settings
        User u = new User(Id = UserInfo.getUserId());
        
        System.runAs (u) {
            List<Org_Constant_CS__c> orgConstant = new List<Org_Constant_CS__c>();
            orgConstant.add(new Org_Constant_CS__c(Name='PMT Svc',Non_Production_Value__c='https://tools.cisco.com/CBMS/service/MessageService',Production_Value__c='https://tools.cisco.com/CBMS/service/MessageService'));
            insert orgConstant;
        }
    }

    @isTest static void test_method_one() {
        prepareData();
        String ciscoEndpoint  = Utilities.getConstant_CS('PMT Svc');
        String organizationId = UserInfo.getOrganizationId().substring(0,15);
        Boolean isProduction  = organizationId == '00D300000000QUu';
        String username = UserInfo.getUserName();
        username = username.split('@')[0];//get first part of username
        if (!isProduction) {
            username += '_' + organizationId;
        }
        Test.setCurrentPage(Page.HomeMessage);


        HomeMessage_CT controller = new HomeMessage_CT();

        System.assertEquals(ciscoEndpoint, controller.ciscoEndpoint);
        System.assertEquals('00D300000000QUu', HomeMessage_CT.prodOrganizationId);
        System.assertEquals(organizationId, controller.organizationId);
        System.assertEquals(isProduction, controller.isProduction);
        System.assertEquals(username, controller.username);
    }

    @isTest static void test_method_two() {
        //run as in production
        prepareData();
        String ciscoEndpoint  = Utilities.getConstant_CS('PMT Svc');
        String organizationId = UserInfo.getOrganizationId().substring(0,15);
        HomeMessage_CT.prodOrganizationId = organizationId;
        Boolean isProduction  = true;
        String username = UserInfo.getUserName();
        username = username.split('@')[0];//get first part of username
        Test.setCurrentPage(Page.HomeMessage);


        HomeMessage_CT controller = new HomeMessage_CT();

        System.assertEquals(ciscoEndpoint, controller.ciscoEndpoint);
        System.assertEquals(organizationId, HomeMessage_CT.prodOrganizationId);
        System.assertEquals(organizationId, controller.organizationId);
        System.assertEquals(isProduction, controller.isProduction);
        System.assertEquals(username, controller.username);
    }    
}