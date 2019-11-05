/* 
    This trigger has been deveoped by PEPE Dev team for May/June 2014 Release

    It does following job:

    A. It creates the LP based on TR Status for Partner Plus
    B. Update the LP records based on TR Status for Partner Plus
    C. Updates the Event Agenda and sibling TR statuses based on Primary TR for Partner Plus Lounge

    */
    trigger LearningPartnerCreation_PEPE on PEPE_Training_Request__c (before insert,before update,after insert,after update) {

    final String CREATED = 'Created';
    final string REQUESTED= 'Requested';
    final String DELIVERED = 'Delivered';
    final string ADDED_INTO_CART = 'Added Into Cart';
    final String EVENT_APPROVED = 'Event Approved';
    final String LOGISTICS_CONFIRMED = 'Logistics Confirmed';
    final String LEARNING_PARTNER_BEING_CONTACTED = 'Learning Partner being contacted';
    final String AWAITING_REQUESTORS_CONFIRMATION = 'Awaiting Requestor\'s confirmation';
    final String REQUEST_REJECTED = 'Request Rejected';
    final String REQUESTOR_CANCELLATION = 'Requestor Cancellation';
    final String EVENT_CANCELLED = 'Event Cancelled';
    final String EVENT_CANCELLED_BUT_PAID = 'Event Cancelled but Paid';
    final String LP_BEING_CONTACTED = 'LP being contacted';
    final String INSTRUCTOR_BEING_CONTACTED = 'Instructor being contacted';
    final String QUOTE_ACCEPTED = 'QUOTE ACCEPTED';

    public static final String PLATFORM_PARTNER_PLUS = 'Partner Plus';
    public static final String PLATFORM_ARCHITECTURE = 'Architectures';
    public static final String PLATFORM_PARTNER_PLUS_LOUNGE = 'Partner Plus Lounge';
    public static final String Expired = 'Expired';
    public static final String APPROVED= 'APPROVED';
    public final String PrTrStatus = '';
    Public integer EACOUNT;
    Public integer EARecCOUNT;

    Set<Id> lpsExistingTRSet = new Set<Id>();
    List<Id> lpsIds = new List<Id>();

    List<PEPE_Learning_Partner__c> lpsLPBC = new List<PEPE_Learning_Partner__c>();
    List<PEPE_Learning_Partner__c> lpsRest = new List<PEPE_Learning_Partner__c>();

    List<PEPE_Training_Request__c> trs = [Select Id, Status__c, Training_Offering_Id__r.Platform__c,platform__c,BLP_Flag__c,Training_Offering_Id__r.Delivery_Team_new__c,Training_Offering_Id__c, Training_Offering_Id__r.Potential_Learning_Partner_01__c,Training_Offering_Id__r.Potential_Learning_Partner_02__c,Training_Offering_Id__r.Potential_Learning_Partner_03__c,Training_Offering_Id__r.Estimated_Training_Cost__c,Training_Offering_Id__r.Estimated_Training_Cost_02__c,Training_Offering_Id__r.Estimated_Training_Cost_03__c, PLP_Email_Field_01__c, PLP_Email_Field_02__c, PLP_Email_Field_03__c from PEPE_Training_Request__c where id =: Trigger.new AND platform__c IN ( 'Partner Plus' , 'Architectures')];
    //List<PEPE_Learning_Partner__c> lpsList = [Select Id, Training_Request_Id__c, Status__c, QUOTE_ACCEPTED_FLAG__c from PEPE_Learning_Partner__c where Training_Request_Id__c =: Trigger.new];
    List<PEPE_Learning_Partner__c> lpsList = [Select Id, Training_Request_Id__c, Status__c, QUOTE_ACCEPTED_FLAG__c from PEPE_Learning_Partner__c where Training_Request_Id__c =: Trigger.new and Training_Request_Id__r.platform__c IN ( 'Partner Plus' , 'Architectures') ];
    //List<PEPE_Learning_Partner__c> lpsList = [Select Id, Training_Request_Id__c,Training_Request_Id__r.Platform__c, Status__c, QUOTE_ACCEPTED_FLAG__c from PEPE_Learning_Partner__c where Training_Request_Id__c =: Trigger.new and Training_Request_Id__r.platform__c !='Partner Plus Lounge'];
    system.debug('Count of lpsList ='+lpsList.size());
    set<id> eventid = new set<id>();
    set<id> otherID = new set<id>();


    //Added by Amit Mittal for Learning Partner Functionality
    for(PEPE_Learning_Partner__c l: lpsList){
    lpsExistingTRSet.add(l.Training_Request_Id__c);
    }


    ProfileID__c p = ProfileID__c.getInstance();
    String pid = UserInfo.getProfileId();

    
    //Before Trigger
    if(Trigger.isUpdate  && Trigger.isBefore){
    //system.debug('@@@ IS BEFORE TRIGGER TRAINING REQUEST =' + trs); 
    //system.debug('@@@ IS BEFORE TRIGGER Learning Partner =' + lpsList);

    ContextUtility_PEPE.OnTRBeforeUpdate(trs, Trigger.newMap);
    //system.debug('TR value after method is'+trs[0].PLP_Email_Field_01__c);
    //system.debug('Trigger.New value' + trigger.new);
    }

    //After Trigger
    if(Trigger.isUpdate && Trigger.isAfter){
    //system.debug('@@@ IS AFTER TRIGGER TRAINING REQUEST =' + trs); 
    //system.debug('@@@ IS AFTER TRIGGER Learning Partner =' + lpsList);


    //system.debug('@@@Inside the the isafter trigger');
    //A. Partner Plus and Architectures :It creates the LP based on TR Status
    for(PEPE_Training_Request__c tr: trs){
        system.debug('@@@Inside tr.Status__c '+tr.Status__c  + 'lpsLPBC.size()' + lpsLPBC.size()  );
        if((tr.Status__c == LEARNING_PARTNER_BEING_CONTACTED ||tr.Status__c == INSTRUCTOR_BEING_CONTACTED)  && lpsLPBC.size() >=0 ){
            system.debug('%%%%%%%'+tr.Status__c  + 'lpsLPBC.size()' + lpsLPBC.size() );
            if((tr.Training_Offering_Id__r.Platform__c  == PLATFORM_PARTNER_PLUS  || tr.Training_Offering_Id__r.Platform__c  == PLATFORM_ARCHITECTURE) && (tr.BLP_Flag__c == 'Yes' && tr.Training_Offering_Id__r.Delivery_Team_new__c.contains('Cisco Learning Partner'))){
            system.debug('AAAAAAAAAAMMMMMMMMMMMMMMMMMMMMIIIIIIIIIIIIIIITTTTTTTTTTTTTTTTT PLATFORM='+tr.Training_Offering_Id__r.Platform__c + 'FLAG='+tr.BLP_Flag__c +' Delivery TEAM='+tr.Training_Offering_Id__r.Delivery_Team_new__c );
                if(!lpsExistingTRSet.contains(tr.id)){
                    PEPE_Learning_Partner__c c1 = ContextUtility_PEPE.createLearningPartner(tr, tr.Training_Offering_Id__r.Potential_Learning_Partner_01__c, LP_BEING_CONTACTED, tr.Training_Offering_Id__r.Estimated_Training_Cost__c);    
                    if(c1 != null){
                        lpsLPBC.add(c1);
                    }
                    PEPE_Learning_Partner__c c2 = ContextUtility_PEPE.createLearningPartner(tr, tr.Training_Offering_Id__r.Potential_Learning_Partner_02__c, LP_BEING_CONTACTED, tr.Training_Offering_Id__r.Estimated_Training_Cost_02__c);    
                    if(c2!=null){
                        lpsLPBC.add(c2);
                    }
                    PEPE_Learning_Partner__c c3 = ContextUtility_PEPE.createLearningPartner(tr, tr.Training_Offering_Id__r.Potential_Learning_Partner_03__c, LP_BEING_CONTACTED, tr.Training_Offering_Id__r.Estimated_Training_Cost_03__c);    
                    if(c3!=null){
                        lpsLPBC.add(c3);
                    }
                }
            }
        }
    }
    //B. Partner Plus and Architectures : TR update PLP Email fields 
    for(PEPE_Training_Request__c t: trs ){    
        if(t.platform__c == PLATFORM_PARTNER_PLUS || (t.platform__c == PLATFORM_ARCHITECTURE && t.BLP_Flag__c == 'Yes' && t.Training_Offering_Id__r.Delivery_Team_new__c.contains('Cisco Learning Partner'))){
            system.debug(' @@@ Inside the Platform Filter Loop = '+ t.id);
            if(lpsList.size()>0){
                for(PEPE_Learning_Partner__c l: lpsList){
                    lpsRest.add(ContextUtility_PEPE.setLPS(l,t));
                }
            }
            system.debug(' @@@ Inside the Loop for lpsRest = '+ lpsRest);
        }
    }
    //DML operations
    if(lpsLPBC.size()>0){
        system.debug('Size gt than zero created lp records in LPBC ');
        insert lpsLPBC; 
    }

    if(lpsRest.size()>0){
    system.debug ('@@@lpsRest.size : '+ lpsRest.size());
        update lpsRest;

    }    

    }
    
    // functionality C. Start for Partner Plus Lounge
    if(Trigger.isUpdate && Trigger.isAfter){
    system.debug('@@@Inside the the isafter trigger - Dec release');
    if(ContextUtility_PEPE.isFirstRun()){  
     for(PEPE_Training_Request__c tr : trigger.new){      
        if (tr.platform__c == PLATFORM_PARTNER_PLUS_LOUNGE){ //Checking if the TR belongs to Partner Plus Lounge Platform
            eventid.add(tr.Training_Offering_Id__c); //setting the Event Id for the Partner Plus Lounge Platform
            if(tr.Primary_request__c == 'Yes'){
                otherID.add(tr.id);
            }
        }
    }
    //Enter this loop only for Partner Plus Lounge        
    If(eventid != null && eventid.size()>0)    {
        List<PEPE_Event_Agenda__c> eventAgendaList = [select id,Delivery_Team__c,Status__c,Training_Offering_Id__c from PEPE_Event_Agenda__c where Training_Offering_Id__c IN : eventid AND Delivery_Team__c!='' AND Status__c!=''];
        List<PEPE_Training_Request__c> forPRList = [select id,Primary_request__c,Status__c,Training_Offering_Id__c from PEPE_Training_Request__c where Training_Offering_Id__c=:eventid AND Primary_request__c='yes' AND Status__c!=:REQUEST_REJECTED];    
        List<PEPE_Training_Request__c> trNOList = [select id,status__c,Training_Offering_Id__c, Primary_request__c from PEPE_Training_Request__c where Training_Offering_Id__c IN : eventid AND  (Status__c!=:REQUEST_REJECTED and Status__c !=:REQUESTED and Status__c!=:ADDED_INTO_CART)]; // id NOT IN : otherID AND
        RecordType rtList =[select Id,name,SobjectType  from RecordType where Name = 'PPL Read Only' and SobjectType = 'PEPE_Training_Event__c' limit 1];
        EARecCOUNT = eventAgendaList.size();
            //Display error when more than one Primary TR
           EACOUNT = 0;
           for(PEPE_Training_Request__c trPr : trigger.new){ 
                if(forPRList.size()>1){ trPr.addError('Cannot create more than ONE Primary Request for PRIMARY HUB');}        
            }        
            for(PEPE_Training_Request__c tr1 : trigger.new){
             // Loop is handling Event Agenda Status's                                       
                for(PEPE_Event_Agenda__c ea1 : eventAgendaList)
                {                    
                    PEPE_Training_Event__c relatedTE = new  PEPE_Training_Event__c(id=tr1.Training_Offering_Id__c);
                    //Event Agenda Record Type assignment to 'Read Only' as per the status change of the Training request 
                    if(rtList!=null)
                    { 
                                if(tr1.status__c==Expired ||tr1.status__c==EVENT_CANCELLED ||tr1.status__c==EVENT_CANCELLED_BUT_PAID)
                                {
                                system.debug('Record Type Change to Read Only Here' );
                                relatedTE.RecordTypeId=rtList.id ;
                                update relatedTE;
                                }
                    }
                    
                                          
                    //Assigning the address from the Primary TR to Training Event & Language__c from Training Event to Event Agenda
                    if(tr1.Training_Offering_Id__c == ea1.Training_Offering_Id__c){
                        if(tr1.Primary_request__c == 'Yes' && tr1.status__c == LEARNING_PARTNER_BEING_CONTACTED )
                            {
                                //PEPE_Training_Event__c relatedTE = new  PEPE_Training_Event__c(id=tr1.Training_Offering_Id__c);
                                relatedTE.Alternate_Address_1__c = tr1.Alternate_Address_1__c;
                                relatedTE.Alternate_Address_2__c = tr1.Alternate_Address_2__c;
                                relatedTE.Alternate_Address_3__c = tr1.Alternate_Address_3__c;
                                relatedTE.Alternate_Tranining_location_Address__c = tr1.Alternate_Tranining_location_Address__c;
                                relatedTE.Alternate_Training_location_City__c = tr1.Alternate_Training_location_City__c;
                                relatedTE.Alternate_Zip_Code__c = tr1.Alternate_Zip_Code__c;
                                update relatedTE;
                                
                                ea1.Preferred_Language__c = relatedTE.Language_coverage__c;                               
                                
                                if(ea1.Delivery_Team__c == 'Cisco' || ea1.Delivery_Team__c == 'Distributors')
                                {ea1.status__c = AWAITING_REQUESTORS_CONFIRMATION;
                                //Counting EA Records
                                EACOUNT = EACOUNT+1;}                                                                
                                else  {ea1.status__c = tr1.status__c; }                                                                
                                // Below condition to check if primary request is "yes"  and all Agenda's are Cisco or distributors then Status of respective TR should be  ARC not LPBC
                                
                                                                                
                            }
                        
                    system.debug('@@@ value inside LearningPartnerCreation_PEPE trigger tr1.Primary_request__c :'+tr1.Primary_request__c  +' tr1.status__c:'+tr1.status__c + '  ea1.Delivery_Team__c :'+ea1.Delivery_Team__c+'  ea1.status__c:'+ea1.status__c);
                    //Update the status of the Event Agenda based on the Primary TR Status
                    if( tr1.Primary_request__c == 'Yes' && (tr1.status__c == EVENT_APPROVED || tr1.status__c == LOGISTICS_CONFIRMED || tr1.status__c == DELIVERED|| tr1.status__c == EVENT_CANCELLED || tr1.status__c == EVENT_CANCELLED_BUT_PAID || tr1.status__c ==Expired)){
                         if( ea1.status__c != 'Quote Rejected')
                            { ea1.status__c = tr1.status__c;  }
                        }
                        system.debug('@@@ value inside LearningPartnerCreation_PEPE trigger tr1.Primary_request__c :'+tr1.Primary_request__c  +' tr1.status__c:'+tr1.status__c + '  ea1.Delivery_Team__c :'+ea1.Delivery_Team__c+'  ea1.status__c:'+ea1.status__c);
                                                   
                     }  
                    
                     
                }//End of EA1
                
                //Update the Training Request Status
                if( tr1.Primary_request__c == 'Yes' && (tr1.status__c != ADDED_INTO_CART) && (tr1.status__c != REQUESTED) && (tr1.status__c != REQUEST_REJECTED)  )
                  {
                 
                            for(integer i = 0;i<trNOList.size(); i++){
                            
                            if(trNOList[i].Primary_request__c == 'No'){ trNOList[i].status__c = tr1.status__c; }
                            } 
                             
                   }
                
                
              } //End of Tr1 
                
            ContextUtility_PEPE.setFirstRunFalse();
            if(eventAgendaList.size()>0){ update eventAgendaList;}
            
            ContextUtility_PEPE.setFirstRunFalse();
            if(trNOList.size()>0){  update trNOList;  } 
                 
            //For Cisco and Distributor chnaging the TR Status to ARC    
            if (EACount == EARecCOUNT){
                for(integer i = 0;i<trNOList.size(); i++){
                    trNOList[i].status__c = AWAITING_REQUESTORS_CONFIRMATION; 
                            
                }   
            }
            
            ContextUtility_PEPE.setFirstRunFalse();
            if(trNOList.size()>0){  update trNOList;  } 
            
                  
            
       
      
        }//Partner Plus Lounge
        }
    } // End For DEC FY16 Release

    } //End the Trigger