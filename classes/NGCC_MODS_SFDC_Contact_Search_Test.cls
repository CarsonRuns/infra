@isTest(SeeAllData=true) 

private class NGCC_MODS_SFDC_Contact_Search_Test {
 /*
    private static testMethod void MODSSearchTest(){
        PageReference current = ApexPages.currentPage();
        Test.setCurrentPage(current);
        current.getParameters().put('node', '{"CONTACT":[{"EMAIL_ADDRESS":"regooge@gmail.com","CISCO_PHONE_OPT_FLAG":"","ISO_COUNTRY_NAME":"UNITED STATES","POSTAL_CODE":"32401","REPORTED_ORG_NAME":"BAY RADIOLOGY ASSOCIATES PA","CITY_NAME":"PANAMA CITY","LINE_2_ADDRESS":"","SITE_ISO_COUNTRY_NAME":"UNITED STATES","PHONE_NUMBER":"+1(850)873-3970","LAST_NAME":"Googe","LINE_4_ADDRESS":"","CISCO_EMAIL_OPT_FLAG":"","CISCO_FAX_OPT_TXN_DT":"","CISCO_MAIL_OPT_TXN_DT":"","CISCO_MAIL_OPT_FLAG":"","LINE_1_ADDRESS":"527 N PALO ALTO AVE","CISCO_EMAIL_OPT_TXN_DT":"","LINE_3_ADDRESS":"","FIRST_NAME":"Bog","SOURCE":[{"SOURCE_RECORD_ID":"00380000014CgNhAAK"}],"CISCO_FAX_OPT_FLAG":"","CISCO_PHONE_OPT_TXN_DT":"","STATE_OR_PROVINCE_NAME":"FL","ISO_COUNTRY_CODE":"US","PERSON_PARTY_ID":"167448269","PREFERRED_LANGUAGE":""}],"STATUS":"SUCCESS","TOTAL_CONTACTS":1,"MESSAGE":"1 Contact(s) found"}');
        Lead a = new Lead();
        ApexPages.StandardController controller = new ApexPages.StandardController(a);   
        NGCC_MODS_SFDC_Contact_Search_CTE searcher = new NGCC_MODS_SFDC_Contact_Search_CTE(controller);
        searcher.MODS_Search();
    }
    
    private static testMethod void getResultsSizeTest(){
        PageReference current = ApexPages.currentPage();
        current.getParameters().put('node', '{"CONTACT":[{"EMAIL_ADDRESS":"regooge@gmail.com","CISCO_PHONE_OPT_FLAG":"","ISO_COUNTRY_NAME":"UNITED STATES","POSTAL_CODE":"32401","REPORTED_ORG_NAME":"BAY RADIOLOGY ASSOCIATES PA","CITY_NAME":"PANAMA CITY","LINE_2_ADDRESS":"","SITE_ISO_COUNTRY_NAME":"UNITED STATES","PHONE_NUMBER":"+1(850)873-3970","LAST_NAME":"Googe","LINE_4_ADDRESS":"","CISCO_EMAIL_OPT_FLAG":"","CISCO_FAX_OPT_TXN_DT":"","CISCO_MAIL_OPT_TXN_DT":"","CISCO_MAIL_OPT_FLAG":"","LINE_1_ADDRESS":"527 N PALO ALTO AVE","CISCO_EMAIL_OPT_TXN_DT":"","LINE_3_ADDRESS":"","FIRST_NAME":"Bog","SOURCE":[{"SOURCE_RECORD_ID":"00380000014CgNhAAK"}],"CISCO_FAX_OPT_FLAG":"","CISCO_PHONE_OPT_TXN_DT":"","STATE_OR_PROVINCE_NAME":"FL","ISO_COUNTRY_CODE":"US","PERSON_PARTY_ID":"167448269","PREFERRED_LANGUAGE":""}],"STATUS":"SUCCESS","TOTAL_CONTACTS":1,"MESSAGE":"1 Contact(s) found"}');
        Lead a = new Lead();
        ApexPages.StandardController controller = new ApexPages.StandardController(a);   
        NGCC_MODS_SFDC_Contact_Search_CTE searcher = new NGCC_MODS_SFDC_Contact_Search_CTE(controller);
        searcher.MODS_Search();
        System.assertEquals(1, searcher.getResultSize());
    }
    
    private static testMethod void clearResultsTest(){
        PageReference current = ApexPages.currentPage();
        current.getParameters().put('searchEmailAddress', 'test@test.com');
        Lead a = new Lead();
        ApexPages.StandardController controller = new ApexPages.StandardController(a);   
        NGCC_MODS_SFDC_Contact_Search_CTE searcher = new NGCC_MODS_SFDC_Contact_Search_CTE(controller);
        
        searcher.MODS_Search();
        searcher.clearResults();
        System.assertEquals(0, searcher.getResultSize());
    }*/
   /*    
    private static testMethod void newProspectTestBlank(){
        PageReference current = ApexPages.currentPage();
        current.getParameters().put('searchEmailAddress', 'test@cisco.com');
        Lead a = new Lead();
        ApexPages.StandardController controller = new ApexPages.StandardController(a);   
        NGCC_MODS_SFDC_Contact_Search_CTE searcher = new NGCC_MODS_SFDC_Contact_Search_CTE(controller);
        searcher.newProspect();
    }
    private static testMethod void newProspectTestCountrySpecified(){
        PageReference current = ApexPages.currentPage();
        current.getParameters().put('searchEmailAddress', 'test@cisco.com');
        Lead a = new Lead();
        ApexPages.StandardController controller = new ApexPages.StandardController(a);   
        NGCC_MODS_SFDC_Contact_Search_CTE searcher = new NGCC_MODS_SFDC_Contact_Search_CTE(controller);
        searcher.searchCountryName = 'UK';
        searcher.searchlastName = 'test';
        Test.startTest();
        searcher.newProspect();
        Test.stopTest();
    }*/
    
