//This controller class checks for concurrent accept of Case 

public class TSN_Case_Acceptance_CTE {
  // SCAVA Helper Method to validate Update Access at field level
     public static Boolean flsUpdateGet(SObjectField field)
    {
        return field.getDescribe().isUpdateable() ? true : false;
    }
    public String results{get;set;}
    public List<Case> selectedCaseRecordsList;
    
    public TSN_Case_Acceptance_CTE(ApexPages.StandardController controller) {}
    
    public TSN_Case_Acceptance_CTE(ApexPages.StandardSetController controller) {
       selectedCaseRecordsList=controller.getSelected();
    }
    public PageReference getCaseAcceptanceUpdation()
    {
      String caseRejected ='';
      String caseAccepted ='';
      String currentUserId=UserInfo.getUserId();
      List<Case> acceptedCasesList=new List<Case>();
      List<Id> selectedCaseRecordIdList=new List<Id>();
      for(Case c:selectedCaseRecordsList)
          selectedCaseRecordIdList.add(c.id);
          
      List<Case> queryResultList=[select casenumber,id,ownerId,owner.type,status from case where id in 
                                  :selectedCaseRecordIdList for update ];
                                  
      results='';
      
      System.debug('queryResultList>>>>>>'+ queryResultList);
      for(Case c:queryResultList)
         {
          if(c.owner.type == 'User')
            {
             caseRejected += ((caseRejected !='') ? ',':'')+ c.casenumber;
            }
          else
            {
             caseAccepted += ((caseAccepted !='') ? ',':'') + c.casenumber ;
             // SCAVA FIX , Oct16th 2018
             if(flsUpdateGet(case.ownerId)){
             c.ownerId=currentUserId;
             }
             acceptedCasesList.add(c);
            }
         }
      try {  
          Utilities.setValidationSkip(true);
          update acceptedCasesList;
         
         // Checks for CaseAccepted by Engineer
         
         if(caseAccepted != '')
         {
          results+='You have accepted the following Cases :'+caseAccepted ;
         }
      }
      catch(Exception e){
         apexPages.addMessages(e);
         
         if(caseAccepted != '')
         {
          results+='You are not able to accepted the following Cases due to Error(s):'+caseAccepted ;
         }
      } 
        // Checks for CaseAccepted by another Engineer
        
      if(caseRejected  != '')
         {
          results+='\n The following Cases :' + caseRejected +' has been accepted by another engineer' ;
         }
      return null;   
      
    }
}