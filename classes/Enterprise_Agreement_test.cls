@isTest
private class Enterprise_Agreement_test {
    private static void prepareData() {
        //load custom settings
        User u = new User(Id = UserInfo.getUserId());
        
        System.runAs (u) {
            List<Org_Constant_CS__c> orgConstant = new List<Org_Constant_CS__c>();
            orgConstant.add(new Org_Constant_CS__c(Name='ENT BASE',Non_Production_Value__c='https://eaccw-dev.cloudapps.cisco.com',Production_Value__c='https://eaccw-dev.cloudapps.cisco.com'));
            insert orgConstant;
        }
    }

    @isTest static void test_method_one() {
        prepareData();
        String ENT_BASE = Utilities.getConstant_CS('ENT BASE');
        String VPN = Utilities.getConstant_CS('VPN');
        Test.setCurrentPage(Page.Forecast_Tab_10_0);


        Enterprise_Agreement controller = new Enterprise_Agreement();

    }

}