    private static testMethod void newProspectTestConsoleMode(){
        PageReference current = ApexPages.currentPage();
        Lead a = new Lead();
        ApexPages.StandardController controller = new ApexPages.StandardController(a);   
        NGCC_MODS_SFDC_Contact_Search_CTE searcher = new NGCC_MODS_SFDC_Contact_Search_CTE(controller);
        searcher.searchCountryName = 'UK';
        searcher.searchlastName = 'test';
        searcher.isAutomatic = 'true';
        Lead l = new Lead();
        l.Company = 'test';
        l.Email = 'test@test.com';
        l.FirstName = 'test';
        l.LastName = 'test';
        l.Phone = 'test';
        insert l;
        searcher.validation();
        
        searcher.newProspect();
    }
    
    private static testMethod void getResultsTest(){
        PageReference current = ApexPages.currentPage();
        current.getParameters().put('searchEmailAddress', 'test@test.com');
        Lead a = new Lead();
        ApexPages.StandardController controller = new ApexPages.StandardController(a);   
        NGCC_MODS_SFDC_Contact_Search_CTE searcher = new NGCC_MODS_SFDC_Contact_Search_CTE(controller);
        searcher.getResults();
    }  
    
    
    private static testMethod void fieldFormatDeformatAll(){
        PageReference current = ApexPages.currentPage();
        Test.setCurrentPage(current);
        
        current.getParameters().put('firstName', 'test ');
        current.getParameters().put('lastName', 'test ');
        current.getParameters().put('company', 'test ');
        current.getParameters().put('city', 'test ');
        current.getParameters().put('state', 'test ');
        current.getParameters().put('countryName', 'test ');
        current.getParameters().put('postalCode', 'test ');
        current.getParameters().put('phoneNumber', 'test ');
        current.getParameters().put('ResponseId', 'test ');

        Lead a = new Lead();
        ApexPages.StandardController controller = new ApexPages.StandardController(a);   
        NGCC_MODS_SFDC_Contact_Search_CTE searcher = new NGCC_MODS_SFDC_Contact_Search_CTE(controller);
        System.assertEquals('test ', searcher.searchFirstName);
        System.assertEquals('test ', searcher.searchLastName);
        System.assertEquals('test ', searcher.searchCompany);
        System.assertEquals('test ', searcher.searchCity);
        System.assertEquals('test ', searcher.searchState);
        System.assertEquals('test ', searcher.searchPostalCode );
        System.assertEquals('test ', searcher.searchPhoneNumber);

        searcher.fieldFormat();
        System.assertEquals('test+', searcher.searchFirstName);
        System.assertEquals('test+', searcher.searchLastName);
        System.assertEquals('test+', searcher.searchCompany);
        System.assertEquals('test+', searcher.searchCity);
        System.assertEquals('test+', searcher.searchState);
        System.assertEquals('test+', searcher.searchPostalCode );
        System.assertEquals('test+', searcher.searchPhoneNumber);
    
        searcher.fieldDeformat();
        System.assertEquals('test ', searcher.searchFirstName);
        System.assertEquals('test ', searcher.searchLastName);
        System.assertEquals('test ', searcher.searchCompany);
        System.assertEquals('test ', searcher.searchCity);
        System.assertEquals('test ', searcher.searchState);
        System.assertEquals('test ', searcher.searchPostalCode );
        System.assertEquals('test ', searcher.searchPhoneNumber);
    }
    
     private static testMethod void businessRule1Test(){
        PageReference current = ApexPages.currentPage();
        
        Lead a = new Lead();
        ApexPages.StandardController controller = new ApexPages.StandardController(a);   
        NGCC_MODS_SFDC_Contact_Search_CTE searcher = new NGCC_MODS_SFDC_Contact_Search_CTE(controller);

        Boolean value = searcher.validateDataFields('','firstname', 'lastname', '', '', '', 'country','', '');
        System.assertEquals(true, value);
     }
    
    private static testMethod void businessRuleOverallTest(){
        PageReference current = ApexPages.currentPage();
        Test.setCurrentPage(current);
        current.getParameters().put('emailAddress', 'test@test.com');
        current.getParameters().put('firstName', '');
        current.getParameters().put('lastName', '');
        current.getParameters().put('company', '');
        current.getParameters().put('city', '');
        current.getParameters().put('state', '');
        current.getParameters().put('countryName', '');
        current.getParameters().put('postalCode', '');
        current.getParameters().put('phoneNumber', '');
        current.getParameters().put('ResponseId', '');
        
        Lead a = new Lead();
        ApexPages.StandardController controller = new ApexPages.StandardController(a);   
        NGCC_MODS_SFDC_Contact_Search_CTE searcher = new NGCC_MODS_SFDC_Contact_Search_CTE(controller);

        searcher.validation();
        System.assertEquals('<script> MODS_Search(\'test@test.com\',\'\',\'\',\'\',\'\',\'\',\'\',\'\',\'\'); </script>', EncodingUtil.urlDecode(searcher.outputText,'UTF-8'));
     }
    
     
     private static testMethod void businessRule2Test(){
        PageReference current = ApexPages.currentPage();
        
        Lead a = new Lead();
        ApexPages.StandardController controller = new ApexPages.StandardController(a);   
        NGCC_MODS_SFDC_Contact_Search_CTE searcher = new NGCC_MODS_SFDC_Contact_Search_CTE(controller);

        Boolean value = searcher.validateDataFields('test@test.com','', '', '', '', '', '','', '');
        System.assertEquals(true, value);
     }
  
