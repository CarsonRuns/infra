public class Update_Opty_Engagement_type {
// Class to update Engagement Type
@FUTURE 
PUBLIC static void upd_opty(id[] optyid)
{
    datetime startTime = datetime.now();
    system.debug('starttime is '+startTime);
    OPPORTUNITY[] opptyArray = new Opportunity[]{};

    Resource_Request_Assignment__c[] se_resource=[Select Id,Opportunity_Name__c, Resource_Name__c,Assignment_Type__c 
    from Resource_Request_Assignment__c  where Opportunity_Name__c IN :optyid and Resource_Name__r.isactive =true and
    Resource_Status__c in ('Assigned','Direct Assignment')order by Opportunity_Name__c ];
    
    BOOLEAN v_partneronly = true;
    BOOLEAN v_ciscoonly = true;
    BOOLEAN v_partnerprimary = false;
    BOOLEAN v_ciscoprimary = false ;
    BOOLEAN v_partnerled = false;
    BOOLEAN v_ciscoled = false;
    BOOLEAN v_partnersecondary = false;
    BOOLEAN v_secondary = false;

    system.debug('Opty size ='+ optyid.size());
    system.debug('SE Resource size ='+ se_resource.size());

    //set up the flag for first record
    IF (se_resource.size()>0)
    {
    If (se_resource[0].Assignment_Type__c != 'Partner Primary' && se_resource[0].Assignment_Type__c != 'Partner Secondary' )
    {
     v_partneronly = false ;
    }
    
    If (se_resource[0].Assignment_Type__c != 'Primary' && se_resource[0].Assignment_Type__c != 'Secondary' )
    {
     v_ciscoonly = false ;
    }
    
    If (se_resource[0].Assignment_Type__c == 'Partner Primary' )
    {
     v_partnerprimary = true;
    }

    If (se_resource[0].Assignment_Type__c == 'Partner Secondary' )
    {
     v_partnersecondary = true;
    }
    
    If (se_resource[0].Assignment_Type__c == 'Secondary' )
    {
     v_secondary = true;
    }
    
    If (v_partnerprimary ==true && v_secondary == true)
    {
     v_partnerled = true;
    }
    
    If (se_resource[0].Assignment_Type__c == 'Primary' )
    {
     v_ciscoprimary = true;
    }
    
    If (v_ciscoprimary ==true && v_partnersecondary == true)
    {
     v_ciscoled = true;
    }

    for (Integer l = 0; l < se_resource.size(); l++)
    {
    
      // if the opportunity is changed or if it is the last record
        If ((l>0 && se_resource[l-1].Opportunity_Name__c != se_resource[l].Opportunity_Name__c) || l==se_resource.size()-1)
        {
    
        // if the record is last record
         If (l==se_resource.size()-1)
         {
    
            If (se_resource[l].Assignment_Type__c != 'Partner Primary' && se_resource[l].Assignment_Type__c != 'Partner Secondary' )
            {
             v_partneronly = false ;
            }
            
            If (se_resource[l].Assignment_Type__c != 'Primary' && se_resource[l].Assignment_Type__c != 'Secondary' )
            {
             v_ciscoonly = false ;
            }
            
            If (se_resource[l].Assignment_Type__c == 'Partner Primary' )
            {
             v_partnerprimary = true;
            }
    
            If (se_resource[l].Assignment_Type__c == 'Partner Secondary' )
            {
             v_partnersecondary = true;
            }
            
            If (se_resource[l].Assignment_Type__c == 'Secondary' )
            {
             v_secondary = true;
            }
            
            If (v_partnerprimary ==true && v_secondary == true)
            {
             v_partnerled = true;
            }
            
            If (se_resource[l].Assignment_Type__c == 'Primary' )
            {
             v_ciscoprimary = true;
            }
            
            If (v_ciscoprimary ==true && v_partnersecondary == true)
            {
             v_ciscoled = true;
            }

            if (v_partneronly == true)
            {
                
                Opportunity OpptyUpdate = new Opportunity(Id= se_resource[l].Opportunity_Name__c, SE_Engagement_Type__c='Partner Only');          
                opptyArray.add(OpptyUpdate);    
            }
            
            if (v_ciscoonly == true && v_partneronly == false)
            {
            
                Opportunity OpptyUpdate = new Opportunity(Id= se_resource[l].Opportunity_Name__c, SE_Engagement_Type__c='Cisco Only');            
                opptyArray.add(OpptyUpdate);
            }
            
            if (v_partnerled == true && v_partneronly == false && v_ciscoonly == false)
            {
                
                Opportunity OpptyUpdate = new Opportunity(Id= se_resource[l].Opportunity_Name__c, SE_Engagement_Type__c='Partner Led – Partner SE Primary');           
                opptyArray.add(OpptyUpdate);
            }
            
            if (v_ciscoled == true && v_partnerled == false && v_partneronly == false && v_ciscoonly == false)
            {
                
                Opportunity OpptyUpdate = new Opportunity(Id= se_resource[l].Opportunity_Name__c, SE_Engagement_Type__c='Cisco Led – Cisco SE Primary');           
                opptyArray.add(OpptyUpdate);
            }
            
          break ;
         }
         else
         { 
            system.debug('Optyid added to array ='+ se_resource[l-1].Opportunity_Name__c);
            if (v_partneronly == true)
            {
                
                Opportunity OpptyUpdate = new Opportunity(Id= se_resource[l-1].Opportunity_Name__c, SE_Engagement_Type__c='Partner Only');          
                opptyArray.add(OpptyUpdate);    
            }
            
            if (v_ciscoonly == true && v_partneronly == false)
            {
            
                Opportunity OpptyUpdate = new Opportunity(Id= se_resource[l-1].Opportunity_Name__c, SE_Engagement_Type__c='Cisco Only');            
                opptyArray.add(OpptyUpdate);
            }
            
            if (v_partnerled == true && v_partneronly == false && v_ciscoonly == false)
            {
                
                Opportunity OpptyUpdate = new Opportunity(Id= se_resource[l-1].Opportunity_Name__c, SE_Engagement_Type__c='Partner Led – Partner SE Primary');           
                opptyArray.add(OpptyUpdate);
            }
            
            if (v_ciscoled == true && v_partnerled == false && v_partneronly == false && v_ciscoonly == false)
            {
                
                Opportunity OpptyUpdate = new Opportunity(Id= se_resource[l-1].Opportunity_Name__c, SE_Engagement_Type__c='Cisco Led – Cisco SE Primary');           
                opptyArray.add(OpptyUpdate);
            }
        
            system.debug (              
            '  v_partneronly=' +v_partneronly + 
            '  v_ciscoonly=' +v_ciscoonly +
            '  v_partnerprimary='+v_partnerprimary +
            '  v_ciscoprimary='+v_ciscoprimary + 
            '  v_partnerled='+v_partnerled +
            '  v_ciscoled='+v_ciscoled  ) ;

            v_partneronly = true;
            v_ciscoonly = true;
            v_partnerprimary = false;
            v_partnersecondary = false;
            v_secondary = false;
            v_ciscoprimary = false ;
            v_partnerled = false;
            v_ciscoled = false;
         }
        }       
        system.debug('se_resource[l].opportunity_name '+se_resource[l].opportunity_name__C);
        
        If (se_resource[l].Assignment_Type__c != 'Partner Primary' && se_resource[l].Assignment_Type__c != 'Partner Secondary' )
        {
         v_partneronly = false ;
        }
        
        If (se_resource[l].Assignment_Type__c != 'Primary' && se_resource[l].Assignment_Type__c != 'Secondary' )
        {
         v_ciscoonly = false ;
        }
        
        If (se_resource[l].Assignment_Type__c == 'Partner Primary' )
        {
         v_partnerprimary = true;
        }

        If (se_resource[l].Assignment_Type__c == 'Partner Secondary' )
        {
         v_partnersecondary = true;
        }
        
        If (se_resource[l].Assignment_Type__c == 'Secondary' )
        {
         v_secondary = true;
        }
        
        If (v_partnerprimary ==true && v_secondary == true)
        {
         v_partnerled = true;
        }
        
        If (se_resource[l].Assignment_Type__c == 'Primary' )
        {
         v_ciscoprimary = true;
        }
        
        If (v_ciscoprimary ==true && v_partnersecondary == true)
        {
         v_ciscoled = true;
        }
 
    }
    }
    system.debug('Opty Array size ='+ opptyArray.size());
 
    Utilities.setSkip(true);   
    Utilities.setValidationSkip(true);
	Utilities.setSkipFuture(true);
    
    IF (opptyArray.size() > 0)
    update opptyArray;
}



}