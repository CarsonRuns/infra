@isTest(SeeAllData = true)
public class NGCC_LeadUtilities_Test {
    public static testMethod void NGCC_LeadUtilities_SaveResponse_Test() {
        User uSDR = NGCC_CallScript_Data_Test.testSDRUser('sdr8@cisco.com');
                                      
        System.runAs(uSDR) {
             Lead lstLead= NGCC_CallScript_Data_Test.testLead();  
             Test.setCurrentPageReference(New PageReference('Page.NGCC_LeadUtitlities'));
             ApexPages.StandardController stdCtlLead = New ApexPages.StandardController(lstLead);       
             
             NGCC_LeadUtitlities_CTE ngccUtilities = new NGCC_LeadUtitlities_CTE(stdCtlLead);
                Test.startTest();    
                   Test.setMock(HttpCalloutMock.class, new NGCC_CRAddressValidationCallout_Mock());
                   ngccUtilities.cmdValidateAddress();               
                   ngccUtilities.cmdCallScript();
                   ngccUtilities.response.Response_Type__c = 'Inbound Call';
                   ngccUtilities.response.Status__c = 'Call Back';
                   ngccUtilities.statusUpdate();
                    try 
                    {
                        ngccUtilities.saveResponse();
                    }
                    catch(Exception e)
                    {
                        
                        Boolean expectingException =  e.getMessage().contains('Call Back Time')?true:false;
                        System.AssertEquals(expectingException, true);
                    } 
                   ngccUtilities.response.Status__c = 'Left Company';
                   ngccUtilities.statusUpdate();
                   ngccUtilities.saveResponse();
                   ngccUtilities.response.Status__c = 'Refer a New Contact';
                   ngccUtilities.statusUpdate();
                   ngccUtilities.saveResponse();
                Test.stopTest(); 
            
        }       
    }
    public static testMethod void NGCC_LeadUtilities_ReferaContact_Neg_Test() {
        User uSDR = NGCC_CallScript_Data_Test.testSDRUser('sdr8@cisco.com');
                                      
        System.runAs(uSDR) {
             Lead lstLead= NGCC_CallScript_Data_Test.testLead();  
             Test.setCurrentPageReference(New PageReference('Page.NGCC_LeadUtitlities'));
             ApexPages.StandardController stdCtlLead = New ApexPages.StandardController(lstLead);       
             
             NGCC_LeadUtitlities_CTE ngccUtilities = new NGCC_LeadUtitlities_CTE(stdCtlLead);
                Test.startTest();                   
                   ngccUtilities.cmdCallScript();
                   ngccUtilities.response.Response_Type__c = 'Inbound Call';
                   ngccUtilities.response.Status__c = 'Refer a New Contact';
                   ngccUtilities.statusUpdate();
                   ngccUtilities.saveResponse();
                Test.stopTest(); 
            
        }       
    }
    public static testMethod void NGCC_LeadUtilities_ReferaContact_Pos_Test() {
        User uSDR = NGCC_CallScript_Data_Test.testSDRUser('sdr8@cisco.com');
                                      
        System.runAs(uSDR) {
             Lead lstLead= NGCC_CallScript_Data_Test.testLead();  
             lstLead.Address_Line_1__c = '175 W Tasman';
             lstLead.Address_Line_2__c = 'Dr';
             lstLead.Address_Line_3__c = '1st Floor';
             lstLead.CustomCity__c='San Jose';
             lstLead.CustomZip__c='95134';
             lstLead.CustomCountry__c ='UNITED STATES';
             update lstLead;
             Test.setCurrentPageReference(New PageReference('Page.NGCC_LeadUtitlities'));
             ApexPages.StandardController stdCtlLead = New ApexPages.StandardController(lstLead);       
             
             NGCC_LeadUtitlities_CTE ngccUtilities = new NGCC_LeadUtitlities_CTE(stdCtlLead);
                Test.startTest();                   
                   ngccUtilities.cmdCallScript();
                   ngccUtilities.response.Response_Type__c = 'Inbound Call';
                   ngccUtilities.response.Status__c = 'Refer a New Contact';
                   ngccUtilities.statusUpdate();
                   ngccUtilities.saveResponse();
                Test.stopTest(); 
            
        }       
    }
    
    public static testMethod void NGCC_LeadUtilities_Cancel_Pos_Test() {
        User uSDR = NGCC_CallScript_Data_Test.testSDRUser('sdr8@cisco.com');
                                      
        System.runAs(uSDR) {
             Lead lstLead= NGCC_CallScript_Data_Test.testLead();  
             
             Test.setCurrentPageReference(New PageReference('Page.NGCC_LeadUtitlities'));
             ApexPages.StandardController stdCtlLead = New ApexPages.StandardController(lstLead);       
             
             NGCC_LeadUtitlities_CTE ngccUtilities = new NGCC_LeadUtitlities_CTE(stdCtlLead);
                Test.startTest();                   
                   ngccUtilities.cmdCancelLead();
                   lstLead.Lead_Cancel_Reason__c = 'Project Cancelled';
                    ngccUtilities.cmdProcessCancelLead();
                Test.stopTest(); 
            
        }       
    }
    
