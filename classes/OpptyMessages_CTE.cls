public class OpptyMessages_CTE {

    Opportunity oppty;
    
    String overdueMsg;
    
    String isMessages;
    @TestVisible
    Boolean isOverdue = false;
    @TestVisible
    Boolean isError = false;
    
    
    public OpptyMessages_CTE(ApexPages.StandardController controller) {
        this.oppty = (Opportunity)controller.getRecord();
        system.debug('No_of_days_Overdue__c '+oppty.No_of_days_Overdue__c );
        system.debug('currentDate'+oppty.CloseDate);
        if(oppty.No_of_days_Overdue__c > 30 && oppty.DealID__c != '' && oppty.StageName != '1 - Prospect' && oppty.Opportunity_Status__c == 'Active'){ 
            if(checkTerritory()){ 
                overdueMsg = '- Forecasting has been locked out because this opportunity is more than 30 days overdue. Please update the Expected Book Date to a future date or set the Status to Booked, Cancelled, or Lost';
                isOverdue = true;
            }
        }
        else if(oppty.No_of_days_Overdue__c >= 14 && oppty.DealID__c != '' && oppty.StageName != '1 - Prospect' && oppty.Opportunity_Status__c == 'Active'){ 
            if(checkTerritory()){ 
                overdueMsg = '- Please update the Expected Book Date to a future date or set the Status to Booked, Cancelled, or Lost';
                isOverdue = true;
            }
        }
        if(oppty.error_description__c != null && oppty.error_description__c != 'Your opportunity was updated.' && oppty.error_description__c != 'Your opportunity was updated' && oppty.error_description__c != 'Inserted Successfully')
            isError = true;
         
    }
    public boolean checkTerritory(){
        UserTerritory2Association[] territory2Id = [Select Id From UserTerritory2Association where UserId = :UserInfo.getUserId() and IsActive = true and Territory2Id = :oppty.Territory2Id]; 
        Integer idSize = territory2Id.size();
        System.debug('Territory2IdSize'+idSize);
        return territory2Id.size()>0? true:false;
        /*if(territory2Id.size()>0)
            return true;
        else
           return false;    */
    
    }
    
    public String getOverdueMsg(){
        return overdueMsg;
    }
    
    public String getIsMessages(){
        if(isOverdue || isError)
             return '1';
        else    
             return '0';       
    }
    
    
}