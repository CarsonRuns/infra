public with sharing virtual class SCP_Communities_PageControllerBase {

private Map<String, SCP_Communities_ComponentControllerBase>componentControllerMap; //new
    

  //new getter for the hashmap
  public virtual Map<String, SCP_Communities_ComponentControllerBase> getComponentControllerMap(){
    System.debug(System.LoggingLevel.INFO, '*** INSIDE getComponentControllerMap OF SCP_Communities_PageControllerBase : '+componentControllerMap);
    if(componentControllerMap == null ) {
        componentControllerMap = new Map<String, SCP_Communities_ComponentControllerBase>();
    }
    return componentControllerMap;
  }
  //new method for putting value in the hashmap
  public virtual void setComponentControllerMap(String key, SCP_Communities_ComponentControllerBase compController){
    System.debug(System.LoggingLevel.INFO, '*** INSIDE setComponentControllerMap OF SCP_Communities_PageControllerBase : '+key);
    if(componentControllerMap == null)
      componentControllerMap = new Map<String, SCP_Communities_ComponentControllerBase>();
    componentControllerMap.put(key,compController);
    System.debug('*** Inside SCP_Communities_PageControllerBase setComponetControllerMap');    
  } 
    
  public virtual SCP_Communities_PageControllerBase getThis() {
    System.debug(System.LoggingLevel.INFO, '*** INSIDE getThis OF SCP_Communities_PageControllerBase');
    return this;
  }
  
  
  public virtual Pagereference assignPSRs() {
  	System.debug('*** Inside assign PSR of SCP_Communities_PageControllerBase');
  	return null;
  }
  
  public virtual Pagereference updateStatus(Lead leadRec) {
  	return null;
  }
  // Modified By: Sudi 02 Nov 2014 
  // Release : November Sprint 4
  // User Story : US7093
  // Below method is added for PageControlerBase to use this method in SCP_Communities_LeadFilter_CT.
  public virtual Pagereference AssignPartnerName(string partnerAccId) {
  	return null;
  }
  // Modified By: Santhosh 04 Nov 2014 
  // Release : November Sprint 4
  // User Story : US7118
  // Below method used to enable the mass update in lead filter gird view
  public virtual void enableMassEdit(String status) {}
  // Modified By: Santhosh 04 Nov 2014 
  // Release : November Sprint 4
  // User Story : US7118
  // Below method is used to cancel the mass update status.
  public virtual Pagereference cancelMassUpdate() {
  	return null;
  }
}