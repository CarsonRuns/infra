/**
* @release - MAY Q4FY14
* @author - Manjunath TJ  
* @date - 09-May-2014
* @description  - This class is utilized for building Security Contact roles business logic for OpportunityTeamMember object and duplicate validation and
* to update the Account & AccountTeamMember for SourceFire integration. 
* Developed for Work Request - WR-00626.
*/ 

public class Oppty_SecurityContact{
    
    private static boolean run = true;
        public boolean runOnce(){
            if(run){
                run=false;
                return true;
            } else {
                return run;
            }
        }

    // This class will validate OpportunityTeamMember input records and throw error on duplicate users for Security Roles
    public void securityRoleDuplicateCheck_Insert(List<OpportunityTeamMember> oppTeamList){
    String seEngineer = null, seEngError = null, seManager = null, seMgrErr = null;
    List<String> opids = new List<String>();
    List<SecurityTeamRole__c> secRoles = SecurityTeamRole__c.getAll().values();
    Map<String, Integer> seMapUpdateValidation = new Map<String, Integer>();
    Map<String, Integer> smMapUpdateValidation = new Map<String, Integer>();
    // Retrieve Security Roles from Custom Setting Object
        for(SecurityTeamRole__c secrole :secRoles){
            if(secrole.Security_Engineer__c != null){
                seEngineer = secrole.Security_Engineer__c;
            }
            if(secrole.Security_Manager__c != null){
                seManager = secrole.Security_Manager__c;
            }
            if(secrole.Security_Enginner_Duplicate_Error__c != null){
                seEngError = secrole.Security_Enginner_Duplicate_Error__c;
            }
            if(secrole.Security_Manager_Duplicate_Error__c != null){
                seMgrErr = secrole.Security_Manager_Duplicate_Error__c;
            }
        }
        
        // Create a list of Opportunity IDs from OpportunityTeamMember list.
        for(OpportunityTeamMember optr :oppTeamList){         
            opids.add(optr.OpportunityId);
        }
        
        List<OpportunityTeamMember>  optyRole =[SELECT OpportunityId, UserId, TeamMemberRole FROM OpportunityTeamMember where OpportunityId in :opids 
            AND (TeamMemberRole=:seEngineer OR TeamMemberRole=:seManager)];
        
        // Identify the duplicate roles by matching against a map.
        for(OpportunityTeamMember opteams :optyRole){
            if(opteams.TeamMemberRole == seEngineer){ 
                if(seMapUpdateValidation.containsKey(opteams.OpportunityId)){             
                    seMapUpdateValidation.put(opteams.OpportunityId,2);
                }else{
                    seMapUpdateValidation.put(opteams.OpportunityId,1);
                }
            }
            if(opteams.TeamMemberRole == seManager){
                if(smMapUpdateValidation.containsKey(opteams.OpportunityId)){                 
                    smMapUpdateValidation.put(opteams.OpportunityId,2);                  
                }else{
                    smMapUpdateValidation.put(opteams.OpportunityId,1);                  
                }
            }
        }   
        
        // Display error if duplicate role is being inserted.
        for(OpportunityTeamMember opt :oppTeamList){
            if(seMapUpdateValidation.get(opt.OpportunityId)>1){
                opt.addError(seEngError);
            }
            if(smMapUpdateValidation.get(opt.OpportunityId)>1){
                opt.addError(seMgrErr);
            }
        }    
           
        securityRoleOpptyUpdate(oppTeamList);
    }
    
