/**
 * Class of utility methods for CSOpty.cls
 * Use case is if actions fail, keep processing
 * Created for Quote Collaboration Q2FY10
 * author - cmiura
 */
public class CSOptyUtils {
    
    // SCAVA Helper Method to validate Create Access at field level
     public static Boolean flsGet(SObjectField field)
    {
        return field.getDescribe().isCreateable() ? true : false;
    }
    
    /* Create Note */
    Public static boolean createNote(String title1, String optyId, String note1) {
        boolean success = true;
        try {
            Note noteNew = new Note();
            // SCAVA FIX 
            if(flsGet(Note.ParentId)){ 
             noteNew.ParentId = String.valueOf(optyId);
             }
             // SCAVA FIX
             if(flsGet(Note.title)){
             noteNew.title = title1;
             }
             //SCAVA FIX
             if(flsGet(Note.body)){
             noteNew.body = note1;
             }
            Insert noteNew;
        }
        catch (Exception e) {
            success = false;
        }
        return success;      
    }
    
    /* Copy SE Assignments */
    
   Public static boolean copySE(String origOptyId, String newOptyId) {return true;}
       // boolean success = true;
      //  try {
            /* START DYNAMIC APEX */
            /* Get all fields for the sObject */
           /* Map<String, Schema.SObjectField> fieldMap = Schema.SObjectType.SE_Assignment__c.fields.getMap();
            List<String> fieldList = getFieldList(fieldMap,true);
                
            /* Build query string */
         /*   String fieldNames = getFieldNamesFromList(fieldList);
            String q = 'select '+fieldNames+' from SE_Assignment__c where Opportunity__c=:origOptyId';
                
            /*List<SObject> sArr = Database.query(q);
            /* END DYNAMIC APEX */
            /*List<SE_Assignment__c> seli = new SE_Assignment__c[]{};

            for (sObject s : sArr) {
                /* Cast sObject to Task and clone */
  /*              SE_Assignment__c se = (SE_Assignment__c)s;
                SE_Assignment__c seNew = new SE_Assignment__c(); 
                seNew = se.clone(false);
                seNew.Opportunity__c = String.valueOf(newOptyId);
                //Insert seNew;
                seli.add(seNew);
            }
            Database.SaveResult[] MySaveResult = Database.Insert(seli,false);
        }
        catch (QueryException qe) {
            //No SE Assignments - do nothing.
        }
        catch (Exception e) {
            success = false;
        }
        return success;      
    }*/ //Commented to replace with Resource Request object code
    
    
 /* Copy Resource Request and Assignments */
 
    Public static boolean copyResourceRequestAss(String origOptyId, String newOptyId) {
        boolean success = true;
        try {
            /* START DYNAMIC APEX */
            /* Get all fields for the sObject */
            Map<String, Schema.SObjectField> fieldMap = Schema.SObjectType.Resource_Request_Assignment__c.fields.getMap();
            List<String> fieldList = getFieldList(fieldMap,true);
                
            /* Build query string */
            String fieldNames = getFieldNamesFromList(fieldList);
            String q = 'select '+fieldNames+' from Resource_Request_Assignment__c where Opportunity_Name__c=:origOptyId';
                
            List<SObject> sArr = Database.query(q);
            /* END DYNAMIC APEX */
                
            List<Resource_Request_Assignment__c> rrali = new Resource_Request_Assignment__c[]{};

            for (sObject s : sArr) {
                /* Cast sObject to Task and clone */
                Resource_Request_Assignment__c rr = (Resource_Request_Assignment__c)s;
                Resource_Request_Assignment__c rrNew = new Resource_Request_Assignment__c(); 
                rrNew = rr.clone(false);
                //SCAVA FIX
               if(flsGet(Resource_Request_Assignment__c.Opportunity_Name__c))
                {
                rrNew.Opportunity_Name__c = String.valueOf(newOptyId);
                }
                //Insert rrNew;
                rrali.add(rrNew);
            }
            Database.SaveResult[] MySaveResult = Database.Insert(rrali,false);
        }
        catch (QueryException qe) {
            //No Resource Request Assignments- do nothing.
        }
        catch (Exception e) {
            success = false;
        }
        return success;      
    }
   