    public static testMethod void NGCC_LeadUtilities_Cancel_Test() {
        User uSDR = NGCC_CallScript_Data_Test.testSDRUser('sdr8@cisco.com');
                                      
        System.runAs(uSDR) {
             Lead lstLead= NGCC_CallScript_Data_Test.testLead();  
             Test.setCurrentPageReference(New PageReference('Page.NGCC_LeadUtitlities'));
             ApexPages.StandardController stdCtlLead = New ApexPages.StandardController(lstLead);       
             
             NGCC_LeadUtitlities_CTE ngccUtilities = new NGCC_LeadUtitlities_CTE(stdCtlLead);
                Test.startTest();                   
                  ngccUtilities.cmdCancel();                  
                Test.stopTest(); 
            
        }       
    }
    
    public static testMethod void NGCC_LeadUtilities_LaunchCS_Pos_Test() {
        
          //User uSMgr = [SELECT Id FROM User WHERE isActive = True and UserRole.Name Like '%Site Manager Alea (Canada)%' Limit 1];
          User uSDR = NGCC_CallScript_Data_Test.testSDRUser('sdr8@cisco.com');
        User uSMgr = NGCC_CallScript_Data_Test.testSMUser();
        uSMgr.Email = 'NewuSMgr@cisco.com';
        System.runAs(uSMgr ) {
            PermissionSet ps = [SELECT Id from PermissionSet where Name like '%NGCC_Call_Script_Super_User%'];
            PermissionSetAssignment psAssignment = new PermissionSetAssignment();
            psAssignment.AssigneeId = uSMgr.Id;
            psAssignment.PermissionSetId = ps.Id;
            insert psAssignment;
            
            CC_Master_Question_Answer_Bank__c ccMQA = NGCC_CallScript_Data_Test.testNGCC_Call_Script_MasterQA('Number');
                insert ccMQA;
    
                CC_Call_Script__c ccCS = NGCC_CallScript_Data_Test.test_Call_Script();
                CC_Call_Script_Q_A__c ccCSQA = NGCC_CallScript_Data_Test.testNGCC_Call_Script_Call_Script_QA(ccCS, ccMQA);
                insert ccCSQA;
    
                ccCS.Status__c = 'Active';
                Update ccCS;
                
            Campaign camCS = NGCC_CallScript_Data_Test.testCampaign();
                camCS.Call_Script__c = ccCS.Id;
                Update camCS;
        
                                              
        System.runAs(uSDR) {
             //Lead lstLead= NGCC_CallScript_Data_Test.testLead();  
             Lead leadCS = NGCC_CallScript_Data_Test.testLead();
                
    
                leadCS.Campaign_Name__c = camCS.Id;
                update leadCS;
                
             Test.setCurrentPageReference(New PageReference('Page.NGCC_LeadUtitlities'));
             ApexPages.StandardController stdCtlLead = New ApexPages.StandardController(leadCS );       
             
             NGCC_LeadUtitlities_CTE ngccUtilities = new NGCC_LeadUtitlities_CTE(stdCtlLead);
                Test.startTest();                   
                   ngccUtilities.cmdCallScript();
                   ngccUtilities.response.Response_Type__c = 'Inbound Call';
                   ngccUtilities.response.Call_Script__c = ccCS.Id;
                   ngccUtilities.response.language__c = 'English : en_US';
                   ngccUtilities.launchCallScript();
                Test.stopTest(); 
            
        }       
    }
    }
    public static testMethod void NGCC_LeadUtilities_CSExisting_Pos_Test() {
        User uSDR = NGCC_CallScript_Data_Test.testSDRUser('sdr8@cisco.com');
        //User uSMgr = [SELECT Id FROM User WHERE isActive = True and UserRole.Name Like '%Site Manager Alea (Canada)%' Limit 1];
        User uSMgr = NGCC_CallScript_Data_Test.testSMUser();
        uSMgr.Email ='uSMgr8@cisco.com';
        System.runAs(uSMgr ) {
            PermissionSet ps = [SELECT Id from PermissionSet where Name like '%NGCC_Call_Script_Super_User%'];
            PermissionSetAssignment psAssignment = new PermissionSetAssignment();
            psAssignment.AssigneeId = uSMgr.Id;
            psAssignment.PermissionSetId = ps.Id;
            insert psAssignment;
            
            List < CC_Call_Script_Q_A__c > ccCallScriptQA = NGCC_CallScript_Data_Test.testCall_Script_QA();
    
            //Activating the call Script
            CC_Call_Script__c ccCS = [Select Id from CC_Call_Script__c where Id = : ccCallScriptQA[0].Call_Script__c];
            ccCS.Status__c = 'Active';

            update ccCS;

           
            Campaign camCS = NGCC_CallScript_Data_Test.testCampaign();
            camCS.Call_Script__c = ccCS.Id;
            Update camCS;

            //leadCS.Campaign_Name__c = camCS.Id;
            //update leadCS;
                
            
                                              
        System.runAs(uSDR) {
                Lead leadCS = NGCC_CallScript_Data_Test.testLead();   
                //Creating Responses
            CC_Response__c ccRes = New CC_Response__c();
            ccRes.Name = leadCS.Name + System.Now();
            ccRes.Call_Script__c = leadCS.Campaign_Name__r.Call_Script__c;
            ccRes.Lead__c = leadCS.Id;
            ccRes.Campaign__c = leadCS.Campaign_Name__c;
            ccRes.Key_Code__c = leadCS.ProgramEvent__c;
            ccRes.Source_Event_Number__c = leadCS.Source_Event_Number__c;
            ccRes.Source_System_Name__c = 'NGCC';
            ccRes.Call_Script_Executed__c = true;
            insert ccRes;

            //Creating Response Detail
            List < CC_Response_Detail__c > newResDetail = new List < CC_Response_Detail__c > ();
            integer i = 1;

            for (CC_Call_Script_Q_A__c csQA: ccCallScriptQA ) {
                CC_Response_Detail__c newDetail = NGCC_CallScript_Data_Test.testNGCC_Call_Script_Response_Detail(ccCS, ccRes, csQA);
                newResDetail.add(newDetail);
            }
            insert newResDetail;            
             Test.setCurrentPageReference(New PageReference('Page.NGCC_LeadUtitlities'));
             ApexPages.StandardController stdCtlLead = New ApexPages.StandardController(leadCS );       
             system.debug('iiiiiiiiiiiiiiiiii'+leadCS);
             NGCC_LeadUtitlities_CTE ngccUtilities = new NGCC_LeadUtitlities_CTE(stdCtlLead);
                Test.startTest();                   
                   ngccUtilities.cmdCallScript();
                   ngccUtilities.response.Response_Type__c = 'Inbound Call';
                   ngccUtilities.response.Call_Script__c = ccCS.Id;
                   ngccUtilities.response.language__c = 'English : en_US';
                   ngccUtilities.launchCallScript();
                Test.stopTest(); 
            
        }       
    }
    }
    public static testMethod void NGCC_LeadUtilities_CSExisting_MODS_Pos_Test() {
        User uSDR = NGCC_CallScript_Data_Test.testSDRUser('sdr8@cisco.com');
        //User uSMgr = [SELECT Id FROM User WHERE isActive = True and UserRole.Name Like '%Site Manager Alea (Canada)%' LIMIT 1 ];
        User uSMgr = NGCC_CallScript_Data_Test.testSMUser();
        uSMgr.Email ='uSMgr@cisco.com';
        System.runAs(uSMgr ) {
            PermissionSet ps = [SELECT Id from PermissionSet where Name like '%NGCC_Call_Script_Super_User%'];
            PermissionSetAssignment psAssignment = new PermissionSetAssignment();
            psAssignment.AssigneeId = uSMgr.Id;
            psAssignment.PermissionSetId = ps.Id;
            insert psAssignment;
            
            List < CC_Call_Script_Q_A__c > ccCallScriptQA = NGCC_CallScript_Data_Test.testCall_Script_QA();
    
            //Activating the call Script
            CC_Call_Script__c ccCS = [Select Id from CC_Call_Script__c where Id = : ccCallScriptQA[0].Call_Script__c];
            ccCS.Status__c = 'Active';

            update ccCS;

           
            Campaign camCS = NGCC_CallScript_Data_Test.testCampaign();
            camCS.Call_Script__c = ccCS.Id;
            Update camCS;

            //leadCS.Campaign_Name__c = camCS.Id;
            //update leadCS;
                
            
                                              
        System.runAs(uSDR) {
                Lead leadCS = NGCC_CallScript_Data_Test.testLead();   
                //Creating Responses
            CC_Response__c ccRes = New CC_Response__c();
            ccRes.Name = leadCS.Name + System.Now();
            ccRes.Call_Script__c = leadCS.Campaign_Name__r.Call_Script__c;
            ccRes.Lead__c = leadCS.Id;
            ccRes.Campaign__c = leadCS.Campaign_Name__c;
            ccRes.Key_Code__c = leadCS.ProgramEvent__c;
            ccRes.Source_Event_Number__c = leadCS.Source_Event_Number__c;
            ccRes.Source_System_Name__c = 'NGCC';
            insert ccRes;

            //Creating Response Detail
            List < CC_Response_Detail__c > newResDetail = new List < CC_Response_Detail__c > ();
            integer i = 1;

            for (CC_Call_Script_Q_A__c csQA: ccCallScriptQA ) {
                CC_Response_Detail__c newDetail = NGCC_CallScript_Data_Test.testNGCC_Call_Script_Response_Detail(ccCS, ccRes, csQA);
                newResDetail.add(newDetail);
            }
            insert newResDetail;            
             Test.setCurrentPageReference(New PageReference('Page.NGCC_LeadUtitlities'));
             ApexPages.StandardController stdCtlLead = New ApexPages.StandardController(leadCS );       
             system.debug('iiiiiiiiiiiiiiiiii'+leadCS);
             NGCC_LeadUtitlities_CTE ngccUtilities = new NGCC_LeadUtitlities_CTE(stdCtlLead);
                Test.startTest();                   
                   ngccUtilities.cmdCallScript();
                   ngccUtilities.response.Response_Type__c = 'Inbound Call';
                   ngccUtilities.response.Call_Script__c = ccCS.Id;
                   ngccUtilities.response.language__c = 'English : en_US';
                   ngccUtilities.launchCallScript();
                Test.stopTest(); 
            
        }
       
      }
    }
    public static testmethod  void ApprovalForEMEAR (){
    User uSDR;
    Lead l;
    Campaign camp;
    User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
    System.runAs ( thisUser ) {  
    
    camp = new Campaign(Name='Testing Campaign',
                            Program_Event_Name__c = 'Program_Event_Name__c',
                            Offer_Description__c = 'Offer_Description__c',
                            Offer_URL__c = 'Offer_URL__c',
                            Primary_Technology__c = 'Primary_Technology__c',
                            Campaign_Code__c = 'Campaign_Code__c',
                            Description = 'Campaign_Description__c',
                            Program_Event_Description__c = 'Program_Event_Description__c',
                            Offer_Name__c = 'Offer_Name__c',
                            Offer_Architecture__c = 'Offer_Architecture__c'

        );
        insert camp;
        
        ObjectRecordTypeIds__c orgConstant = ObjectRecordTypeIds__c.getInstance(); 
        Id marketingRecId = orgConstant.Marketing_Lead_RecordType__c;
        l= new Lead();
        l.RecordTypeId=marketingRecId;
        l.Status = 'New Prospect';
        l.LastName = 'TestLast';
        l.Company = 'Test Company';
        l.Campaign_Name__c = camp.Id;
        l.CustomCountry__c = 'EGYPT';
        l.Theater__c = 'EMEAR';
        insert l;
        
        Profile p = [SELECT Id FROM Profile WHERE Name Like '%NGCC'
                    Limit 1];
        
        UserRole rSDR = [SELECT Id FROM UserRole WHERE Name Like 'NGCC-SDR Raya (Egypt)'
                            Limit 1];
        uSDR = new User(Alias = 'newUser', Email = 'newuserSM@cisco.com',
                    EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',
                    LocaleSidKey = 'en_US', ProfileId = p.Id, UserRoleId = rSDR.id,Marketing_Call_Center__c = 'Raya Cairo Egypt',
                    TimeZoneSidKey = 'America/Los_Angeles', UserName = 'newuserSDR@cisco.com.reg', Theatre__c = 'EMEAR');
          
        insert uSDR;
        }
        ApexPages.StandardController sc = new ApexPages.standardController(l);
        NGCC_LeadUtitlities_CTE ngccl = new NGCC_LeadUtitlities_CTE (sc);
        System.runAs(uSDR){
            ngccl.cmdApprove();
        }
        
        System.runAs(uSDR){
        RecordType r = new RecordType();
        r=[select Id,Name from Recordtype where SobjectType='Lead' and Name='Prospect' limit 1];
            Lead leadOne= new Lead();
            leadOne.RecordTypeId = r.Id;
            leadOne.Status = 'New Prospect';
            leadOne.LastName = 'TestLast';
            leadOne.Company = 'Test Company';
            leadOne.Campaign_Name__c = camp.ID;
            leadOne.CustomCountry__c = 'EGYPT';
            leadOne.Theater__c = 'EMEAR';
            leadOne.Medium_Type__c = 'Inbound Chat';
            leadOne.DeduperProcessing__c = true;
            insert leadOne;
            
            System.runAs(thisUser){
            leadOne.status = 'Marketing Qualified'; 
            update leadOne;
            System.assertEquals(leadOne.Status, 'Marketing Qualified'); // Added by Awnish to validate the lead status
            } 
            ApexPages.StandardController sc1 = new ApexPages.standardController(leadOne);
            NGCC_LeadUtitlities_CTE ngccLeadOne = new NGCC_LeadUtitlities_CTE (sc1);
            ngccLeadOne.cmdSubmitForApproval ();
            System.runAs(thisUser){
            leadOne.Status ='Approval Pending';
            update leadOne;
            System.assertEquals(leadOne.Status, 'Approval Pending'); // Added by Awnish to validate the lead status
            }
            
        System.runAs(uSDR){
            ngccLeadOne.approvalNeeded();
        }
            ngccLeadOne.cmdReject();
            ngccLeadOne.cmdRequalify();
            ngccLeadOne.processApprovalRejected();
            ngccLeadOne.cmdApprove();
        }
       }
       public static testmethod  void cmdSendToSales (){
        Campaign camCS = NGCC_CallScript_Data_Test.testCampaign();
        
        RecordType r1 = new RecordType();
        r1=[select Id,Name from Recordtype where SobjectType='Lead' and Name='Prospect' limit 1];
        
        Lead l= new Lead();
        l.RecordTypeId = r1.Id;
        l.Status = 'Approved';
        l.LastName = 'TestLast';
        l.Company = 'Test Company';
        l.Campaign_Name__c = camCS.ID;
        l.CustomCountry__c = 'EGYPT';
        l.Theater__c = 'EMEAR';
        l.DeduperProcessing__c = true;
        insert l;
        
        ApexPages.StandardController sc = new ApexPages.standardController(l);
        NGCC_LeadUtitlities_CTE ngccl = new NGCC_LeadUtitlities_CTE (sc);
        ngccl.cmdSendToSales();
            
        } 
        
      
       public static testmethod  void approvalNeeded()
   {
   
           
            RecordType r1 = new RecordType();
            Campaign camp;
            User usm,u2,Manager1,Manager2;
            Lead l;
            User Admin = [Select Id from User where Id=:UserInfo.getUserId()];
            system.runAs(Admin)
            {
             camp = new Campaign(Name='Testing Campaign',
                            Program_Event_Name__c = 'Program_Event_Name__c',
                            Offer_Description__c = 'Offer_Description__c',
                            Offer_URL__c = 'Offer_URL__c',
                            Primary_Technology__c = 'Primary_Technology__c',
                            Campaign_Code__c = 'Campaign_Code__c',
                            Description = 'Campaign_Description__c',
                            Program_Event_Description__c = 'Program_Event_Description__c',
                            Offer_Name__c = 'Offer_Name__c',
                            Offer_Architecture__c = 'Offer_Architecture__c'
                );
             insert camp;
             
             r1=[select Id,Name from Recordtype where SobjectType='Lead' and Name='Prospect' limit 1];
             
             //Insert SM user..
             Profile p = [SELECT Id FROM Profile WHERE Name Like '%NGCC'
                    Limit 1];
             UserRole rSM = [SELECT Id FROM UserRole WHERE Name Like 'NGCC-CC Site Manager Raya (Egypt)'
                    Limit 1];
        
             uSM = new User(Alias = 'newUser', Email = 'newuserSM@cisco.com',
                    EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',
                    LocaleSidKey = 'en_US', ProfileId = p.Id, UserRoleId = rSM.id,Marketing_Call_Center__c = 'Raya Cairo Egypt',
                    TimeZoneSidKey = 'America/Los_Angeles', UserName = 'newuserSM@cisco.com.reg', Theatre__c = 'EMEAR');
             insert uSM;
             
             Manager1 = new User(Alias = 'newUser', Email = 'newuserSM@cisco.com',
                    EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',
                    LocaleSidKey = 'en_US', ProfileId = p.Id, UserRoleId = rSM.id,Marketing_Call_Center__c = 'Raya Cairo Egypt',
                    TimeZoneSidKey = 'America/Los_Angeles', UserName = 'newuserMgr1@cisco.com.reg', Theatre__c = 'EMEAR');
             insert Manager1;
             
             Manager2 = new User(Alias = 'newUser', Email = 'newuserSM2@cisco.com',
                    EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',
                    LocaleSidKey = 'en_US', ProfileId = p.Id, UserRoleId = rSM.id,Marketing_Call_Center__c = 'Raya Cairo Egypt',
                    TimeZoneSidKey = 'America/Los_Angeles', UserName = 'newuserMgr2@cisco.com.reg', Theatre__c = 'EMEAR');
             insert Manager2;
             
             //Insert SDR user
             UserRole rSDR = [SELECT Id FROM UserRole WHERE Name Like 'NGCC-SDR Raya (Egypt)'
                            Limit 1];
             u2 = new User(Alias = 'newUser', Email = 'newuserSM@cisco.com',
                    EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',
                    LocaleSidKey = 'en_US', ProfileId = p.Id, UserRoleId = rSDR.id,Marketing_Call_Center__c = 'Raya Cairo Egypt',
                    TimeZoneSidKey = 'America/Los_Angeles', UserName = 'newuserSDR@cisco.com.reg', Theatre__c = 'EMEAR');
          
             insert u2;
            
             l= new Lead();
             l.RecordTypeId = r1.Id;
             l.Status = 'Approval Pending';
             l.LastName = 'TestLast';
             l.Company = 'Test Company';
             l.Campaign_Name__c = camp.ID;
             l.CustomCountry__c = 'EGYPT';
             l.Theater__c = 'EMEAR';
             l.OwnerId = uSM.id;
             l.DeduperProcessing__c = true;
             insert l;
             
            }
            
            ApexPages.StandardController sc = new ApexPages.standardController(l);
            NGCC_LeadUtitlities_CTE ngccl = new NGCC_LeadUtitlities_CTE (sc);
            ngccl.approvalNeeded();
            
            System.runAs(uSM){
                ngccl.approvalNeeded();
            }
           
            Lead ld2;
            system.runAs(Admin)
            {
            
             ld2= new Lead();
                ld2.RecordTypeId = r1.Id;
                ld2.Status = 'Marketing Qualified';
                ld2.LastName = 'TestLast';
                ld2.Company = 'Test Company';
                ld2.Campaign_Name__c = camp.ID;
                ld2.CustomCountry__c = 'EGYPT';
                ld2.Theater__c = 'EMEAR';
                ld2.Cisco_Contact_Center_Manager1__c = Manager1.id;//'00580000007HKIK';// query the managers 
                ld2.Cisco_Contact_Center_Manager2__c= Manager2.id; //'00580000007HKIK';
                ld2.OwnerId = u2.id;
				ld2.DeduperProcessing__c = true;
                insert ld2;
            }
            ApexPages.StandardController sc1 = new ApexPages.standardController(ld2);
            NGCC_LeadUtitlities_CTE ngccl2 = new NGCC_LeadUtitlities_CTE (sc1);
            //user u3 =[SELECT Id,UserRoleId,UserRole.Name FROM User WHERE UserRole.Name LIKE 'NGCC-CC Site Manager Raya (Egypt)' AND isActive = true AND id NOT in:userIds limit 1]; 
            System.runAs(u2)
            {    
                //ngccl2.cmdSubmitForApproval();
                //ngccl2.approvalNeeded();
                ngccl2.assignvalue();
            }
            System.runAs(uSM)
            {    
                ngccl2.processApprovalEMEAR();
                //ngccl2.assignvalue();
            }
     }
     
     
        public static testmethod  void cancelLead(){
        
            Campaign camp = NGCC_CallScript_Data_Test.testCampaign();
            
            RecordType r1 = new RecordType();
            r1=[select Id,Name from Recordtype where SobjectType='Lead' and Name='Prospect' limit 1];
            
            Lead l= new Lead();
            l.RecordTypeId = r1.Id;
            l.Status = 'Approval Pending';
            l.LastName = 'TestLast';
            l.Company = 'Test Company';
            l.Campaign_Name__c = camp.ID;
            l.CustomCountry__c = 'EGYPT';
            l.Theater__c = 'EMEAR';
            l.Lead_Cancel_Reason__c = 'Test Cancel Reason';
            l.DeduperProcessing__c = true;
            insert l;
            
            ApexPages.StandardController sc = new ApexPages.standardController(l);
            NGCC_LeadUtitlities_CTE ngccLead = new NGCC_LeadUtitlities_CTE (sc);
            ngccLead.cmdProcessCancelLead();
        }
        