     private static testMethod void businessRule3Test(){
        PageReference current = ApexPages.currentPage();
        
        Lead a = new Lead();
        ApexPages.StandardController controller = new ApexPages.StandardController(a);   
        NGCC_MODS_SFDC_Contact_Search_CTE searcher = new NGCC_MODS_SFDC_Contact_Search_CTE(controller);

        Boolean value = searcher.validateDataFields('','', '', '', '', '', '','', '7856088694');
        System.assertEquals(true, value);
     }
     
     private static testMethod void businessRule4Test(){
        PageReference current = ApexPages.currentPage();
        
        Lead a = new Lead();
        ApexPages.StandardController controller = new ApexPages.StandardController(a);   
        NGCC_MODS_SFDC_Contact_Search_CTE searcher = new NGCC_MODS_SFDC_Contact_Search_CTE(controller);

        Boolean value = searcher.validateDataFields('','Test', 'Test', '', '', '', 'US','', '');
        System.assertEquals(true, value);
     }
     
     private static testMethod void businessRuleFail1Test(){
        PageReference current = ApexPages.currentPage();
        
        Lead a = new Lead();
        ApexPages.StandardController controller = new ApexPages.StandardController(a);   
        NGCC_MODS_SFDC_Contact_Search_CTE searcher = new NGCC_MODS_SFDC_Contact_Search_CTE(controller);

        Boolean value = searcher.validateDataFields('','', '', '', '', '', '','', '');
        System.assertEquals(false, value);
     }     

     private static testMethod void businessRuleFail2Test(){
        PageReference current = ApexPages.currentPage();
        
        Lead a = new Lead();
        ApexPages.StandardController controller = new ApexPages.StandardController(a);   
        NGCC_MODS_SFDC_Contact_Search_CTE searcher = new NGCC_MODS_SFDC_Contact_Search_CTE(controller);

        Boolean value = searcher.validateDataFields('t','t', 't', 't', 't', 't', 't','t', 't');
        System.assertEquals(false, value);
     }
     
     private static testMethod void getEmptyTest(){
        PageReference current = ApexPages.currentPage();
        
        Lead a = new Lead();
        ApexPages.StandardController controller = new ApexPages.StandardController(a);   
        NGCC_MODS_SFDC_Contact_Search_CTE searcher = new NGCC_MODS_SFDC_Contact_Search_CTE(controller);

        SelectOption so = searcher.getemptyItem();
        System.assertEquals('', so.getValue());
     }

     private static testMethod void getErrorFlag(){
        PageReference current = ApexPages.currentPage();
        
        Lead a = new Lead();
        ApexPages.StandardController controller = new ApexPages.StandardController(a);   
        NGCC_MODS_SFDC_Contact_Search_CTE searcher = new NGCC_MODS_SFDC_Contact_Search_CTE(controller);
        searcher.setErrorFlag();
        System.assertEquals(true, searcher.errorFlag);
     }

     private static testMethod void getBlockFlag(){
        PageReference current = ApexPages.currentPage();
        
        Lead a = new Lead();
        ApexPages.StandardController controller = new ApexPages.StandardController(a);   
        NGCC_MODS_SFDC_Contact_Search_CTE searcher = new NGCC_MODS_SFDC_Contact_Search_CTE(controller);
        searcher.setBlockFlag();
        System.assertEquals(false, searcher.resultBlockFlag);
     }
     private static testMethod void getServiceErrorFlag(){
        PageReference current = ApexPages.currentPage();
        
        Lead a = new Lead();
        ApexPages.StandardController controller = new ApexPages.StandardController(a);   
        NGCC_MODS_SFDC_Contact_Search_CTE searcher = new NGCC_MODS_SFDC_Contact_Search_CTE(controller);
        searcher.setServiceErrorFlag();
        System.assertEquals(true, searcher.serviceErrorFlag);
     }
     
     private static testMethod void getCountries(){
        PageReference current = ApexPages.currentPage();
        
        Lead a = new Lead();
        ApexPages.StandardController controller = new ApexPages.StandardController(a);   
        NGCC_MODS_SFDC_Contact_Search_CTE searcher = new NGCC_MODS_SFDC_Contact_Search_CTE(controller);
        List<SelectOption> c = searcher.getCountries();
        System.assertNotEquals(0, c.size());
     }
     
     private static testMethod void getStates(){
        PageReference current = ApexPages.currentPage();
        
        Lead a = new Lead();
        ApexPages.StandardController controller = new ApexPages.StandardController(a);   
        NGCC_MODS_SFDC_Contact_Search_CTE searcher = new NGCC_MODS_SFDC_Contact_Search_CTE(controller);
        List<SelectOption> s = searcher.getStates();
        System.assertNotEquals(0, s.size());
     }
     
     private static testMethod void getResultSize(){
        PageReference current = ApexPages.currentPage();
        
        Lead a = new Lead();
        ApexPages.StandardController controller = new ApexPages.StandardController(a);   
        NGCC_MODS_SFDC_Contact_Search_CTE searcher = new NGCC_MODS_SFDC_Contact_Search_CTE(controller);
        Integer value = searcher.getResultSize();
        System.assertEquals(0, value);
     }
     
     private static testMethod void responseUpdateTest(){
        PageReference current = ApexPages.currentPage();
        CC_Response__c id = new CC_Response__c();
        insert id;
        
        Test.setCurrentPage(current);
        current.getParameters().put('ResponseId', id.Id);
        
        Lead a = new Lead();
        ApexPages.StandardController controller = new ApexPages.StandardController(a);   
        NGCC_MODS_SFDC_Contact_Search_CTE searcher = new NGCC_MODS_SFDC_Contact_Search_CTE(controller);
        searcher.responseUpdate('test', 'test', 'test', 'test');
     }
     
