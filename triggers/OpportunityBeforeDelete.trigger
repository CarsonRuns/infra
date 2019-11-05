trigger OpportunityBeforeDelete on Opportunity(before delete)
{   
     DelOppAccLead dopAcc = new DelOppAccLead();
     dopAcc.beforeOpptys(trigger.old);
}