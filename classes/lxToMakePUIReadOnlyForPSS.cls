/**************************************
Author          : Kavya 
Release         : Mar Release version 1
Created         : Feb 22,2019
Functionality   : PSS - Edit Oppty fields except $, Book Date and Stage, Technology/Service line items
(Set Flag Value if user is PSS/Vss)
Modification History:
Itrack#        Date             Author                      Change  
****************************************************************************
US250307     Feb 27 ,2019  Kavya                          Initial Draft(Set Flag Value if user is PSS/Vss)

**********************************************/
public class lxToMakePUIReadOnlyForPSS {
    public Boolean isPSSEditable {get;set;}
    String opptyId = ApexPages.currentPage().getParameters().get('id');
    
    public lxToMakePUIReadOnlyForPSS(ApexPages.StandardController controller) { 
        Opportunity opp = new Opportunity();
        Boolean isStageCheck=false;
        String value = 'noError';
        Map<id,Opportunity> mapOpp = new Map<id,Opportunity>();
        
        /*'Add Technology & Service' from Opportunity record detail page, opptyId is passed as parameter from url */
        
        if (String.isNotBlank(opptyId)){   
            
            //to fetch the Opportunity Id if PUI page is opened from delete button 
            String objectName =String.valueOf(Id.valueOf(opptyId).getSobjectType());
            
            if(objectName.equalsIgnoreCase('Opportunity')){
                opp.Id = opptyId;
            }
            if(objectName.equalsIgnoreCase('OpportunityLineItem')){
            	OpportunityLineItem oppLineItem = [SELECT OpportunityId FROM OpportunityLineItem WHERE Id=:opptyId];
                opp.Id = oppLineItem.OpportunityId;
            }
        }
       
        List<Opportunity> optyListForUpdateCheck = [SELECT Id,StageName FROM Opportunity WHERE id= :opp.Id];
        //call method to check pss/vss user
        value = lxPilotUserCheck.CheckBeforeUpdate(mapOpp,optyListForUpdateCheck,'lines');
        
        for(Opportunity oppt:optyListForUpdateCheck){
            if(oppt.StageName.contains('3') || oppt.StageName.contains('4') || oppt.StageName.contains('5')){
                isStageCheck = true;
            }
        }
        //If the user is PSS/VSS and tagged to opportunity and in stage 3/4/5
        //If the user is PSS/VSS and not tagged to opportunity and in stage 1/2/3/4/5(value=='UserError')
        if((value=='error' && isStageCheck) || value=='UserError'){
            isPSSEditable = true;
        }
        else {
            isPSSEditable = false;
        }
        
       /* if(isPSSEditable==true) {
            ApexPages.Message pilotError = new ApexPages.Message(ApexPages.Severity.ERROR,'Line editing is only allowed by the line Specialist.');
            ApexPages.addMessage(pilotError);
        }*/
    }
}