     private static testMethod void clearInputTest(){
        PageReference current = ApexPages.currentPage();
        
        Test.setCurrentPage(current);
        current.getParameters().put('firstName', 'test ');
        current.getParameters().put('lastName', 'test ');
        current.getParameters().put('company', 'test ');
        current.getParameters().put('city', 'test ');
        current.getParameters().put('state', 'test ');
        current.getParameters().put('countryName', 'test ');
        current.getParameters().put('postalCode', 'test ');
        current.getParameters().put('phoneNumber', 'test ');
        
        Lead a = new Lead();
        ApexPages.StandardController controller = new ApexPages.StandardController(a);   
        NGCC_MODS_SFDC_Contact_Search_CTE searcher = new NGCC_MODS_SFDC_Contact_Search_CTE(controller);
        searcher.clearInput();
      }
      
      private static testMethod void permissionDateNullInput(){
        String input;
        Lead a = new Lead();
        ApexPages.StandardController controller = new ApexPages.StandardController(a);   
        NGCC_MODS_SFDC_Contact_Search_CTE searcher = new NGCC_MODS_SFDC_Contact_Search_CTE(controller);
        
        DateTime dt = searcher.getPermissionDate(input);
        System.assertEquals(dt, null);
      }
      
      private static testMethod void permissionDateInvalidInput(){
        String input = 'abc';
        Lead a = new Lead();
        ApexPages.StandardController controller = new ApexPages.StandardController(a);   
        NGCC_MODS_SFDC_Contact_Search_CTE searcher = new NGCC_MODS_SFDC_Contact_Search_CTE(controller);
        
        DateTime dt = searcher.getPermissionDate(input);
        System.assertEquals(dt, null);
      }

      private static testMethod void permissionDateValidInput(){
        String input= '2010-01-11 18:31:10.0';
        Lead a = new Lead();
        ApexPages.StandardController controller = new ApexPages.StandardController(a);   
        NGCC_MODS_SFDC_Contact_Search_CTE searcher = new NGCC_MODS_SFDC_Contact_Search_CTE(controller);
        
        DateTime dt = searcher.getPermissionDate(input);
        Datetime valid = DateTime.newInstance(2010, 01, 11, 18, 31, 10);
        System.assertEquals(dt, valid);
      }
      
      private static testMethod void getItemsTest(){
        Lead a = new Lead();
        ApexPages.StandardController controller = new ApexPages.StandardController(a);   
        NGCC_MODS_SFDC_Contact_Search_CTE searcher = new NGCC_MODS_SFDC_Contact_Search_CTE(controller);
        
        List<SelectOption> li = searcher.getItems();
        
        System.assertEquals(li.size(), 2);
      }
      
      
      private static testMethod void forceNotNulltest(){
        Lead a = new Lead();
        ApexPages.StandardController controller = new ApexPages.StandardController(a);   
        NGCC_MODS_SFDC_Contact_Search_CTE searcher = new NGCC_MODS_SFDC_Contact_Search_CTE(controller);
        
        String input = 'test';
        input= searcher.forceNonNull(input);
        
        System.assertEquals(input, 'test');
      }
      
      private static testMethod void contactLookupNulltest(){
        Lead a = new Lead();
        ApexPages.StandardController controller = new ApexPages.StandardController(a);   
        NGCC_MODS_SFDC_Contact_Search_CTE searcher = new NGCC_MODS_SFDC_Contact_Search_CTE(controller);
      
        Lead newL = new Lead();
        Lead test = searcher.contactLookup(newL);
        
        System.assertEquals(newL.End_Customer_Account__c, null);
        System.assertEquals(test.End_Customer_Account__c, null);
      }
      
      private static testMethod void campaignCrossReferenceTest(){
        PageReference current = ApexPages.currentPage();
        Test.setCurrentPage(current);
        current.getParameters().put('sourceId', '123');
        
        Lead a = new Lead();
        ApexPages.StandardController controller = new ApexPages.StandardController(a);   
        NGCC_MODS_SFDC_Contact_Search_CTE searcher = new NGCC_MODS_SFDC_Contact_Search_CTE(controller);
      
        Lead newLead = new Lead();
        Campaign newCamp = new Campaign();
        newCamp.Name= 'test';
        newCamp.Campaign_Code__c = '123';
        newCamp.Program_Event_Name__c = 'Test';
        newCamp.Program_Event_Code__c = '123unique';
        newCamp.Program_Originating_Country__c = 'Austria';
        newCamp.Outbound_Call_Center__c = '';
        insert newCamp;
        
        newLead = searcher.CampaignCrossReference(newCamp.Id, newLead);
        System.assertEquals(newLead.Campaign_Code__c, '123');
       } 
      