        public static testMethod void getCustomPicklistNotes(){
            
            RecordType r1 = new RecordType();
            r1=[select Id,Name from Recordtype where SobjectType='Lead' and Name='Prospect' limit 1];
            Campaign camCS = NGCC_CallScript_Data_Test.testCampaign();
            Lead leadDetail = new Lead();
            leadDetail.RecordTypeId = r1.Id;
            leadDetail.Status = 'Approval Pending';
            leadDetail.LastName = 'TestLast';
            leadDetail.Company = 'Test Company';
            leadDetail.Campaign_Name__c = camCS.ID;
            leadDetail.CustomCountry__c = 'EGYPT';
            leadDetail.Theater__c = 'EMEA';
            leadDetail.Lead_Cancel_Reason__c = 'Test Cancel Reason';
            leadDetail.DeduperProcessing__c = true;
            insert leadDetail;
            
            CC_Call_Script__c ccCS = NGCC_CallScript_Data_Test.test_Call_Script();
            ccCS.Theater__c = 'EMEA';
            update ccCS;
            
            CC_Response__c response = new CC_Response__c();
            response.status__c = 'Ghost Chat';
            response.Name = leadDetail.Name + System.Now();
            response.Call_Script__c = leadDetail.Campaign_Name__r.Call_Script__c;
            response.Lead__c = leadDetail.Id;
            response.AM_Email_Id__c = leadDetail.Route_to_AM__r.Email;
            response.Campaign__c = leadDetail.Campaign_Name__c;
            response.Key_Code__c = leadDetail.ProgramEvent__c;
            response.Call_Script__c = ccCS.Id;
            response.Source_Event_Number__c = leadDetail.Source_Event_Number__c;
            response.Source_System_Name__c = 'NGCC';
            response.Response_Type__c = leadDetail.Medium_Type__c;
            response.Notes__c = 'Technical Support' ;
            insert response;
            
            ApexPages.StandardController sc = new ApexPages.standardController(leadDetail);
            NGCC_LeadUtitlities_CTE ngccLead = new NGCC_LeadUtitlities_CTE (sc);
            ngccLead.getCustomPicklistForNotes();
            ngccLead.response = response;
            ngccLead.saveResponse();
            
        }
        