    /* Story: US7301
    Removed the method - copyResourceCase to cleanup Resource_Case__c object */

    /* Copy Opportunity Contact Role */
    Public static boolean copyContactRole(String origOptyId, String newOptyId) {
        boolean success = true;
        try {
            /* START DYNAMIC APEX */
            /* Get all fields for the sObject */
            Map<String, Schema.SObjectField> fieldMap = Schema.SObjectType.OpportunityContactRole.fields.getMap();
            List<String> fieldList = getFieldList(fieldMap,true);
                
            /* Build query string */
            String fieldNames = getFieldNamesFromList(fieldList);
            String q = 'select '+fieldNames+' from OpportunityContactRole where OpportunityId=:origOptyId';
                
            List<SObject> sArr = Database.query(q);
            /* END DYNAMIC APEX */

            List<OpportunityContactRole> ocrl = new OpportunityContactRole[]{};
                
            for (sObject s : sArr) {
                /* Cast sObject to Task and clone */
                OpportunityContactRole ocr = (OpportunityContactRole)s;
                OpportunityContactRole ocrNew = new OpportunityContactRole(); 
                ocrNew = ocr.clone(false);
                //SCAVA FIX
                if(flsGet(OpportunityContactRole.OpportunityId))
                {
                ocrNew.OpportunityId = String.valueOf(newOptyId);
                }
                //Insert ocrNew;
                ocrl.add(ocrNew);
            }
            Database.SaveResult[] MySaveResult = Database.Insert(ocrl,false);
        }
        catch (QueryException qe) {
            //No Sales Team members - do nothing.
        }
        catch (Exception e) {
           success = false;
        }
        return success;      
    }

     /* Copy Sales Team */
    //Modified and Moved this method into Utilities Class
    /*
    Public static boolean copySalesTeam(String origOptyId, String newOptyId) {
        boolean success = true;
        try {
            opportunityTeamMember[] ot = [Select o.UserId, o.TeamMemberRole, o.OpportunityAccessLevel 
            From OpportunityTeamMember o where o.OpportunityId=:origOptyId and o.User.IsActive= true and o.OpportunityAccessLevel!= 'None'  ];
           //opportunityTeamMember[] ot = [Select o.UserId, o.TeamMemberRole ,  o.OpportunityAccessLevel From OpportunityTeamMember o where o.OpportunityId=:opptyID and o.IsDeleted=false];
                    
                      
                        OpportunityTeamMember[] opptyTeamToUpdate = new OpportunityTeamMember[]{};
                        OpportunityShare[] OpptyShare = new OpportunityShare[]{};  
                        System.debug('***ot :'+ ot);
                        For (Integer l = 0; l < ot.size(); l++)
                        {
                        OpportunityTeamMember otm = new opportunityTeamMember ( OpportunityId=newOptyId, UserId=ot[l].UserId, TeamMemberRole=ot[l].TeamMemberRole); 
                        opptyTeamToUpdate.add(otm);
                        OpportunityShare os = new OpportunityShare(OpportunityId=newOptyId, UserOrGroupId=ot[l].UserId, OpportunityAccessLevel=ot[l].OpportunityAccessLevel);
                        opptyShare.add(os);
                        }
                        System.debug('***'+ opptyTeamToUpdate);
                        System.debug('***'+ opptyShare);
      
                        insert opptyTeamToUpdate;
                        insert opptyShare;
                }           
          catch (QueryException qe) {
            //No Sales Team members - do nothing.
        }
         catch (Exception e) {
            success = false;
        } 
      
                        System.debug('***End of Code');
      return success;      
    }        
 */ 

