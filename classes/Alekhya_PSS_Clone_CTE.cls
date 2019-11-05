/**
// Added Workspace_Partner, AT_Competitor & Win Loss Comments as part of WR-01104 & WR-01105 respectively.
* @release -Feb 2016 (WR-01432)
* @author -kikamara.
* @description - Added Expiration Start Date, Service Term & Source to the Clone functionality.

* @release - May 2016 (WR-0034)
* @author - bdabbara.
* @description - Added Model, Partner, Disti and Tech Specialist to Workspace Clone.
*/

public class Alekhya_PSS_Clone_CTE {
// SCAVA Helper Method to validate Create Access at field level
     public static Boolean flsGet(SObjectField field)
    {
        return field.getDescribe().isCreateable() ? true : false;
    }
// This class is for PSS workspace
    public Alekhya_PSS_Clone_CTE(ApexPages.StandardController controller) {   }

    public PageReference clonethis(){
        if(AT_Workspace__c.Sobjecttype.getDescribe().isCreateable()){
            Final String oid = System.currentPageReference().getParameters().get('id');
            //WR-01432 - Added Expiration Start, Service Term & Source to Query.
            AT_Workspace__c current = [Select Name, Opportunity__c, Forecast_Position_ID__c, PSS__c, AT_Expected_Book_Date__c, AT_Expected_Product__c, AT_Expected_Service__c, 
                                    AT_Forecast_Status__c, AT_Flags__c, AT_Optional_1__c, AT_Optional_2__c,  AT_Comments__c, AT_Technology__c, AT_Sub_Technology__c, 
                                    AT_Team__c, AT_Product__c, PSS_Workspace_Status__c,Additional_Use_Case_Info__c,Business_Driver__c,Solution_Offer__c,Application__c,
                                    Opportunity_Source__c, Workspace_Service_Source__c, Workspace_Stage__c, Workspace_Lost_Cancelled_Reason__c, Workspace_Contract_Start_Date__c,
                                    Workspace_Contract_Expiration_Date__c, Is_Multi_Tech__c, Workspace_Partner__c, AT_Competitor__c, Workspace_Win_Loss_Comments__c  , Service_Term__c , Referenceable_Account__c,Software_Buying_Model__c from AT_Workspace__c Where id=:oid];
            
            AT_Workspace__c cloned = current.clone(false,true);
        
        
            Insert cloned;
        
        
            if(current.Is_Multi_Tech__c && Workspace_Technology__c.SObjectType.getDescribe().isCreateable()){
                List< Workspace_Technology__c > wts = [Select Name, Id, Expected_000__c, Business_Entity__c, Comments__c, 
                    Workspace__c, Product_Family__c, Service_Source__c, Business_Sub_Entity__c, Model__c, Partner__c, Distibutor__c, Technology_Specialist__c
                    FROM Workspace_Technology__c WHERE Workspace__c =: current.id];   

                List< Workspace_Technology__c > wtsCloned = wts.deepClone(false);

                List< Workspace_Technology__c > wtsUpdated = new List< Workspace_Technology__c > ();

                
                for(Workspace_Technology__c wksp : wtsCloned) {
                    
                    //SCAVA FIX
                        if(flsGet(Workspace_Technology__c.Workspace__c))
                        {
                            wksp.Workspace__c = cloned.Id;
                            }
                        
                    //SCAVA FIX
                    wtsUpdated.add(wksp);
                        
                    
                }
                
                insert wtsUpdated;
            }
        
            PageReference pageRef = new PageReference('/' + cloned.id + '/e');
            pageRef.setRedirect(true);
            return pageRef;
        }

        return null;    
    } 
}