      private static testMethod void campaignCrossReferenceKeycodeTest(){
        PageReference current = ApexPages.currentPage();
        Test.setCurrentPage(current);
        current.getParameters().put('sourceId', '123');
        current.getParameters().put('data-c2c-ecid', '96325');
        current.getParameters().put('data-c2c-dtid', '1235--dtid');
        current.getParameters().put('data-c2c-ccid', '8523--ccid');
        current.getParameters().put('data-c2c-oid', '8885--oid');
        
        
        Lead a = new Lead();
        ApexPages.StandardController controller = new ApexPages.StandardController(a);   
        NGCC_MODS_SFDC_Contact_Search_CTE searcher = new NGCC_MODS_SFDC_Contact_Search_CTE(controller);
        searcher.keycode = '123';
      
      
        Lead newLead = new Lead();
        Campaign newCamp = new Campaign();
        newCamp.Name= 'test';
        newCamp.Campaign_Code__c = '123';
        newCamp.Program_Event_Name__c = 'Test';
        newCamp.Program_Event_Code__c = '123unique';
        newCamp.Program_Originating_Country__c = '';
        newCamp.Outbound_Call_Center__c = 'N3 Dublin';
        insert newCamp;
        
        newLead = searcher.CampaignCrossReference(null, newLead);
       }
       
//Zak: adding test methods  
      private static testMethod void campaignCrossReferenceKeycodeNullTest(){
        PageReference current = ApexPages.currentPage();
        Test.setCurrentPage(current);
        current.getParameters().put('sourceId', '123');
        current.getParameters().put('data-c2c-ecid', '96325');
        current.getParameters().put('data-c2c-dtid', '1235--dtid');
        current.getParameters().put('data-c2c-ccid', '8523--ccid');
        current.getParameters().put('data-c2c-oid', '8885--oid');
        
        
        Lead a = new Lead();
        ApexPages.StandardController controller = new ApexPages.StandardController(a);   
        NGCC_MODS_SFDC_Contact_Search_CTE searcher = new NGCC_MODS_SFDC_Contact_Search_CTE(controller);
        searcher.keycode = ' ';

      
      
        Lead newLead = new Lead();
        Campaign newCamp = new Campaign();
        newCamp.Name= 'test';
        newCamp.Campaign_Code__c = '123';
        newCamp.Program_Event_Name__c = 'Test';
        newCamp.Program_Event_Code__c = '123unique';
        newCamp.Program_Originating_Country__c = 'Austria';
        newCamp.Outbound_Call_Center__c = 'N3 Dublin';
        insert newCamp;
        
        newLead = searcher.CampaignCrossReference('', newLead);
        System.assertEquals(newLead.Campaign_Code__c, null);
       }   
      private static testMethod void campaignCrossEcidTest(){
        PageReference current = ApexPages.currentPage();
        Test.setCurrentPage(current);
        
        Lead a = new Lead();
        ApexPages.StandardController controller = new ApexPages.StandardController(a);   
        NGCC_MODS_SFDC_Contact_Search_CTE searcher = new NGCC_MODS_SFDC_Contact_Search_CTE(controller);
        searcher.ecid = '123';
        
        Lead newLead = new Lead();
        Campaign newCamp = new Campaign();
        newCamp.Name= 'test';
        newCamp.Campaign_Code__c = '123';
        newCamp.Program_Event_Name__c = 'Test';
        newCamp.Program_Event_Code__c = '123unique';
        newCamp.Program_Originating_Country__c = 'Austria';
        newCamp.Outbound_Call_Center__c = '';
        insert newCamp;
        
        System.Debug('The NewCamp is :' +newCamp);
        newLead = searcher.CampaignCrossReference(newCamp.Id, newLead);
        System.Debug('The NewLead is :' +newLead.Campaign_Code__c + newLead);
        System.assertEquals(newLead.Campaign_Code__c, '123');
      }

