public with sharing virtual class SCP_Communities_ComponentControllerBase {
  //the new property
  private String key{ get; set; }
  
  public virtual void setKey(String value) {
  
  	System.debug(System.LoggingLevel.INFO, '*** INSIDE setKey OF ComponentControllerBase');

  	if(value != null) {
  		System.debug('*** Inside Component Base setKey');
  		key = value;
  		//if(pageController != null) {
  			pageController.setComponentControllerMap(key, this);
  		//}
  	}
  }
 
  private SCP_Communities_PageControllerBase pageController { get; set; }
  
  public virtual void setPageController(SCP_Communities_PageControllerBase value) {
  	System.debug(System.LoggingLevel.INFO, '*** INSIDE setPageController OF ComponentControllerBase');
  	if(value != null) {
  		System.debug('*** Setting page controller Base');
  		pageController = value;
  		pageController.setComponentControllerMap(key,this);
  	}
  }
}