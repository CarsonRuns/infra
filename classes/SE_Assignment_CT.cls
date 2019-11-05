public class SE_Assignment_CT 
{  

    // SCAVA Helper Method to validate Update Access at field level
     public static Boolean flsUpdate(SObjectField field)
    {
        return field.getDescribe().isUpdateable() ? true : false;
    }
     // SCAVA Helper Method to validate Create Access at field level
     public static Boolean flsGet(SObjectField field)
    {
        return field.getDescribe().isCreateable() ? true : false;
    } 
    //check for isdtp=mn 
    //scontrol w/ delId 
    //OwnerId add as SE. Error.
        
    List<SE_Assignment__c> allAssignments;
    List<SE_Assignment__c> assignments = new SE_Assignment__c[]{};
    List<SE_Assignment__c> toDelete = new SE_Assignment__c[]{};
    List<Id> toDeleteSEIds = new Id[]{};
    private Final String oid = System.currentPageReference().getParameters().get('id');
    private Final Id delID = System.currentPageReference().getParameters().get('delId');

    Opportunity o;
    public Opportunity getOpportunity() 
    {
        if (o == null)
        {
            o = [Select Name from Opportunity where Id = :oid];
        }           
        return o;
    }

    public List<SE_Assignment__c> getAssignments() 
    {
        errorMsg = '';
        if(allAssignments == null)
        { 
                    
            allAssignments = [select 
                                Id, Opportunity__c, Cisco_SE__c, contribution__c, 
                                se_assignment_type__c, 
                                se_engagement_type__c, Partner_SE__c, notify_SE__c, notify_AM__c   
                            from SE_Assignment__c where Opportunity__c = :oid];

            for ( SE_Assignment__c a : allAssignments )
            {   

                if(a.Id == delID)
                {
                    toDelete.add(a);
                    toDeleteSEIds.add(a.Cisco_SE__c);                   
                    errorMsg = 'Save to delete the selected row.';                                      
                }
                else
                {
                    assignments.add(a);
                }                   
            }               
        }
        return assignments;
    }
    
    public PageReference addSE() 
    {
        SE_Assignment__c newSE = new SE_Assignment__c();
        if(flsGet(SE_Assignment__c.Opportunity__c)|| flsUpdate(SE_Assignment__c.Opportunity__c)) //SCAVA FIX
       {
        newSE.Opportunity__c = oid;
       }
       if(flsGet(SE_Assignment__c.notify_SE__c)|| flsUpdate(SE_Assignment__c.notify_SE__c)) //SCAVA FIX
       {
        newSE.notify_SE__c=true;
       }
       if(flsGet(SE_Assignment__c.se_assignment_type__c)|| flsUpdate(SE_Assignment__c.se_assignment_type__c)) //SCAVA FIX
       {
        newSE.se_assignment_type__c = 'Secondary';
       }        
        assignments.add(newSE);
        return null;
    }
    
    private String delRowNum;
    public String getRowNum() { return delRowNum;}
    public void setRowNum(String data) { delRowNum = data; }

    public PageReference delSE() 
    {
        Integer i = Integer.valueOf(delRowNum);
        if(assignments.get(i).id != null)
        {
            toDelete.add(assignments.get(i));
            if ( assignments.get(i).Cisco_SE__c != null)
            {
                toDeleteSEIds.add(assignments.get(i).Cisco_SE__c);
            }               
        }
        assignments.remove(i);  
        return null;
    }
    
    private String errorMsg = '';
    public String getError_msg() { return errorMsg;}

    public PageReference save() 
    {
        Savepoint sp = Database.setSavepoint();
        PageReference newpage = null;
        try{
            Utilities.setSkip(true);//skips certain trigger functionality
            Utilities.setValidationSkip(true); 
            if(flsUpdate(Opportunity.SE_Assigned__c))           //SCAVA FIX 
          {         
            o.SE_Assigned__c = true;
          }
            update o;
    
            addSEs();

            if ( toDelete.size() > 0 ){
                deleteSEs();
            }
            
            newpage = new PageReference('/'+ oid);
            newpage.setRedirect(true);          
        } 
        catch (Exception e) {
            errorMsg += '*** SEA exc: ' + e;
            Database.rollback(sp);          
        }
        return newpage;
    }
    
    private void deleteSEs()
    {
//  try{
        if ( toDeleteSEIds.size() > 0 )
        {
            try
            {         
                OpportunityTeamMember otm = [select Id FROM OpportunityTeamMember where OpportunityId = :oid and UserId in :toDeleteSEIds];
               //SCAVA FIX
               if (OpportunityTeamMember.sObjectType.getDescribe().isDeletable())
               { 
                delete otm;
               }
            }               
            catch (Exception e) 
            {
                //do nothing
            }               
        }      
     //SCAVA FIX
               if (SE_Assignment__c.sObjectType.getDescribe().isDeletable())
               {               
                delete(toDelete);   
               }

    }
    
    private void addSEs()
    {
        for ( SE_Assignment__c sea : assignments )
        {
            if ( sea.Cisco_SE__c != null )
            {
                //errorMsg = ' addSEs ' +oid +' '+ sea.Cisco_SE__c;
                SE_TeamMember.addUser(oid,sea.Cisco_SE__c);
            }
        }
        upsert(assignments);
    }
    
//TEST METHOD//
    public static testMethod void test_SE_Assignment_CT() 
    {
        
        Opportunity o = new Opportunity(name='test',stageName='Open',
                                        CloseDate=Date.newInstance(2006,10,10));
        insert o;                                                                                        

        User[] se = [select Id FROM User where isactive = true limit 2];
        
        SE_Assignment__c[] SE_Assignments = new SE_Assignment__c[]{};                                        

        SE_Assignment__c SEATmp = new SE_Assignment__c(Opportunity__c = o.id, notify_SE__c=true,Cisco_SE__c = se[0].Id );
        SE_Assignments.add(SEATmp);
        SEATmp = new SE_Assignment__c(Opportunity__c = o.id, notify_SE__c=true,Cisco_SE__c = se[1].Id );  
        SE_Assignments.add(SEATmp);

        insert SE_Assignments;

        Test.setCurrentPageReference(new PageReference('SE_Assignment'));
        // Add parameters to page URL
        System.currentPageReference().getParameters().put('id', o.id);
        //del li from del link
        System.currentPageReference().getParameters().put('delId', SE_Assignments[1].Id );
                
        SE_Assignment_CT controller = new SE_Assignment_CT();
    
        controller.getOpportunity();
        controller.getAssignments();    
    
        controller.setRowNum('0');
        controller.getRowNum();    
        controller.delSE();
        
        controller.addSE();        
        
        for ( SE_Assignment__c a : controller.getAssignments() )
        {
            if ( a.Partner_SE__c == null && a.Cisco_SE__c == null )
            {
                a.Cisco_SE__c = se[1].Id;
            }
        }

        controller.save();

        System.debug( controller.getError_msg() );
        
        controller.addSE();
        controller.save();

    }

}