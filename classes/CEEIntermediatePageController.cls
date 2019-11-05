/*-------------------------------------------------------------------------------
   @Author :Laxman Thadaka
   @name :CEEIntermediatePageController
   @CreateDate : 08/05/2015
   @Description :CEEIntermediatePageController Passing the values on CEE detail page.
   @Version :1.0
    11/17 INC000034402394 - Added single quotes escape for Account Name with single quotes causing the intermediate page to hung
  -------------------------------------------------------------------------------*/


public class CEEIntermediatePageController {
    // SCAVA Helper Method
    public static Boolean flsGet(SObjectField field)
    {
        return field.getDescribe().isCreateable() ? true : false;
    }
    private CEERedirectExtension redirectExt {get; set; }
    private String acctEBCECandOtherFSOLocation = Utilities.getConstant_CS('EBCECandOtherFSOLocation');
    private String acctceePrimaryFSO = Utilities.getConstant_CS('ceePrimaryFSO');
    private String acctceeLocation = Utilities.getConstant_CS('ceeLocation');
    private String acctEventType = Utilities.getConstant_CS('EventType');
    private String acctMeetingDeliveryType = Utilities.getConstant_CS('MeetingDeliveryType');
    private String acctBriefingTheatre = Utilities.getConstant_CS('BriefingTheatre');
    private String acctServiceCharge = Utilities.getConstant_CS('CEEServiceCharge');
    public string ceeLocation;
    public string CeeId;
    public Id PrimarySiteId;
    public Boolean chk {get; set; }
    public string serviceChargInfolink{get; set;}
    
    
  public CEEIntermediatePageController(ApexPages.StandardController controller) {
      CEE__c cee = (CEE__c)controller.getRecord();     
      CeeId = cee.Id;
      chk = false;
      redirectExt = new CEERedirectExtension(controller); 
      serviceChargInfolink = Utilities.getConstant_CS('CEEServiceChargeinfoLink');
  }
  CEE__C ce = new CEE__c();
  public CEE__c getCEE(){
      ce.RecordTypeId = ApexPages.currentPage().getParameters().get('RecordType');
      system.debug('ce.RecordTypeId>>>'+ce.RecordTypeId);
      return ce;
  }     
  
  //  Passing the Paramenters CEEIntermediatePage To CEE Detail Page
    public Pagereference continueNext(){                           
    string strUline = ApexPages.currentPage().getParameters().get('strURLRedirect');
    string oBXRecordType = objectRecordTypeIds__c.getOrgDefaults().CEE_OBX_Record_Type_ID__c.substring(0,15);    
    strUline = (strUline !=null) ? strUline : '/apex/CEEIntermediatePage?RecordType='+oBXRecordType;    
    
    try{
        ceeLocation = (ce.Primary_FSO__c != null && ce != null) ? [select Name, Id from CEE_Location__c where Id=:ce.Primary_FSO__c].Name : '';
                     
    }catch (Exception e){
            System.debug(e.getStackTraceString());
    }
    if(strUline != null){
            strUline = strUline.replace('CEEIntermediatePage','CEENewRecordTypeRedirect');        
            strUline = strUline.replace('AJAXREQUEST=_viewRoot','').replace('3FAJAXREQUEST%3D_viewRoot','');
            if(ce.Primary_FSO__c != null) { 
                strUline = strUline+'&'+acctEBCECandOtherFSOLocation+'='+ce.EBC_CBC_Location__c+'&'+acctceeLocation+'='+ceeLocation+'&'+acctceePrimaryFSO+'='+ce.Primary_FSO__c;
            }
            else{
                strUline = strUline+'&'+acctEBCECandOtherFSOLocation+'='+ce.EBC_CBC_Location__c+'&'+acctceeLocation+'='+ceeLocation;
            }
            system.debug('ce.Meeting_Delivery_Type__c>>>'+ ce.Meeting_Delivery_Type__c);
            if(ce.Service_Charge_1K_USD_to_Engagement__c != null){
                strUline = strUline+'&'+acctEventType+'='+ce.Event_Type__c +'&'+acctMeetingDeliveryType+'='+ce.Meeting_Delivery_Type__c+'&'+acctBriefingTheatre+'='+ce.Briefing_Theatre__c+'&'+acctServiceCharge+'='+ce.Service_Charge_1K_USD_to_Engagement__c;          
            }else{
              strUline = strUline+'&'+acctEventType+'='+ce.Event_Type__c +'&'+acctMeetingDeliveryType+'='+ce.Meeting_Delivery_Type__c+'&'+acctBriefingTheatre+'='+ce.Briefing_Theatre__c;          
            }            
        }
    //INC000034402394 - Added for suppressing special meaning of single quotes
    strUline =String.escapeSingleQuotes(strUline);
    
    PageReference pg= new PageReference(strUline);  
    pg.getParameters().put('strURLRedirect', strUline);   
    pg.setRedirect(true);
      return pg;              
    }
    //DisagreeCancelRequest Values Insert in to Service Charage object
    
    public void DisagreeCancelRequest(){
      Service_Charge__c sc = new Service_Charge__c();
      // SCAVA Fix
       if(flsget(Service_Charge__c.Briefing_Theatre__c))
      {
      sc.Briefing_Theatre__c = ce.Briefing_Theatre__c;
      }
       if(flsget(Service_Charge__c.EBC_CBC_Location_c__c))
      {
      sc.EBC_CBC_Location_c__c = ce.EBC_CBC_Location__c;
      }
      if(flsget(Service_Charge__c.Event_Type__c))
      {
      sc.Event_Type__c = ce.Event_Type__c;
      }
      if(flsget(Service_Charge__c.Meeting_Delivery_Type__c))
      {
      sc.Meeting_Delivery_Type__c = ce.Meeting_Delivery_Type__c;
      }
      if(flsget(Service_Charge__c.Primary_FSO1__c))
      {
      sc.Primary_FSO1__c = ce.Primary_FSO__c;
      }
       if(flsget(Service_Charge__c.User__c))
      {
      sc.User__c = userinfo.getUserId();
      }
      insert sc;
    }
    
    public list<Agenda_Item__c> getAgendaItemsData(){
        return [SELECT id,name,Start_Date_Time__c,End_Date_Time__c,Topic_Name__c,Selected_Rooms_Display__c,presenters__c,
                Outlook_Status__c,CEE_Attendee__c 
                FROM Agenda_Item__c WHERE Customer_Engagements_Events__c=:CeeId];
    }
                             
}