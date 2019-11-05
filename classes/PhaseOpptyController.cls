/*
* PhaseOpptyController: 
* Controller for the list button VF Page (AddPhaseOppty.page) on Phase Opportunity related list 
* The button appears on Parent Opportunity page layouts only
*
* Modification Log =============================================================== 
* 2015-02-09: Created to migrate Add_Phase s-control
* 
* */ 

global without sharing class PhaseOpptyController {

    private ApexPages.StandardSetController controller = null;
    public Static String PROFILE_PSS = 'Cisco_PSS';
    public static String opptyId { get; set; }
    public static String phaseOpptyId { get; set; }
    
    
    public PhaseOpptyController(ApexPages.StandardSetController controller) {
        
        this.controller = controller;
        opptyId = ApexPages.currentPage().getParameters().get('id');
    }
    
    /* This method calls AddPhaseOppty.AddPhase to create new Phase Opportunity and on success redirects
    *  the user to the phase opportunity for further editing
    *  On Error, displays the error with a button to return to parent opportuinity
    */
    @RemoteAction
    global static String [] createNewPhase(String opId) {
        
        String [] retArray = new String []{};
        
        opptyId = opId;
        PageReference pageRef = new PageReference('/'+opptyId); //ApexPages.currentPage();
        
        String errorMsg = 'Failure';
        String returnURL = pageRef.getURL();
        
        
        if (opptyId == null) {
        	
            errorMsg = 'Parent Opportunity is missing';
            System.debug('$$$$$ opptyId is Null'+opptyId);
            
            return retArray;
        }
        
        String userProfileName = [select Name from Profile where id = :userInfo.getProfileId() limit 1].Name;
        
        if (userProfileName == null || userProfileName.equals(PROFILE_PSS)) {
            errorMsg =  'A PSS cannot add a phase to an Opportunity';
            
            System.debug('$$$$$ User profile is PSS '+userProfileName);
            
        }
        
        Opportunity oppty = getOpportunity(opptyId);
        
        //@TODO: Why does AddPhaseOppty.AddPhase take RecordTypeId as second param. It has a SOQL query that can fetch the id
        phaseOpptyId = AddPhaseOppty.AddPhase(opptyId, oppty.RecordTypeId);
        System.debug('$$$$$ Opty Phase Id after webeservice:  '+phaseOpptyId);
        
        if (phaseOpptyId != null) {
        	
			/*
			 * Modified to fix prod issue with exception message in URL				
			*/	        	
        	if(phaseOpptyId.startsWith('006')) {// Returning Phase oppty id, succuss url

        		errorMsg = 'Success';
        		returnURL = '/'+phaseOpptyId+'/e?retURL=/'+phaseOpptyId;
        		System.debug('$$$$$ Phase created successfully '+phaseOpptyId);
        	}
            else if (phaseOpptyId.equals('1')) {
                errorMsg = 'Invalid Opportunity Id!. Opportunity does not exist!';
            }
            else if (phaseOpptyId.equals('2')) {
                errorMsg= 'This is a Child Phase - please navigate to the parent opportunity';
                
            }
            else if (phaseOpptyId.equals('3')) {
                errorMsg ='Please create a new Opportunity. The maximum number of Phases for this Opportunity has been reached!';
                
            }
            else if (phaseOpptyId.equals('4')) {
                errorMsg = 'New Phase Opportunity cannot be created as Account is not an End User Account!';
                
            }
            else { // In case of any exceptions
            	errorMsg = phaseOpptyId;
          	
               	System.debug(System.LoggingLevel.INFO, 'Exception block : '+phaseOpptyId);                 
            }
        }
        
        retArray.add(errorMsg);
        retArray.add(returnURL);        
        
        return retArray;
    }
    
    private static Opportunity getOpportunity(id opptyId2) {
        
        List<Opportunity> opptySO = [select id, Name, stageName, RecordTypeId, RecordType.Name 
                                        from Opportunity
                                        where id = :opptyId2];
        
        return (!opptySO.isEmpty() ? opptySO[0] : null);
    }
}