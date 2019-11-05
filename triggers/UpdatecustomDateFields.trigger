/**
   @Author sfdc config
   @name <UpdatecustomDateFields>
   @CreateDate <3/28/2014>
   @Description To track partner customer data
   @Version <1.0>
  */
trigger UpdatecustomDateFields on Partner_Customer_Deployment_Tracking_SF__c (before insert,before update) {
if(trigger.isInsert){
    for(Partner_Customer_Deployment_Tracking_SF__c psd:Trigger.new)
    {
        if(psd.Partner_PSS_Sales_Cycle__c == '1-Qualification'){
          psd.PSS_Sales_Qualification_Created_Date__c = system.now();            
        }
        if(psd.Partner_PSS_Sales_Cycle__c=='2-Awareness'){
        psd.PSS_Sales_Awareness_Created_Date__c= system.now();
        }
        if (psd.Partner_PSS_Sales_Cycle__c== '3-Foundation Services Readiness'){
        psd.PSS_Sales_FSR_Created_Date__c=system.now();
        }
        if(psd.Partner_PSS_Sales_Cycle__c=='4-Smart'){
        psd.PSS_Sales_Smart_Created_Date__c= system.now();
        }
        if (psd.Partner_PSS_Sales_Cycle__c=='5-Pilots'){
        psd.PSS_Sales_Pilots_Created_Date__c=system.now();
        }
        if(psd.Partner_PSS_Sales_Cycle__c=='6-Deployment'){
        psd.PSS_Sales_Deployment_Created_Date__c=system.now();
        }
        if(psd.Partner_Customer_Deployment_Stage_Custom__c=='1-Crawl'){
        psd.PSS_Sales_Crawl_Created_Date__c=system.now();
        }
        if(psd.Partner_Customer_Deployment_Stage_Custom__c=='2-Walk'){
        psd.PSS_Sales_Walk_Created_Date__c=system.now();
        }
        if(psd.Partner_Customer_Deployment_Stage_Custom__c=='3-Run'){
        psd.PSS_Sales_Run_Created_Date__c=system.now();
        }
        if(psd.Partner_Customer_Deployment_Stage_Custom__c=='4-Sprint'){
        psd.PSS_Sales_Sprint_Created_Date__c=system.now();
        }        
    }
 }
if(trigger.isUpdate){
    for(integer i=0;i<Trigger.new.size();i++)
    {
        if(Trigger.new[i].Partner_PSS_Sales_Cycle__c != Trigger.old[i].Partner_PSS_Sales_Cycle__c
            && Trigger.new[i].Partner_PSS_Sales_Cycle__c == '1-Qualification'){
            Trigger.new[i].PSS_Sales_Qualification_Created_Date__c = system.now();
            Trigger.new[i].PSS_Sales_Qualification_End_Date__c = null;            
        }        
        if(Trigger.old[i].Partner_PSS_Sales_Cycle__c == '1-Qualification' 
            && Trigger.new[i].Partner_PSS_Sales_Cycle__c != '1-Qualification'){
            Trigger.new[i].PSS_Sales_Qualification_End_Date__c = system.now();
        }        

        if(Trigger.new[i].Partner_PSS_Sales_Cycle__c != Trigger.old[i].Partner_PSS_Sales_Cycle__c
            && Trigger.new[i].Partner_PSS_Sales_Cycle__c=='2-Awareness'){
            Trigger.new[i].PSS_Sales_Awareness_Created_Date__c = system.now();
            Trigger.new[i].PSS_Sales_Awareness_End_Date__c = null;
        }
        if(Trigger.old[i].Partner_PSS_Sales_Cycle__c == '2-Awareness' 
            && Trigger.new[i].Partner_PSS_Sales_Cycle__c != '2-Awareness'){
            Trigger.new[i].PSS_Sales_Awareness_End_Date__c = system.now();
        }
        
        if(Trigger.new[i].Partner_PSS_Sales_Cycle__c != Trigger.old[i].Partner_PSS_Sales_Cycle__c
            && Trigger.new[i].Partner_PSS_Sales_Cycle__c== '3-Foundation Services Readiness'){
            Trigger.new[i].PSS_Sales_FSR_Created_Date__c=system.now();
            Trigger.new[i].PSS_Sales_FSR_End_Date__c = null;
        }
        if(Trigger.old[i].Partner_PSS_Sales_Cycle__c == '3-Foundation Services Readiness' 
            && Trigger.new[i].Partner_PSS_Sales_Cycle__c != '3-Foundation Services Readiness'){
            Trigger.new[i].PSS_Sales_FSR_End_Date__c = system.now();
        }
        
        if(Trigger.new[i].Partner_PSS_Sales_Cycle__c != Trigger.old[i].Partner_PSS_Sales_Cycle__c 
            && Trigger.new[i].Partner_PSS_Sales_Cycle__c=='4-Smart'){
            Trigger.new[i].PSS_Sales_Smart_Created_Date__c = system.now();
            Trigger.new[i].PSS_Sales_Smart_End_Date__c = null;
        }
        if(Trigger.old[i].Partner_PSS_Sales_Cycle__c == '4-Smart' 
            && Trigger.new[i].Partner_PSS_Sales_Cycle__c != '4-Smart'){
            Trigger.new[i].PSS_Sales_Smart_End_Date__c = system.now();
        }
        
        if(Trigger.new[i].Partner_PSS_Sales_Cycle__c != Trigger.old[i].Partner_PSS_Sales_Cycle__c
            && Trigger.new[i].Partner_PSS_Sales_Cycle__c=='5-Pilots'){
            Trigger.new[i].PSS_Sales_Pilots_Created_Date__c = system.now();
            Trigger.new[i].PSS_Sales_Pilots_End_Date__c = null;
        }
        if(Trigger.old[i].Partner_PSS_Sales_Cycle__c == '5-Pilots' 
            && Trigger.new[i].Partner_PSS_Sales_Cycle__c != '5-Pilots'){
            Trigger.new[i].PSS_Sales_Pilots_End_Date__c = system.now();
        }
        
        if(Trigger.new[i].Partner_PSS_Sales_Cycle__c != Trigger.old[i].Partner_PSS_Sales_Cycle__c
            && Trigger.new[i].Partner_PSS_Sales_Cycle__c == '6-Deployment'){
            Trigger.new[i].PSS_Sales_Deployment_Created_Date__c = system.now();
            Trigger.new[i].PSS_Sales_Deployment_End_Date__c = null;
        }
        if(Trigger.old[i].Partner_PSS_Sales_Cycle__c == '6-Deployment' 
            && Trigger.new[i].Partner_PSS_Sales_Cycle__c != '6-Deployment'){
            Trigger.new[i].PSS_Sales_Deployment_End_Date__c = system.now();
        }
        
        if(Trigger.new[i].Partner_Customer_Deployment_Stage_Custom__c != Trigger.old[i].Partner_Customer_Deployment_Stage_Custom__c
            && Trigger.new[i].Partner_Customer_Deployment_Stage_Custom__c == '1-Crawl'){
            Trigger.new[i].PSS_Sales_Crawl_Created_Date__c = system.now();
            Trigger.new[i].PSS_Sales_Crawl_End_Date__c = null;
        }
        if(Trigger.old[i].Partner_Customer_Deployment_Stage_Custom__c == '1-Crawl' 
            && Trigger.new[i].Partner_Customer_Deployment_Stage_Custom__c != '1-Crawl'){
            Trigger.new[i].PSS_Sales_Crawl_End_Date__c = system.now();
        }

        if(Trigger.new[i].Partner_Customer_Deployment_Stage_Custom__c != Trigger.old[i].Partner_Customer_Deployment_Stage_Custom__c
            && Trigger.new[i].Partner_Customer_Deployment_Stage_Custom__c == '2-Walk'){
            Trigger.new[i].PSS_Sales_Walk_Created_Date__c = system.now();
            Trigger.new[i].PSS_Sales_Walk_End_Date__c = null;
        }
        if(Trigger.old[i].Partner_Customer_Deployment_Stage_Custom__c == '2-Walk' 
            && Trigger.new[i].Partner_Customer_Deployment_Stage_Custom__c != '2-Walk'){
            Trigger.new[i].PSS_Sales_Walk_End_Date__c = system.now();
        }
        
        if(Trigger.new[i].Partner_Customer_Deployment_Stage_Custom__c != Trigger.old[i].Partner_Customer_Deployment_Stage_Custom__c
            && Trigger.new[i].Partner_Customer_Deployment_Stage_Custom__c == '3-Run'){
            Trigger.new[i].PSS_Sales_Run_Created_Date__c = system.now();
            Trigger.new[i].PSS_Sales_Run_End_Date__c = null;
        }
        if(Trigger.old[i].Partner_Customer_Deployment_Stage_Custom__c == '3-Run' 
            && Trigger.new[i].Partner_Customer_Deployment_Stage_Custom__c != '3-Run'){
            Trigger.new[i].PSS_Sales_Run_End_Date__c = system.now();
        }
        
        if(Trigger.new[i].Partner_Customer_Deployment_Stage_Custom__c != Trigger.old[i].Partner_Customer_Deployment_Stage_Custom__c
            && Trigger.new[i].Partner_Customer_Deployment_Stage_Custom__c == '4-Sprint'){
            Trigger.new[i].PSS_Sales_Sprint_Created_Date__c = system.now();
            Trigger.new[i].PSS_Sales_Sprint_End_Date__c = null;
        }

        if(Trigger.old[i].Partner_Customer_Deployment_Stage_Custom__c == '4-Sprint' 
            && Trigger.new[i].Partner_Customer_Deployment_Stage_Custom__c != '4-Sprint'){

            Trigger.new[i].PSS_Sales_Sprint_End_Date__c = system.now();
        }       
    }
} 

}