        public static testmethod  void otherMethods ()
    {        
            Campaign camCS = NGCC_CallScript_Data_Test.testCampaign();
            Lead  l = new Lead();
             
            ObjectRecordTypeIds__c orgConstant = ObjectRecordTypeIds__c.getInstance(); 
            Id marketingRecId = orgConstant.Marketing_Lead_RecordType__c;
            l= new Lead();
            l.RecordTypeId=marketingRecId;
            l.Status = 'Approval Pending';
            l.LastName = 'TestLast';
            l.Company = 'Test Company';
            l.Campaign_Name__c = camCS.Id;
            l.CustomCountry__c = 'EGYPT';
            l.Theater__c = 'EMEAR';
            l.Medium_Type__c = 'Test';
        	l.DeduperProcessing__c = true;
            insert l;  
               
            Test.setCurrentPageReference(New PageReference('Page.NGCC_LeadUtitlities'));
            ApexPages.StandardController stdCtlLead = New ApexPages.StandardController(l);       
            
            NGCC_LeadUtitlities_CTE ngccUtilities = new NGCC_LeadUtitlities_CTE(stdCtlLead);
            Test.startTest(); 
               ngccUtilities.response = new CC_Response__c ();
               ngccUtilities.response.language__c = 'English: US';           
               ngccUtilities.cmdSubmitForApproval();      
               ngccUtilities.setIsInConsoleMode();
               ngccUtilities.launchCallScript();
               ngccUtilities.resetRefresh();
               
               ngccUtilities.response.Status__c = 'Ghost Chat';
               ngccUtilities.dropdownNote = '- Not Specified -';
               ngccUtilities.saveResponse();
               ngccUtilities.dropdownNote = '';
               ngccUtilities.saveResponse();
               ngccUtilities.processApprovalEMEAR();
               
            Test.stopTest();
    } 
   
