@isTest(SeeAllData=true)
public class NGCC_MODS_SFDC_Contact_Search_Flow_Test {
    @isTest
    public static void testMethod1(){
        Test.StartTest(); 
        
        PageReference pageRef = Page.NGCC_MODS_SFDC_Contact_Search_FLOW; // Add your VF page Name here
        pageRef.getParameters().put('emailAddress', 'Test@Cisco.com');
        pageRef.getParameters().put('firstName', 'Test');
        pageRef.getParameters().put('lastName', 'Test');
        pageRef.getParameters().put('company', 'Cisco');
        pageRef.getParameters().put('city', '');
        pageRef.getParameters().put('state', '');
        pageRef.getParameters().put('countryName', '');
        pageRef.getParameters().put('postalCode', '');
        pageRef.getParameters().put('phoneNumber', '123456789');
        
        pageRef.getParameters().put('node', '{"CONTACT":[{"EMAIL_ADDRESS":"regooge@gmail.com","CISCO_PHONE_OPT_FLAG":"","ISO_COUNTRY_NAME":"UNITED STATES","POSTAL_CODE":"32401","REPORTED_ORG_NAME":"BAY RADIOLOGY ASSOCIATES PA","CITY_NAME":"PANAMA CITY","LINE_2_ADDRESS":"","SITE_ISO_COUNTRY_NAME":"UNITED STATES","PHONE_NUMBER":"+1(850)873-3970","LAST_NAME":"Googe","LINE_4_ADDRESS":"","CISCO_EMAIL_OPT_FLAG":"","CISCO_FAX_OPT_TXN_DT":"","CISCO_MAIL_OPT_TXN_DT":"","CISCO_MAIL_OPT_FLAG":"","LINE_1_ADDRESS":"527 N PALO ALTO AVE","CISCO_EMAIL_OPT_TXN_DT":"","LINE_3_ADDRESS":"","FIRST_NAME":"Bog","SOURCE":[{"SOURCE_RECORD_ID":"00380000014CgNhAAK"}],"CISCO_FAX_OPT_FLAG":"","CISCO_PHONE_OPT_TXN_DT":"","STATE_OR_PROVINCE_NAME":"FL","ISO_COUNTRY_CODE":"US","PERSON_PARTY_ID":"167448269","PREFERRED_LANGUAGE":""}],"STATUS":"SUCCESS","TOTAL_CONTACTS":1,"MESSAGE":"1 Contact(s) found"}');
        Test.setCurrentPage(pageRef);
        
        NGCC_MODS_SFDC_Contact_Search_Flow_CTE Cntrl = new NGCC_MODS_SFDC_Contact_Search_Flow_CTE();
        
        
        String email = 'test';
        String fname = 'test';
        String lname = 'test';
        String plang = 'test';
        String country = 'test';
        String phone = 'test';
        
        String address1 = 'test';
        String address2 = 'test';
        String address3 = 'test';
        String address4 = 'test';
        String city = 'test';
        
        String zip = 'test';
        String companyName = 'test';
        String countryName = 'test';
        String state = 'test';
        List<NGCC_MODS_SFDC_Contact_Search_Flow_CTE.MarketingSource> sourceList = new List<NGCC_MODS_SFDC_Contact_Search_Flow_CTE.MarketingSource>(); 
        
        String modsId = 'test';
        String orgId = 'test';
        String mobile = 'test';
        String title = 'test';
        
        String emailPermission = 'test';
        String emailDate = 'test';
        String phonePermission = 'test';
        
        String phoneDate = 'test';
        String dataPermisison = 'test';
        String dataDate = 'test';
        String altPhone = 'test';
        
        NGCC_MODS_SFDC_Contact_Search_Flow_CTE.MarketingContact mcl =  new NGCC_MODS_SFDC_Contact_Search_Flow_CTE.MarketingContact(email,fname,lname,plang,country,phone,
                                                                                                                                   address1,address2,address3,address4,city,
                                                                                                                                   zip,companyName,countryName,state, sourceList,        
                                                                                                                                   modsId,orgId,mobile,title,        
                                                                                                                                   emailPermission,emailDate, phonePermission,
                                                                                                                                   phoneDate,dataPermisison,dataDate,altPhone);
        
        Cntrl.MODS_Search();
        Cntrl.mcList.add(mcl);
    }
    public static testMethod void marketingSourceConstcutorTest(){
        NGCC_MODS_SFDC_Contact_Search_Flow_CTE.MarketingSource ms = new NGCC_MODS_SFDC_Contact_Search_Flow_CTE.MarketingSource();
        
        System.assertEquals(ms.Source_Record_ID, null);
    }
    public static testMethod void marketingContactListConstructorTest(){
        String status = 'test'; 
        Integer total = 0;
        String message = 'test';
        List<NGCC_MODS_SFDC_Contact_Search_Flow_CTE.MarketingContact> li = new List<NGCC_MODS_SFDC_Contact_Search_Flow_CTE.MarketingContact>();
        
        NGCC_MODS_SFDC_Contact_Search_Flow_CTE.MarketingContactsList mcl = new NGCC_MODS_SFDC_Contact_Search_Flow_CTE.MarketingContactsList(status, total, message, li);
        System.assertNotEquals(mcl, null);
        
    }
    public static testMethod void forceNotNulltest(){ 
        NGCC_MODS_SFDC_Contact_Search_Flow_CTE searcher = new NGCC_MODS_SFDC_Contact_Search_Flow_CTE();
        
        String input = 'test';
        input= searcher.forceNonNull(input);
        
        System.assertEquals(input, 'test');
    }
    public static testMethod void forceNotNulltest2(){ 
        NGCC_MODS_SFDC_Contact_Search_Flow_CTE searcher = new NGCC_MODS_SFDC_Contact_Search_Flow_CTE();
        
        String input = '';
        input= searcher.forceNonNull(input);
        
        System.assertEquals(input, 'Please Update');
    }
    
    public static testMethod void permissionDateInvalidInput(){
        String input = 'abc'; 
        NGCC_MODS_SFDC_Contact_Search_Flow_CTE searcher = new NGCC_MODS_SFDC_Contact_Search_Flow_CTE();
        
        DateTime dt = searcher.getPermissionDate(input);
        System.assertEquals(dt, null);
    }
    public static testMethod void fullNameTest(){  
        NGCC_MODS_SFDC_Contact_Search_Flow_CTE searcher = new NGCC_MODS_SFDC_Contact_Search_Flow_CTE();
        
        String input = 'Y';
        System.assertEquals(searcher.fullName(input) , 'Yes');
        
        input = 'N';
        System.assertEquals(searcher.fullName(input) , 'No');
         
        input = 'blah';
        System.assertEquals(searcher.fullName(input) , null);
         
      } 
    public static testMethod void permissionDateValidInput(){
        String input= '2010-01-11 18:31:10.0'; 
        NGCC_MODS_SFDC_Contact_Search_Flow_CTE searcher = new NGCC_MODS_SFDC_Contact_Search_Flow_CTE();
        
        DateTime dt = searcher.getPermissionDate(input);
        Datetime valid = DateTime.newInstance(2010, 01, 11, 18, 31, 10);
        System.assertEquals(dt, valid);
    }
}