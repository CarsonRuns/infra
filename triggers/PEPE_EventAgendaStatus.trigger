/* This Trigger is added for PEPE FY16 Dec Release 

    A. Update the Training Request statuses if the Event Agenda status are as below

    Cisco then Awaiting Requestors confirmation
    BLP then Quote Accepted or Quote Rejected

    */

    trigger PEPE_EventAgendaStatus on PEPE_Event_Agenda__c (after update) {
    set<id> eventid = new set<id>();
    integer QACount=0;
    integer RCount=0;
    integer ARCCount=0;
    integer QAQRCount=0;
    integer RESTALLCount=0;


    final String AWAITING_REQUESTORS_CONFIRMATION = 'Awaiting Requestor\'s confirmation';
    final String QUOTE_ACCEPTED = 'QUOTE ACCEPTED';
    final String QUOTE_REJECTED = 'QUOTE REJECTED';
    final String REQUEST_REJECTED = 'Request Rejected';
    final string REQUESTED= 'Requested';
    final string ADDED_INTO_CART = 'Added Into Cart';
    public static final String LEARNING_PARTNER_BEING_CONTACTED = 'Learning Partner being contacted';
    public static final String Revised_Details_Requested ='Revised Details Requested';
    Public String EmailValue='';
    // Added on 9-mar-16  
    List<PEPE_Event_Agenda__c> eaLst= [Select Id, Agenda_Id__r.Business_Learning_Partner__c,Agenda_Id__r.Delivery_Team__c,Status__c, Training_Offering_Id__r.Platform__c,Training_Offering_Id__r.Delivery_Team__c,Training_Offering_Id__c, Training_Offering_Id__r.Potential_Learning_Partner_01__c,Training_Offering_Id__r.Potential_Learning_Partner_02__c,Training_Offering_Id__r.Potential_Learning_Partner_03__c,Training_Offering_Id__r.Estimated_Training_Cost__c,Training_Offering_Id__r.Estimated_Training_Cost_02__c,Training_Offering_Id__r.Estimated_Training_Cost_03__c, PLP_Email_Field_01__c from PEPE_event_agenda__c where id =: Trigger.new AND platform__c ='Partner Plus Lounge' and (status__c in('LEARNING PARTNER BEING CONTACTED' ,'Revised Details Requested'))];

    system.debug('XXXXXXXX ealist info '+eaLst); 

    /*

    for(PEPE_Event_Agenda__c p:eaLst)
    {
    if(p.Agenda_Id__r.Business_Learning_Partner__c !=null  && p.PLP_Email_Field_01__c==null ){
    //EmailValue=ContextUtility_PEPE.getEmailAlias(p.Agenda_Id__r.Business_Learning_Partner__c);
    p.PLP_Email_Field_01__c =ContextUtility_PEPE.getEmailAlias(p.Agenda_Id__r.Business_Learning_Partner__c);
    system.debug('XXXXX  P Value '+p.PLP_Email_Field_01__c);
    }
    }
    */

    for (integer j = 0; j <eaLst.size(); j++)
    {
    system.debug('XXXXX  IN LOOP');
    if(eaLst[j].Agenda_Id__r.Business_Learning_Partner__c !=null  && eaLst[j].PLP_Email_Field_01__c==null ){
    //EmailValue=ContextUtility_PEPE.getEmailAlias(p.Agenda_Id__r.Business_Learning_Partner__c);
    eaLst[j].PLP_Email_Field_01__c =ContextUtility_PEPE.getEmailAlias(eaLst[j].Agenda_Id__r.Business_Learning_Partner__c);
    system.debug('XXXXX  P Value '+eaLst[j].PLP_Email_Field_01__c);

    }
    }



    system.debug('@@@ value inside ContextUtility_PEPE.isFirstRun()'+ContextUtility_PEPE.isFirstRun());
    if(ContextUtility_PEPE.isFirstRun()){      

    for(PEPE_Event_Agenda__c ea : trigger.new){
    eventid.add(ea.Training_Offering_Id__c);
    }
    system.debug('XXXXXX entered into Event Agenda Trigger');
    List<PEPE_Training_Request__c> trList = [select id,status__c,Training_Offering_Id__c from PEPE_Training_Request__c where Training_Offering_Id__c IN : eventid and status__c !=:REQUESTED AND status__c !=:REQUEST_REJECTED and status__c !=:ADDED_INTO_CART];
    List<PEPE_Event_Agenda__c> allEventAgendaList = [select id,Delivery_Team__c,Status__c,Training_Offering_Id__c from PEPE_Event_Agenda__c where Training_Offering_Id__c=:eventid AND Delivery_Team__c!='' AND Status__c!=''];

    for(integer i=0; i<allEventAgendaList.size(); i++){
        
        system.debug('@@@ inside PEPE_EventAgendaStatus trigger allEventAgendaList[i].Delivery_Team__c:'+allEventAgendaList[i].Delivery_Team__c + '  allEventAgendaList[i].status__c:'+allEventAgendaList[i].status__c );
        if((allEventAgendaList[i].Delivery_Team__c == 'cisco' || allEventAgendaList[i].Delivery_Team__c == 'Distributors') && (allEventAgendaList[i].status__c == AWAITING_REQUESTORS_CONFIRMATION)){
            ARCCount++;
        }
        else if(allEventAgendaList[i].Delivery_Team__c == 'Business Learning Partner' && (allEventAgendaList[i].status__c == QUOTE_ACCEPTED || allEventAgendaList[i].status__c == QUOTE_REJECTED)){
            QAQRCount++;
        }
        else{
            RESTALLCount++;
        }
    }


    if(  ( allEventAgendaList.size()== (ARCCount + QAQRCount)) ){
    for(PEPE_Event_Agenda__c ea1 : trigger.new){
        for(PEPE_Training_Request__c tr1 : trList){  
            system.debug('@@@ inside PEPE_EventAgendaStatus trigger ea1.Training_Offering_Id__c :'+ea1.Training_Offering_Id__c+'  tr1.Training_Offering_Id__c : '+tr1.Training_Offering_Id__c);
           if(ea1.Training_Offering_Id__c == tr1.Training_Offering_Id__c){
                if(tr1.status__c != REQUEST_REJECTED){
                    tr1.status__c = AWAITING_REQUESTORS_CONFIRMATION;
                }
           }
            
        }
    }

    ContextUtility_PEPE.setFirstRunFalse();        
    if(trList.size()>0){
        update trList;
    }


    }
    //Amit updating for Email list
    ContextUtility_PEPE.setFirstRunFalse();        
    if(eaLst.size()>0)
    {
        update eaLst;
         system.debug('XXXXX Emai Value Update');
    }
    }


    }