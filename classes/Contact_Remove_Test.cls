@isTest

// This is the test class for Contact_Remove_CTE Apex class
Private Class Contact_Remove_Test{
    private static testMethod void TestCRMethod(){
        String dummyEndUserAccountId = Utilities.getConstant_CS('Contact_Delete_EndUserAccountID');
        String dummyChannelAccountId = Utilities.getConstant_CS('Contact_Delete_ChannelPartnerAccountID'); 
        
        Contact c = new Contact(AccountId=dummyChannelAccountId,LastName='Test Contact Remove',recordtypeId=Utilities.getContactManualPartnerRecordTypeId());
        Contact c1 = new Contact(AccountId=dummyEndUserAccountId,LastName='Test Contact Remove2',recordtypeId=Utilities.getContactManualEndUserRecordTypeId());
        Contact c2 = new Contact(AccountId=dummyChannelAccountId,LastName='Test Contact Remove3',recordtypeId=Utilities.getContactPDBContactRecordTypeId());
        User u = [Select ID, Email from User where ProfileID =: '00e30000000dcbg' AND alias != :'auser' LIMIT 1];
        Insert c;
        Insert c1;
        Insert c2;
       System.runas(u){
            test.StartTest();
             ApexPages.CurrentPage().getparameters().put('Id',c.Id);
             ApexPages.StandardController stdCon = new ApexPages.StandardController(c); 
             Contact_Remove_CTE conRem = new Contact_Remove_CTE(stdCon);
             conRem.start();
            
             stdCon = new ApexPages.StandardController(c); 
             conRem = new Contact_Remove_CTE(stdCon);
             
             id[] cids = new List<id>(); 
             cids.add(c.id);
             cids.add(c1.id);
             cids.add(c2.id);            
             Contact_Remove_CTE.massDelete(cids);
             test.StopTest();    
         }
    }
    
    private static testMethod void TestCRMethod2(){
        String dummyEndUserAccountId = Utilities.getConstant_CS('Contact_Delete_EndUserAccountID');
        String dummyChannelAccountId = Utilities.getConstant_CS('Contact_Delete_ChannelPartnerAccountID'); 
        List<id> userIDs = Utilities.getConstant_CS('Contact_Delete_UserID').split(',');
        ID userID;
        if(!userIDs.isEmpty()){
            userID = userIDs[0];
        }else{
            userID = UserInfo.getUserId();
        }
        User u = [Select ID, Email from User where ID =: userID];
            
        Contact c = new Contact(AccountId=dummyChannelAccountId,LastName='Test Contact Remove',recordtypeId=Utilities.getContactManualPartnerRecordTypeId());
        Contact c1 = new Contact(AccountId=dummyEndUserAccountId,LastName='Test Contact Remove2',recordtypeId=Utilities.getContactManualEndUserRecordTypeId());
        Contact c2 = new Contact(AccountId=dummyChannelAccountId,LastName='Test Contact Remove3',recordtypeId=Utilities.getContactPDBContactRecordTypeId());
        
        Insert c;
        Insert c1;
        Insert c2;
        
        System.runas(u){
            test.StartTest();
            ApexPages.CurrentPage().getparameters().put('Id',c.Id);
             ApexPages.StandardController stdCon = new ApexPages.StandardController(c); 
             Contact_Remove_CTE conRem = new Contact_Remove_CTE(stdCon);
             conRem.start();
            
             stdCon = new ApexPages.StandardController(c); 
             conRem = new Contact_Remove_CTE(stdCon);
             
             id[] cids = new List<id>(); 
             cids.add(c1.id);
             cids.add(c2.id);
             Contact_Remove_CTE.massDelete(cids);
             test.StopTest();    
        }
         
    }
}