    /* Copy Event */
    Public static boolean copyEvent(String origOptyId, String newOptyId) {
        boolean success = true;
        try {
            /* START DYNAMIC APEX */
            /* Get all fields for the sObject */
            Map<String, Schema.SObjectField> fieldMap = Schema.SObjectType.Event.fields.getMap();
            List<String> fieldList = getFieldList(fieldMap,true);
              
            /* Build query string */
            String fieldNames = getFieldNamesFromList(fieldList);
            String q = 'select '+fieldNames+' from Event where WhatId=:origOptyId';
                
            List<SObject> sArr = Database.query(q);
            /* END DYNAMIC APEX */
                
            List<Event> e = new Event[]{};

            for (sObject s : sArr) {
                Event eventNew = new Event();
                /* Cast sObject to Task and clone */
                Event evt = (Event)s;
                eventNew = evt.clone(false);
                //SCAVA FIX
                if(flsGet(Event.WhatId))
                {
                eventNew.WhatId = String.valueOf(newOptyId);
                }
                //Insert eventNew;
                e.add(eventNew);
            }
            Database.SaveResult[] MySaveResult = Database.Insert(e,false);
        }
        catch (QueryException qe) {
            //No Events - do nothing.
        }
        catch (Exception e) {
            success = false;
        }
        return success;      
    }

    /* Copy Task */
    Public static boolean copyTask(String origOptyId, String newOptyId) {
        boolean success = true;
        try {
            /* START DYNAMIC APEX */
            /* Get all fields for the sObject */
            Map<String, Schema.SObjectField> fieldMap = Schema.SObjectType.Task.fields.getMap();
            List<String> fieldList = getFieldList(fieldMap,true);
                
            /* Build query string */
            String fieldNames = getFieldNamesFromList(fieldList);
            String q = 'select '+fieldNames+' from Task where WhatId=:origOptyId';
                
            List<SObject> sArr = Database.query(q);
            /* END DYNAMIC APEX */
                
            List<Task> tli = new Task[]{};

            for (sObject s : sArr) {
                /* Cast sObject to Task and clone */
                Task tsk = (Task)s;
                Task taskNew = new Task(); 
                taskNew = tsk.clone(false);
                //SCAVA FIX
                if(flsGet(Task.WhatId))
                {
                taskNew.WhatId = String.valueOf(newOptyId);
                }
                //Insert taskNew;
                tli.add(taskNew);
            }
            Database.SaveResult[] MySaveResult = Database.Insert(tli,false);
        }
        catch (QueryException qe) {
            //No Tasks - do nothing.
        }
        catch (Exception e) {
            success = false;
        }
        return success;      
    }

    /* Copy Note */
    Public static boolean copyNote(String origOptyId, String newOptyId) {
        boolean success = true;
        try {
            /* START DYNAMIC APEX */
            /* Get all fields for the sObject */
            Map<String, Schema.SObjectField> fieldMap = Schema.SObjectType.Note.fields.getMap();
            List<String> fieldList = getFieldList(fieldMap,true);
                
            /* Build query string */
            String fieldNames = getFieldNamesFromList(fieldList);
            String q = 'select '+fieldNames+' from Note where ParentId=:origOptyId';
                
            List<SObject> sArr = Database.query(q);
            /* END DYNAMIC APEX */
                
            List<Note> nli = new Note[]{};

            for (sObject s : sArr) {
                /* Cast sObject to Task and clone */
                Note nte = (Note)s;
                Note noteNew = new Note(); 
                noteNew = nte.clone(false);
                //SCAVA FIX
                if(flsGet(Note.ParentId))
                {
                noteNew.ParentId = String.valueOf(newOptyId);
                }
                //Insert noteNew;
                nli.add(noteNew);
            }
            Database.SaveResult[] MySaveResult = Database.Insert(nli,false);
        }
        catch (QueryException qe) {
            //No Note - do nothing.
        }
        catch (Exception e) {
            success = false;
        }
        return success;      
    }


