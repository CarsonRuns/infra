@isTest
private class TSN_Case_Acceptance_CTE_Test{
private static testMethod void TSN_Case_Acceptance_CTE_Test()
    {
     User tsnUser=[select id from User where profileid=:Utilities.getTSNProfileId() and isactive=true limit 1];
     CEE_TestUtility.loadCustomSettings();
     Group triageGroup=[select id from Group where name='Front Line' limit 1];
     List<Case> caseList=new List<Case>();
     Group gp1=new Group(name='Front Line');
       insert gp1;
       System.runAs(tsnUser){
             GroupMember gm1 =new GroupMember(groupId=gp1.id,userorgroupId=tsnUser.id);
               insert gm1;
       }
     for(Integer i=0;i<10;i++)
        {
         caseList.add(new Case(subject='CaseTest'+i));
        }
     Utilities.setValidationSkip(true);
     caseList[1].ownerid=tsnUser.id;
     
     insert caseList;
     caseList[1].ownerid=tsnUser.id;
     
     caseList[1].team__c='GVE Tier I';
     caseList[3].ownerid=triageGroup.id;
     caseList[7].ownerid=triageGroup.id;
     caseList[5].ownerId=tsnUser.id;
     //update caseList;
     ApexPages.StandardSetController con=new ApexPages.StandardSetController(caseList);
     List<Case> selectedCaseList=new List<Case>();
     selectedCaseList.add(CaseList[1]);
     selectedCaseList.add(CaseList[3]);
     selectedCaseList.add(CaseList[5]);
     selectedCaseList.add(CaseList[7]);
     selectedCaseList[1].team__c='GVE Tier I';
     con.setSelected(selectedCaseList);
     system.debug('<<<<<<<<<<<<<<<'+selectedCaseList);
     TSN_Case_Acceptance_CTE classController=new TSN_Case_Acceptance_CTE(con);
     
     classController.getCaseAcceptanceUpdation();
     
    }



}