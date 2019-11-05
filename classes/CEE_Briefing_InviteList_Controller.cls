/***************************************************************************************************
Name    : CEE_Briefing_InviteList_Controller 
Author  : Eric Pesch
Purpose : Controller for shell CEE Briefing InviteList page  
Created Date: Dec 1 2014
Modification History: 
Eric Pesch - Jan 5 2015: Added Comments, cleanup                     
*****************************************************************************************************/

public with sharing class CEE_Briefing_InviteList_Controller {

	//Controller standard vars
	private static final String TAG = 'CEE_Briefing_InviteList_Controller - ';
    private final ApexPages.StandardController controller;
    public CEE__c briefing { get; set; } 
    public String redirectURL { get; set; }
    
    /*@Constructor: Controller for the VF page*/
    public CEE_Briefing_InviteList_Controller(ApexPages.StandardController stdController){
        //Constructors
        this.controller = stdController;
        this.briefing = (CEE__c)stdController.getRecord();
		this.redirectURL = controller.view().getUrl();
    }
    
    /*@method: Return Page Reference for Back Button*/
    public pagereference backMethod() {
		Pagereference pg =  new Pagereference('/' + briefing.Id); // Include name of page where user should be navigated after clicking on Back button
		pg.setRedirect(true);
		return pg;
	}
}