    /* Copy AT Workspace */
    Public static boolean copyATWorkspace(String origOptyId, String newOptyId) {
        boolean success = true;
        try {
            /* START DYNAMIC APEX */
            /* Get all fields for the sObject */
            Map<String, Schema.SObjectField> fieldMap = Schema.SObjectType.AT_Workspace__c.fields.getMap();
            List<String> fieldList = getFieldList(fieldMap,true);
                
            /* Build query string */
            String fieldNames = getFieldNamesFromList(fieldList);
            String q = 'select '+fieldNames+' from AT_Workspace__c where Opportunity__c=:origOptyId';
                
            List<SObject> sArr = Database.query(q);
            /* END DYNAMIC APEX */
                
            List<AT_Workspace__c> atwli = new AT_Workspace__c[]{};

            for (sObject s : sArr) {
                /* Cast sObject to Task and clone */
                AT_Workspace__c at = (AT_Workspace__c)s;
                AT_Workspace__c atNew = new AT_Workspace__c(); 
                atNew = at.clone(false);
                //SCAVA FIX
                if(flsGet(AT_Workspace__c.Opportunity__c))
                {
                atNew.Opportunity__c = String.valueOf(newOptyId);
                }
                //Insert atNew;
                atwli.add(atNew);
            }
            Database.SaveResult[] MySaveResult = Database.Insert(atwli,false);
        }
        catch (QueryException qe) {
            //No AT Workspaces - do nothing.
        }
        catch (Exception e) {
            success = false;
        }
        return success;      
    }

    /* Copy Attachments */
    Public static boolean copyAttachments(String origOptyId, String newOptyId) {
        boolean success = true;
        try {
            /* START DYNAMIC APEX */
            /* Get all fields for the sObject */
            Map<String, Schema.SObjectField> fieldMap = Schema.SObjectType.Attachment.fields.getMap();
            List<String> fieldList = getFieldList(fieldMap,true);
                
            /* Build query string */
            String fieldNames = getFieldNamesFromList(fieldList);
            String q = 'select '+fieldNames+' from Attachment where ParentId=:origOptyId';
                
            List<SObject> sArr = Database.query(q);
            /* END DYNAMIC APEX */
            
            List<Attachment> ali = new Attachment[]{};

            for (sObject s : sArr) {
                /* Cast sObject to Task and clone */
                Attachment att = (Attachment)s;
                Attachment attNew = new Attachment(); 
                attNew = att.clone(false);
                //SCAVA FIX
                if(flsGet(Attachment.ParentId))
                {
                attNew.ParentId = String.valueOf(newOptyId);
                }
                //Insert attNew;
                ali.add(attNew);
            }
            Database.SaveResult[] MySaveResult = Database.Insert(ali,false);
        }
        catch (QueryException qe) {
            //No Attachment - do nothing.
        }
        catch (Exception e) {
            success = false;
        }
    return success;      
    }
    /*
     * Helper method to build list of sObject fields
     * http://community.salesforce.com/sforce/board/message?board.id=apex&message.id=10219
     */
    public static List<String> getFieldList(Map<String,Schema.SObjectField> fieldMap, Boolean selectAllFields) {
        List<String> fieldList = new List<String>();
        
        //build dynamic list of fieldnames
        for (String fieldKey : fieldMap.keySet()) {
            Schema.SObjectField fsObj = fieldMap.get(fieldKey);
            Schema.DescribeFieldResult f = fsObj.getDescribe();
            String fieldName = f.getName();
            
            if (selectAllFields) {
                fieldList.add(fieldName);
            }
            else if (f.getName()=='Id' || f.isNameField() || f.isCustom()) {
                fieldList.add(fieldName);
            }
        }
        return fieldList;
    }
    public static Id getTerrIdByPostn(String postnName) {
        Id i;
        try {
            if (postnName != null && postnName != '') {
                Territory2 t = [Select Id From Territory2 where Name=:postnName Limit 1];
                return t.Id;
            }
        }
        catch (Exception e) {
        }
        return i;
    }
    /* Helper method fo build SOQL query string from list of sObject field names */
    public static String getFieldNamesFromList(List<String> fieldList) {
        String fieldNames = '';
        for (String field : fieldList) {
            if (fieldNames.length()>0) {
                fieldNames += ',';
            }
            fieldNames += field;
        }
        
        if (fieldNames.length()>15000) {
            throw new Opty.OptyException('Fieldnames length > 15000 characters');
        }
        return fieldNames;
    }    
}