    static testMethod void testNegetive(){

        CC_Call_Script__c ccCS = NGCC_CallScript_Data_Test.test_Call_Script();
        Campaign camCS = NGCC_CallScript_Data_Test.testCampaign();
        camCS.Call_Script__c = ccCS.Id;
        Update camCS;
        
        Lead leadCS = NGCC_CallScript_Data_Test.testLead();
        leadCS.Campaign_Name__c = camCS.Id;
        leadCS.Theater__c = null;
        update leadCS;
        
        ccCS.Theater__c = null;
        update ccCS;
            
        CC_Response__c response = new CC_Response__c();
        response.status__c = 'Ghost Chat';
        response.Name = leadCS.Name + System.Now();
        response.Call_Script__c = ccCS.Id;
        response.Lead__c = leadCS.Id;
        response.AM_Email_Id__c = leadCS.Route_to_AM__r.Email;
        response.Campaign__c = leadCS.Campaign_Name__c;
        response.Key_Code__c = leadCS.ProgramEvent__c;
        response.Call_Script__c = ccCS.Id;
        response.Source_Event_Number__c = leadCS.Source_Event_Number__c;
        response.Source_System_Name__c = 'NGCC';
        response.Response_Type__c = 'Inbound Call';
        response.Notes__c = 'Technical Support' ;
        response.language__c = 'English : en_US';
        //insert response;
        
        Test.setCurrentPageReference(New PageReference('Page.NGCC_LeadUtitlities'));
        ApexPages.StandardController stdCtlLead = New ApexPages.StandardController(leadCS );       
        
        NGCC_LeadUtitlities_CTE ngccUtilities = new NGCC_LeadUtitlities_CTE(stdCtlLead);
        Test.startTest();                   
           ngccUtilities.cmdCallScript();           
           ngccUtilities.launchCallScript();
           ngccUtilities.response = response;
          
           ngccUtilities.saveResponse();
        Test.stopTest(); 
    }
    
