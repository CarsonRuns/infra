//This is a test class for ContextUtility_PEPE
@isTest(SeeAllData=true)
private class ContextUtility_PEPETest {

    private static testMethod void TestCRMethod(){
        
    //Defining Variables and Constants 
    final String AWAITING_REQUESTORS_CONFIRMATION = 'Awaiting Requestor\'s confirmation';
    final String ADDED_INTO_CART = 'Added into cart';
    final String LEARNING_PARTNER_BEING_CONTACTED = 'Learning Partner being contacted';
    final String REQUESTED = 'Requested';
    final String LP_BEING_CONTACTED = 'LP being contacted';
    
    PEPE_Training_Request__c trRec1 = new PEPE_Training_Request__c();
    PEPE_Learning_Partner__c lpRec1 = new PEPE_Learning_Partner__c();

    
 
    //Calling constructor of the class 
    ContextUtility_PEPE lpProcessing = new ContextUtility_PEPE ();
    
    //Calling Methods of the class
    lpProcessing.updateQuoteFields(trRec1, lpRec1);
    lpProcessing.emptyQuoteFields(trRec1);
  
    /*----------Positive test cases----------*/
     
    //calling isFirstRun() Method of the class
    Boolean contextVar = ContextUtility_PEPE.isFirstRun();
    System.assertEquals(contextVar, True);
    Integer orgValue = ContextUtility_PEPE.getOrgValue();
    //test.StopTest();
    
    //System.assertEquals(orgValue, 1);
    
    PEPE_Training_Event__c teRec1 = new PEPE_Training_Event__c();
    teRec1.Status__c = 'Published';
    teRec1.Platform__c = 'Partner Plus Lounge';
    teRec1.Training_Event_Name__c = 'test';
    teRec1.Geography__c = 'EMEAR';
    teRec1.Potential_Learning_Partner_01__c = 'Innovise';
    teRec1.Estimated_Training_Cost__c = 2000;
    teRec1.Other_Costs__c='40';
    teRec1.Potential_Learning_Partner_02__c = 'FastLane';
    teRec1.Estimated_Training_Cost_02__c = 4000;
    teRec1.Other_Cost_02__c='50';
    teRec1.Potential_Learning_Partner_03__c = 'Quadmark';
    teRec1.Estimated_Training_Cost_03__c = 5000;
    teRec1.Other_Cost_03__c='60';  
    Insert teRec1;
    
    PEPE_Training_Request__c trRec2 = new PEPE_Training_Request__c();
    trRec2.Training_Offering_Id__c = teRec1.Id;
    trRec2.Status__c =  ADDED_INTO_CART;
    trRec2.Geography__c = 'EMEAR';
    trRec2.Proposed_Start_Date_1__c = Date.today();
    trRec2.Language__c = 'English';
    trRec2.Theatre_Region__c = 'Central';
    trRec2.Country_Cluster__c = 'EMEA-CEE';
    trRec2.Country__c = 'Austria';
    trRec2.Fiscal_Quarter__c = 'Q1 FY14';
    trRec2.Training_Location_Address__c = 'Address';
    trRec2.Training_Location_City__c = 'City';
    trRec2.PLP_Email_Field_01__c = '';
    trRec2.PLP_Email_Field_02__c = '';
    trRec2.PLP_Email_Field_03__c = '';
    trRec2.Training_Offering_Id__c = teRec1.id;
    List<recordtype> lstRecordtype1 = [select id from recordtype where developername='Partner_Plus' and SobjectType='PEPE_Training_Request__c'];
    if(lstRecordtype1 != null && lstRecordtype1.size() > 0)
        trRec2.recordtypeid = lstRecordtype1[0].id;
    
      insert trRec2;  
     // test.StartTest(); 
      trRec2.Status__c = 'Learning Partner being contacted';
      update trRec2;
    
    
    PEPE_Training_Event__c teRec = new PEPE_Training_Event__c();
    teRec.Status__c = 'Published';
    teRec.Platform__c = 'Partner Plus';
    teRec.Training_Event_Name__c = 'test';
    teRec.Geography__c = 'EMEAR';
    teRec.Potential_Learning_Partner_01__c = 'Innovise';
    teRec.Estimated_Training_Cost__c = 2000;
    teRec.Other_Costs__c='40';
    teRec.Potential_Learning_Partner_02__c = 'FastLane';
    teRec.Estimated_Training_Cost_02__c = 4000;
    teRec.Other_Cost_02__c='50';
    teRec.Potential_Learning_Partner_03__c = 'Quadmark';
    teRec.Estimated_Training_Cost_03__c = 5000;
    teRec.Other_Cost_03__c='60';
    teRec.Delivery_Team_new__c='Cisco Learning Partner';
  //try{
    Insert teRec;
  //}catch(Exception e){}
  System.debug('id:::'+teRec.id);
//[Select id, Potential_Learning_Partner_01__c from PEPE_Training_Event__c where Potential_Learning_Partner_01__c != '' limit 1];
    
    //Defining object variable
    PEPE_Training_Request__c trRec = new PEPE_Training_Request__c();
    trRec.Training_Offering_Id__c = teRec.Id;
    trRec.Status__c =  ADDED_INTO_CART;
    trRec.Geography__c = 'EMEAR';
    trRec.Proposed_Start_Date_1__c = Date.today();
    trRec.Language__c = 'English';
    trRec.Theatre_Region__c = 'Central';
    trRec.Country_Cluster__c = 'EMEA-CEE';
    trRec.Country__c = 'Austria';
    trRec.Fiscal_Quarter__c = 'Q1 FY14';
    trRec.Training_Location_Address__c = 'Address';
    trRec.Training_Location_City__c = 'City';
    trRec.PLP_Email_Field_01__c = '';
    trRec.PLP_Email_Field_02__c = '';
    trRec.PLP_Email_Field_03__c = '';
    trRec.BLP_Flag__c='Yes';    
    trRec.Training_Offering_Id__c = teRec.id;
    List<recordtype> lstRecordtype = [select id from recordtype where developername='Partner_Plus' and SobjectType='PEPE_Training_Request__c'];
    if(lstRecordtype != null && lstRecordtype.size() > 0)
        trRec.recordtypeid = lstRecordtype[0].id;
    
      insert trRec;  
      test.StartTest(); 
      trRec.Status__c = 'Learning Partner being contacted';
      update trRec;
    
    PEPE_Learning_Partner__c lpRec = [select id, name, QUOTE_ACCEPTED_FLAG__c, status__c, Learning_Partner_Cost__c, Actual_Start_Date__c, Instructor_Email__c, Instructor_Name__c, Launguage__c from PEPE_Learning_Partner__c Limit 1];

    lpRec.Learning_Partner_Cost__c = 10000;
    lpRec.Actual_Start_Date__c = date.today();
    lpRec.Instructor_Email__c = 'ABC@test.com';
    lpRec.Instructor_Name__c = 'ABC';
    lpRec.Launguage__c = 'English';
    lpRec.status__c = 'Quote Accepted';
    lpRec.QUOTE_ACCEPTED_FLAG__c = 'Y';
    
    ContextUtility_PEPE.setFirstRunTrue();
    
    update lpRec; 
    ContextUtility_PEPE.setFirstRunFalse();
    
    ContextUtility_PEPE.setFirstRunTrue();
    trRec.Status__c = 'Event Approved';
    update trRec;
    ContextUtility_PEPE.setFirstRunFalse();
    test.StopTest();

 
   
 
  
  }//End of the Method
    
    

}