/**
* @release - MAY Q4FY14
* @author - majanard
* @date - 09-May-2014
* @description  - This class will add the new Security Contacts to Account & AccountTeamMeber if not added earlier on update to Opportunity.
* Developed for Work Request - WR-00626.
*/ 

public class Oppty_SecurityRoles_AccountTeamUpdate{
    // SCAVA Helper Method to validate Create Access at field level
     public static Boolean flsGet(SObjectField field)
    {
        return field.getDescribe().isCreateable() ? true : false;
    }
    public void updateAccount(List<Opportunity> opptyList){
        List<String> actids1 = new List<String>();
        String seEngineer = null;
        String seManager = null;
        Map<ID, ID> actUserid_SE = new Map<ID, ID>();
        Map<ID, ID> actUserid_AM = new Map<ID, ID>();
        Map<ID,String> actRoleMap = new Map<ID,String>();
        List<AccountTeamMember> atMember_SE = new List<AccountTeamMember>();
        List<AccountTeamMember> atMember_AM = new List<AccountTeamMember>();
        
        // Filter the incoming list to separate the Opportunities for Security Engineer and Manager.
        List<SecurityTeamRole__c> optSecRoles = SecurityTeamRole__c.getAll().values();
        for(SecurityTeamRole__c secrole :optSecRoles){
            if(secrole.Security_Engineer__c != null){
                seEngineer = secrole.Security_Engineer__c;
            }
            if(secrole.Security_Manager__c != null){
                seManager = secrole.Security_Manager__c;
            }
        }
        // Identify the Accounts to be update and map the field value.
        for(Opportunity optr : opptyList){
            if((optr.Security_SE__c != null || optr.Security_SE__c != '') || (optr.Security_AM__c != null || optr.Security_AM__c != '')){
                actids1.add(optr.AccountID);
                if(optr.Security_SE__c != null || optr.Security_SE__c != ''){
                    actUserid_SE.put(optr.AccountID, optr.Security_SE__c);
                }
                if(optr.Security_AM__c != null || optr.Security_AM__c != ''){
                    actUserid_AM.put(optr.AccountID, optr.Security_AM__c);
                }
            }
        }
                 
        List<Account> acctIDs = [Select ID, Security_SE__c, Security_AM__c from Account where Id in :actids1];
            
        // Update the accounts with Security field mapping.
        for(Account act :acctIDs){
            if(act.Security_SE__c == null){
                act.Security_SE__c = actUserid_SE.get(act.id);
            } 
            if(act.Security_AM__c == null){
                act.Security_AM__c = actUserid_AM.get(act.id);
            }
        }
        if(!acctIDs.isEmpty()){
            Database.SaveResult[]  result = Database.update(acctIDs);
        }
            
        // Add records to Account Team Member.
        List<AccountTeamMember> currentActRole = [SELECT AccountAccessLevel, AccountId, Id, TeamMemberRole, UserId FROM AccountTeamMember where AccountId in :actids1];
        for(AccountTeamMember atm :currentActRole){
            actRoleMap.put(atm.AccountId, atm.TeamMemberRole);
        }
        List<ID> actList_SE = new List<ID>();
        List<ID> actList_AM = new List<ID>();
        
        // Prepare the list of Accounts for Security Engineer and Manager.
        for(Account act :acctIDs){
            if(actRoleMap.get(act.id) != seEngineer){
                actList_SE.add(act.id);    
            }
            if(actRoleMap.get(act.id) != seManager){
                actList_AM.add(act.id);        
            }
        }
        
        if(!actList_SE.isEmpty() || !actList_AM.isEmpty()) {
            List<Account> atm_SE = [SELECT Id, Security_SE__c, Security_AM__c FROM Account where Id in :actList_SE];
            List<Account> atm_AM = [SELECT Id, Security_SE__c, Security_AM__c FROM Account where Id in :actList_AM];
            
            // Add AccountTeamMember for Security Engineer
                       
            if(!atm_SE.isEmpty()){
                for(Account act_SE :atm_SE){
                    AccountTeamMember member1 =new AccountTeamMember(); 
                    //SCAVA FIX
                    if(flsGet(AccountTeamMember.AccountId))
                    {
                    member1.AccountId = act_SE.ID;
                    }
                    if(flsGet(AccountTeamMember.UserId))
                    {
                    member1.UserId = act_SE.Security_SE__c;
                    }
                    if(flsGet(AccountTeamMember.TeamMemberRole))
                    {
                    member1.TeamMemberRole = seEngineer;
                    }
                    atMember_SE.add(member1);
                }    
            }
            
            // Add AccountTeamMember for Security Manager
            
            if(!atm_AM.isEmpty()){
                for(Account act_AM :atm_AM){
                    AccountTeamMember member2 =new AccountTeamMember();
                    //SCAVA FIX             
                    if(flsGet(AccountTeamMember.AccountId))
                    {                   
                    member2.AccountId = act_AM.ID;
                    }
                    if(flsGet(AccountTeamMember.UserId))
                    {
                    member2.UserId = act_AM.Security_AM__c;
                    }
                    if(flsGet(AccountTeamMember.TeamMemberRole))
                    {
                    member2.TeamMemberRole = seManager;
                    }
                    atMember_AM.add(member2);
                }    
            }
            
            // Add records to Account TeamMember.
            if(!atMember_SE.isEmpty()){
                Database.SaveResult[] sr = Database.insert(atMember_SE,false);
            }
            if(!atMember_AM.isEmpty()){
                Database.SaveResult[] sr1 = Database.insert(atMember_AM,false);
            }
        }
    }
}