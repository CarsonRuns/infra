/*
Author          : Shivi
Release         : Account Team March 29, 2019 Release
Created         : Feb 11, 2019
Functionality   : Account Team


Modification History:
Itrack#        Date        Author              Change 
US249615       2/5/2019    Shivi         SE Evol Seller adding themselves to Account teams, removing themselves and reassign  en masse not individually(Need to split in 2 parts)
US307738       5/3/2019    Shivi         SE Evol - Account Team Management - view picklist dropdown for Recently Viewed, Associated Accounts and Unassociated Accounts
US290148	   6/12/2019   Kavya 		 SE Evol - Account Team Management - SE ID Filter for SEMs
US304333       6/27/2019   Kavya 		 SE Evolution - Account Management - AM search/filter
DE261892	   7/23/2019   Kavya         Number of contacts field is blank for few accounts in unassociated view
*/
public WITH sharing class AccountSearch_CTL {
    public static String orderByVal;
    public static String sortDirection;
    @AuraEnabled  
    public static List<accountInfo> fetchAccounts(String accId,String accOwnerId, String selectedView, List<String> reporteeLst, Integer offsetVal, String sortedField, String sortDir) { 
        String searchKey =  '%' + accId + '%';
        String accOwnerSearchKey = '%' + accOwnerId + '%';
        String recordtype=Utilities.getConstant_CS('AccountRecordType');
        Boolean sortOnServer=false;
        sortDirection=sortDir;
        List<AggregateResult> result = new List<AggregateResult>();
        List<Id> accIdList = new List<Id>();
        //Check if loggedIn User is SE Manager
        //To fetch the Accounts from Selected View for the Account Team
        List<Account> accLst= new List<Account>(); 
        String userId=(userInfo.getUserName()).substringBefore('@');
        List<User> reportees=[Select id from User where Reporting_Manager_Level_1_cec__c=:userId.toUpperCase() AND Additional_User_Permissions__c includes ('SE User') and isActive=true];
        List<accountInfo> AI=new List<accountInfo>();
        List<Id> userIdLst=new List<Id>();
        Map<Id, Integer> accMap = new Map<Id,Integer>();
        List<Account> accTM=new List<Account>();
        if(!reportees.isEmpty()){        
            for(User uId: reportees){
                userIdLst.add(uId.Id); 
            }
        } 
        //Add logged in user to list
        userIdLst.add(UserInfo.getUserId());
        
        if(!reporteeLst.isEmpty()){
            userIdLst.clear();
            userIdLst.addAll(reporteeLst);
        }
        //Sort Fields mapping
        if(sortedField=='redirectURL'){orderByVal='name';}
        if(sortedField=='accOwner'){orderByVal='Owner.Username';}
        if(sortedField=='city'){orderByVal='City__c';}
        if(sortedField=='country'){orderByVal='Country__c';}
        if(sortedField=='cActiveOpty'){orderByVal='Count_of_Active_Opps__c';}
        if(sortedField=='atvOptyVal'){orderByVal='Active_Opportunity_Value__c';}
        if(sortedField=='cOpty'){orderByVal='Count_of_Opportunities__c';}
        if(sortedField=='optyVal'){orderByVal='All_Opportunity_Value__c';}
        
        /*--------------------------------------------Query the Accounts based on the Selected Views------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
        
        //when selected view is unassociated account
        if(selectedView=='unassociatedAccounts')
        {
            //reportee lst will be blank always in unassociated view
            //when accid and am id is blank
            if(String.isBlank(accId) && String.isBlank(accOwnerId))
            {
                List<Account> accTM1=  [Select Name,Country__c,City__c,Id,Owner.Username,Count_of_Opportunities__c,All_Opportunity_Value__c,                
                                        Active_Opportunity_Value__c,Count_of_Active_Opps__c,
                                        (Select id,TeamMemberRole,User.Username,UserId from AccountTeamMembers) 
                                        from Account where Id IN (Select AccountId from AccountTeamMember where UserId IN:userIdLst)
                                        AND recordtypeId=:recordtype];
                List<Id> accIds= new List<Id>();
                Map<Id,Account>mapAcc=new Map<Id,Account>();
                for(Account acc:accTM1){
                    accIds.add(acc.Id);
                    mapAcc.put(acc.Id,acc);
                }
                System.debug('mapAcc>> '+mapAcc);
                String soqlGetLastViewedUnAccounts='Select Name,Country__c,City__c,Id,Owner.Username,'+
                    'Count_of_Opportunities__c,All_Opportunity_Value__c,Active_Opportunity_Value__c,Count_of_Active_Opps__c'+
                    ' From Account WHERE recordtypeId=: recordtype AND Id not IN:accIds ORDER BY '+orderByVal+' '+sortDir+' limit 50 OFFSET '+ offsetVal;
                
                //Commenting below code because its not used 
                /*Set<Account> accLstSet=new Set<Account>();
                if(!accIds.isEmpty()){
                    for(Account parAcc:Database.query(soqlGetLastViewedUnAccounts)){
                        if(!mapAcc.containsKey(parAcc.Id)){
                            accLstSet.add(parAcc);
                            
                        }
                     }
                    accLst.addAll(accLstSet);
                    System.debug('acc Lst'+accLst);
                    //adding accId to accIdList to pass accIdList to query for fetching count of contacts
                    for(Account acc : accLst)
                    {
                        accIdList.add(acc.Id);//Kavya
                    }
					System.debug('accLst'+accLst);                    
                }
                else{
                    //Added for loop to avoid QueryException
                    for(Account acc: Database.query(soqlGetLastViewedUnAccounts)){
                        accLst.add(acc);
                        accIdList.add(acc.Id);
                    }
                }*/
                
                for(Account parAcc:Database.query(soqlGetLastViewedUnAccounts)){
                    	accLst.add(parAcc);
                        accIdList.add(parAcc.Id);
                }
                //added by Kavya to fetch the Number of contacts
                result = [SELECT COUNT(Id) Total, AccountId FROM Contact WHERE AccountId in:accIdList GROUP BY AccountId]; 
                for(AggregateResult a : result) {  
                    accMap.put((Id)a.get('AccountId'),(Integer)a.get('Total'));
                }
            }
            //when accid is not blank and am id is blank
            else if(!String.isBlank(accId) && String.isBlank(accOwnerId))
            {
                List<Account> accTM1=  [Select Name,Country__c,City__c,Id,Owner.Username,Count_of_Opportunities__c,All_Opportunity_Value__c,                
                                        Active_Opportunity_Value__c,Count_of_Active_Opps__c,
                                        (Select id,TeamMemberRole,User.Username,UserId from AccountTeamMembers) 
                                        from Account where Id IN (Select AccountId from AccountTeamMember where UserId IN:userIdLst AND Account.Name like:searchKey )
                                        AND recordtypeId=:recordtype];
                List<Id> accIds= new List<Id>();
                for(Account acc:accTM1){
                    accIds.add(acc.Id);
                }
                String soqlGetLastViewedUnAccounts='Select Name,Country__c,City__c,Id,Owner.Username,'+
                    'Count_of_Opportunities__c,All_Opportunity_Value__c,Active_Opportunity_Value__c,Count_of_Active_Opps__c'+
                    ' From Account WHERE (recordtypeId=:recordtype AND Id not IN:accIds AND Account.Name like:searchKey ) Order By '+orderByVal+' '+sortDir+' limit 50 OFFSET '+ offsetVal;
                accLst=Database.query(soqlGetLastViewedUnAccounts);
                for(Account acc: accLst){
                    accIdList.add(acc.Id);
                }
                //added by Kavya to fetch the Number of contacts
                result = [SELECT COUNT(Id) Total, AccountId FROM Contact WHERE AccountId in:accIdList GROUP BY AccountId]; 
                for(AggregateResult a : result) {  
                    accMap.put((Id)a.get('AccountId'),(Integer)a.get('Total'));
                }
            }
            //when accid is blank and amid is not blank
            else if(String.isBlank(accId) && !String.isBlank(accOwnerId))
            {
                List<Account> accTM1=  [Select Name,Country__c,City__c,Id,Owner.Username,Count_of_Opportunities__c,All_Opportunity_Value__c,                
                                        Active_Opportunity_Value__c,Count_of_Active_Opps__c,
                                        (Select id,TeamMemberRole,User.Username,UserId from AccountTeamMembers) 
                                        from Account where Id IN (Select AccountId from AccountTeamMember where UserId IN:userIdLst AND Account.Owner.Username like:accOwnerSearchKey )
                                        AND recordtypeId=:recordtype];
                List<Id> accIds= new List<Id>();
                for(Account acc:accTM1){
                    accIds.add(acc.Id);
                }
                String soqlGetLastViewedUnAccounts='Select Name,Country__c,City__c,Id,Owner.Username,'+
                    'Count_of_Opportunities__c,All_Opportunity_Value__c,Active_Opportunity_Value__c,Count_of_Active_Opps__c'+
                    ' From Account WHERE (recordtypeId=:recordtype AND Id not IN:accIds AND Account.Owner.Username like:accOwnerSearchKey ) Order By '+orderByVal+' '+sortDir+' limit 50 OFFSET '+ offsetVal;
                accLst=Database.query(soqlGetLastViewedUnAccounts);
                for(Account acc: accLst){
                    accIdList.add(acc.Id);
                }
                //added by Kavya to fetch the Number of contacts
                result = [SELECT COUNT(Id) Total, AccountId FROM Contact WHERE AccountId in:accIdList GROUP BY AccountId]; 
                for(AggregateResult a : result) {  
                    accMap.put((Id)a.get('AccountId'),(Integer)a.get('Total'));
                }
            }
            //when both accid and amid is present
            else
            {
                List<Account> accTM1=  [Select Name,Country__c,City__c,Id,Owner.Username,Count_of_Opportunities__c,All_Opportunity_Value__c,                
                                        Active_Opportunity_Value__c,Count_of_Active_Opps__c,
                                        (Select id,TeamMemberRole,User.Username,UserId from AccountTeamMembers) 
                                        from Account where Id IN (Select AccountId from AccountTeamMember where UserId IN:userIdLst AND (Account.Name like:searchKey and Account.Owner.Username like:accOwnerSearchKey ))
                                        AND recordtypeId=:recordtype];
                List<Id> accIds= new List<Id>();
                for(Account acc:accTM1){
                    accIds.add(acc.Id);
                }
                String soqlGetLastViewedUnAccounts='Select Name,Country__c,City__c,Id,Owner.Username,'+
                    'Count_of_Opportunities__c,All_Opportunity_Value__c,Active_Opportunity_Value__c,Count_of_Active_Opps__c'+
                    ' From Account WHERE (recordtypeId=:recordtype AND Id not IN:accIds AND (Account.Name like:searchKey and Account.Owner.Username like:accOwnerSearchKey)) Order By '+orderByVal+' '+sortDir+' limit 50 OFFSET '+ offsetVal;
                accLst=Database.query(soqlGetLastViewedUnAccounts);
                //added by Kavya to fetch the Number of contacts
                for(Account acc: accLst){
                    accIdList.add(acc.Id);
                }
                result = [SELECT COUNT(Id) Total, AccountId FROM Contact WHERE AccountId in:accIdList GROUP BY AccountId]; 
                for(AggregateResult a : result) {  
                    accMap.put((Id)a.get('AccountId'),(Integer)a.get('Total'));
                }
            }
        }
        //for associate account
        else if(selectedView=='associatedAccounts')
        {
            
            if(String.isBlank(accId)  && reporteeLst.isEmpty() && String.isBlank(accOwnerId))
            {
                String query ='Select Name,Country__c,City__c,Id,Owner.Username,Count_of_Opportunities__c,'+
                    'All_Opportunity_Value__c,Active_Opportunity_Value__c,Count_of_Active_Opps__c,'+
                    '(Select id,TeamMemberRole,User.Username,UserId '+ 
                    'from AccountTeamMembers) from Account where Id IN (Select AccountId from AccountTeamMember '+
                    'where UserId IN:userIdLst) AND recordtypeId=:recordtype order by '+ orderByVal+' '+sortDir+' limit 50 offset '+offsetVal;
                accTM=Database.query(query); 
                //added by Kavya to fetch the Number of contacts
                for(Account acc: accTM){
                    accIdList.add(acc.Id);
                }
                result = [SELECT COUNT(Id) Total, AccountId FROM Contact WHERE AccountId in:accIdList GROUP BY AccountId]; 
                for(AggregateResult a : result) {  
                    accMap.put((Id)a.get('AccountId'),(Integer)a.get('Total'));
                }
            }
            else if((!String.isBlank(accId)  && reporteeLst.isEmpty() && String.isBlank(accOwnerId))
                    || (!String.isBlank(accId)  && !reporteeLst.isEmpty() && String.isBlank(accOwnerId)))
            {
                accTM =Database.query('Select Name,Country__c,City__c,Id,Owner.Username,Count_of_Opportunities__c,'+
                                      'All_Opportunity_Value__c,Active_Opportunity_Value__c,Count_of_Active_Opps__c,'+
                                      '(Select id,TeamMemberRole,User.Username,UserId '+ 
                                      'from AccountTeamMembers) from Account where Id IN (Select AccountId from AccountTeamMember '+ 
                                      'where UserId IN:userIdLst AND Account.Name like:searchKey ) AND recordtypeId=:recordtype ORDER BY '+orderByVal+' '+sortDir+' limit 50 offset '+offsetVal);
               //added by Kavya to fetch the Number of contacts
                for(Account acc: accTM){
                    accIdList.add(acc.Id);
                }
                result = [SELECT COUNT(Id) Total, AccountId FROM Contact WHERE AccountId in:accIdList GROUP BY AccountId]; 
                for(AggregateResult a : result) {  
                    accMap.put((Id)a.get('AccountId'),(Integer)a.get('Total'));
                }
            }
            else if(String.isBlank(accId)  && !reporteeLst.isEmpty() && String.isBlank(accOwnerId))
            {
                accTM = Database.query('Select Name,Country__c,City__c,Id,Owner.Username,Count_of_Opportunities__c,'+   
                                       'All_Opportunity_Value__c,Active_Opportunity_Value__c,Count_of_Active_Opps__c,'+
                                       '(Select id,TeamMemberRole,User.Username,UserId '+ 
                                       'from AccountTeamMembers) from Account where Id IN (Select AccountId from AccountTeamMember '+ 
                                       'where UserId IN:userIdLst) AND recordtypeId=:recordtype order by '+orderByVal+' '+sortDir+' limit 50 offset '+offsetVal);
               //added by Kavya to fetch the Number of contacts
                for(Account acc: accTM){
                    accIdList.add(acc.Id);
                }
                result = [SELECT COUNT(Id) Total, AccountId FROM Contact WHERE AccountId in:accIdList GROUP BY AccountId]; 
                for(AggregateResult a : result) {  
                    accMap.put((Id)a.get('AccountId'),(Integer)a.get('Total'));
                }
            }
            else if((String.isBlank(accId)  && reporteeLst.isEmpty() && !String.isBlank(accOwnerId))
                    || (String.isBlank(accId)  && !reporteeLst.isEmpty() && !String.isBlank(accOwnerId)))
            {
                accTM =Database.query('Select Name,Country__c,City__c,Id,Owner.Username,Count_of_Opportunities__c,'+
                                      'All_Opportunity_Value__c,Active_Opportunity_Value__c,Count_of_Active_Opps__c,'+
                                      '(Select id,TeamMemberRole,User.Username,UserId '+ 
                                      'from AccountTeamMembers) from Account where Id IN (Select AccountId from AccountTeamMember '+ 
                                      'where UserId IN:userIdLst AND Account.Owner.Username like:accOwnerSearchKey ) AND recordtypeId=:recordtype ORDER BY '+orderByVal+' '+sortDir+' limit 50 offset '+offsetVal); 
                //added by Kavya to fetch the Number of contacts
                for(Account acc: accTM){
                    accIdList.add(acc.Id);
                }
                result = [SELECT COUNT(Id) Total, AccountId FROM Contact WHERE AccountId in:accIdList GROUP BY AccountId]; 
                for(AggregateResult a : result) {  
                    accMap.put((Id)a.get('AccountId'),(Integer)a.get('Total'));
                }
            }
            else if((!String.isBlank(accId)  && reporteeLst.isEmpty() && !String.isBlank(accOwnerId))
                    || !String.isBlank(accId)  && !reporteeLst.isEmpty() && !String.isBlank(accOwnerId))
            {
                accTM = Database.query('Select Name,Country__c,City__c,Id,Owner.Username,Count_of_Opportunities__c,'+
                                       'All_Opportunity_Value__c,Active_Opportunity_Value__c,Count_of_Active_Opps__c,'+
                                       '(Select id,TeamMemberRole,User.Username,UserId ' + 
                                       'from AccountTeamMembers) from Account where Id IN (Select AccountId from AccountTeamMember '+ 
                                       'where UserId IN:userIdLst and Account.Name like:searchKey and Account.Owner.Username like:accOwnerSearchKey) AND recordtypeId=:recordtype order by '+orderByVal+' '+sortDir+' limit 50 offset '+offsetVal);
                //added by Kavya to fetch the Number of contacts
                for(Account acc: accTM){
                    accIdList.add(acc.Id);
                }
                result = [SELECT COUNT(Id) Total, AccountId FROM Contact WHERE AccountId in:accIdList GROUP BY AccountId]; 
                for(AggregateResult a : result) {  
                    accMap.put((Id)a.get('AccountId'),(Integer)a.get('Total'));
                }
            }
            
        }
        else if(selectedView=='recentlyViewed')
        {
            if(String.isBlank(accId)  && reporteeLst.isEmpty() && String.isBlank(accOwnerId))
            {
                sortOnServer=true;
                accTM=  [Select Name,Country__c,City__c,Id,Owner.Username,Count_of_Opportunities__c,All_Opportunity_Value__c,                
                         Active_Opportunity_Value__c,Count_of_Active_Opps__c,
                         (Select id,TeamMemberRole,User.Username,UserId from AccountTeamMembers) 
                         from Account where Id IN (Select AccountId from AccountTeamMember where UserId IN:userIdLst)
                         AND recordtypeId=:recordtype AND LastViewedDate != null limit 50 offset:offsetVal];
                List<Id> accIds= new List<Id>();
                for(Account acc:accTM){
                    accIds.add(acc.Id);
                }
                //UnAssociated +Recently Viewed Accounts
                Integer limits=50-accTM.size();
                if(limits>0){
                    String soqlGetLastViewedUnAccounts='Select Name,Country__c,City__c,Id,Owner.Username,'+
                        'Count_of_Opportunities__c,All_Opportunity_Value__c,Active_Opportunity_Value__c,Count_of_Active_Opps__c'+
                        ' From Account WHERE (recordtypeId=:recordtype AND Id not IN:accIds AND'+
                        ' LastViewedDate != null) Order By '+orderByVal+' '+sortDir+' limit:limits offset '+offsetVal;
                    accLst=Database.query(soqlGetLastViewedUnAccounts);
                    for(Account acc: accLst){
                        accIdList.add(acc.Id);
                    }
                    //added by Kavya to fetch the Number of contacts ,here AccountId might be associated or unassociated so passing both accIdList
                    result = [SELECT COUNT(Id) Total, AccountId FROM Contact WHERE (AccountId in:accIdList OR AccountId in:accIds) GROUP BY AccountId]; 
                    for(AggregateResult a : result) {  
                        accMap.put((Id)a.get('AccountId'),(Integer)a.get('Total'));
                    }
                }     
            }
            else if(!String.isBlank(accId)  && reporteeLst.isEmpty() && String.isBlank(accOwnerId))
            {
                sortOnServer=true;
                accTM=  [Select Name,Country__c,City__c,Id,Owner.Username,Count_of_Opportunities__c,All_Opportunity_Value__c,                
                         Active_Opportunity_Value__c,Count_of_Active_Opps__c,
                         (Select id,TeamMemberRole,User.Username,UserId from AccountTeamMembers) 
                         from Account where Id IN (Select AccountId from AccountTeamMember where UserId IN:userIdLst and (Account.Name like:searchKey ))
                         AND recordtypeId=:recordtype AND LastViewedDate != null limit 50 offset:offsetVal];
                List<Id> accIds= new List<Id>();
                for(Account acc:accTM){
                    accIds.add(acc.Id);
                }
                Integer limits=50-accTM.size();
                if(limits>0){
                    String soqlGetLastViewedUnAccounts='Select Name,Country__c,City__c,Id,Owner.Username,'+
                        'Count_of_Opportunities__c,All_Opportunity_Value__c,Active_Opportunity_Value__c,Count_of_Active_Opps__c'+
                        ' From Account WHERE (recordtypeId=:recordtype AND Id not IN:accIds AND'+
                        ' LastViewedDate != null and (Account.Name like:searchKey)) Order By '+orderByVal+' '+sortDir+' limit:limits offset '+offsetVal;
                    accLst=Database.query(soqlGetLastViewedUnAccounts);
                    
                }
                //added by Kavya to fetch the Number of contacts ,here AccountId might be associated or unassociated so passing both accIdList
				for(Account acc: accLst){
                    accIdList.add(acc.Id);
                }
                result = [SELECT COUNT(Id) Total, AccountId FROM Contact WHERE (AccountId in:accIdList OR AccountId in:accIds) GROUP BY AccountId]; 
                for(AggregateResult a : result) {  
                    
                    accMap.put((Id)a.get('AccountId'),(Integer)a.get('Total'));
                }
            }
            else if(String.isBlank(accId)  && !reporteeLst.isEmpty() && String.isBlank(accOwnerId))
            {
                accTM=  Database.query('Select Name,Country__c,City__c,Id,Owner.Username,Count_of_Opportunities__c,All_Opportunity_Value__c,'+                
                                       'Active_Opportunity_Value__c,Count_of_Active_Opps__c,'+
                                       '(Select id,TeamMemberRole,User.Username,UserId from AccountTeamMembers) '+
                                       'from Account where Id IN (Select AccountId from AccountTeamMember where UserId IN:userIdLst) '+
                                       'AND recordtypeId=:recordtype AND LastViewedDate != null order by '+orderByVal+' '+sortDir+' limit 50 offset '+offsetVal);
               
                //added by Kavya to fetch the Number of contacts ,here AccountId might be associated or unassociated so passing both accIdList
				for(Account acc: accTM){
                    accIdList.add(acc.Id);
                }
                result = [SELECT COUNT(Id) Total, AccountId FROM Contact WHERE AccountId in:accIdList GROUP BY AccountId]; 
                for(AggregateResult a : result) {  
                    accMap.put((Id)a.get('AccountId'),(Integer)a.get('Total'));
                }
            }
            else if(String.isBlank(accId)  && reporteeLst.isEmpty() && !String.isBlank(accOwnerId))
            {
                sortOnServer=true;
                accTM=  [Select Name,Country__c,City__c,Id,Owner.Username,Count_of_Opportunities__c,All_Opportunity_Value__c,                
                         Active_Opportunity_Value__c,Count_of_Active_Opps__c,
                         (Select id,TeamMemberRole,User.Username,UserId from AccountTeamMembers) 
                         from Account where Id IN (Select AccountId from AccountTeamMember where UserId IN:userIdLst and (Account.Owner.Username like:accOwnerSearchKey))
                         AND recordtypeId=:recordtype AND LastViewedDate != null limit 50 offset:offsetVal];
                List<Id> accIds= new List<Id>();
                for(Account acc:accTM){
                    accIds.add(acc.Id);
                }
                Integer limits=50-accTM.size();
                if(limits>0){
                    String soqlGetLastViewedUnAccounts='Select Name,Country__c,City__c,Id,Owner.Username,'+
                        'Count_of_Opportunities__c,All_Opportunity_Value__c,Active_Opportunity_Value__c,Count_of_Active_Opps__c'+
                        ' From Account WHERE (recordtypeId=:recordtype AND Id not IN:accIds AND'+
                        ' LastViewedDate != null and (Account.Owner.Username like:accOwnerSearchKey)) Order By '+orderByVal+' '+sortDir+' limit:limits offset '+offsetVal;
                    accLst=Database.query(soqlGetLastViewedUnAccounts);
                }
                for(Account acc: accLst){
                    accIdList.add(acc.Id);
                }
                //added by Kavya to fetch the Number of contacts ,here AccountId might be associated or unassociated so passing both accIdList

                result = [SELECT COUNT(Id) Total, AccountId FROM Contact WHERE (AccountId in:accIdList OR AccountId in:accIds) GROUP BY AccountId]; 
                for(AggregateResult a : result) {  
                    accMap.put((Id)a.get('AccountId'),(Integer)a.get('Total'));
                }
            }
            else if(!String.isBlank(accId)  && !reporteeLst.isEmpty() && String.isBlank(accOwnerId))
            {
                String loggedInUserSOQL = 'Select Name,Country__c,City__c,Id,Owner.Username,Count_of_Opportunities__c,'+
                    'All_Opportunity_Value__c,Active_Opportunity_Value__c,Count_of_Active_Opps__c,'+ 
                    '(Select id,TeamMemberRole,User.Username,UserId from AccountTeamMembers)'+
                    ' from Account where Id IN (Select AccountId from AccountTeamMember where UserId IN:userIdLst AND '+
                    '(Account.Name like:searchKey)) AND recordtypeId=:recordtype AND LastViewedDate != null order by '+orderByVal+' '+sortDir+' limit 50 offset '+offsetVal;
                accTM = Database.query(loggedInUserSOQL);
                for(Account acc: accTM){
                    accIdList.add(acc.Id);
                }
                //added by Kavya to fetch the Number of contacts 

                result = [SELECT COUNT(Id) Total, AccountId FROM Contact WHERE AccountId in:accIdList GROUP BY AccountId]; 
                for(AggregateResult a : result) {  
                    accMap.put((Id)a.get('AccountId'),(Integer)a.get('Total'));
                }
            }
            else if(!String.isBlank(accId)  && reporteeLst.isEmpty() && !String.isBlank(accOwnerId))
            {
                sortOnServer=true;
                accTM=  [Select Name,Country__c,City__c,Id,Owner.Username,Count_of_Opportunities__c,All_Opportunity_Value__c,                
                         Active_Opportunity_Value__c,Count_of_Active_Opps__c,
                         (Select id,TeamMemberRole,User.Username,UserId from AccountTeamMembers) 
                         from Account where Id IN (Select AccountId from AccountTeamMember where UserId IN:userIdLst and (Account.Name like:searchKey and Account.Owner.Username like:accOwnerSearchKey))
                         AND recordtypeId=:recordtype AND LastViewedDate != null limit 50 offset:offsetVal];
                List<Id> accIds= new List<Id>();
                for(Account acc:accTM){
                    accIds.add(acc.Id);
                }
                Integer limits=50-accTM.size();
                if(limits>0){
                    String soqlGetLastViewedUnAccounts='Select Name,Country__c,City__c,Id,Owner.Username,'+
                        'Count_of_Opportunities__c,All_Opportunity_Value__c,Active_Opportunity_Value__c,Count_of_Active_Opps__c'+
                        ' From Account WHERE (recordtypeId=:recordtype AND Id not IN:accIds AND'+
                        ' LastViewedDate != null and (Account.Name like:searchKey and Account.Owner.Username like:accOwnerSearchKey)) Order By '+orderByVal+' '+sortDir+' limit:limits offset '+offsetVal;
                    accLst=Database.query(soqlGetLastViewedUnAccounts);
                }
                for(Account acc: accLst){
                    accIdList.add(acc.Id);
                }
                //added by Kavya to fetch the Number of contacts 
                result = [SELECT COUNT(Id) Total, AccountId FROM Contact WHERE (AccountId in:accIdList OR AccountId in:accIds) GROUP BY AccountId]; 
                for(AggregateResult a : result) {  
                    accMap.put((Id)a.get('AccountId'),(Integer)a.get('Total'));
                }
            }
            else if(String.isBlank(accId)  && !reporteeLst.isEmpty() && !String.isBlank(accOwnerId))
            {
                String loggedInUserSOQL = 'Select Name,Country__c,City__c,Id,Owner.Username,Count_of_Opportunities__c,'+
                    'All_Opportunity_Value__c,Active_Opportunity_Value__c,Count_of_Active_Opps__c,'+ 
                    '(Select id,TeamMemberRole,User.Username,UserId from AccountTeamMembers)'+
                    ' from Account where Id IN (Select AccountId from AccountTeamMember where UserId IN:userIdLst AND '+
                    '(Account.Owner.Username like:accOwnerSearchKey)) AND recordtypeId=:recordtype AND LastViewedDate != null order by '+orderByVal+' '+sortDir+' limit 50 offset '+offsetVal;
                accTM = Database.query(loggedInUserSOQL);
                for(Account acc: accTM){
                    accIdList.add(acc.Id);
                }
                //added by Kavya to fetch the Number of contacts 
                result = [SELECT COUNT(Id) Total, AccountId FROM Contact WHERE AccountId in:accIdList GROUP BY AccountId]; 
                for(AggregateResult a : result) {  
                    accMap.put((Id)a.get('AccountId'),(Integer)a.get('Total'));
                }
            }
            else if(!String.isBlank(accId)  && !reporteeLst.isEmpty() && !String.isBlank(accOwnerId))
            {
                String loggedInUserSOQL = 'Select Name,Country__c,City__c,Id,Owner.Username,Count_of_Opportunities__c,'+
                    'All_Opportunity_Value__c,Active_Opportunity_Value__c,Count_of_Active_Opps__c,'+ 
                    '(Select id,TeamMemberRole,User.Username,UserId from AccountTeamMembers)'+
                    ' from Account where Id IN (Select AccountId from AccountTeamMember where UserId IN:userIdLst AND '+
                    '(Account.Name like:searchKey and Account.Owner.Username like:accOwnerSearchKey)) AND recordtypeId=:recordtype AND LastViewedDate != null order by '+orderByVal+' '+sortDir+' limit 50 offset '+offsetVal;
                accTM = Database.query(loggedInUserSOQL);
                for(Account acc: accTM){
                    accIdList.add(acc.Id);
                }
                //added by Kavya to fetch the Number of contacts 
                result = [SELECT COUNT(Id) Total, AccountId FROM Contact WHERE AccountId in:accIdList GROUP BY AccountId]; 
                for(AggregateResult a : result) {  
                    accMap.put((Id)a.get('AccountId'),(Integer)a.get('Total'));
                }
            }
        }
        //Kavya ends here
        
        /*--------------------------------------------Queries/Logic End Here------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
        //Pushing Account and AccountTeamMember data to Wrapper
        if(!accTM.isEmpty()){
            for(Account accTempP:accTM){
                for(AccountTeamMember accTemp:accTempP.AccountTeamMembers){
                    if(userIdLst.contains(accTemp.UserId)&& AI.size()<50){
                        AI.add(new accountInfo(accTempP,accTemp,userIdLst,reportees,accMap));
                    }
                }
            }
        }
        if(!accLst.isEmpty()){
            for(Account acc: accLst){
                AI.add(new accountInfo(acc,reportees,accMap));
            }
        }
        else if(AI.isEmpty()&& !reportees.isEmpty()){
            AI.add(new accountInfo(null,reportees,null));
        }
        if(sortOnServer==true){
            AI.sort();
        }
        return AI;
    }
    //Wrapper Class
    public class accountInfo implements Comparable{
        @AuraEnabled
        public String id { get; set; }
        @AuraEnabled
        public String name { get; set; }
        @AuraEnabled
        public String teamId { get; set; }
        @AuraEnabled
        public string country { get; set; }
        @AuraEnabled
        public string accOwner { get; set; }
        @AuraEnabled
        public string city { get; set; }
        @AuraEnabled
        public string role{get;set; }
        @AuraEnabled
        public string atmId{get;set; }
        @AuraEnabled
        public string memberId{get;set; }
        @AuraEnabled
        public string accId{get;set; }
        @AuraEnabled
        public decimal cOpty{get;set; }
        @AuraEnabled
        public decimal cActiveOpty{get;set; }
        @AuraEnabled
        public decimal optyVal{get;set; }
        @AuraEnabled
        public decimal atvOptyVal{get;set; }
        @AuraEnabled
        public decimal totalContact{get;set; }
        @AuraEnabled
        public String hasManager{get;set; }
        @AuraEnabled
        public Boolean hasSEUsrFlag{get;set; }
        @AuraEnabled
        public String redirectURL{get;set; }
        
        public accountInfo(Account acc,AccountTeamMember atm, List<Id>userIdLst,List<User> reportees,Map<Id,Integer> accMap) {
            this.role=String.valueOf(atm.TeamMemberRole);
            this.atmId=atm.Id;
            this.accId=acc.id;
            this.name=acc.Name;
            this.teamId=String.valueOf(atm.User.Username).substringBefore('@');
            this.accOwner=String.valueOf(acc.Owner.Username).substringBefore('@');//acc.Owner.Name;
            this.country=acc.Country__c;
            this.city = acc.City__c;
            this.memberId= atm.UserId;
            this.cOpty= acc.Count_of_Opportunities__c;
            this.cActiveOpty= acc.Count_of_Active_Opps__c;
            if(acc.All_Opportunity_Value__c!=null){
                this.optyVal=acc.All_Opportunity_Value__c.setScale(2);
            }
            if(acc.Active_Opportunity_Value__c!=null){
                this.atvOptyVal=acc.Active_Opportunity_Value__c.setScale(2);
            }
            
            this.redirectURL=URL.getSalesforceBaseUrl().toExternalForm() + '/' + acc.id;
            if(!reportees.isEmpty()){
                this.hasManager=userInfo.getUserId();
            }
            else{
                this.hasManager='';
            }
            //added by Kavya 
            if(accMap.containsKey(acc.Id)){
                this.totalContact=accMap.get(acc.Id);
            }
            else
            {
                this.totalContact=0;
            } 
            //ends here
        }
        public accountInfo(Account acc,List<User> reportees,Map<Id,Integer> accMap) {
            try{
                if(acc!=null){
                    this.role='None';
                    this.atmId='';
                    this.accId=acc.id;
                    this.name=acc.Name;
                    this.teamId='None';
                    this.accOwner=String.valueOf(acc.Owner.Username).substringBefore('@');//acc.Owner.Name;
                    this.country=acc.Country__c;
                    this.city = acc.City__c;
                    this.memberId= '';
                    this.cOpty= acc.Count_of_Opportunities__c;
                    this.cActiveOpty= acc.Count_of_Active_Opps__c;
                    if(acc.All_Opportunity_Value__c!=null){
                        this.optyVal=acc.All_Opportunity_Value__c.setScale(2);   
                    }
                    if(acc.Active_Opportunity_Value__c!=null){
                        this.atvOptyVal=acc.Active_Opportunity_Value__c.setScale(2);               
                    }
                    this.redirectURL=URL.getSalesforceBaseUrl().toExternalForm() + '/' + acc.id;
                    //To pass the information if the loggedIn user is Manager
                }
                if(!reportees.isEmpty()){
                    this.hasManager=userInfo.getUserId();
                }
                else{
                    this.hasManager='';
                }
                //added by Kavya 
                if(accMap.containsKey(acc.Id)){
                    this.totalContact=accMap.get(acc.Id);
                }
                else
                {
                    this.totalContact=0;
                } 
                //ends here
            }catch(Exception ex){
                system.debug(ex.getStackTraceString());
                system.debug(ex.getMessage());
                system.debug(ex.getLineNumber());
            }
        }
        //US288487 changes to sort the view based on highest active Opportunity Value
        public Integer compareTo(Object objToCompare) {
            
            Integer comparedVal;
            if(orderByVal=='Active_Opportunity_Value__c'){
                if(sortDirection=='desc'){comparedVal= Integer.valueOf(((accountInfo)objToCompare).atvOptyVal-atvOptyVal);}
                else{comparedVal= Integer.valueOf(atvOptyVal-((accountInfo)objToCompare).atvOptyVal);}
            }
            if(orderByVal=='Count_of_Opportunities__c'){
                if(sortDirection=='desc'){comparedVal= Integer.valueOf(((accountInfo)objToCompare).cOpty-cOpty);}
                else{comparedVal=Integer.valueOf(cOpty-((accountInfo)objToCompare).cOpty);}
            }
            if(orderByVal=='All_Opportunity_Value__c'){
                if(sortDirection=='desc'){comparedVal= Integer.valueOf(((accountInfo)objToCompare).optyVal-optyVal);}
                else{comparedVal= Integer.valueOf(optyVal-((accountInfo)objToCompare).optyVal);}
            }
            if(orderByVal=='Count_of_Active_Opps__c'){
                if(sortDirection=='desc'){comparedVal= Integer.valueOf(((accountInfo)objToCompare).cActiveOpty-cActiveOpty);}
                else{comparedVal= Integer.valueOf(cActiveOpty-((accountInfo)objToCompare).cActiveOpty);}
            }
            if(orderByVal=='name'){
                if(sortDirection=='asc'){comparedVal= name.compareTo(((accountInfo)objToCompare).name);}
                else{comparedVal= (((accountInfo)objToCompare).name).compareTo(name);}
            }
            if(orderByVal=='Owner.Username'){
                if(sortDirection=='asc'){comparedVal= accOwner.compareTo(((accountInfo)objToCompare).accOwner);}
                else{comparedVal=(((accountInfo)objToCompare).accOwner).compareTo(accOwner);}
            }
            if(orderByVal=='City__c'){
                if(sortDirection=='asc'){comparedVal= city.compareTo(((accountInfo)objToCompare).city);}
                else{comparedVal= (((accountInfo)objToCompare).city).compareTo(city);}
            }
            if(orderByVal=='Country__c'){
                if(sortDirection=='asc'){comparedVal=country.compareTo(((accountInfo)objToCompare).country); }
                else{comparedVal= (((accountInfo)objToCompare).country).compareTo(country);}
            }
            return comparedVal;
        }
    }
}