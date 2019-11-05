/*
 Description : Automatically reassign leads and target prospects to a current PA when PSRs are deactivated
 
         Lead:
                - Inactive PSR on the Lead record should be removed from the Lead record.
                - If there are no other PSR assigned on the Lead, then Partner Status on the Lead record should be re-set to "Partner Assigned" status.
                - Only Leads with Partner Status as  "Actively Working" and "Assigned to PSR" should be considered for the Re-set.
Target Prospect:
                - Inactive PSR on the TP record should be removed from the TP record
                - If there are no other PSR assigned on the TP, then Partner status on the TP record should be re-set to "Partner Assigned" status and TP should remain "Activated".
                - Only Active TP records with "Actively Working" and "Assigned to PSR" should be considered for the Re-Set.
 
*/

public class P360_ReassignLeadsandTPsonDeactivedUser {
    
    // SCAVA Helper Method to validate Update Access at field level
     public static Boolean flsUpdate(SObjectField field)
    {
        return field.getDescribe().isUpdateable() ? true : false;
    }

    
    public static void ReassignLeadsandTPsDirect(set<Id> setUser){
        ReassignLeadsandTPsProcess(setUser);    
    }
    
    @future
    public static void ReassignLeadsandTPsFuture(set<Id> setUser){
        ReassignLeadsandTPsProcess(setUser);    
    }

 public static void ReassignLeadsandTPsProcess(set<Id> setUser)
 {  
    //Initialize variable.
    list<lead> lstLead = new list<lead>();
    list<Assigned_Partner__c> lstTP = new list<Assigned_Partner__c>();
    boolean bval=false;
    string activelyWorking = Org_Constant_CS__c.getValues('P360 Actively working').Production_Value__c;
    string partnerAssigned = Org_Constant_CS__c.getValues('P360 Partner Assigned').Production_Value__c;                
    string assignedtoPSR = Org_Constant_CS__c.getValues('P360 Assigned to PSR').Production_Value__c; 
    
    //iterate leads filter by userset ids.
    for(lead l:[select id,Partner_Lead_Status__c,Channel_Partner__c,PSR_1__c,PSR_2__c,PSR_3__c from lead where (Partner_Lead_Status__c =:activelyWorking or Partner_Lead_Status__c =:assignedtoPSR) and (PSR_1__c IN: setUser or PSR_2__c IN: setUser or PSR_3__c IN: setUser) ])
    {
         bval = false;
         
        //check whether psr 1,2,3 values exist in userset.
        if(setUser.contains(l.PSR_1__c))
        {
            //SCAVA FIX
            if(flsUpdate(Lead.PSR_1__c))
            {
            l.PSR_1__c =null; 
            }
            bval = true;            
        }
        if(setUser.contains(l.PSR_2__c))
        {
            if(flsUpdate(Lead.PSR_2__c))
            {
            l.PSR_2__c = null; 
            }
            bval = true;            
        }
        if(setUser.contains(l.PSR_3__c))
        {
            if(flsUpdate(Lead.PSR_3__c))
            {
            l.PSR_3__c = null;
            }
            bval = true;
        }
        
        
        if(bval)
        {   
            //check whether psr 1,2,3 has values.       
            if(l.PSR_1__c !=null || l.PSR_2__c !=null || l.PSR_3__c !=null)
            {    
            //SCAVA FIX
            if(flsUpdate(Lead.Partner_Lead_Status__c))
            {       
                l.Partner_Lead_Status__c = assignedtoPSR;
            }
            }
            else
            {
                l.Partner_Lead_Status__c = partnerAssigned;
            }           
            
            //add to list.
            lstLead.add(l);
        }
                
     }
     
     //Iterate Target Prospect filter by Userset ids.
     for(Assigned_Partner__c tp:[select id,Partner_Status__c,Assigned_Partner__c,Assigned_Partner_Sales_Rep__c,Assigned_Partner_Sales_Rep_2__c,Assigned_Partner_Sales_Rep_3__c from Assigned_Partner__c where (Partner_Status__c =:activelyWorking or Partner_Status__c =:assignedtoPSR) and  (Assigned_Partner_Sales_Rep__c IN: setUser or Assigned_Partner_Sales_Rep_2__c IN: setUser or Assigned_Partner_Sales_Rep_3__c IN: setUser)])
    {
         bval = false;
         
         //check whether psr 1,2,3 values exist in userset.
        if(setUser.contains(tp.Assigned_Partner_Sales_Rep__c))
        {
            //SCAVA FIX
            if(flsUpdate(Assigned_Partner__c.Assigned_Partner_Sales_Rep__c))
            {
            tp.Assigned_Partner_Sales_Rep__c = null; 
            }
            bval = true;            
        }
        if(setUser.contains(tp.Assigned_Partner_Sales_Rep_2__c))
        {
            //SCAVA FIX
            if(flsUpdate(Assigned_Partner__c.Assigned_Partner_Sales_Rep_2__c))
            {
            tp.Assigned_Partner_Sales_Rep_2__c = null; 
            }
            bval = true;            
        }
        if(setUser.contains(tp.Assigned_Partner_Sales_Rep_3__c))
        {
            //SCAVA FIX
            if(flsUpdate(Assigned_Partner__c.Assigned_Partner_Sales_Rep_3__c))
            {
            tp.Assigned_Partner_Sales_Rep_3__c = null;
            }
            bval = true;
        }
        
        if(bval)
        {
            //check whether psr 1,2,3 has values.
            if(tp.Assigned_Partner_Sales_Rep__c !=null || tp.Assigned_Partner_Sales_Rep_2__c !=null || tp.Assigned_Partner_Sales_Rep_3__c !=null)
            {
                //SCAVA FIX
            if(flsUpdate(Assigned_Partner__c.Partner_Status__c))
            {
                tp.Partner_Status__c = assignedtoPSR;
            }
            }
            else
            {
                tp.Partner_Status__c = partnerAssigned;
            }
            
            //add to list.
            lstTP.add(tp);
        }
                
     }
     
     //check list is not empty.
     if(!lstLead.isEmpty())
     {
        database.update(lstLead,false);
     }
     
     //check list is not empty.
     if(!lstTP.isEmpty())
     {
        database.update(lstTP,false);
     }
    
 }
}