      private static testMethod void campaignCrossEcidTest1(){
        PageReference current = ApexPages.currentPage();
        Test.setCurrentPage(current);
        
        Lead a = new Lead();
        ApexPages.StandardController controller = new ApexPages.StandardController(a);   
        NGCC_MODS_SFDC_Contact_Search_CTE searcher = new NGCC_MODS_SFDC_Contact_Search_CTE(controller);
        searcher.ecid = '123';
        
        Lead newLead = new Lead();
        Campaign newCamp = new Campaign();
        newCamp.Name= 'test';
        newCamp.Campaign_Code__c = '123';
        newCamp.Program_Event_Name__c = 'Test';
        newCamp.Program_Event_Code__c = '123Unique';
        newCamp.Program_Originating_Country__c = '';
        newCamp.Outbound_Call_Center__c = 'N3 Dublin';
        insert newCamp;
        
        System.Debug('The NewCamp is :' +newCamp);
        newLead = searcher.CampaignCrossReference(null, newLead);
        System.Debug('The NewLead is :' +newLead.Campaign_Code__c + newLead);
      }
      private static testMethod void campaignCrossEcidNullTest(){
        PageReference current = ApexPages.currentPage();
        Test.setCurrentPage(current);
        
        Lead a = new Lead();
        ApexPages.StandardController controller = new ApexPages.StandardController(a);   
        NGCC_MODS_SFDC_Contact_Search_CTE searcher = new NGCC_MODS_SFDC_Contact_Search_CTE(controller);
        searcher.ecid = ' ';
        
        Lead newLead = new Lead();
        Campaign newCamp = new Campaign();
        newCamp.Name= 'test';
        newCamp.Campaign_Code__c = '123';
        newCamp.Program_Event_Name__c = 'Test';
        newCamp.Program_Event_Code__c = '123Unique';
        newCamp.Program_Originating_Country__c = 'Austria';
        newCamp.Outbound_Call_Center__c = 'N3 Dublin';
        insert newCamp;
        
        System.Debug('The NewCamp is :' +newCamp);
        newLead = searcher.CampaignCrossReference('', newLead);
        System.Debug('The NewLead is :' +newLead.Campaign_Code__c + newLead);
        System.assertEquals(newLead.Campaign_Code__c, null);
      }
      private static testMethod void campaignCrossEcidKeycodeTest(){
        PageReference current = ApexPages.currentPage();
        Test.setCurrentPage(current);
        
        Lead a = new Lead();
        ApexPages.StandardController controller = new ApexPages.StandardController(a);   
        NGCC_MODS_SFDC_Contact_Search_CTE searcher = new NGCC_MODS_SFDC_Contact_Search_CTE(controller);
        searcher.ecid = '123 ';
        searcher.keycode = '123 ';
        Lead newLead = new Lead();
        Campaign newCamp = new Campaign();
        newCamp.Name= 'test';
        newCamp.Campaign_Code__c = '123';
        newCamp.Program_Event_Name__c = 'Test';
        newCamp.Program_Event_Code__c = '123Unique';
        newCamp.Program_Originating_Country__c = 'Austria';
        newCamp.Outbound_Call_Center__c = '';
        insert newCamp;
        
        System.Debug('The NewCamp is :' +newCamp);
        newLead = searcher.CampaignCrossReference(null, newLead);
        System.Debug('The NewLead is :' +newLead.Campaign_Code__c + newLead);
      }
      private static testMethod void campaignCrossEcidKeycodeSTest(){
        PageReference current = ApexPages.currentPage();
        Test.setCurrentPage(current);
        
        Lead a = new Lead();
        ApexPages.StandardController controller = new ApexPages.StandardController(a);   
        NGCC_MODS_SFDC_Contact_Search_CTE searcher = new NGCC_MODS_SFDC_Contact_Search_CTE(controller);
        searcher.ecid = '@ ';
        searcher.keycode = '123 ';
        Lead newLead = new Lead();
        Campaign newCamp = new Campaign();
        newCamp.Name= 'test';
        newCamp.Campaign_Code__c = '123';
        newCamp.Program_Event_Name__c = 'Test';
        newCamp.Program_Event_Code__c = '123Unique';
        newCamp.Program_Originating_Country__c = '';
        newCamp.Outbound_Call_Center__c = 'N3 Dublin';
        insert newCamp;
        
        System.Debug('The NewCamp is :' +newCamp);
        newLead = searcher.CampaignCrossReference(null, newLead);
        System.Debug('The NewLead is :' +newLead.Campaign_Code__c + newLead);
      }
//Zak      
      private static testMethod void convertContactTest(){
        
        Lead a = new Lead();
        ApexPages.StandardController controller = new ApexPages.StandardController(a);   
        NGCC_MODS_SFDC_Contact_Search_CTE searcher = new NGCC_MODS_SFDC_Contact_Search_CTE(controller);
      
        String email = 'test@test.com';
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
        List<NGCC_MODS_SFDC_Contact_Search_CTE.MarketingSource> sourceList = new List<NGCC_MODS_SFDC_Contact_Search_CTE.MarketingSource>(); 
        
        String modsId = '123';
        String orgId = '123';
        String mobile = 'test';
        String title = 'test';
        
        String emailPermission = 'test';
        String emailDate = 'test';
        String phonePermission = 'test';

        String phoneDate = 'test';
        String dataPermisison = 'test';
        String dataDate = 'test';
        String altphone = 'test';
        
        NGCC_MODS_SFDC_Contact_Search_CTE.MarketingContact mcl = new NGCC_MODS_SFDC_Contact_Search_CTE.MarketingContact( email, fname, lname, plang, country, phone,
                          address1, address2, address3, address4, city,
                          zip, companyName, countryName, state, sourceList,        
                          modsId, orgId, mobile, title,        
                          emailPermission, emailDate,  phonePermission,
                          phoneDate, dataPermisison, dataDate,altphone);

        
        Lead newLead = searcher.convertContact(mcl);
        System.assertEquals(newLead.title, 'test');
      }
      
      
      
      private static testMethod void automaticProspectTest(){
        
        Lead a = new Lead();
        ApexPages.StandardController controller = new ApexPages.StandardController(a);   
        NGCC_MODS_SFDC_Contact_Search_CTE searcher = new NGCC_MODS_SFDC_Contact_Search_CTE(controller);
      
        String email = 'test@test.com';
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
        List<NGCC_MODS_SFDC_Contact_Search_CTE.MarketingSource> sourceList = new List<NGCC_MODS_SFDC_Contact_Search_CTE.MarketingSource>(); 
        
        String modsId = '123';
        String orgId = '123';
        String mobile = 'test';
        String title = 'test';
        
        String emailPermission;
        String emailDate ;
        String phonePermission ;

        String phoneDate ;
        String dataPermisison ;
        String dataDate ;
        String altphone = 'test';
        NGCC_MODS_SFDC_Contact_Search_CTE.MarketingContact mcl = new NGCC_MODS_SFDC_Contact_Search_CTE.MarketingContact( email, fname, lname, plang, country, phone,
                          address1, address2, address3, address4, city,
                          zip, companyName, countryName, state, sourceList,        
                          modsId, orgId, mobile, title,        
                          emailPermission, emailDate,  phonePermission,
                          phoneDate, dataPermisison, dataDate,altphone);

        Lead l = new Lead();
        l.Company = 'test';
        l.Email = 'test@test.com';
        l.FirstName = 'test';
        l.LastName = 'test';
        l.Phone = '123123123';
        insert l;
        
          searcher.searchEmailAddress = 'test@test.com';
        searcher.searchFirstName = 'test';
        searcher.searchLastName = 'test';
        searcher.searchPhoneNumber = '123123123';
        searcher.isAutomatic = 'true';
        searcher.origLastName= searcher.searchLastName;
        searcher.validation();
        
        Lead newLead = searcher.convertContact(mcl);
        
        PageReference p = searcher.automaticProspect(mcl);
        
        
        System.assertNotEquals(p, null);
      } 
      
