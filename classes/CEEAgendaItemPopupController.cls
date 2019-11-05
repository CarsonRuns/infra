/**************************************************************************************************
   @Author :Jay Dash
   @name :CEEAgendaItemPopupController
   @CreateDate : 07/28/2015
   @Description : This controller manages to fetch the agenda item details to CEE briefing detail page
   @Version :1.0
   
  *************************************************************************************************/
public class CEEAgendaItemPopupController{

    public final cee__c cee;
    public List<Agenda_Item__c> sub=new List<Agenda_Item__c>() ;
    public Agenda_Item__c agendaDelete = new Agenda_Item__c();
    public string agendaId {get; set;}  
    public ApexPages.StandardSetController setCon { get; set; }
    public List<PermissionSetAssignment> pset;
    public boolean perm {get; set;}
    public Integer pages { get; set; }
    
    
    //For Avoiding Hard coded Data
    
    //private static final string ERROR_MSG='No Records found for this subscription';

    public CEEAgendaItemPopupController(ApexPages.StandardController ceeController)
    {
         perm = false;
         try{
             pset = [SELECT id,permissionset.name FROM permissionsetassignment WHERE assigneeid =:UserInfo.getUserId() AND permissionset.name='CEE_Scheduler_program_manager' limit 1 ];
             if(!pset.isempty()){perm=true;}
         }catch (DMLException e){
             System.debug(e.getStackTraceString());
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING,e.getDmlMessage(0)));            
         }
         this.cee = (cee__c) ceeController.getRecord();
         if(cee.id!=null){
            try{
               loadData();
            }catch(Exception e){
               system.debug('Error on load data'+e.getStackTraceString());
            }
         }
    }
    
         
    public void loadData(){
       sub = [SELECT id,name,Start_Date_Time__c,Demo_Delivery_Location_s__c,End_Date_Time__c,Topic__c,Topic_Name__c,Topic__r.id,Selected_Rooms_Display__c,presenters__c,Outlook_Status__c
               FROM Agenda_Item__c WHERE Customer_Engagements_Events__c=:cee.id ORDER BY Start_Date_Time__c];
       
    }
    
    
    public list<Agenda_Item__c> getAgendaitems() {
        return sub;
    }
    
    public void deleteAgendaItem(){
        try{
            agendaDelete = [SELECT id,name FROM Agenda_Item__c WHERE id = :agendaId];
        }catch(Exception e){
            system.debug('Error on Delete data'+e.getStackTraceString());
        }
        if(agendaDelete.id != null){
            if (Agenda_Item__c.sObjectType.getDescribe().isDeletable())
               {
                delete agendaDelete;
               }
        }
        loadData();
   }
      
}