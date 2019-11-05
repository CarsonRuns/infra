trigger LeadBeforeDelete on Lead(before delete) 
{   
     DelOppAccLead dopAcc = new DelOppAccLead();
     dopAcc.beforeLeds(trigger.old);
}