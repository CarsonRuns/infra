/***************************************************************************************************
Name    : AccountExecSponsorBeforeUpsert 
Author  : Eric Pesch
Purpose : Trigger for inserting the Account Executive Sponsor information  
Created Date: Dec 1 2014
Modification History: 
Eric Pesch - Jan 5 2015: Added Comments, cleanup                     
*****************************************************************************************************/

trigger AccountExecSponsorBeforeUpsert on Account_Executive_Sponsor__c (after insert, after update) {
    private final String TAG = 'AccountExecSponsorBeforeUpsert - ';
    Account_Executive_Sponsor__c[] resources = Trigger.new;
    
    Set<Account_Executive_Sponsor__c> resourceUpdate = new Set<Account_Executive_Sponsor__c>();
    Set<String> resourceCEC = new Set<String>();
    Map<String, User> resourceUsers = new Map<String, User>();
    
    //Iterate and find where might need Users
    //System.debug(TAG + 'Grabbing resources');
    for(Account_Executive_Sponsor__c resource : resources){
        if(!String.isEmpty(resource.VP_CEC__c) 
                || !String.isEmpty(resource.Supporting_Sponsors_CEC__c)
                || !String.isEmpty(resource.Lead_Sponsors_CEC__c)
                || !String.isEmpty(resource.Account_Leads_CEC__c)){
            resourceUpdate.add(resource);
            
            String[] cecList = null;            
            if(!String.isEmpty(resource.VP_CEC__c)){
                cecList = resource.VP_CEC__c.split(',');
                for(Integer i = 0 ; i < cecList.size(); i++){
                    cecList[i] = cecList[i] + '@%';
                }
                resourceCEC.addAll(cecList);
            }
            
            if(!String.isEmpty(resource.Supporting_Sponsors_CEC__c)){
                cecList = resource.Supporting_Sponsors_CEC__c.split(',');
                for(Integer i = 0 ; i < cecList.size(); i++){
                    cecList[i] = cecList[i] + '@%';
                }
                resourceCEC.addAll(cecList);
            } 
            
            if(!String.isEmpty(resource.Lead_Sponsors_CEC__c)){
                cecList = resource.Lead_Sponsors_CEC__c.split(',');
                for(Integer i = 0 ; i < cecList.size(); i++){
                    cecList[i] = cecList[i] + '@%';
                }
                resourceCEC.addAll(cecList);
            } 
            
            if(!String.isEmpty(resource.Account_Leads_CEC__c)){
                cecList = resource.Account_Leads_CEC__c.split(',');
                for(Integer i = 0 ; i < cecList.size(); i++){
                    cecList[i] = cecList[i] + '@%';
                }
                resourceCEC.addAll(cecList);
            } 
        }
    }

    
    //Find old ESP Users
    Map<Id, List<Account_Executive_User__c>> oldUserMap = 
        new Map<Id, List<Account_Executive_User__c>>();
    try{
        //Grab ESP Users
        //System.debug(TAG + 'Fetching old Users');
        List<Account_Executive_User__c> oldUsers = null;
        oldUsers = [select Id, Account_Executive_Sponsor__c, Type__c, User__c, User__r.UserName from Account_Executive_User__c
                    where Account_Executive_Sponsor__c in : (resourceUpdate) ];
        for(Account_Executive_User__c user : oldUsers){
            if(!oldUserMap.containsKey(user.Account_Executive_Sponsor__c)){
                oldUserMap.put(user.Account_Executive_Sponsor__c, new List<Account_Executive_User__c>{user});
            } else {
                oldUserMap.get(user.Account_Executive_Sponsor__c).add(user);
            }
        }
        
        //Grab salesforce users (to add later if required)
        //System.debug(TAG + 'Fetching SFDC Users from cec list');
        List<User> sfdcUsers = [select Id, UserName from User where UserName like : (resourceCEC)];
        for(User sfdcUser : sfdcUsers){
            resourceUsers.put(sfdcUser.UserName.substring(0, sfdcUser.UserName.indexOf('@')), sfdcUser);
            //System.debug(TAG + 'user - ' + sfdcUser.UserName + ' - ' + sfdcUser.UserName.substring(0, sfdcUser.UserName.indexOf('@')));
        }
        
    } catch (Exception e){
        System.debug(TAG + 'Error in retrieving old Account Users - ' + e.getStackTraceString());
    }
    
    //ESP - iterate resource
    //Find if <Type, User> exists for ESP
    //ESP - <ESP, <type, cec>>
    //ESP, list<type, cec> - see if ESP in oldUser map, <ESP, List<ESP User>>, see if in List or Map, if yes, remove from old, else, add
    List<Account_Executive_User__c> newUsers = new List<Account_Executive_User__c>();
    for(Account_Executive_Sponsor__c resource : resourceUpdate){
        String[] cecList = null;
        List<Account_Executive_User__c> oldUser = oldUserMap.get(resource.Id);
        Boolean isOldUser = false;
        if(!String.isEmpty(resource.VP_CEC__c)){
            cecList = resource.VP_CEC__c.split(',');
            for(String cec : cecList){
                isOldUser = false;
                if(oldUser != null){
                    for(Integer i = 0; i < oldUser.size(); i++){
                        if(oldUser.get(i).User__r.UserName.contains(cec + '@') &&
                                oldUser.get(i).Type__c == 'VP'){
                            oldUser.remove(i);
                            isOldUser = true;
                            i = oldUser.size();
                        }
                    }
                }
                
                if(!isOldUser && resourceUsers.containsKey(cec)){
                    //System.debug(TAG + 'VP - found SFDC user - adding - ' + cec);
                    Account_Executive_User__c newUser = new Account_Executive_User__c();
                    newUser.Account_Executive_Sponsor__c = resource.Id;
                    newUser.Type__c = 'VP';
                    newUser.User__c = resourceUsers.get(cec).Id;
                    
                    newUsers.add(newUser);
                }
            }
        } 
        
        if(!String.isEmpty(resource.Supporting_Sponsors_CEC__c)){
            cecList = resource.Supporting_Sponsors_CEC__c.split(',');
            for(String cec : cecList){
                isOldUser = false;
                if(oldUser != null){
                    for(Integer i = 0; i < oldUser.size(); i++){
                        if(oldUser.get(i).User__r.UserName.contains(cec + '@') &&
                                oldUser.get(i).Type__c == 'Supporting Sponsor'){
                            oldUser.remove(i);
                            isOldUser = true;
                            i = oldUser.size();
                        }
                    }
                }
                
                if(!isOldUser && resourceUsers.containsKey(cec)){
                    Account_Executive_User__c newUser = new Account_Executive_User__c();
                    newUser.Account_Executive_Sponsor__c = resource.Id;
                    newUser.Type__c = 'Supporting Sponsor';
                    newUser.User__c = resourceUsers.get(cec).Id;
                    
                    newUsers.add(newUser);
                }
            }
        } 
        
        if(!String.isEmpty(resource.Lead_Sponsors_CEC__c)){
            cecList = resource.Lead_Sponsors_CEC__c.split(',');
            for(String cec : cecList){
                isOldUser = false;
                if(oldUser != null){
                    for(Integer i = 0; i < oldUser.size(); i++){
                        if(oldUser.get(i).User__r.UserName.contains(cec + '@') &&
                                oldUser.get(i).Type__c == 'Lead Sponsor'){
                            oldUser.remove(i);
                            isOldUser = true;
                            i = oldUser.size();
                        }
                    }
                }
                
                if(!isOldUser && resourceUsers.containsKey(cec)){
                    Account_Executive_User__c newUser = new Account_Executive_User__c();
                    newUser.Account_Executive_Sponsor__c = resource.Id;
                    newUser.Type__c = 'Lead Sponsor';
                    newUser.User__c = resourceUsers.get(cec).Id;
                    
                    newUsers.add(newUser);
                }
            }
        } 
        
        if(!String.isEmpty(resource.Account_Leads_CEC__c)){
            cecList = resource.Account_Leads_CEC__c.split(',');
            for(String cec : cecList){
                isOldUser = false;
                if(oldUser != null){
                    for(Integer i = 0; i < oldUser.size(); i++){
                        if(oldUser.get(i).User__r.UserName.contains(cec + '@') &&
                                oldUser.get(i).Type__c == 'Account Lead'){
                            oldUser.remove(i);
                            isOldUser = true;
                            i = oldUser.size();
                        }
                    }
                }
                
                if(!isOldUser && resourceUsers.containsKey(cec)){
                    Account_Executive_User__c newUser = new Account_Executive_User__c();
                    newUser.Account_Executive_Sponsor__c = resource.Id;
                    newUser.Type__c = 'Account Lead';
                    newUser.User__c = resourceUsers.get(cec).Id;
                    
                    newUsers.add(newUser);
                }
            }
        } 
    }
    
    //Insert new Users
    try {
        insert newUsers;
    } catch (Exception e){
        System.debug(TAG + 'Error in inserting new users - ' + e.getStackTraceString());
    }
    
    //Delete Users who are no longer needed
    List<Account_Executive_User__c> delUsers = new List<Account_Executive_User__c>();
    for(List<Account_Executive_User__c> userLists : oldUserMap.values()){
        for(Account_Executive_User__c user : userLists){
            delUsers.add(user);
        }
    }
    
    try {
        delete delUsers;
    } catch (Exception e){
        System.debug(TAG + 'Error in deleting old users - ' + e.getStackTraceString());
    }
}