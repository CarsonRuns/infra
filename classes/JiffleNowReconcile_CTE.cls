/************************************************************************************************************************************
Name    : JiffleReconcile_CTE
Author  : Mukesh Srivastava
Purpose : This class is a controller extension for reconciling meeting 
            1) Mark select attendee as Attended
            2) Capture outcome of the meetings
            3) 
Created Date: 4/15/2015
Modification History: 

*************************************************************************************************************************************/
public class JiffleNowReconcile_CTE {
    // Declaring variables
    List < Jiffle_Attendee_Invitee__c > lstAttendees = new List < Jiffle_Attendee_Invitee__c > ();
    Set < Id > setAttId = new Set < Id > ();
    Public String returnURL;
    Public String strAction;

    //@ Constructors to capture all selected records
    public JiffleNowReconcile_CTE(ApexPages.StandardSetController controller) {
        lstAttendees = controller.getSelected();
        
        // Validate if the Records were Selected from List view
        if (lstAttendees == null || (lstAttendees != null && lstAttendees.isempty())) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.ERROR, 'Please select at least one Record to Reconcile');
            ApexPages.addMessage(myMsg);
        }
        
        returnURL = ApexPages.currentPage().getParameters().get('retURL');    //get the return URL
        strAction = ApexPages.currentPage().getParameters().get('action');    //get Status which need to be set
    }

    //@ Method for setting all the selected record as Attended and updating
    public pageReference cmdSubmit() {
        // Validate if the Records were Selected from List view
        system.debug('-----'+lstAttendees);
        if (!lstAttendees.isempty()) {
        
        // set the Meeting attended as respective status passed through URL    
            for (Jiffle_Attendee_Invitee__c jAI: lstAttendees) {
                jAI.Meeting_Attended__c = strAction;
            }
        // Updating all the attendee information
            Database.SaveResult[] lstJiffleAttendeeSaveResult = Database.update(lstAttendees, false);
        
        // Process the update status and generate the List of Errors
            Integer failures = 0;
            Integer successes = 0;
            Set < String > errors = new Set < String > ();
            for (Database.SaveResult saveResult: lstJiffleAttendeeSaveResult) {
                if (!saveResult.success) {
                    failures++;
                    for (Database.Error err: saveResult.getErrors()) {
                        errors.add(err.getMessage());
                    }
                } else {
                    successes++;
                }
            }
        // Generating error messages
            String result = successes + ' Attendee Confirmations Updated.<br/>';
            if (failures > 0) {
                result += '<font color="red">' + failures + ' Attendee Confirmations Failed due to below errors: <ul>';
                for (String msg: errors) {
                    result += '<li>' + msg + '</li>';
                }
                result += '</font></ul>';
            }

            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.INFO, result);
            ApexPages.addMessage(errMsg);
        }
        return null;
    }

    //@ Method for redirecting users to list view page
    public pageReference cmdDone() {
        PageReference pg = new PageReference(returnURL);
        pg.setRedirect(true);
        return pg;
    }

}