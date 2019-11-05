/************************************************************************************************************************************
Name    : CaseTriggerImpl
Author  : Sournaga
Purpose : Case trigger consolidation 
Created Date:  7/6/2015
Modification History: Sournaga- Code clean up, Enhancements & Optimization
US257804 - 12/19/18- To update CCW Deals Quotes Section of GVE and TSN Cases if it has Opportunity and Integrated Quote= Yes Associated to it.
*************************************************************************************************************************************/

public class CaseTriggerImpl implements TriggerInterface
{

    public void beforeInit(){
      //initiate any required variables or data for one time caching to be used in before operations
    }

    public void afterInit(){
      //initiate any required variables or data for one time caching to be used in after operations
    }

    public void executeBeforeInsert(){
        system.debug('***BEFORE INSERT****');
        //Update case entitlement & contact flags   
        CaseBO.updateCaseFlags(Trigger.new);
        
        // Nishi -- Commented the method calling to prevent owner check for TSN cases
        //check if user belongs to the team selected
        //CaseBO.TSNCaseOwnerSyncWithTeam(Trigger.new);
        
        //do not allow change of status to closed for parent cases with child cases still open
        CaseBO.TSN_PreventParentCloseWhenChildOpen(Trigger.new);
                
        //insert case SLA business hours
        CaseBO.insertCaseBusinessHours(Trigger.new);
        
        //update child contact from parent case owner
        CaseBO.updateChildContactDetails(Trigger.new);
        
        //route web case
        CaseBO.RouteWebCases(Trigger.new);  
        
        
        //ER Case Validation
        CaseBO.ercaseValidation(Trigger.new);
    }


    public void executeAfterInsert(){
        system.debug('***AFTER INSERT****');
        //update contact, account based on ccoID
        CaseBO.UpdateAccountContactByCCOIdContactSearch(Trigger.new);
        //US257804 - Manikant Kella- 12/21/18
        //Update Case CCW Deals Quotes Section for TSN and CWR Case Types- Invoke method from CaseBO and pass newly created cases after insert
        CaseBO.updateCaseCCWDealsSection(trigger.new);
        
        //Manikant Kella
        
        //invoke VcPDBUpdate webservice call
        CaseBO.VcPDBUpdate(trigger.new);  
        
       CaseBO.updateErcaseAfter(trigger.new);  
          
    }

    public void executeBeforeUpdate(){
        system.debug('***BEFORE UPDATE****');
        //Updating Case Owner, Case Status when Case is shared from SOne
        CaseBO.updateEngageCaseValues(Trigger.new);  
        //Update case entitlement & contact flags
        CaseBO.updateCaseFlags(Trigger.new);
        
        // Nishi -- Commented the method calling to prevent owner check for TSN cases
        //check if updated case owner belongs to team selected
       // CaseBO.TSNCaseOwnerSyncWithTeam(Trigger.new);
        
        //update case SLA business hours
        CaseBO.updateCaseBusinessHours(Trigger.oldMap, Trigger.new);
        
        //do not allow change of status to closed for parent cases with child cases still open
        CaseBO.TSN_PreventParentCloseWhenChildOpen(Trigger.new); 
         
        //update child contact from parent case owner
        CaseBO.updateChildContactDetails(Trigger.new);
        
        //update Spark Room with values of changed fields  
        CaseBO.sendUpdateToSparkRoom(Trigger.oldMap, Trigger.new);
        
        
        // ER Case Validation
        CaseBO.ercaseValidation(Trigger.new);

    }

    public void executeAfterUpdate(){
        system.debug('***AFTER UPDATE****');
        //invoke VcPDBUpdate webservice call
        CaseBO.VcPDBUpdate(trigger.new);
        
        //update opportunity team & status change history object
        CaseBO.CaseOwnerOptyTeamAndCaseStatusHistoryUpdate(trigger.new);
        
    }

    public void executeBeforeDelete(){
        system.debug('***BEFORE DELETE****');
        //check if the user has persmission to delete the case
        CaseBO.caseBeforeDelete(Trigger.old); 
    }

    public void executeAfterDelete(){}

    public void executeUnDelete(){}

}