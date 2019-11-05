public class OptyBO{
// SCAVA Helper Method to validate Update Access at field level
     public static Boolean flsUpdate(SObjectField field)
    {
        return field.getDescribe().isUpdateable() ? true : false;
    }
    public static boolean sparkRun = false;
    
    public static void CreteOptyUsingMobile(List<Opportunity> listOpty, string mRecordTypeID, string pRecordTypeID, string runningUserTheater, boolean isRunningUserPss){
        for(Opportunity opty: listOpty){
        System.debug('Executing from OptyBO');
            if(opty.RecordTypeId == mRecordTypeID){
                opty.RecordTypeId = pRecordTypeID;
                //Set flag to true
                opty.Created_Via_Salesforce1__c = true;
            }

            //US7244: Set theater field if is null
            if(opty.Theater__c == null && runningUserTheater != null){
                opty.Theater__c = runningUserTheater;
            }

            //US7244: Set Opportunity Owner AM field if not pss
            if(!isRunningUserPss && opty.Opportunity_Owner_AM__c == null ){
                opty.Opportunity_Owner_AM__c = UserInfo.getUserId();
            }        
        }
        
    }
    
    public static void UpdateSolutionID(List<Opportunity> lstOpt){
        //SolutionID - Opportunity Insert/Update fix
        Set<string> lstStr = new set<string>();     
        Map<id,string> sMap = new Map<id,string>();
        Map<string,id> slMap = new Map<string,id>();             
        List<Solution_ID__c> sltonIds = new List<Solution_ID__c>();
        if(Trigger.isInsert){
            for(Opportunity opt :lstOpt ){
                    if(opt.Solution_Identifier__c != null && opt.Solution_Identifier__c != ''){
                        lstStr.add(opt.Solution_Identifier__c);
                        sMap.put(opt.id,opt.Solution_Identifier__c);
                    }
                }
            }
            if(trigger.isUpdate){               
                for(Opportunity opt :lstOpt ){
                    Opportunity oldOpt = (Opportunity)trigger.oldMap.get(opt.id);
                    if( (oldOpt.Solution_Identifier__c != opt.Solution_Identifier__c)){
                        lstStr.add(opt.Solution_Identifier__c);
                        sMap.put(opt.id,opt.Solution_Identifier__c);
                    }
                }
            }
            
            if(!lstStr.isEmpty()){
                sltonIds = [select id,Solution_ID__c from Solution_ID__c where Solution_ID__c in: lstStr];      
             }
             
            for(Solution_ID__c sid : sltonIds){
                slMap.put(sid.Solution_ID__c,sid.id);
             }
            
            for(Opportunity opts :lstOpt ){
                if(sMap.containsKey(opts.id)){
                    opts.Solution_ID_Description__c = slMap.get(sMap.get(opts.id));             
                }           
            }
        }
        
         private static List<User> getUserNamesFromId(String id1, String id2)
         {
                List<User> u = new List<User>();
                u = [select Id,Name from User where Id in (:id1, :id2)];
                return u;
         }
 
        public static void opportunitySparkRecordUpdate(List<Opportunity> op, Map<id,sobject> oldOppMap)
        {    
            if (op.size()<=5)
            {
            System.debug('inside new spark method');
            sparkRun = true;
            String sparkId; 
            String convoId;
            String roomMessage  = '';
            String userName     = UserInfo.getName();
        
            /* get entire list of available fields on the opportunity */
            List<String> globalTriggers                 = new List<String>{};
            list<Spark_Conversation__c> updateTriggers  = new list<Spark_Conversation__c>();
            Set<ID> oppIds                              = new Set<ID>();
            
            /* Get the list of Opportunity Id's that are changing */
            for(SObject eachOpp: op)
            {
                oppIds.add(eachOpp.id);
            }
        
            /* Get entire list of available fields on the opportunity. This will be used to
             * compare the globally configured triggers to all fields, to determine chagning
             * field names. */
            Map<String, Schema.SObjectField> o = Schema.SObjectType.Opportunity.fields.getMap();    
            Map<String, String> apiNameToLabel = new Map<String, String>();
        
            /* Assign API field label names to display pretty names in room messages. */
            for(String fieldName : o.keySet())
            {
                apiNameToLabel.put(fieldName, o.get(fieldName).getDescribe().getLabel());
            }
    
            /* For opportunity Id list, check if any Opportunities have Spark Rooms Associated. This
             * will allow us to run the trigger ONLY if a spark room is associated.  On the first 
             * iteration only (to reduce unnecessary queries), we will populate the global trigger list. 
             * This will be used for all opportunities with rooms in the list.
             */
            Map<String, Spark_Conversation__c> roomList = new Map<String,Spark_Conversation__c>();        
               
            for(Spark_Conversation__c  convo:[SELECT id, Spark_Id__c,TriggerFields__c,ObjectId__c from Spark_Conversation__c where ObjectId__c in :oppIds ])
            {
                roomList.put(convo.ObjectId__c,convo);
            }
            /* if at leat one room exists, and global triggers list is not 
             * yet populated, then run the global trigger query */
            if (!roomList.isEmpty() && globalTriggers.isEmpty())
            {
                List<Spark_Config__c> config = [SELECT TriggerFields__c FROM Spark_Config__c limit 1];
                if (!config.isEmpty() && config[0].TriggerFields__c.length() > 2)
                {
                    globalTriggers = (List<String>) JSON.deserialize(config[0].TriggerFields__c,List<String>.class); 
                }
            }
        
            for(SObject mo:op)
            {
               /* If a spark room exists for the current iteration of the Opportunity
                * run the trigger.
                */
                if (roomList.get(mo.id) != NULL)
                {            
                    /* get Room Conversation Object for given Opportunity */
                    Spark_Conversation__c roomObj = roomList.get(mo.id);
                    SparkId = roomObj.Spark_Id__c;
                    convoId = roomObj.Id;
                
                    Map<String,String> roomTriggers = new Map<String,String>{};
                
                    if (roomObj.TriggerFields__c != NULL && roomObj.TriggerFields__c.length() > 2)
                    {
                      roomTriggers = (Map<String,String>) JSON.deserialize(roomObj.TriggerFields__c,MAP<String,String>.class); 
                    }
                    system.debug('LOCAL ROOM TRIGGERS & VALUES ' + roomTriggers);            
                    Opportunity oldOpp = (Opportunity) oldOppMap.get(mo.Id);
                    /* Loop through our globally configured trigger list */
                    for (String t : globalTriggers)
                    {
                        /* loop through all available object fields */
                        for(String field : o.keyset())
                        {
                            /* prepend object name, since global triggers are stored with object */
                            String fullFieldName = 'Opportunity.' + field;
                            /* loop through fields in our global trigger list */
                            if (t == fullFieldName)
                            {
                                /* get field label for nice room message */
                                String fieldLabel   = apiNameToLabel.get(field);
                                /* define field values */
                                String oldValue     = String.ValueOf(roomTriggers.get(t));
                                String newValue     = String.valueOf(mo.get(field));
                                String oldOppValue  = String.valueOf(oldOpp.get(field));
                                if (oldValue == NULL)
                                {
                                    oldValue = oldOppValue;
                                }
                                system.debug('OUR OLD VALUE ' + oldValue + ' Our NEW Value ' + newValue + ' Our Old Opp Value ' + oldOppValue);
                                /* Insert new Value into local trigger */
                                roomTriggers.put(t,newValue);
                                
                                if (oldValue != newValue)
                                {
                                    /* replace null values with 'None' to improve message
                                     * quality and to void dereference errors */
                                    if (oldValue == NULL)
                                    {
                                        oldValue = 'None';
                                    }
                                    String fieldMessage = 'The Opportunity Field "' + fieldLabel + '" was updated by ' + userName + ', and has changed from '; 
                                    String fieldEnding  =  oldValue + ' to ' + newValue + '\r\n';
                                    if (oldValue.length() == 18 && oldValue.substring(0,3) == '005'){
                                        List<User> triggerUsers = getUserNamesFromId(oldValue, newValue);
                                        system.debug('USER LOOKUP FOR TRIGGRER' + triggerUsers);
                                        String OldName; String NewName;
                                        for (User u : triggerUsers)
                                        {
                                            if (u.Id == oldOppValue){
                                                oldName = u.Name;
                                            }
                                            if (u.Id == newValue){
                                                newName = u.Name;
                                            }
                                        }
                                    fieldEnding = oldName + ' to ' + newName + '\r\n';  
                                    } 
                                    /* Construct message for given field */                             
                                    roomMessage  += fieldMessage + fieldEnding;
                                    /* Clear set variables */
                                    oldValue = null;
                                    newValue = null;
                                } 
                            }
                        }
                    }
                    
                String j = JSON.serialize(roomTriggers);

                /* We only have to update local triggers if a room exists
                 * and a field is changed generating a message. */
                if (!Test.isRunningTest() && roomMessage != '')
                { 
                    Spark_Conversation__c thisConvo = new Spark_Conversation__c(Id=convoId);
                    //SCAVA FIX
                       if(flsUpdate(Spark_Conversation__c.TriggerFields__c))
                        {
                            thisConvo.TriggerFields__c = j;
                         }
                    updateTriggers.add(thisConvo);
                    Spark_Room_Controller.setRoomMessage(sparkId, roomMessage);
                }
                roomMessage = '';  
            }
                   
            } // end of Opportunity for loop
         update updateTriggers; 
         }
    }
    // Added as part of VDC Program to populate Opportunity Information on the Lead Record
    public static void  updateOpportunityOnLead(List<Opportunity> opties, Map<id,sobject> oldOppMap){
        List<Id> oldleadIds = new List<Id>();
        List<Id> newleadIds = new List<Id>();
        List<Lead> updateLds = new List<Lead>();
        for(Opportunity opty : opties){
            if(opty.DRT_Lead__c!= ((Opportunity)oldOppMap.get(opty.Id)).DRT_Lead__c){
                newleadIds.add(opty.DRT_Lead__c);
                oldleadIds.add(((Opportunity)oldOppMap.get(opty.Id)).DRT_Lead__c);
            }
        }
        List<Lead> oldlds = [select id,Existing_Opportunity__c from Lead where id in :oldleadIds];
        for(Lead ld:oldlds){
            ld.Existing_Opportunity__c = null;
            updateLds.add(ld);
        }
        List<Lead> newlds = [select id,Existing_Opportunity__c from Lead where id in :newleadIds];
        for(Lead ld: newlds){
            for(Opportunity opty : opties){
                if(ld.Id==opty.DRT_Lead__c){
                    ld.Existing_Opportunity__c = opty.Id;
                }
            }
            updateLds.add(ld);
        }
        if(!updateLds.isEmpty()){
            update updateLds; 
        }
    }
    
    /***Added by Alekhya from DelOppAccLead class to consolidate multiple triggers into one trigger
	OpportunityBeforeDelete Trigger logic is replicated here***/
    
    public static void opportunityBeforeDelete(List<Opportunity> triggerOld) {
  
      Map<string,string> mpstd=new Map<string,string>(); 
      String profileId = Userinfo.getProfileId();
      String profileIds  = profileId.substring(0,15);      
      string accDeleteId = Utilities.getConstant_CS('ProfileIds_for_Delete');      
      string[] accDeleteIds;    
      if(accDeleteId != null){
          accDeleteIds= accDeleteId.split(';');
          for(string stIds:accDeleteIds){
               mpstd.put(stIds,stIds);    
          }    
       }   
      for(Opportunity opp : triggerOld){
          if(!(mpstd.containsKey(profileIds) || mpstd.containsKey(profileId))){  
              opp.addError('You do not have permission to delete the Opportunity. Please contact your Administrator.');          
           }     
      }
   }
    
  /***End Here***/  
    
    /***Added by Alekhya from DelOppAccLead class to consolidate multiple triggers into one trigger
	OwnerAssignmentbyAT Trigger logic is replicated here***/
    
    public static void ownerAssignmentbyAT(list<Opportunity>triggerNew){
        for (Opportunity o : triggerNew){       
            if(o.Opportunity_Owner_AM__c != null && (UserInfo.getProfileId() == '00e30000000rrZwAAI' || Utilities.getIsTestMethod())) {
                //System.debug(Logginglevel.INFO, 'OwnerAssignment ' + o.Owner_Assignment_byAT__c);
                o.OwnerId = o.Opportunity_Owner_AM__c;
            } 
    	}
        
    }
    
  /***End Here***/  
     /***Added by Alekhya from NoEPSSOpptyOwner trigger to consolidate multiple triggers into one trigger
	NoEPSSOpptyOwner Trigger logic is replicated here***/
    
    public static void NoEPSSOpptyOwner(list<Opportunity>triggerNew){
        //set default postn for epss. lead convert and other.
        //epss/pss cannot own oppty. this is for lead convert. 
        //need addPhase line to set owner of phase. 
        ProfileID__c profileIds = ProfileID__c.getInstance();
       
        String pssProfileId = profileIds.Cisco_PSS__c;
        String currentUserProfileId = userinfo.getProfileId();
        if (triggerNew.size() == 1){
            Boolean CurrentUserEpss = false;
            Boolean OwnerEpss = false;       
            Opportunity opty = triggerNew[0];
            //Added Logic to get the Permission Set for the User
            User CurrentUser = [select Default_Position__c, Id, Profile.Name, Additional_User_Permissions__c,(SELECT Id,PermissionSet.ID, PermissionSet.Name,AssigneeId FROM PermissionSetAssignments)  from user where id = :UserInfo.getUserId()];
            //Check if the logged in User is BDR/LDR
            Boolean currentUserBDRORLDR = false;
            for(PermissionSetAssignment permSet : CurrentUser.PermissionSetAssignments){
                if(permSet.PermissionSet.Name== Utilities.getConstant_CS('NGCC_LDR_BDR_Permission_Set')){
                    currentUserBDROrLDR = true;
                }
            }
            if(CurrentUser.Additional_User_Permissions__c <> null && (CurrentUser.Additional_User_Permissions__c.replace('Enable_ePSS','') != CurrentUser.Additional_User_Permissions__c ||
                                                                      CurrentUser.Additional_User_Permissions__c.contains('Enable_VSS')) 
               ){
                   CurrentUserEpss=true;     
               }
            
            Id owner = opty.Opportunity_Owner_Am__c;
            if(owner == null){
                owner = opty.OwnerId;
            }
            
            User OwnerInfo = [select Default_Position__c, Id, ProfileId, Profile.Name, Additional_User_Permissions__c,(SELECT Id,PermissionSet.ID, PermissionSet.Name,AssigneeId FROM PermissionSetAssignments) from user where id = :owner];
            string OwnerProfileId = OwnerInfo.ProfileId;
            //Logic to check if the Opportunity Owner is Specialist
            if( Utilities.isEPSSuser(owner)){
                OwnerEpss=true;
            }
            //Logic to check if the Opportunity Owner is LDR/BDR
            Boolean ownerBDRORLDR = false;
            for(PermissionSetAssignment permSet : OwnerInfo.PermissionSetAssignments){
                if(permSet.PermissionSet.Name== Utilities.getConstant_CS('NGCC_LDR_BDR_Permission_Set')){
                    ownerBDRORLDR = true;
                }
            }
            // Added currentUserBDROrLDR for LDR/BDR 
            if(currentUserBDROrLDR || CurrentUserEpss || currentUserProfileId.contains(pssProfileId) ){
                String tempPostn = OwnerInfo.Default_Position__c;
                Opportunity OpptyToUpdate = new Opportunity(Id=opty.Id);
                if( OwnerEpss == false && ownerBDRORLDR==false)
                {   
                    //Set Opportunity Owner to AM
                    if(opty.Opportunity_Owner_Am__c <> null)
                    {
                        OpptyToUpdate.OwnerId = opty.Opportunity_Owner_Am__c;
                        update OpptyToUpdate;
                    }
                  
                    if (tempPostn <> null || opty.Opportunity_Owner_Am__c <> null)
                    {
                        Utilities.setValidationSkip(true);//skips validation rules
                        Utilities.setSkip(true);//skips certain trigger functionality
                        Utilities.setskipFuture(true);//skips more future calls
                        if(currentUserBDROrLDR==true){
                            //Add Opportunity Team Member
                            OpportunityTeamMember optyTeam = new opportunityTeamMember(OpportunityId=opty.Id, 
                                                                                       UserId=UserInfo.getUserId(),
                                                                                       OpportunityAccessLevel = 'Edit',
                                                                                       TeamMemberRole=Utilities.getConstant_CS('NGCC_Opportunity_Team_Role'));
                            insert optyTeam;
                            //get all of the sharing records which Salesforce created right now. rowCause is Sales Team.
                            List<OpportunityShare> oppShareRecords = [select Id, OpportunityAccessLevel, RowCause from OpportunityShare where OpportunityId =: opty.Id and RowCause = 'Team'];
                            // set team members access to read/write
                            for (OpportunityShare OppShare : oppShareRecords){
                                OppShare.OpportunityAccessLevel = 'Edit'; 
                            }
                            update oppShareRecords; 
                            
                            //Update Opportunity ID on the Lead Record
                            Lead ld = [select id,Existing_Opportunity__c from Lead where id=:opty.DRT_Lead__c];
                            ld.Existing_Opportunity__c = opty.Id;
                            update ld;
                            
                        }else{
                            Utilities.addStUser(opty.Id, UserInfo.getUserId(), 'Edit', 'Product Sales Specialist', 'Team');
                        }
                    }
                }
                else {
                    opty.addError('Specialists or VDC Sales Reps (LDRs, BDRs) cannot own opportunities. Please select the correct Account Owner in the "Opportunity Owner AM" field.');
                }
            }
            else if( OwnerEpss || currentUserProfileId.contains(pssProfileId) )
            {
                opty.addError('PSS users cannot own opportunities. Please choose another Owner AM.');
             }
        }
        
    }
    
   /***End Here***/ 
     /***Added by Alekhya from OpptyGetDealId trigger to consolidate multiple triggers into one trigger
	OpptyGetDealId Trigger logic is replicated here***/
    
    public static void  opptyGetDealId(List<Opportunity> triggerNew, Map<id,sobject> oldMap, Boolean isUpdate){
    
        if (!Utilities.getskipFuture() ){
            //WR-0480 :: commented below query whihc is not using 7/1/2016    
            ID[] opptys = new ID[]{};
            Opportunity[] opptyStatusUpdates = new Opportunity[]{};
            Map<id,Opportunity> mapOptysDelIdObj = new Map<id,Opportunity>();
            Opportunity[] optysDelId = new Opportunity[]{};
    
    
            for(Opportunity o : triggerNew) {        
                //US7979: Updating if condition to check if opportunity has line items to allow deal id to be generated for opportunity
                //GDM change for deal Id generation for Global Opportunity recordtype 
                //Quote Integration: Enabling Deal Id generation even without Tech & Service in Stage 1
                if(o.dealID__c == null && o.Deal_Id_Status__c == null &&
                   (o.RecordTypeId == Utilities.getOpptyParentRecordTypeId() || o.RecordTypeId == Utilities.getOpptyGlobalRecordTypeId()
                       || o.RecordTypeId == Utilities.getOpptyRenewalRecordTypeId()) && 
                   o.Position__c != null){
                    // Oppty_deal_id_processing_time__c and Processing time custom fields added on Opportunity object for WR-00851
                    Opportunity o2 = new Opportunity(Id=o.Id, Timestamp_DealID_Status_SetTo_Processing__c = DateTime.now());
                    if(o.StageName != '1 - Prospect' && OpportunityService.hasValidTechnology(o) && OpportunityService.hasValidService(o)){                    
                        opptyStatusUpdates.add(o2);
                        opptys.add(o.Id);
                        mapOptysDelIdObj.put(o.id,o);
                    } else{
                        opptyStatusUpdates.add(o2);
                        opptys.add(o.Id);
                        mapOptysDelIdObj.put(o.id,o);
                    }
                   
                }
            }
                
            // 7/7/2015 Changed this line for batch size. Will flux when testing bulk upload (clv)
            if(opptys.size()>0) {
                Utilities.setValidationSkip(true);//skips validation rules
                Utilities.setSkip(true);//skips certain trigger functionality
                Utilities.setskipFuture(true);//skips more future calls            
                OpptyGetDealId.assignDealids(mapOptysDelIdObj);
                Update opptyStatusUpdates;            
            }
            
        }
    
        if(isUpdate){
            ID[] opptysNewDealIds = new ID[]{};
            for(Opportunity o : triggerNew) {
                opportunity old = (opportunity)oldMap.get(o.Id);
                if(o.dealID__c != null && old.dealID__c == null){
                    opptysNewDealIds.add(o.Id);
                }           
                // majanard - moved the Account trigger call position so it will trigger only during Security contact updates 5/21
                if(o.Security_SE__c != old.Security_SE__c || o.Security_AM__c != old.Security_AM__c){
                    // This trigger is updated to call the AccountTeamMember update class for Work Request - WR-00626. 
                    // Purpose: Adding the Securit contacts to Account and AccountTeamMember from Opportunity.
                    Oppty_SecurityRoles_AccountTeamUpdate actUpdate = new Oppty_SecurityRoles_AccountTeamUpdate();
                    actUpdate.UpdateAccount(triggerNew);
                } 
             }
            if(opptysNewDealIds.size()>0){
                Oppty_Deal_ID_Failure_Log__c[] failureLogInserts = new Oppty_Deal_ID_Failure_Log__c[]{};
                Opptys_Requiring_DealIDs__c[] ordToDelete = new Opptys_Requiring_DealIDs__c[]{};             
                for(Opptys_Requiring_DealIDs__c ord: [Select Id, Opportunity__c, attempts__c, error__c from Opptys_Requiring_DealIDs__c where Opportunity__c IN :opptysNewDealIds]){
                    Oppty_Deal_ID_Failure_Log__c logTemp = new Oppty_Deal_ID_Failure_Log__c(Opportunity__c=ord.Opportunity__c, attempts__c=ord.attempts__c, error__c=ord.error__c);
                    failureLogInserts.add(logTemp);
                    ordToDelete.add(ord);
                }                
                if(failureLogInserts.size() > 0)
                    Insert failureLogInserts;
                         
                if(ordToDelete.size() > 0)
                    Delete ordToDelete;
            }
        }
    }
    
    /***Added by Alekhya from OpptyFutureUpdate trigger to consolidate multiple triggers into one trigger
	OpptyFutureUpdate Trigger logic is replicated here***/
    
    public static void  opptyFutureUpdate(List<Opportunity> triggerNew, Map<id,sobject> oldMap, Boolean isUpdate){
        
        if ( !Utilities.getskipFuture() ){
        ID[] newOpptyNames = new ID[]{};
        ID[] statusOpptys = new ID[]{};
        ID[] allSyncOptyIds = new ID[]{};
    
            for(Opportunity o : triggerNew) {
                
                // if an update trigger, then add to the sync to workspace list.
                if(isUpdate) {
                    
                    Opportunity oldTemp = (opportunity)oldMap.get(o.Id);
                    if(isUpdate && o.Name != oldTemp.Name){
                        newOpptyNames.add(o.Id);
                    }
                    
                    if(isUpdate && o.Opportunity_Status__c != oldTemp.Opportunity_Status__c){
                        statusOpptys.add(o.Id);
                    } 
                    // Update workspace only if Opportunity fields have changed             
                    if(o.Forecast_Status__c != oldTemp.Forecast_Status__c ||
                        o.CloseDate != oldTemp.CloseDate ||
                        o.Expected_Product__c != oldTemp.Expected_Product__c ||
                        o.Expected_Service__c != oldTemp.Expected_Service__c ||        
                        o.Opportunity_Status__c != oldTemp.Opportunity_Status__c)
                        {
                            allSyncOptyIds.add(o.Id); 
                        }                   
                }    
            }
            if( newOpptyNames.size() > 0 || statusOpptys.size() > 0){
                OpptyFutureClass.updateOpptys(newOpptyNames, statusOpptys);
            }
                
                
            // sync all the opty workspaces with the oppty
            if(allSyncOptyIds.size() > 0){
                OpptyFutureClass.syncWorkspaceWithOpty(allSyncOptyIds);                
            }       
                   
    
        }
        
    }
     /***Added by Alekhya from opptyChildUpdate trigger to consolidate multiple triggers into one trigger
	opptyChildUpdate Trigger logic is replicated here***/
    
    public static void  opptyChildUpdate(List<Opportunity> triggerNew, List<Opportunity> triggerOld )

    {
        if (OpptyChildUpdate.getProcessOpptyChild())
        {
            try 
            {                    
               OpptyChildUpdate.setProcessOpptyChild(false);
               Opportunity[] childOpptys = new Opportunity[]{};
               Map<ID, Opportunity> OpptyValMap = new Map<ID, Opportunity>();           
                
               for(Integer x=0;x<triggerNew.size();x++)
               {      
                    if(triggerNew[x].RecordTypeId == Utilities.getOpptyParentRecordTypeId() || 
                        triggerNew[x].RecordTypeId == Utilities.getOpptyPartnerParentRecordTypeId()){               
                            Opportunity toO = new Opportunity( id =  triggerNew[x].Id, 
                            OwnerId = triggerNew[x].OwnerId,
                            Position__c = triggerNew[x].Position__c,              
                            Territory2Id = triggerNew[x].Territory2Id,    
                            Contract_Number__c=triggerNew[x].Contract_Number__c,
                            DD_Status__c = triggerNew[x].DD_Status__c ,
                            DealID__c = triggerNew[x].DealID__c ,
                            Theater__c = triggerNew[x].Theater__c,                        
                            skipValidations__c = true);
                            OpptyValMap.put(triggerNew[x].Id, toO);
                            System.debug('*** Parent=>' + triggerNew[x].Name + ':' + triggerNew[x].Id + ':new ' + triggerNew[x].OwnerId + ':old ' + triggerOld[x].OwnerId);
                    }
                }
            
                Opportunity[] children = [select Id, Parent_ID__c 
                                             From Opportunity 
                                             WHERE 
                                             RecordTypeId in (:Utilities.getOpptyPhaseRecordTypeId(),:Utilities.getOpptyPartnerPhaseRecordTypeId()) 
                                             and Parent_ID__c in :OpptyValMap.keySet()]; 
                                                         
                for(Opportunity o : children)
                {               
                        Opportunity tempOPPTY = new Opportunity(
                            Id = o.Id, 
                            OwnerId = OpptyValMap.get(o.Parent_ID__c).OwnerId ,                                  
                            Position__c = OpptyValMap.get(o.Parent_ID__c).Position__c,
                            Territory2Id = OpptyValMap.get(o.Parent_ID__c).Territory2Id,                         
                            Contract_Number__c = OpptyValMap.get(o.Parent_ID__c).Contract_Number__c ,
                            DD_Status__c = OpptyValMap.get(o.Parent_ID__c).DD_Status__c ,
                            DealID__c = OpptyValMap.get(o.Parent_ID__c).DealID__c ,
                            Theater__c = OpptyValMap.get(o.Parent_ID__c).Theater__c,
                            skipValidations__c = true 
                        );                                
                        childOpptys.add(tempOPPTY);
                        system.debug('entering>>>'+childOpptys);
                }
                if(childOpptys.size() > 0)
                {
                    System.debug('**Child Opptys updating** ' + childOpptys.size());
                    Database.SaveResult[] opptyRslts = Database.Update(childOpptys,false);
                    System.debug('**Child Opptys updating** ' + childOpptys.size());
                }
            }
            catch(Exception e)
            {
                System.debug('Error \n' + e);
            }
        }
    }
    
    /***Added by Alekhya from  OpptyMandatoryCompetitor trigger to consolidate multiple triggers into one trigger
	 OpptyMandatoryCompetitor Trigger logic is replicated here***/
    
    public static void  opptyMandatoryCompetitor(List<Opportunity> triggerNew, Map<id,sobject> oldMap, Boolean isUpdate, Boolean isInsert)
    
    {    
        //enforce Competitors being mandatory for specfic recordTypes, profiles, and conditions in validation rule.
        Opportunity[] opptys = triggerNew;
        boolean tempHasComp = false;
        //added by Kavya to get the competitor available list
        Set<String> pickListValuesList= new Set<String>();
        Schema.DescribeFieldResult F = Opportunity.Competitors__c.getDescribe();
        List<Schema.PicklistEntry> p = F.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : p){
            if(pickListVal.isActive()==true)
                pickListValuesList.add(pickListVal.getLabel().toLowerCase());
        }
        System.debug('pickListValuesList'+pickListValuesList);
        //ends here
    //    String recordTypeIds = Utilities.OpptyMandatoryCompetitorRecordTypes();
    
       if(Utilities.skipUser())
        {
            tempHasComp = true;
        }
        
        for (Opportunity o : opptys)
       
        {
             Opportunity oldTemp = (opportunity)oldMap.get(o.Id);
            
            //added by Kavya to check value of other competitor field is present in competitor multiselect
            
            if(String.isNotBlank(o.Other_Competitor__c) && pickListValuesList.contains(o.Other_Competitor__c.toLowerCase()) )
            {
                o.addError(o.Other_Competitor__c+ ' is already in the list of competitors. Pick from the list or enter a new competitor.');
            }
            //ends here
            if ( o.Competitors__c != null )
            {
                o.Competitors__c = o.Competitors__c.replace( ';Competitors;' , ';').replace( 'Competitors;' , '' ).replace( ';Competitors' , '');
                
            }                   
            if( ( o.Competitors__c == null || o.Competitors__c == 'Competitors' ) && 
      /*          recordTypeIds.contains(o.RecordTypeId) &&*/ 
                (isInsert) || ( isUpdate && o.OwnerId == oldTemp.OwnerId )  )  
            {
                o.Has_Competitors__c = tempHasComp;
            }
            else
            {
                o.Has_Competitors__c = true;
            }               
        }   
    }
    /***Added by Alekhya from  OpptyOwnerPostnChk trigger to consolidate multiple triggers into one trigger
	 OpptyOwnerPostnChk Trigger logic is replicated here***/
    
    Public static void  opptyOwnerPostnChk(List<Opportunity> triggerNew, Map<id,sobject> oldMap, Boolean isInsert)
    
    {
        Opportunity[] opptys = triggerNew; 
        Set<Id> OpptyOwner = new Set<Id>{}; 
        Set<id> epsUserwithPostion = new Set<id>{}; 
        Set<Id> UsersWithPositions = new Set<Id>{};     
        Set<Id> NonAMOwners = new Set<Id>{};  
        Set<id> ownerAMIDs = new set<id>();
        
        ProfileID__c profileIds = ProfileID__c.getInstance();
        
    
        for (Opportunity o : opptys){ /*get all new owners*/
            if(o.OwnerId != null){
                OpptyOwner.add(o.OwnerId);
                 ownerAMIDs.add(o.Opportunity_Owner_AM__c);
            }   
        }
        // saduvvur modified on 8/13/2015
        // merged multiple soql queris using maps to fix test class issues
        //Map of default forecast position based on Opportunity AM
        Map<id,user> myMap = new Map<id,User>([select Default_Position__c,Position_1__c, Profile.Name, Additional_User_Permissions__c , Id from user where id in : OpptyOwner]);
        Map<id,user> myMapAM = new Map<id,User>([select Default_Position__c,Position_1__c, Profile.Name, Additional_User_Permissions__c , Id from user where id in : ownerAMIDs]);    
       
        for(User u : myMap.values() ){
            if(u.Position_1__c != null){
                UsersWithPositions.add(u.Id);
            }        
            if(u.Additional_User_Permissions__c <> null  && (u.Additional_User_Permissions__c.replace('Enable_ePSS','') != u.Additional_User_Permissions__c || u.Profile.Name == 'Cisco_PSS')){
                epsUserwithPostion.add(u.id);
               
            }else if(u.Additional_User_Permissions__c <> null  && u.Additional_User_Permissions__c.replace('Enable_ePSS','') != u.Additional_User_Permissions__c){
                NonAMOwners.add(u.Id);
            }
        }
        
        
        String recordTypeIds = Utilities.OpptyOwnerPostnChkRecordTypes();
        for (Opportunity o : opptys){
            
             Opportunity oldTemp = (opportunity)oldMap.get(o.Id);
            
            
            if(!isInsert && (o.OwnerId != oldTemp.OwnerId) ){  /*if update & new owner*/  
                String ownerProfileId = myMap.get(o.OwnerId).profileId;
                if( (recordTypeIds.contains(o.RecordTypeId) && !UsersWithPositions.contains(o.OwnerId)) || NonAMOwners.contains(o.OwnerId)
                    ){/*if parent type and no postn*/
                    o.OwnerId.addError(Label.Opportunity_Owner_Change_Error);
                } else {
                }
            } 
            else if (!Utilities.skipUser() && o.Position__c == null && UsersWithPositions.contains(o.OwnerId)){   
                if (recordTypeIds.contains(o.RecordTypeId) ){                 
                    if(isInsert)
                    {
                        if(myMap.get(o.ownerId).Position_1__c != null && myMap.get(o.ownerId).Position_1__c!='')
                        {
                            string[] strPostion = myMap.get(o.ownerId).Position_1__c.split('\n');
                            if(strPostion.size() == 1){
                                o.Position__c = myMap.get(o.ownerId).Position_1__c.split('\n')[0].trim();
                            }
                        }
                        else
                        {
                            System.debug('Unable to Determine Forecast Position for userid->' + o.ownerId);
                        }                        
                    }  
                }                           
            }
            else if(!Utilities.skipUser() && o.Position__c == null && epsUserwithPostion.contains(o.ownerId)){     
                if(!(myMapAM.isEmpty()) && myMapAM.get(o.Opportunity_Owner_AM__c).Position_1__c != null && myMapAM.get(o.Opportunity_Owner_AM__c).Position_1__c!='')
                {
                    string[] strPostion = myMapAM.get(o.Opportunity_Owner_AM__c).Position_1__c.split('\n');               
                    if(strPostion.size() == 1){                 
                        o.Position__c = myMapAM.get(o.Opportunity_Owner_AM__c).Position_1__c.split('\n')[0].trim();
                    }           
                }
                else
                {
                    System.debug('Unable to Determine Forecast Position for userid->' + o.Opportunity_Owner_AM__c);
                }   
            }
        }
    }
    
    /***Added by Alekhya from  OpptyOwnerPostnChk trigger to consolidate multiple triggers into one trigger
	 OpptyValidationRuleChk Trigger logic is replicated here***/
    
    Public static void  opptyValidationRuleChk (List<Opportunity> triggerNew, Map<id,sobject> oldMap,Boolean isUpdate, Boolean isInsert)
    /***Modification History:
    Itrack#        Date             Author                      Change  
    ****************************************************************************
    US250307     March 20 ,2019  Kavya                         Setting a isPSSuser Variable
    
    **********************************************/
     {
        
        boolean checkBox = false;
        Set<Opportunity> opptyObjectId = new Set<Opportunity>();
        Set<Opportunity> opptyObjectIdDelete = new Set<Opportunity>();
        
        if(Utilities.getValidationSkip())
            checkBox = true;
        //added by Kavya to set the flag to allow pss user to create opportunity
        if(isInsert)
           Utilities.setisPSSUser(true);
           //ends here
        for(Opportunity o :triggerNew) {
             o.skipValidations__c = checkBox;
             
             Opportunity oldTemp = (opportunity)oldMap.get(o.Id);
             
             //Cloud Demand field removal
            if (isUpdate && oldTemp.Cloud_Demand_Partner_Service_OfferLookup__c != null && o.Cloud_Demand_Partner_Service_OfferLookup__c == null) { 
                opptyObjectIdDelete.add(o);
            }
            
            //Cloud Demand fields that need to be populated
            if(o.Cloud_Demand_Partner_Service_OfferLookup__c != null  && ((isUpdate && oldTemp.Cloud_Demand_Partner_Service_OfferLookup__c != o.Cloud_Demand_Partner_Service_OfferLookup__c) || isInsert)){
                opptyObjectId.add(o);
            }
        }
    
        //Cloud Demand Processing
        opptyCloudDemand cd = new opptyCloudDemand();
        
        if(opptyObjectId.size() > 0)
            cd.cloudDemandPopulate(opptyObjectId);
            
        if(opptyObjectIdDelete.size() > 0)
            cd.cloudDemandDelete(opptyObjectIdDelete);
    
        OpptyCloudDemandProjectedValue cDProjVal = new OpptyCloudDemandProjectedValue();
        cDProjVal.updateCloudProjectedValue(triggerNew);
                  
    }
    
     /***Added by Alekhya from  PartnerUpdate trigger to consolidate multiple triggers into one trigger
	 PartnerUpdate Trigger logic is replicated here***/
    
    Public static void  partnerUpdate (List<Opportunity> triggerNew, Map<id,sobject> oldMap, Boolean isInsert){
     
        if(OpptyPartnerUpdate.getOpptyPartnerUpdated() == false) {
            OpptyPartnerUpdate.setOpptyPartnerUpdated(true);
     
        Partner[] partnerToUpdate = new Partner[]{}; 
        Map<String, ID> opptyPartnerAcct = new Map<String, ID>();
    
        
        for(Opportunity o : triggerNew) {
            
            Opportunity oldTemp = (opportunity)oldMap.get(o.Id);
            
            if(isInsert){
                Partner newPartner;
                if(o.Primary_Partner__c != null)
                    partnerToUpdate.add(new Partner(AccountToId=o.Primary_Partner__c, OpportunityId=o.Id, Role=o.Primary_Partner_Role__c, IsPrimary=true));
                if(o.Partner_2__c != null)
                    partnerToUpdate.add(new Partner(AccountToId=o.Partner_2__c, OpportunityId=o.Id, Role=o.Role_2__c));
                if(o.Partner_3__c != null)
                    partnerToUpdate.add(new Partner(AccountToId=o.Partner_3__c, OpportunityId=o.Id, Role=o.Role_3__c));
                if(o.Partner_4__c != null)
                    partnerToUpdate.add(new Partner(AccountToId=o.Partner_4__c, OpportunityId=o.Id, Role=o.Role_4__c));
                if(o.Partner_5__c != null)
                    partnerToUpdate.add(new Partner(AccountToId=o.Partner_5__c, OpportunityId=o.Id, Role=o.Role_5__c));         
            }
            else{
                if(o.Primary_Partner__c != oldTemp.Primary_Partner__c || o.Partner_2__c != oldTemp.Partner_2__c || o.Partner_3__c != oldTemp.Partner_3__c || o.Partner_4__c != oldTemp.Partner_4__c || o.Partner_5__c != oldTemp.Partner_5__c)
                {
                    if(o.Primary_Partner__c != oldTemp.Primary_Partner__c){
                        if(o.Primary_Partner__c != null){
                            partnerToUpdate.add(new Partner(AccountToId=o.Primary_Partner__c, OpportunityId=o.Id, Role=o.Primary_Partner_Role__c, IsPrimary=true));
                            if(oldTemp.Primary_Partner__c != null){
                                opptyPartnerAcct.put(o.Id + '-' + oldTemp.Primary_Partner__c + '-' + oldTemp.Primary_Partner_Role__c, o.Id);    
                            }
                        }
                        else{
                            opptyPartnerAcct.put(o.Id + '-' + oldTemp.Primary_Partner__c + '-' + oldTemp.Primary_Partner_Role__c, o.Id);
                        }   
                    }
                    if(o.Partner_2__c != oldTemp.Partner_2__c){
                        if(o.Partner_2__c != null){
                            Partner p = new Partner(AccountToId=o.Partner_2__c, OpportunityId=o.Id, Role=o.Role_2__c);
                            partnerToUpdate.add(p);
                            if(oldTemp.Partner_2__c != null){
                                opptyPartnerAcct.put(o.Id + '-' + oldTemp.Partner_2__c + '-' + oldTemp.Role_2__c, o.Id);
                            }
                        }
                        else{
                            opptyPartnerAcct.put(o.Id + '-' + oldTemp.Partner_2__c + '-' + oldTemp.Role_2__c, o.Id);
                        }
                    }
                    if(o.Partner_3__c != oldTemp.Partner_3__c){
                        if(o.Partner_3__c != null){
                            Partner p = new Partner(AccountToId=o.Partner_3__c, OpportunityId=o.Id, Role=o.Role_3__c);
                            partnerToUpdate.add(p);
                            if(oldTemp.Partner_3__c != null){
                                opptyPartnerAcct.put(o.Id + '-' + oldTemp.Partner_3__c + '-' + oldTemp.Role_3__c, o.Id);
                            }
                        }
                        else{
                            opptyPartnerAcct.put(o.Id + '-' + oldTemp.Partner_3__c + '-' + oldTemp.Role_3__c, o.Id);
                        }
                    }
                    if(o.Partner_4__c != oldTemp.Partner_4__c){
                        if(o.Partner_4__c != null){ 
                            Partner p = new Partner(AccountToId=o.Partner_4__c, OpportunityId=o.Id, Role=o.Role_4__c);
                            partnerToUpdate.add(p);
                            if(oldTemp.Partner_4__c != null){
                                opptyPartnerAcct.put(o.Id + '-' + oldTemp.Partner_4__c + '-' + oldTemp.Role_4__c, o.Id);
                            }                
                        }
                        else{
                            opptyPartnerAcct.put(o.Id + '-' + oldTemp.Partner_4__c + '-' + oldTemp.Role_4__c, o.Id);
                        }
                    }
                    if(o.Partner_5__c != oldTemp.Partner_5__c){
                        if(o.Partner_5__c != null){
                            Partner p = new Partner(AccountToId=o.Partner_5__c, OpportunityId=o.Id, Role=o.Role_5__c);
                            partnerToUpdate.add(p);
                            if(oldTemp.Partner_5__c != null){
                                opptyPartnerAcct.put(o.Id + '-' + oldTemp.Partner_5__c + '-' + oldTemp.Role_5__c, o.Id);
                            }
                        }
                        else{
                            opptyPartnerAcct.put(o.Id + '-' + oldTemp.Partner_5__c + '-' + oldTemp.Role_5__c, o.Id);
                        }
                    }
                }
                
                if(o.Primary_Partner_Role__c != oldTemp.Primary_Partner_Role__c || o.Role_2__c != oldTemp.Role_2__c || o.Role_3__c != oldTemp.Role_3__c || o.Role_4__c != oldTemp.Role_4__c || o.Role_5__c != oldTemp.Role_5__c) {
                    
                    if(o.Primary_Partner_Role__c != oldTemp.Primary_Partner_Role__c && o.Primary_Partner__c == oldTemp.Primary_Partner__c && o.Primary_Partner__c != null){
                        partnerToUpdate.add(new Partner(AccountToId=o.Primary_Partner__c, OpportunityId=o.Id, Role=o.Primary_Partner_Role__c, IsPrimary=true));
                        opptyPartnerAcct.put(o.Id + '-' + oldTemp.Primary_Partner__c + '-' + oldTemp.Primary_Partner_Role__c, o.Id);    
                    }
                    if(o.Role_2__c != oldTemp.Role_2__c && o.Partner_2__c == oldTemp.Partner_2__c && o.Partner_2__c != null){
                        partnerToUpdate.add(new Partner(AccountToId=o.Partner_2__c, OpportunityId=o.Id, Role=o.Role_2__c));
                        opptyPartnerAcct.put(o.Id + '-' + oldTemp.Partner_2__c + '-' + oldTemp.Role_2__c, o.Id);    
                    }
                    if(o.Role_3__c != oldTemp.Role_3__c && o.Partner_3__c == oldTemp.Partner_3__c && o.Partner_3__c != null){
                        partnerToUpdate.add(new Partner(AccountToId=o.Partner_3__c, OpportunityId=o.Id, Role=o.Role_3__c));
                        opptyPartnerAcct.put(o.Id + '-' + oldTemp.Partner_3__c + '-' + oldTemp.Role_3__c, o.Id);    
                    }
                    if(o.Role_4__c != oldTemp.Role_4__c && o.Partner_4__c == oldTemp.Partner_4__c && o.Partner_4__c != null){
                        partnerToUpdate.add(new Partner(AccountToId=o.Partner_4__c, OpportunityId=o.Id, Role=o.Role_4__c));
                        opptyPartnerAcct.put(o.Id + '-' + oldTemp.Partner_4__c + '-' + oldTemp.Role_4__c, o.Id);    
                    }                                
                    if(o.Role_5__c != oldTemp.Role_5__c && o.Partner_5__c == oldTemp.Partner_5__c && o.Partner_2__c != null){
                        partnerToUpdate.add(new Partner(AccountToId=o.Partner_5__c, OpportunityId=o.Id, Role=o.Role_5__c));
                        opptyPartnerAcct.put(o.Id + '-' + oldTemp.Partner_5__c + '-' + oldTemp.Role_5__c, o.Id);    
                    }                
                }
                
            } // Update
        
        }// for loop
        
        
        if(opptyPartnerAcct.size() > 0) {
            Partner[] partnersToRemove = new Partner[]{};
    
            for(Partner p: [Select Id, AccountToId, OpportunityId, Role From Partner Where OpportunityId IN :opptyPartnerAcct.values()]) {
                if(opptyPartnerAcct.containsKey(p.OpportunityId + '-' + p.AccountToId + '-' + p.Role)){
                    Partner p2 = new Partner(Id=p.Id);
                    partnersToRemove.add(p2);
                }
            }
    
            if(partnersToRemove.size() > 0){
                delete partnersToRemove;
            } 
        }
        if(partnerToUpdate.size() > 0) {
            insert partnerToUpdate;
        }
        
        } // opptyPartnerUpdated
       
    }
 