    // This class will validate OpportunityTeamMember updated records and throw error on duplicate users for Security Roles if already exists for opportunity.
    public void securityRoleDuplicateCheck_Update(List<OpportunityTeamMember> oppTeamList){
    String seEngineer = null,seEngError = null, seManager = null,seMgrErr = null;
    List<String> opids = new List<String>();
    List<SecurityTeamRole__c> secRoles = SecurityTeamRole__c.getAll().values();
    Map<String, Integer> seMapUpdateValidation = new Map<String, Integer>();
    Map<String, Integer> smMapUpdateValidation = new Map<String, Integer>();
        // Retrieve Security Roles from Custom Setting Object
        for(SecurityTeamRole__c secrole :secRoles){
            if(secrole.Security_Engineer__c != null){
                seEngineer = secrole.Security_Engineer__c;
            }
            if(secrole.Security_Manager__c != null){
                seManager = secrole.Security_Manager__c;
            }
            if(secrole.Security_Enginner_Duplicate_Error__c != null){
                seEngError = secrole.Security_Enginner_Duplicate_Error__c;
            }
            if(secrole.Security_Manager_Duplicate_Error__c != null){
                seMgrErr = secrole.Security_Manager_Duplicate_Error__c;
            }
        }
        // Create a list of Opportunity IDs from OpportunityTeamMember list.
        for(OpportunityTeamMember optr :oppTeamList){         
            opids.add(optr.OpportunityId);
        }
        
        List<OpportunityTeamMember>  optyRoles =[SELECT OpportunityId, UserId, TeamMemberRole FROM OpportunityTeamMember where OpportunityId in :opids
            AND (TeamMemberRole=:seEngineer OR TeamMemberRole=:seManager)];
        
        // Identify the duplicate roles by matching against a map.
        for(OpportunityTeamMember opteams :optyRoles){
            if(opteams.TeamMemberRole == seEngineer){
                if(seMapUpdateValidation.containsKey(opteams.TeamMemberRole)){
                    seMapUpdateValidation.put(opteams.TeamMemberRole,2);
                }else{
                    seMapUpdateValidation.put(opteams.TeamMemberRole,1);
                }    
             }   
         
            if(opteams.TeamMemberRole == seManager){
                if(smMapUpdateValidation.containsKey(opteams.TeamMemberRole)){
                    smMapUpdateValidation.put(opteams.TeamMemberRole,2);
                }else{
                    smMapUpdateValidation.put(opteams.TeamMemberRole,1);
                }       
            }
        }
        
        // Display error if duplicate role is during update.
        for(OpportunityTeamMember opts :oppTeamList){
             if(seMapUpdateValidation.get(opts.TeamMemberRole)> 1){
                opts.addError(seEngError);
             }
             if(smMapUpdateValidation.get(opts.TeamMemberRole)> 1){
                opts.addError(seMgrErr);
             }
        }
        // Calling Opportunity Update method to map the Security Roles on Opportunity.
        securityRoleOpptyUpdate(oppTeamList);
    }
    
    // This method will update the Opportunity Security Roles from the OpportunityTeamMember on Opportunity.
    public void securityRoleOpptyUpdate(List<OpportunityTeamMember> oppTeamList){
    String seEngineer = null;
    String seManager = null;
    List<String> opid = new List<String>();
    Map<Id, String> seMap = new Map<Id, String>();
    Map<Id, String> smMap = new Map<Id, String>();
    List<SecurityTeamRole__c> secRoles = SecurityTeamRole__c.getAll().values();    
    for(SecurityTeamRole__c secrole :secRoles){
            if(secrole.Security_Engineer__c != null){
                seEngineer = secrole.Security_Engineer__c;
            }
            if(secrole.Security_Manager__c != null){
                seManager = secrole.Security_Manager__c;
            }
        }
        // Segregate the input records into 2 lists which has Security Engineer and Security Manager.
        for (OpportunityTeamMember optm :oppTeamList){
            opid.add(optm.OpportunityId);
            if(optm.TeamMemberRole == seEngineer){
                seMap.put(optm.OpportunityId, optm.UserID);
            } 
            if(optm.TeamMemberRole == seManager){
                smMap.put(optm.OpportunityId, optm.UserID);
            }
        }    
        //Update the Opportunity if the respective field is empty from the OpportunityTeamMember with the Security Roles.
        if(!seMap.isEmpty() || !smMap.isEmpty()){
            List<Opportunity> opptyList = new List<Opportunity>([Select Security_SE__c, Security_AM__c from Opportunity where id in :opid]);
            for(Opportunity optl :opptyList){
                if(optl.Security_SE__c == null || ((optl.Security_SE__c != seMap.get(optl.id)) && (seMap.get(optl.id) != null))){
                    optl.Security_SE__c = seMap.get(optl.id);
                }
    
                if(optl.Security_AM__c == null || ((optl.Security_AM__c != smMap.get(optl.id)) && (smMap.get(optl.id) != null))){
                    optl.Security_AM__c = smMap.get(optl.id);
                }
            }
            if(!opptyList.isempty()){
            Database.SaveResult[]  result = Database.update(opptyList);
           //     update opptyList;
        }
        
        
        }
    }
    