    static testMethod void testNegetiveResponse(){

        CC_Call_Script__c ccCS = NGCC_CallScript_Data_Test.test_Call_Script();
        Campaign camCS = NGCC_CallScript_Data_Test.testCampaign();
        camCS.Call_Script__c = ccCS.Id;
        Update camCS;
        
        Lead leadCS = NGCC_CallScript_Data_Test.testLead();
        leadCS.Campaign_Name__c = camCS.Id;
        leadCS.Theater__c = null;
        update leadCS;
        
        ccCS.Theater__c = null;
        update ccCS;
            
        CC_Response__c response = new CC_Response__c();
        response.status__c = 'Refer a New Contact';
        response.Name = leadCS.Name + System.Now();
        response.Call_Script__c = ccCS.Id;
        response.Lead__c = leadCS.Id;
        response.AM_Email_Id__c = leadCS.Route_to_AM__r.Email;
        response.Campaign__c = leadCS.Campaign_Name__c;
        response.Key_Code__c = leadCS.ProgramEvent__c;
        response.Call_Script__c = ccCS.Id;
        response.Source_Event_Number__c = leadCS.Source_Event_Number__c;
        response.Source_System_Name__c = 'NGCC';
        response.Response_Type__c = 'Inbound Call';
        response.Notes__c = 'Technical Support' ;
        response.language__c = 'English : en_US';
        //insert response;
        
        Test.setCurrentPageReference(New PageReference('Page.NGCC_LeadUtitlities'));
        ApexPages.StandardController stdCtlLead = New ApexPages.StandardController(leadCS );       
        
        NGCC_LeadUtitlities_CTE ngccUtilities = new NGCC_LeadUtitlities_CTE(stdCtlLead);
        Test.startTest();                   
           ngccUtilities.cmdCallScript();           
           ngccUtilities.launchCallScript();
           ngccUtilities.response = response;
           ngccUtilities.saveResponse();
           ngccUtilities.cmdSubmitForApproval();
           ngccUtilities.processApprovalEMEAR();
        Test.stopTest(); 
    } 
    static testMethod void testApprovalProcess(){

        CC_Call_Script__c ccCS = NGCC_CallScript_Data_Test.test_Call_Script();
        Campaign camCS = NGCC_CallScript_Data_Test.testCampaign();
        camCS.Call_Script__c = ccCS.Id;
        Update camCS;
        
        Lead leadCS = NGCC_CallScript_Data_Test.testLead();
        leadCS.Campaign_Name__c = camCS.Id;
        leadCS.Theater__c = 'Americas';
        update leadCS;
        
        ccCS.Theater__c = null;
        update ccCS;
            
        CC_Response__c response = new CC_Response__c();
        response.status__c = 'Refer a New Contact';
        response.Name = leadCS.Name + System.Now();
        response.Call_Script__c = ccCS.Id;
        response.Lead__c = leadCS.Id;
        response.AM_Email_Id__c = leadCS.Route_to_AM__r.Email;
        response.Campaign__c = leadCS.Campaign_Name__c;
        response.Key_Code__c = leadCS.ProgramEvent__c;
        response.Call_Script__c = ccCS.Id;
        response.Source_Event_Number__c = leadCS.Source_Event_Number__c;
        response.Source_System_Name__c = 'NGCC';
        response.Response_Type__c = 'Inbound Call';
        response.Notes__c = 'Technical Support' ;
        response.language__c = 'English : en_US';
        //insert response;
        
        Test.setCurrentPageReference(New PageReference('Page.NGCC_LeadUtitlities'));
        ApexPages.StandardController stdCtlLead = New ApexPages.StandardController(leadCS );       
        
        NGCC_LeadUtitlities_CTE ngccUtilities = new NGCC_LeadUtitlities_CTE(stdCtlLead);
        Test.startTest();                   
           ngccUtilities.cmdCallScript();           
           ngccUtilities.launchCallScript();
           ngccUtilities.response = response;
           ngccUtilities.saveResponse();
           ngccUtilities.cmdSubmitForApproval();
           ngccUtilities.processApprovalEMEAR();
        Test.stopTest(); 
    }       
    @isTest
    public static void NGCC_LeadUtilities_ReferaContact_No_Test() {
        User uSDR = NGCC_CallScript_Data_Test.testSDRUser('sdr8@cisco.com');
                                      
        System.runAs(uSDR) {
             Lead lstLead= NGCC_CallScript_Data_Test.testLead();
            lstLead.Theater__c = 'Americas';
            update lstLead;
            CC_Call_Script__c callScript = new CC_Call_Script__c(Name='Test_ELQ_AMER_Debug', Theater__c='Americas',Source__c='Global Eloqua',Status__c='Previewed', Default_Call_Script__c = true);
            insert callScript;
             Test.setCurrentPageReference(New PageReference('Page.NGCC_LeadUtitlities'));
             ApexPages.StandardController stdCtlLead = New ApexPages.StandardController(lstLead);       
             
             NGCC_LeadUtitlities_CTE ngccUtilities = new NGCC_LeadUtitlities_CTE(stdCtlLead);
                Test.startTest();                   
                   ngccUtilities.cmdCallScript();
                   ngccUtilities.response.Response_Type__c = 'Inbound Call';
                   ngccUtilities.response.Status__c = 'Qualified Lead';
                    ngccUtilities.response.Call_Script__c = callScript.id;
                   ngccUtilities.statusUpdate();
                   ngccUtilities.saveResponse();
            	ngccUtilities.getPickLstValue();
                Test.stopTest(); 
            
        }       
    }
    public static testmethod void statusChangetest(){
         PageReference current = ApexPages.currentPage();
        CC_Response__c res = new CC_Response__c();
        insert res;
        
        Test.setCurrentPage(current);
        current.getParameters().put('ResponseId', res.Id);
        Lead lstLead= NGCC_CallScript_Data_Test.testLead();  
        ApexPages.StandardController stdCtlLead = New ApexPages.StandardController(lstLead);       
        
        NGCC_LeadUtitlities_CTE ngccUtilities = new NGCC_LeadUtitlities_CTE(stdCtlLead);
        ngccUtilities.response = res;
        ngccUtilities.disposition = 'Nurture';
        ngccUtilities.statusUpdate();
		ngccUtilities.DispositionChange(); 
    }
    public static testmethod void statusChangetest2(){
         PageReference current = ApexPages.currentPage();
        CC_Response__c res = new CC_Response__c();
        insert res;
        
        Test.setCurrentPage(current);
        current.getParameters().put('ResponseId', res.Id);
        Lead lstLead= NGCC_CallScript_Data_Test.testLead();  
        ApexPages.StandardController stdCtlLead = New ApexPages.StandardController(lstLead);       
        
        NGCC_LeadUtitlities_CTE ngccUtilities = new NGCC_LeadUtitlities_CTE(stdCtlLead);
        ngccUtilities.response = res;
        ngccUtilities.disposition = 'Max Attempt Reached';
        ngccUtilities.statusUpdate();  
    }
}