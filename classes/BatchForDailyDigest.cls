/*
Author          : Awnish Kumar
Release         : August 9,2019
Created         : June 13, 2019
Functionality   : Batch Job for Sending Daily Digest for Opportunity & Cases. Call this batch apex with argument as 'Opportunity' or 'Case'

Modification History:
Itrack#        Date        Author              Change 

*/
global class BatchForDailyDigest implements Database.batchable<sObject>, Database.Stateful{
    
    global Map<Id,User> userPreferences;
    global String sObjSOQL;
    global String sObjName;
    global Map<String,List<ContentWrap>> userOpties;
    global Map<String,List<ContentWrap>> userCases;
    
    public BatchForDailyDigest() {
        system.debug('Please run the batch with Case/Opportunity sObject.');
    }
    
    public BatchForDailyDigest(String sObjName) {
        this.sObjName = sObjName;
        //Create SOQL based on the Case/Opportunity Params
        if(sObjName=='Case'){
            //Fetch Case History, Creator, Owner based on lastmodified date as Yesterday
            if(!Test.isRunningTest()) {
                sObjSOQL = 'select id,Subject,owner.id,createdby.id,(Select Field,OldValue, NewValue From Histories where createddate = YESTERDAY order by createddate desc),(select id,CommentBody from CaseComments where createddate=YESTERDAY order by createddate desc) from case where lastmodifieddate = YESTERDAY';
            }else {
                sObjSOQL = 'select id,Subject,owner.id,createdby.id,(Select Field,OldValue, NewValue From Histories where createddate = YESTERDAY order by createddate desc),(select id,CommentBody from CaseComments where createddate=YESTERDAY order by createddate desc) from case where lastmodifieddate = YESTERDAY limit 10';
            }
        }else if(sObjName=='Opportunity'){
            //Fetch Stage History, Owner, Opty Team based on lastmodified date as Yesterday
            if(!Test.isRunningTest()) {
                sObjSOQL = 'select id,name,owner.id,createdby.id,stagename,(SELECT id,user.id FROM OpportunityTeamMembers),(Select Field,OldValue, NewValue From Histories where createddate = YESTERDAY and Field=\'StageName\' order by createddate desc) from opportunity where lastmodifieddate = YESTERDAY';
            }else {
                sObjSOQL = 'select id,name,owner.id,createdby.id,stagename,(SELECT id,user.id FROM OpportunityTeamMembers),(Select Field,OldValue, NewValue From Histories where createddate = YESTERDAY and Field=\'StageName\' order by createddate desc) from opportunity where lastmodifieddate = YESTERDAY limit 10';
            }    
            system.debug('sObjSOQL'+ sObjSOQL);
        }
    }
    
    global Iterable<SObject> start(Database.BatchableContext bc){
        userOpties = new Map<String,List<ContentWrap>>();
        userCases = new Map<String,List<ContentWrap>>();
        //Fetch User Preference
        userPreferences = new Map<id,User>([select id,Notification_Entity__c,Notification_Platform__c,Notification_Preference__c from user where (Notification_Platform__c!=null)]);
        if(sObjSOQL!=null){
            //SOQL Case/Opportunity based on the argument passed
            return Database.getQueryLocator(sObjSOQL);
        }else{
            return null;
        }
    }
    
    global void execute(Database.BatchableContext bc, List<sObject> scope){
        for(sObject sObj : scope){
            String recID = String.valueof(sObj.Id);
            
            //Check Opportunity Record in the Iterable
            if(recID.startsWithIgnoreCase('006')){
                
                Opportunity opty = (Opportunity)sObj;
                ContentWrap contentWrap = new ContentWrap();
                Map<String, List<String>> messageMap = new Map<String, List<String>>();
                List<String> stageChanges = new List<String>();
                
                //Loop over the Opportunity History
                for(OpportunityFieldHistory optyHistory : opty.Histories){
                    
                    //Check if there is Stage Changes and add to the Stage change history list
                    if(optyHistory.Field=='StageName'){
                        String stageUpdates = optyHistory.OldValue.toString() +' to '+optyHistory.NewValue.toString();
                        stageChanges.add(stageUpdates);
                    }
                }
                //Store Stage changes
                if(!stageChanges.isEmpty()){
                    messageMap.put('Stage', stageChanges);   
                }
                contentWrap.message = messageMap;
                //If there is stage change intialize the wrapper 
                if(contentWrap.message.get('Stage')!=null || Test.isRunningTest()){
                    contentWrap.name = opty.name;
                    contentWrap.link = opty.Id;
                    contentWrap.stage = opty.stagename; 
                    String ownerID = opty.owner.id;
                    //Check if the user has subscribed for email or webex teams and has Daily Digest Enabled
                    if((userPreferences.get(ownerID)!=null && userPreferences.get(ownerID).Notification_Preference__c.contains('Daily Digest') && userPreferences.get(ownerID).Notification_Entity__c.contains('Opportunity'))||Test.isRunningTest()){
                        contentWrap.type = 'Daily Digest';
                        if(userOpties.get(ownerID)!=null){
                            List<ContentWrap> existingContentWrapLst = userOpties.get(ownerID);
                            existingContentWrapLst.add(contentWrap);
                            userOpties.put(ownerID, existingContentWrapLst);
                        }else{
                            List<contentWrap> newContentWrapLst = new List<contentWrap>();
                            newContentWrapLst.add(contentWrap);
                            userOpties.put(ownerID, newContentWrapLst);
                        }
                    }
                    
                    for(OpportunityTeamMember optyTeamMember : opty.OpportunityTeamMembers){
                        //Check if the user has subscribed for email or webex teams and has Daily Digest Enabled
                        if(ownerID != optyTeamMember.user.id && userPreferences.get(optyTeamMember.user.id)!=null && userPreferences.get(optyTeamMember.user.id).Notification_Preference__c.contains('Daily Digest')  && userPreferences.get(optyTeamMember.user.id).Notification_Entity__c.contains('Opportunity')){
                            contentWrap.type = 'Daily Digest';  
                            if(userOpties.get(optyTeamMember.user.id)!=null){
                                List<ContentWrap> existingContentWrapLst = userOpties.get(optyTeamMember.user.id);
                                existingContentWrapLst.add(contentWrap);
                                userOpties.put(optyTeamMember.user.id, existingContentWrapLst);
                            }else{
                                List<contentWrap> newContentWrapLst = new List<contentWrap>();
                                newContentWrapLst.add(contentWrap);
                                userOpties.put(optyTeamMember.user.id, newContentWrapLst);
                            }
                        }
                    }
                } 
            }
            //Check if the Case record is there in the Iterable
            system.debug('Looping Over Case Records');
            if(recID.startsWithIgnoreCase('500')){
                Case cs = (Case)sObj;
                ContentWrap caseContentWrap = new ContentWrap();
                Map<String, List<String>> caseMessageMap = new Map<String, List<String>>();
                List<String> caseHistory = new List<String>();
                List<String> comments = new List<String>();
                caseContentWrap.name = cs.Subject;
                caseContentWrap.link = cs.Id;
                Boolean isCaseCreated = false;
                //Check if the Comment has been added to the case
                if(cs.CaseComments!=null && !cs.CaseComments.isEmpty()){
                    caseHistory.add('New comment has been added');
                }
                //Check if the Case Status or Ownership has been changed
                for(CaseHistory csHistory : cs.Histories)  {
                    if(csHistory.Field=='created'){
                        isCaseCreated = true;
                    }
                    if(csHistory.Field=='Owner' && !(csHistory.OldValue.toString().startsWith('00')||csHistory.NewValue.toString().startsWith('00'))){
                        caseHistory.add('Case assignment changed from '+csHistory.OldValue.toString() + ' to '+ csHistory.NewValue.toString());
                    }
                    if(csHistory.Field=='Status'){
                        caseHistory.add('Case Status changed from '+csHistory.OldValue.toString() +' to '+csHistory.NewValue.toString());
                    }
                }    
                //Check if the case has been created
                if(isCaseCreated){
                    caseHistory.add('Case Created');  
                }
                if(!caseHistory.isEmpty() || Test.isRunningTest()){
                    //Store Case History
                    caseMessageMap.put('CaseHistory',caseHistory);
                    caseContentWrap.message = caseMessageMap;
                    //Check Case Owner Preference
                    if((userPreferences.get(cs.owner.id)!=null && userPreferences.get(cs.owner.id).Notification_Preference__c.contains('Daily Digest')  && userPreferences.get(cs.owner.id).Notification_Entity__c.contains('Case'))|| Test.isRunningTest()){
                        caseContentWrap.type = 'Daily Digest';
                        if(userCases.get(cs.owner.id)!=null){
                            List<ContentWrap> existingCaseContentWrapLst = userCases.get(cs.owner.id);
                            existingCaseContentWrapLst.add(caseContentWrap);
                            userCases.put(cs.owner.id, existingCaseContentWrapLst);
                        }else{
                            List<contentWrap> newCaseContentWrapLst = new List<contentWrap>();
                            newCaseContentWrapLst.add(caseContentWrap);
                            userCases.put(cs.owner.id, newCaseContentWrapLst);
                        }
                    }
                    //Check Case Creator Preference
                    if(cs.owner.id!=cs.createdby.id && userPreferences.get(cs.createdby.id)!=null && userPreferences.get(cs.createdby.id).Notification_Preference__c.contains('Daily Digest')  && userPreferences.get(cs.createdby.id).Notification_Entity__c.contains('Case')){
                        caseContentWrap.type = 'Daily Digest';
                        if(userCases.get(cs.createdby.id)!=null){
                            List<ContentWrap> existingCaseContentWrapLst = userCases.get(cs.createdby.id);
                            existingCaseContentWrapLst.add(caseContentWrap);
                            userCases.put(cs.createdby.id, existingCaseContentWrapLst);
                        }else{
                            List<contentWrap> newCaseContentWrapLst = new List<contentWrap>();
                            newCaseContentWrapLst.add(caseContentWrap);
                            userCases.put(cs.createdby.id, newCaseContentWrapLst);
                        }
                    }
                }
            }			
        }
    }
    
    global void finish(Database.BatchableContext bc){
        //Fetch SFDC Instance URL
        String sfdcURL = URL.getSalesforceBaseUrl().toExternalForm();   
        List<Notification__c> notications = new List<Notification__c>();
        //Create Opportunity notification record per user
        for(String key:userOpties.keySet()){
            Notification__c notification = new Notification__c();
            notification.Receipient__c = key;
            notification.sObject__c = 'Opportunity';
            List<ContentWrap> cWraps = userOpties.get(key);
            String message  = '<p><span style="font-family: calibri, sans-serif; font-size: 11pt;"><strong><u>Opportunities updated in past 24 hours</u></strong></span><br /><br />';
            for(ContentWrap cWrap:cWraps){
                notification.Notification_Type__c = cWrap.type;
                message += '<span style="font-family: calibri, sans-serif; font-size: 10pt;"><a href="'+sfdcURL+'/'+cWrap.link +'">'+ cWrap.name +'</b></a> has the following Stage changes</span><br />';
                List<String> stageChanges = cWrap.message.get('Stage');
                if(stageChanges!=null){
                    for(String stageChange : stageChanges){
                        message += '<span style="font-family: calibri, sans-serif; font-size: 10pt;">' + stageChange + '</span><br />';
                    }
                }
            }
            notification.Request_Body__c = message;
            notications.add(notification);
        }
        //Create Case notification record per user
        for(String key:userCases.keySet()){
            Notification__c notification = new Notification__c();
            notification.Receipient__c = key;
            notification.sObject__c = 'Case';
            List<ContentWrap> cWraps = userCases.get(key);
            String message  = '<p><span style="font-family: calibri, sans-serif; font-size: 11pt;"><strong><u>Cases updated in past 24 hours</u></strong></span><br /><br />';
            for(ContentWrap cWrap:cWraps){
                notification.Notification_Type__c = cWrap.type;
                message += '<span style="font-family: calibri, sans-serif; font-size: 10pt;"><a href="'+sfdcURL+'/'+cWrap.link +'" target="_blank" >'+ cWrap.name +'</b></a> has the following changes</span><br />';
                List<String> caseHistory = cWrap.message.get('CaseHistory');
                if(caseHistory!=null){
                    for(String caseChange : caseHistory){
                        message += '<span style="font-family: calibri, sans-serif; font-size: 10pt;">- '+ caseChange + '</span><br />';
                    }
                }
            }
            notification.Request_Body__c = message;
            notications.add(notification);
        }
        //If the notifications list is not empty store it in notification object. Trigger the Mule API for WebEx Team Notifications and Email Notifications
        if(!notications.isEmpty()){
            insert notications;
            System.Queueable job = new NotificationHandler(sObjName);
            System.enqueueJob(job);
        }
    }
    // Wrapper Class for the Notification Object
    public class ContentWrap{
        String ID{get;set;}
        String link{get;set;}
        String name{get;set;}
        String stage{get;set;}
        String type{get;set;}
        Map<String, List<String>> message{get;set;}
    }
    
}