      private static testMethod void prepopulatedTest(){
        PageReference current = ApexPages.currentPage();
        
        Lead a = new Lead();
        current.getParameters().put('index', '0');
        
        ApexPages.StandardController controller = new ApexPages.StandardController(a);   
        NGCC_MODS_SFDC_Contact_Search_CTE searcher = new NGCC_MODS_SFDC_Contact_Search_CTE(controller);
      
        String email = 'test@test.com';
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
        List<NGCC_MODS_SFDC_Contact_Search_CTE.MarketingSource> sourceList = new List<NGCC_MODS_SFDC_Contact_Search_CTE.MarketingSource>(); 
        
        String modsId = '123';
        String orgId = '123';
        String mobile = 'test';
        String title = 'test';
        
        String emailPermission;
        String emailDate ;
        String phonePermission ;

        String phoneDate ;
        String dataPermisison ;
        String dataDate ;
        String altphone ;
        NGCC_MODS_SFDC_Contact_Search_CTE.MarketingContact mcl = new NGCC_MODS_SFDC_Contact_Search_CTE.MarketingContact( email, fname, lname, plang, country, phone,
                          address1, address2, address3, address4, city,
                          zip, companyName, countryName, state, sourceList,        
                          modsId, orgId, mobile, title,        
                          emailPermission, emailDate,  phonePermission,
                          phoneDate, dataPermisison, dataDate,altphone);
        searcher.MODS_Search();
        searcher.mcList.add(mcl);
        
        Lead l = new Lead();
        l.Company = 'test';
        l.Email = 'test@test.com';
        l.FirstName = 'test';
        l.LastName = 'test';
        l.Phone = '123123123';
        insert l;
        
        searcher.searchEmailAddress = 'test@test.com';
        searcher.searchFirstName = 'test';
        searcher.searchLastName = 'test';
        searcher.searchPhoneNumber = '123123123';
        searcher.isAutomatic = 'true';
        searcher.origLastName= searcher.searchLastName;
        searcher.validation();
        System.debug(searcher.origEmailAddress);
        
        Lead newLead = searcher.convertContact(mcl);
        PageReference p = searcher.prepopulatedProspect();
        
        System.assertNotEquals(p, null);
      }
      
      
      private static testMethod void prepopulatedNonAutoTest(){
        PageReference current = ApexPages.currentPage();
        
        Lead a = new Lead();
        current.getParameters().put('index', '0');
        
        ApexPages.StandardController controller = new ApexPages.StandardController(a);   
        NGCC_MODS_SFDC_Contact_Search_CTE searcher = new NGCC_MODS_SFDC_Contact_Search_CTE(controller);
      
        String email = 'test@test.com';
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
        List<NGCC_MODS_SFDC_Contact_Search_CTE.MarketingSource> sourceList = new List<NGCC_MODS_SFDC_Contact_Search_CTE.MarketingSource>(); 
        
        String modsId = '123';
        String orgId = '123';
        String mobile = 'test';
        String title = 'test';
        
        String emailPermission;
        String emailDate ;
        String phonePermission ;

        String phoneDate ;
        String dataPermisison ;
        String dataDate ;
        string altphone;
        NGCC_MODS_SFDC_Contact_Search_CTE.MarketingContact mcl = new NGCC_MODS_SFDC_Contact_Search_CTE.MarketingContact( email, fname, lname, plang, country, phone,
                          address1, address2, address3, address4, city,
                          zip, companyName, countryName, state, sourceList,        
                          modsId, orgId, mobile, title,        
                          emailPermission, emailDate,  phonePermission,
                          phoneDate, dataPermisison, dataDate,altphone);
        searcher.MODS_Search();
        searcher.mcList.add(mcl);
        
        Lead l = new Lead();
        l.Company = 'test';
        l.Email = 'test@test.com';
        l.FirstName = 'test';
        l.LastName = 'test';
        l.Phone = 'test';
        insert l;
        
        searcher.searchEmailAddress = 'test@test.com';
        searcher.searchFirstName = 'test';
        searcher.searchLastName = 'test';
        searcher.searchPhoneNumber = 'test';
        searcher.isAutomatic = 'false';
        searcher.validation();
        
        
        PageReference p = searcher.prepopulatedProspect();
        
        Lead newLead = searcher.convertContact(mcl);
        System.assertNotEquals(p, null);
      }
      
      
      private static testMethod void nonautomaticProspectTest(){
        
        Lead a = new Lead();
        ApexPages.StandardController controller = new ApexPages.StandardController(a);   
        NGCC_MODS_SFDC_Contact_Search_CTE searcher = new NGCC_MODS_SFDC_Contact_Search_CTE(controller);
      
        String email = 'test@test.com';
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
        List<NGCC_MODS_SFDC_Contact_Search_CTE.MarketingSource> sourceList = new List<NGCC_MODS_SFDC_Contact_Search_CTE.MarketingSource>(); 
        
        String modsId = '123';
        String orgId = '123';
        String mobile = 'test';
        String title = 'test';
        
        String emailPermission;
        String emailDate ;
        String phonePermission ;

        String phoneDate ;
        String dataPermisison ;
        String dataDate ;
         String altphone ;
        NGCC_MODS_SFDC_Contact_Search_CTE.MarketingContact mcl = new NGCC_MODS_SFDC_Contact_Search_CTE.MarketingContact( email, fname, lname, plang, country, phone,
                          address1, address2, address3, address4, city,
                          zip, companyName, countryName, state, sourceList,        
                          modsId, orgId, mobile, title,        
                          emailPermission, emailDate,  phonePermission,
                          phoneDate, dataPermisison, dataDate,altphone);

        Lead l = new Lead();
        l.Company = 'test';
        l.Email = 'test@test.com';
        l.FirstName = 'test';
        l.LastName = 'test';
        l.Phone = 'test';
        insert l;
        
        searcher.searchEmailAddress = 'test@test.com';
        searcher.searchFirstName = 'test';
        searcher.searchLastName = 'test';
        searcher.searchPhoneNumber = 'test';
        searcher.isAutomatic = 'false';
        searcher.validation();
        
        
        PageReference p = searcher.automaticProspect(mcl);
        
        Lead newLead = searcher.convertContact(mcl);
        System.assertNotEquals(p, null);
      }
          