Public static void opportunityExpectedAmtChanged (List<Opportunity> triggerNew,List<Opportunity> triggerOld, Map<id,sobject>triggerNewMap, Boolean isInsert, Boolean isUpdate)

    {
    
        /*  
           This trigger identifies new or updated Opportunity records. It checks to see if the 
            Expected_Product__c or Expected_Service__c fields have been changed. If yes, it then
            retrieves related OpportunityLineItem and applies the Mix % to the TotalPrice and 
            Opportunity Line Item Value fields. 
           
        */
        
    /*  MixPctPackage.processLineItems() = false;*///Set the global variable to suppress the OpportunityLineItem trigger from executing.
        MixPct.setProcessLineItems(false);
        
        Opportunity[] opportunityNewArrayToUpdate = triggerNew;
        Opportunity[] opportunityOldArrayToUpdate = triggerOld;
        OpportunityLineItem[] updateLineItems = new OpportunityLineItem[]{}; 
        Opportunity[] opptyToProcessArray = new Opportunity[]{};
        Integer x;
         
        System.debug('Trigger OpportunityExpectedAmtChanged launched....');
        System.debug('Going to process [' + triggerNew.size() + '] Opportunities which have been updated....');
    
     
        //Handle the updates differently than the inserts
        //For updates, we need to check if the Expected Prodcut or Expected Service values changed
        if(isUpdate){
                
            for(x=0;x<opportunityNewArrayToUpdate.size();x++){
                    
                if (opportunityOldArrayToUpdate[x].Expected_Product__c != opportunityNewArrayToUpdate[x].Expected_Product__c || opportunityOldArrayToUpdate[x].Expected_Service__c != opportunityNewArrayToUpdate[x].Expected_Service__c) {
                    //The expected service or expected product value changed. Need to process this Opportunity and related LineItems.
                    opptyToProcessArray.add(opportunityNewArrayToUpdate[x]);
                }
            }
            
        } //isUpdate
    
        //When the trigger is an insert, all records need to be processed. 
        if(isInsert){  
            opptyToProcessArray = triggerNew;
        }   
        
        
        if(opptyToProcessArray!=null && opptyToProcessArray.size() > 0){
                
                //Get all related OpportunityLineItems. Differentiate between Technology and Service lineitems by the ProductCode
                OpportunityLineItem[] technologyRelatedOpptyLineItems = [select o.Id, o.Opportunity_Line_Value__c, o.OpportunityId, o.Mix__c, o.UnitPrice, Expected_TCV_000s__c from OpportunityLineItem o where o.OpportunityId IN :opptyToProcessArray and o.PricebookEntry.ProductCode= 'Technology'];
                OpportunityLineItem[] serviceRelatedOpptyLineItems = [select o.Id, o.Opportunity_Line_Value__c, o.OpportunityId, o.Mix__c, o.UnitPrice, Expected_TCV_000s__c from OpportunityLineItem o where o.OpportunityId IN :opptyToProcessArray and o.PricebookEntry.ProductCode= 'Service'];        
    
            
                //Process all technology related line items
                for(OpportunityLineItem oliTechnology : technologyRelatedOpptyLineItems){
                    
                     
                    
                   Opportunity opptyObj = (opportunity)triggerNewMap.get(oliTechnology.OpportunityId);
                   
                   if(opptyObj.RecordTypeId==Utilities.getOpptyRenewalRecordTypeId()){
                       system.debug('Renewal Opportunity..');               
                       if(opptyObj.Expected_Product__c == null || opptyObj.Expected_Product__c == 0 || oliTechnology.Expected_TCV_000s__c==null){
                      // if(opptyObj.Expected_Product__c == null || opptyObj.Expected_Product__c == 0){                 
                                   oliTechnology.TotalPrice = 0;
                                   oliTechnology.Opportunity_Line_Value__c = 0;
                                   oliTechnology.Mix__c = 0;
                                   oliTechnology.Expected_TCV_000s__c = 0;
                       }
                       else{
                                   Double expprdopp = opptyObj.Expected_Product__c;Double exptcvline = oliTechnology.Expected_TCV_000s__c;
                                   Double mixline = exptcvline/expprdopp*100; Decimal mixline2 = ((decimal)mixline).setScale(2);
                                   
                                   oliTechnology.Mix__c = mixline2;
                       }
                   }
                   else{
                       if(opptyObj.Expected_Product__c == null || opptyObj.Expected_Product__c == 0 || oliTechnology.Mix__c == null || oliTechnology.Mix__c == 0){
                                   oliTechnology.TotalPrice = 0;
                                   oliTechnology.Opportunity_Line_Value__c = 0;
                       }
                       else {
                                   oliTechnology.TotalPrice = (oliTechnology.Mix__c/100) * opptyObj.Expected_Product__c;
                                   oliTechnology.Opportunity_Line_Value__c = (oliTechnology.Mix__c/100) * opptyObj.Expected_Product__c;
                       }
                   } 
                   updateLineItems.add(oliTechnology);
                   if(updateLineItems.size() == 100){
                       update updateLineItems;
                       updateLineItems.clear();
                   }
                        
                }
                
                //Process all service related line items
                for(OpportunityLineItem oliService : serviceRelatedOpptyLineItems){
                    
                   Opportunity opptyObj = (opportunity)triggerNewMap.get(oliService.OpportunityId);
                
                   if(opptyObj.RecordTypeId==Utilities.getOpptyRenewalRecordTypeId()){
                           system.debug('Renewal Opportunity..');               
                           if(opptyObj.Expected_Service__c == null || opptyObj.Expected_Service__c == 0 || oliService.Expected_TCV_000s__c == null){
                        //   if(opptyObj.Expected_Service__c == null || opptyObj.Expected_Service__c == 0){
                                   oliService.TotalPrice = 0;
                                   oliService.Opportunity_Line_Value__c = 0;
                                   oliService.Mix__c = 0;
                                   oliService.Expected_TCV_000s__c = 0;
                           }
                           else{
                                   Double expservopp = opptyObj.Expected_Service__c;Double exptcvline = oliService.Expected_TCV_000s__c;
                                   Double mixline = exptcvline/expservopp*100; Decimal mixline2 = ((decimal)mixline).setScale(2);
                                   
                                   oliService.Mix__c = mixline2;
                           }
                    }
                    else{
                           if(opptyObj.Expected_Service__c == null || opptyObj.Expected_Service__c == 0 || oliService.Mix__c == null || oliService.Mix__c == 0){
                                        oliService.TotalPrice = 0;
                                        oliService.Opportunity_Line_Value__c = 0;
                           }
                           else{
                                        oliService.TotalPrice = (oliService.Mix__c/100) * opptyObj.Expected_Service__c;
                                        oliService.Opportunity_Line_Value__c = (oliService.Mix__c/100) * opptyObj.Expected_Service__c;
                           }                
                    }    
                    updateLineItems.add(oliService);
                    if(updateLineItems.size() == 100){
                        update updateLineItems;
                        updateLineItems.clear();
                    }
                }
                
        }
    
        //Check to see if any OpportunityLineItems need to be updated. Send in bulk.
        if(updateLineItems != null && updateLineItems.size() > 0){
                System.debug('About to update [' + updateLineItems.size() + '] OpportunityLineItems.....');
                //Update OpportunityLineItems
                update updateLineItems;
                System.debug('Completed the update of [' + updateLineItems.size() + '] OpportunityLineItems...');
            }
            else{
                System.debug('No Opportunity Line Items need to be updated');
            }
        System.debug('Trigger OpportunityExpectedAmtChanged exiting....');
        MixPct.setProcessLineItems(true);
        
    }
}