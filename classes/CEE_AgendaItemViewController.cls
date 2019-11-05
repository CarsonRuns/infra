/***************************************************************************************************
Name    : CEE_AgendaItemViewController 
Author  : Eric Pesch
Purpose : Controller for the Agenda Item InviteList Controller page
Created Date: Nov 15 2014
Modification History: 
Eric Pesch - Nov 15 2014: Initial Creation
Eric Pesch - Jan 5 2015: Added Comments, cleanup                       
*****************************************************************************************************/ 

public with sharing class CEE_AgendaItemViewController {
    private static final String TAG = 'CEE_AgendaItemViewController - ';
    
    //Controller standard vars
    private final ApexPages.StandardController controller;
    public Agenda_Item__c agendaItem { get; set; } 
    public String redirectURL { get; set; }
    
    /*@Constructor: Method for initializing the correct fields for the VF page*/
    public CEE_AgendaItemViewController(ApexPages.StandardController stdController){
        List<String> popFields = new List<String>{'Id', 'Customer_Engagements_Events__c', 'Selected_Rooms_Display__c',
        	'Name', 'Start_Date_Time__c', 'End_Date_Time__c'};       

        //Constructors
        this.controller = stdController;
        if(!Test.isRunningTest()){
        	this.controller.addFields(popFields);	
        }
        this.agendaItem = (Agenda_Item__c)stdController.getRecord();
		this.redirectURL = controller.view().getUrl();
    }
}