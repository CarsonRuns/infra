// ******* Change History ********
//  majanard - 03052015: Removed the after trigger logic.
// May-2014 WR-01055- lakshsur: Adding the method to update Fiscal Year & Quarter based on Expected Book Date
// ******* Change History ********

trigger BTxActivityUpdate on BTx_Engagement_Revenue__c (before insert, before update) {


Set<Id> BTxId = new Set<Id>();
List<BTx_Engagement_Activity__c> BTxActivity = new List<BTx_Engagement_Activity__c>();
Set<BTx_Engagement_Activity__c> BTxA = new Set<BTx_Engagement_Activity__c>();
List<BTx_Engagement_Activity__c> BTxEng = new List<BTx_Engagement_Activity__c>();
List<BTx_Engagement_Revenue__c> BTxSolution = new List<BTx_Engagement_Revenue__c>();
String soln = '';
Integer Count = 0;
String primarysol = '';

for(BTx_Engagement_Revenue__c Btx: Trigger.New)
BTxId.add(Btx.Engagement__c);
    


BTxSolution = [Select Id, Solution__c, Is_this_a_Primary_Solution__c, Comments__c, Engagement__c from BTx_Engagement_Revenue__c where Engagement__c in :BTxId];

//BTxActivity = [select Id, Solutions__c from BTx_Engagement_Activity__c where Id in : BTxId];


if(Trigger.Isbefore)
{
    if(BTxSolution.size()>0)
    {
     for(BTx_Engagement_Revenue__c btx : BTxSolution)
    {
        
        if(btx.Is_this_a_Primary_Solution__c == true){
        Count ++;
        primarysol = btx.Id;
        }
       
    }
    
    if(Count > 0 && Trigger.New[0].Is_this_a_Primary_Solution__c == true && primarysol != Trigger.New[0].Id)
    Trigger.New[0].addError('Primary Solution already exists for the current Project. Please uncheck the Primary Solution');
    
    }
    
} 

// WR-01055 - BTx Project/Activities with/without Revenue - FQ & FY MAY Release.
    if((Trigger.isBefore && Trigger.isInsert) || (Trigger.isBefore && Trigger.isUpdate)) {
        for(BTx_Engagement_Revenue__c Btx: Trigger.New){
            BTxId.add(Btx.Engagement__c);
            if(trigger.isBefore ){
                if(Btx.Expected_Book_Date__c != null){
                   Btx.Expected_Book_Date_Fiscal_Year__c = Utilities_FY.getFiscalYear(Btx.Expected_Book_Date__c) ;
                   Btx.Expected_Book_Date_Fiscal_Quarter__c = Utilities_FY.getFiscalQuerter(Btx.Expected_Book_Date__c) ;
                }
             }   
        }
    } 
}