      private static testMethod void contactLookupNonNullTest(){
        PageReference current = ApexPages.currentPage();
        Test.setCurrentPage(current);
        current.getParameters().put('sourceId', '123');
        
        Lead a = new Lead();
        ApexPages.StandardController controller = new ApexPages.StandardController(a);   
        NGCC_MODS_SFDC_Contact_Search_CTE searcher = new NGCC_MODS_SFDC_Contact_Search_CTE(controller);
      
        Lead newL = new Lead();
        Lead test1 = searcher.contactLookup(newL);
        
        System.assertEquals(newL.End_Customer_Account__c, null);
        System.assertEquals(test1.End_Customer_Account__c, null);
      }

      private static testMethod void ghostCallBasicNoInput(){
        Lead a = new Lead();
        ApexPages.StandardController controller = new ApexPages.StandardController(a);   
        NGCC_MODS_SFDC_Contact_Search_CTE searcher = new NGCC_MODS_SFDC_Contact_Search_CTE(controller);
      
        searcher.createGhostResponse();
      } 
      
      private static testMethod void ghostChatNoDispo(){
        Lead a = new Lead();
        ApexPages.StandardController controller = new ApexPages.StandardController(a);   
        NGCC_MODS_SFDC_Contact_Search_CTE searcher = new NGCC_MODS_SFDC_Contact_Search_CTE(controller);
        searcher.disposition = '';
        searcher.createGhostResponse();
        
        System.assertEquals(searcher.responseDisplayed, false);
      } 
      
      private static testMethod void ghostCallBasicInput(){
        Lead a = new Lead();
        ApexPages.StandardController controller = new ApexPages.StandardController(a);   
        NGCC_MODS_SFDC_Contact_Search_CTE searcher = new NGCC_MODS_SFDC_Contact_Search_CTE(controller);
        searcher.ghostStatus = 'Disposition Call';
        searcher.createGhostResponse();
      } 

      private static testMethod void fullNameTest(){
        Lead a = new Lead();
        ApexPages.StandardController controller = new ApexPages.StandardController(a);   
        NGCC_MODS_SFDC_Contact_Search_CTE searcher = new NGCC_MODS_SFDC_Contact_Search_CTE(controller);
        
        String input = 'Y';
        System.assertEquals(searcher.fullName(input) , 'Yes');
        
        input = 'N';
        System.assertEquals(searcher.fullName(input) , 'No');
         
        input = 'blah';
        System.assertEquals(searcher.fullName(input) , null);
         
      } 

      private static testMethod void marketingContactListConstructorTest(){
        String status = 'test'; 
        Integer total = 0;
        String message = 'test';
        List<NGCC_MODS_SFDC_Contact_Search_CTE.MarketingContact> li = new List<NGCC_MODS_SFDC_Contact_Search_CTE.MarketingContact>();
          
        NGCC_MODS_SFDC_Contact_Search_CTE.MarketingContactsList mcl = new NGCC_MODS_SFDC_Contact_Search_CTE.MarketingContactsList(status, total, message, li);
        System.assertNotEquals(mcl, null);
        
      }
      
      
      private static testMethod void marketingContactConstructorTest(){
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
        List<NGCC_MODS_SFDC_Contact_Search_CTE.MarketingSource> sourceList = new List<NGCC_MODS_SFDC_Contact_Search_CTE.MarketingSource>(); 
        
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
        string altphone ='test';
        NGCC_MODS_SFDC_Contact_Search_CTE.MarketingContact mcl = new NGCC_MODS_SFDC_Contact_Search_CTE.MarketingContact( email, fname, lname, plang, country, phone,
                          address1, address2, address3, address4, city,
                          zip, companyName, countryName, state, sourceList,        
                          modsId, orgId, mobile, title,        
                          emailPermission, emailDate,  phonePermission,
                          phoneDate, dataPermisison, dataDate,altphone);
                          
        System.assertNotEquals(mcl, null);
      
      }
       private static testMethod void getDispositionSubTypes(){
        Lead a = new Lead();
        ApexPages.StandardController controller = new ApexPages.StandardController(a);   
        NGCC_MODS_SFDC_Contact_Search_CTE searcher = new NGCC_MODS_SFDC_Contact_Search_CTE(controller);        
        List<SelectOption> li = searcher.getDispositionSubTypes();

      }
      private static testMethod void marketingSourceConstcutorTest(){
        NGCC_MODS_SFDC_Contact_Search_CTE.MarketingSource ms = new NGCC_MODS_SFDC_Contact_Search_CTE.MarketingSource();
        
        System.assertEquals(ms.Source_Record_ID, null);
      }

    public static testmethod void statusUpdatetest(){
        PageReference current = ApexPages.currentPage();
        CC_Response__c res = new CC_Response__c();
        insert res;
        
        Test.setCurrentPage(current);
        current.getParameters().put('ResponseId', res.Id);
        Lead a = new Lead();
        ApexPages.StandardController controller = new ApexPages.StandardController(a); 
        NGCC_MODS_SFDC_Contact_Search_CTE contrl = new NGCC_MODS_SFDC_Contact_Search_CTE(controller);
        contrl.disposition = 'Nurture';
        contrl.statusUpdate();
		contrl.DispositionChange();        
    }
    public static testmethod void statusUpdatetest2(){
        PageReference current = ApexPages.currentPage();
        CC_Response__c res = new CC_Response__c();
        insert res;
        
        Test.setCurrentPage(current);
        current.getParameters().put('ResponseId', res.Id);
        Lead a = new Lead();
        ApexPages.StandardController controller = new ApexPages.StandardController(a); 
        NGCC_MODS_SFDC_Contact_Search_CTE contrl = new NGCC_MODS_SFDC_Contact_Search_CTE(controller);
        contrl.disposition = 'Max Attempt Reached';
        contrl.statusUpdate();        
    }
 }