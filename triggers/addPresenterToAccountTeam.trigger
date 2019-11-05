/***************************************************************************************************
Name    : addPresenterToAccountTeam 
Author  : Kathleen Gannon
Purpose : Trigger for Account Team visibility on a Presenter 
Created Date: Dec 1 2014
Modification History: 
Eric Pesch - Jan 05 2015: Added Comments, cleanup       
Eric Pesch - Jan 14 2015: Added batchable fix for SOQL calls
Jay Dash - Aug 5 2015: Added to update presenters in agenda item  
Sudi - June 14 2016,US10715 : Added extra code for non sfdc user is added as a presenter, 
						we are updating presenter cec ids in CEE, Agenda item objects.             
 *****************************************************************************************************/

trigger addPresenterToAccountTeam on CEE_Attendee__c (after update, after insert, before delete) {
    private static final String TAG = 'addPresenterToAccountTeam - ';
    
    //DML Operation containers
    AccountTeamMember[] acctTeamToUpdate = new AccountTeamMember[]{};
    AccountTeamMember[] acctTeamToDelete = new AccountTeamMember[]{};
    
    //Presenter containers
    Map<ID, CEE_Attendee__c> presenterMap = new Map<ID, CEE_Attendee__c> ();
    List<CEE_Attendee__c> presenterAlias = new List<CEE_Attendee__c>();
    
    //Reference ID lists
    List<Id> presenterToRemove = new List<Id>();    
    List<Id> accounts = new List<Id>();
    
    //Account string mappings
    Set<String> presentersToAccounts = new Set<String>();
    
    //Presenter list updates
    Set<Id> briefingUpdates = new Set<Id>();
    List<CEE__c> briefingToUpdate = new List<CEE__c>();
    Map<Id, CEE__c> briefingMap = new Map<Id, CEE__c>();
    
    //update Agenda item added 8/5/15
    Set<Id> agendaUpdates = new Set<Id>();
    List<Agenda_Item__c> agendaToUpdate = new List<Agenda_Item__c>();
    Map<Id, Agenda_Item__c> agendaMap = new Map<Id, Agenda_Item__c>();

    //Initial parsing
    if(trigger.isDelete){
        presenterMap = new Map<ID, CEE_Attendee__c> ([SELECT Id, Customer_Engagement_Events__r.Primary_Account__c FROM CEE_Attendee__c where Id IN :Trigger.old]); 

        for(CEE_Attendee__c c :trigger.old){
            presenterToRemove.add(Trigger.oldMap.get(c.Id).Salesforce_User__c);
            accounts.add(presenterMap.get(c.ID).Customer_Engagement_Events__r.Primary_Account__c); 
            
            presentersToAccounts.add(Trigger.oldMap.get(c.Id).Salesforce_User__c + '-' + presenterMap.get(c.ID).Customer_Engagement_Events__r.Primary_Account__c);
            briefingUpdates.add(c.Customer_Engagement_Events__c);
            //briefingUpdates.add(c.id);
            agendaUpdates.add(c.Agenda_Item__c);
            //agendaUpdates.add(c.id); 
        }
    } else {
        presenterMap = new Map<ID, CEE_Attendee__c>([SELECT Id, Customer_Engagement_Events__r.Primary_Account__c FROM CEE_Attendee__c where Id IN :Trigger.new]);

        for(CEE_Attendee__c c :trigger.new){
            if(trigger.isInsert && c.Salesforce_User__c != null && c.Type__c == 'Presenter'){
                AccountTeamMember atm = new AccountTeamMember(AccountId=presenterMap.get(c.ID).Customer_Engagement_Events__r.Primary_Account__c, UserId=c.Salesforce_User__c, TeamMemberRole='CEE Presenter');
                acctTeamToUpdate.add(atm);                  
            } else if (trigger.isUpdate){
                if(c.Salesforce_User__c != Trigger.oldMap.get(c.Id).Salesforce_User__c){
                    presenterToRemove.add(Trigger.oldMap.get(c.Id).Salesforce_User__c);
                    accounts.add(presenterMap.get(c.ID).Customer_Engagement_Events__r.Primary_Account__c); 
    
                    presentersToAccounts.add(Trigger.oldMap.get(c.Id).Salesforce_User__c + '-' + presenterMap.get(c.ID).Customer_Engagement_Events__r.Primary_Account__c);
                }
                
                if(c.Salesforce_User__c != null){
                    AccountTeamMember atm1 = new AccountTeamMember(AccountId=presenterMap.get(c.ID).Customer_Engagement_Events__r.Primary_Account__c, UserId=c.Salesforce_User__c, TeamMemberRole='CEE Presenter');
                    acctTeamToUpdate.add(atm1);    
                }             
            }    
            briefingUpdates.add(c.Customer_Engagement_Events__c);
            //briefingUpdates.add(c.id);
            agendaUpdates.add(c.Agenda_Item__c);
            //agendaUpdates.add(c.id); 
        }
    }
    
    //Grab all the attendees from the related briefings
    List<CEE_Attendee__c> fullAttendeeList = new List<CEE_Attendee__c>();
    List<CEE_Attendee__c> PresenterList = new List<CEE_Attendee__c>();
    try{
        // Sudi - 06/14/2016 : added new field email__c in SOQL query .
        fullAttendeeList = [select Id, Salesforce_User__r.Alias, Customer_Engagement_Events__c,Email__c from CEE_Attendee__c where Customer_Engagement_Events__c in : briefingUpdates
                            and Type__c =: 'Presenter'];
    } catch (Exception e){
        System.debug(TAG + e.getStackTraceString());
    }
    
    try{
        if(!agendaUpdates.isEmpty()){
            // Sudi - 06/14/2016 : added new field email__c in SOQL query .
            PresenterList = [select Id, Salesforce_User__r.Alias, Agenda_Item__c,Email__c from CEE_Attendee__c where Agenda_Item__c in : agendaUpdates
                                and Type__c =: 'Presenter'];
        }
    } catch (Exception e){
        System.debug(TAG + e.getStackTraceString());
    }
    
    //Find which listing to use parsing
    List<CEE_Attendee__c> attendeeList = null;
    if(trigger.IsDelete){
        attendeeList = trigger.old;
    } else {
        attendeeList = trigger.new;
    }
    
    //Grab only appropriate attendees for trigger action type
    for(CEE_Attendee__c oldAttendee : attendeeList){
        Set<String> aliasList = new Set<String>();
        List<String> aliasListIter = new List<String>();
        
        //Set<String> aliasListAgenda = new Set<String>();
        List<String> aliasListAgenda = new List<String>();
        List<String> aliasListIterAgenda = new List<String>();
        
        for (CEE_Attendee__c fullAttendee: fullAttendeeList) {
            if(trigger.isDelete){
                if ((oldAttendee.Customer_Engagement_Events__c == fullAttendee.Customer_Engagement_Events__c)
                        && !Trigger.oldMap.containsKey(fullAttendee.Id)) {
                    if(fullAttendee.Salesforce_User__c != null){
                        aliasList.add(fullAttendee.Salesforce_User__r.Alias);
                    }
                    // Sudi - 06/14/2016 : added extra condition for non SFDC user as a presenter 
                    if(fullAttendee.Salesforce_User__c == null && fullAttendee.Email__c != null){
                         string ciscoEmail = fullAttendee.Email__c;
                         String cec = ciscoEmail.substring(0,ciscoEmail.indexOf('@')).trim().toLowerCase();
                         aliasList.add(cec);
                    }
                }                
            } else if(fullAttendee.Salesforce_User__c != null && oldAttendee.Customer_Engagement_Events__c == fullAttendee.Customer_Engagement_Events__c){
                aliasList.add(fullAttendee.Salesforce_User__r.Alias); 
            }
            // Sudi - 06/14/2016 : added extra condition for non SFDC user as a presenter 
            else if(fullAttendee.Salesforce_User__c == null && fullAttendee.Email__c != null && oldAttendee.Customer_Engagement_Events__c == fullAttendee.Customer_Engagement_Events__c){
                string ciscoEmail = fullAttendee.Email__c;
                String cec = ciscoEmail.substring(0,ciscoEmail.indexOf('@')).trim().toLowerCase();
                aliasList.add(cec);
            }
            
        }
        
        for (CEE_Attendee__c Attendee: PresenterList) {
            if(trigger.isDelete){
                if ((oldAttendee.Agenda_Item__c == Attendee.Agenda_Item__c)
                        && !Trigger.oldMap.containsKey(Attendee.Id)) {
                    if(Attendee.Salesforce_User__c != null){
                        aliasListAgenda.add(Attendee.Salesforce_User__r.Alias);
                    }
                    // Sudi - 06/14/2016 : added extra condition for non SFDC user as a presenter 
                    if(Attendee.Email__c != null){  
                        string ciscoEmail = Attendee.Email__c;
                        String cec = ciscoEmail.substring(0,ciscoEmail.indexOf('@')).trim().toLowerCase();                       
                        aliasListAgenda.add(cec);
                    }
                }                
            } else if(Attendee.Salesforce_User__c != null && oldAttendee.Agenda_Item__c == Attendee.Agenda_Item__c){
                aliasListAgenda.add(Attendee.Salesforce_User__r.Alias); 
            }
            // Sudi - 06/14/2016 : added extra condition for non SFDC user as a presenter 
            else if(Attendee.Salesforce_User__c == null && Attendee.Email__c != null && oldAttendee.Agenda_Item__c == Attendee.Agenda_Item__c){
                string ciscoEmail = Attendee.Email__c;
                String cec = ciscoEmail.substring(0,ciscoEmail.indexOf('@')).trim().toLowerCase();                       
                aliasListAgenda.add(cec);
            }
        }
        
        
        if(!aliasList.isEmpty()){
            aliasListIter = new List<String>(aliasList);
        }
        
        if(!aliasListAgenda.isEmpty()){
            aliasListIterAgenda = new List<String>(aliasListAgenda);
        }
        
             
        String s1 = String.join(aliasListIter, ', ');
        String s2 = String.join(aliasListIterAgenda, ', ');
        
        if(!briefingMap.containsKey(oldAttendee.Customer_Engagement_Events__c)){
            CEE__c tmp = new CEE__c();
            tmp.id = oldAttendee.Customer_Engagement_Events__c;
            tmp.Presenter_Name_s__c = s1; 
            
            briefingMap.put(tmp.Id, tmp);
        }
        
        if(!agendaMap.containsKey(oldAttendee.Agenda_Item__c)){
            Agenda_Item__c tmpagnda = new Agenda_Item__c();
            tmpagnda.id = oldAttendee.Agenda_Item__c;
            tmpagnda.Presenters__c = s2; 
            if(tmpagnda.id != null){
                agendaMap.put(tmpagnda.Id, tmpagnda);
            }    
        }
    }
    
    //Grab unique Briefing from Map
    briefingToUpdate = briefingMap.values();
    agendaToUpdate = agendaMap.values();
    
    //Delete Account Team as Attendees removed
    if(!presenterToRemove.isEmpty()){
        for ( AccountTeamMember a : [Select Id, AccountId, UserId From AccountTeamMember Where AccountId IN :accounts]){
            if(presentersToAccounts.contains(a.UserId + '-' + a.AccountId)){
                system.debug(TAG + 'In the delete if');
                acctTeamToDelete.add(a);
            }   
        }
        
        if(!acctTeamToDelete.isEmpty()){
            delete acctTeamToDelete;          
        }
    }

    //Update account team
    if(!acctTeamToUpdate.isEmpty()){
        system.debug(TAG + 'In the insert if - ' + acctTeamToUpdate);
        insert acctTeamToUpdate;
    }   
    
    //Update briefings
    try{
        if(!briefingToUpdate.isEmpty()) {
            system.debug(TAG + 'In the briefing update if');
            update briefingToUpdate;  
        }
    } catch (Exception e){
        System.debug(TAG + e.getStackTraceString());
    }
    //Update Agenda
    try{
        if(!agendaToUpdate.isEmpty()) {
            system.debug(TAG + 'In the agenda update if');
            update agendaToUpdate;  
        }
    } catch (Exception e){
        System.debug(TAG + e.getStackTraceString());
    }
}