    // This method will clear the Opportunity Security Roles from the Opportunity when there is an update on OpportunityTeamMember
    public void securityRoleOpptyUpdate_Clear(List<OpportunityTeamMember> oppTeamListNew, List<OpportunityTeamMember> oppTeamListOld){
    String seEngineer = null, seManager = null;
    List<String> opids_SE = new List<String>();
    List<String> opids_AM = new List<String>();
    List<String> opid = new List<String>();
    List<SecurityTeamRole__c> secRoles = SecurityTeamRole__c.getAll().values();    
    for(SecurityTeamRole__c secrole :secRoles){
            if(secrole.Security_Engineer__c != null){
                seEngineer = secrole.Security_Engineer__c;
            }
            if(secrole.Security_Manager__c != null){
                seManager = secrole.Security_Manager__c;
            }
        }
        // Separate the list of updates received at OpportunityTeamMember for Security Engineer and Security Manager
        for(Integer i=0; i<oppTeamListOld.size();i++){
            if(oppTeamListOld[i].TeamMemberRole == seEngineer && oppTeamListOld[i].TeamMemberRole != oppTeamListNew[i].TeamMemberRole){
                opids_SE.add(oppTeamListNew[i].OpportunityId);
            }
            if(oppTeamListOld[i].TeamMemberRole == seManager && oppTeamListOld[i].TeamMemberRole != oppTeamListNew[i].TeamMemberRole){
                opids_AM.add(oppTeamListNew[i].OpportunityId);
            }
        }
        
        if(!opids_SE.isEmpty() || !opids_AM.isEmpty()){
            List<Opportunity>  opties_SE =[Select Security_SE__c, Security_AM__c from Opportunity where id in :opids_SE];
            List<Opportunity>  opties_AM =[Select Security_SE__c, Security_AM__c from Opportunity where id in :opids_AM];
            // Update the respective Opportunity - Security Role value to null.
            for(Opportunity optyList :opties_SE){
                optyList.Security_SE__c = null;  
            }
            for(Opportunity optyList :opties_AM){
                optyList.Security_AM__c = null;   
            }
            
            if(!opties_SE.isempty()){
                Database.SaveResult[]  result = Database.update(opties_SE);
            }
            if(!opties_AM.isempty()){
                Database.SaveResult[]  result = Database.update(opties_AM);
            }
        }
    }  
    
    // This method will clear the Opportunity Security Roles from the Opportunity when a record is deleted from OpportunityTeamMember
    public void securityRoleOppty_Delete(List<OpportunityTeamMember> oppTeamList){
    String seEngineer = null;
    String seManager = null;
    List<String> opids_SE = new List<String>();
    List<String> opids_AM = new List<String>();
    List<SecurityTeamRole__c> secRoles = SecurityTeamRole__c.getAll().values();
    List<String> opid = new List<String>();
        // Separate the list of updates received at OpportunityTeamMember for Security Engineer and Security Manager
        for(SecurityTeamRole__c secrole :secRoles){
            if(secrole.Security_Engineer__c != null){
                seEngineer = secrole.Security_Engineer__c;
            }
            if(secrole.Security_Manager__c != null){
                seManager = secrole.Security_Manager__c;
            }
        }
    
        //Getting the list of Old Role values.
        for(OpportunityTeamMember optm :oppTeamList){
            if(optm.TeamMemberRole == seEngineer){
            opids_SE.add(optm.OpportunityId);
            }
            if(optm.TeamMemberRole == seManager){
            opids_AM.add(optm.OpportunityId);
            }
        }
    
        //Based on the removed/updates mapping, Opportunity will be updated.
        if(!opids_SE.isEmpty() || !opids_AM.isEmpty()) {
        List<Opportunity> opptyList_SE = new List<Opportunity>([Select Security_SE__c, Security_AM__c from Opportunity where id in :opids_SE]);
        List<Opportunity> opptyList_AM = new List<Opportunity>([Select Security_SE__c, Security_AM__c from Opportunity where id in :opids_AM]);
            for(Opportunity optl :opptyList_SE){
                if((optl.Security_SE__c) != null){
                    optl.Security_SE__c = null;
                }
            }
            for(Opportunity optl :opptyList_AM){
                if((optl.Security_AM__c) != null){
                    optl.Security_AM__c = null;
                }
            }            
            
            if(!opptyList_SE.isEmpty()){
                Database.SaveResult[]  result = Database.update(opptyList_SE);
            }
            if(!opptyList_AM.isEmpty()){
                Database.SaveResult[]  result = Database.update(opptyList_AM);
            }
         }
     }
}