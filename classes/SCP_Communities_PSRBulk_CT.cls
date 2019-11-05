public without sharing class SCP_Communities_PSRBulk_CT extends SCP_Communities_ComponentControllerBase {
	
	public SCP_Communities_PSRBulk_CT() {
		leadRec = new Lead();
		System.debug(System.LoggingLevel.INFO,'#### isLead : '+isLead+' ####');
		isLead = false;
		System.debug(System.LoggingLevel.INFO,'#### isLead : '+isLead+' ####');
		// Modified By: Sudi 02 Nov 2014 
	    // Release : November Sprint 3
	    // User Story : US7093
	    // Below code is added to populate the Partner name drop down values in Partnar mass update
		partnerNameList = new list<SelectOption>();	
		set<SelectOption> newList = new set<SelectOption>();
		partnerNameList.add(new SelectOption('',Label.PRM_Picklist_Value_Select_options));		
		for(Disti_to_Partner_Mapping__c DP : [Select Partner__c, Channel_Partner__c from Disti_to_Partner_Mapping__c where Distributor__c=:channelAccount]){
			if(DP.Partner__c != null){						
				newList.add(new SelectOPtion(DP.Partner__c,DP.Channel_Partner__c));
			}				
		} 
		partnerNameList.addAll(newList);
		disableUpdate = false;

	}
	
	private String key ;
	
	public SCP_Communities_PageControllerBase pageController;
	
	public String getKey() {
		return this.key;
	}
	public override void setKey(String value) {
		if(value != null) {
			this.key = value;
			if(this.pageController != null)
			this.pageController.setComponentControllerMap(this.key, (SCP_Communities_PSRBulk_CT)this);
		}
	}
	
	public SCP_Communities_PageControllerBase getPageController() {
		return (this.pageController);
	}
	
  	public override void setPageController(SCP_Communities_PageControllerBase value) {
	  	System.debug(System.LoggingLevel.INFO, '*** INSIDE setPageController OF PSR');
	  	if(value != null) {	  		
	  		this.pageController = value;
	  		if(this.key != null)
	  		this.pageController.setComponentControllerMap(this.key,(SCP_Communities_PSRBulk_CT)this);
	  	}
  	}
	
	
		public string psr1_name { get; set; }
        public string psr1_Id { get; set; }
        public string psr2_name { get; set; }
        public string psr2_Id {get; set;}
        public string psr3_name { get; set; }
        public string psr3_Id { get; set; }
        
    	public void assignPSRs() {
       		pageController.assignPSRs();
   			psr1_name = null;
			psr1_Id = null;
			psr2_name = null;
			psr2_Id = null;
			psr3_name = null;
			psr3_Id = null;
        }
        
        public Lead leadRec { get; set; }
        public Boolean isLead { get; set; }
        public Boolean isPA {
        	get {
        		return (prmFilterUtility.isPA);
        	}
        }
        public Boolean isPSR {
        	get {
        		return (prmFilterUtility.isPSR);
        	}
        } 
        // Modified By: Sudi 02 Nov 2014 
	    // Release : November Sprint 3
	    // User Story : US7093
	    // Below method is used to get the distributor role
        public boolean isDisti{
			get{			
				return (prmFilterUtility.loggedInUserIsDisti =='Distributor')?true:false;
			}
		}
		public String channelAccount{
			get{
					return String.valueof(prmFilterUtility.loggedInUserPartnerAccount);
			}
		}
		// Modified By: Sudi 02 Nov 2014 
	    // Release : November Sprint 4
	    // User Story : US7093
	    // Below method is used to populated the Partner lead status drop down
        public List<SelectOption> getleadStatusList() {
        	
			List<SelectOption> options = new List<SelectOption>();
			//	leadSourceList.add(new SelectOption('All',Label.PRM_Picklist_Value_All));
			Schema.DescribeFieldResult status  = Lead.Partner_Lead_Status__c.getDescribe();
			for(Schema.Picklistentry sp : status.getPicklistValues()) {				
				if(isPA && sp.value != 'Partner Assigned' && sp.value != 'Deal Created') {					
					options.add(new SelectOption(sp.value,sp.label));
				}
				else if(isPSR  && sp.value != 'Partner Assigned' && sp.value != 'Deal Created'){					
					options.add(new SelectOption(sp.value,sp.label));
				}
			}
			return options;
        }
        public String leadStatus { get; set; }
        public Boolean disableUpdate { get; set; }
        public list<SelectOption> partnerNameList{get;set;}
        public string selectedPartner{get;set;}
        
        // Modified By: Sudi 02 Nov 2014 
	    // Release : November Sprint 4
	    // User Story : US7093
	    // Below method is added for update the Channel partner for all selected leads in lead filter page
        public void AssignPartnerName(){
    		pageController.AssignPartnerName(selectedPartner);
    	}
    	// Modified By: Santhosh 04 Nov 2014 
	    // Release : November Sprint 4
	    // User Story : US7118
	    // Below method used to enable the mass update in lead filter gird view
        public void enableMassEdit() {
        	disableUpdate = false;
        	if(leadStatus == 'Actively Working' || leadStatus.startsWith('Closed-Order')) {
        		disableUpdate = true;
        	}
        	pageController.enableMassEdit(leadStatus);
        	//return null;
        }
        // Modified By: Santhosh 04 Nov 2014 
	    // Release : November Sprint 4
	    // User Story : US7118
	    // Below method is mass Update the partner lead status.
        public void updateStatus() {
        	if(leadStatus != null && leadStatus != '') {
        		leadRec.Partner_Lead_Status__c = leadStatus;
        	}        	
        	pageController.updateStatus(leadRec);
        }
         // Modified By: Santhosh 04 Nov 2014 
	    // Release : November Sprint 4
	    // User Story : US7118
	    // Below method is used to cancel the mass update status.
        public Pagereference cancelMassUpdate() {
        	leadStatus = '';
        	selectedPartner = '';
        	disableUpdate = false;
        	return pageController.cancelMassUpdate();
        }
}