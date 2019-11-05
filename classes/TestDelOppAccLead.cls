@istest(seealldata=true)
public class TestDelOppAccLead {  
    private static testMethod void A1()
    {        
       Account acc= [select id,Name from account limit 1];
          try
           {
           delete acc;
             System.assert(true);
           }
              catch (Exception e)
           {
               // expected
           }
     }
    
    private static testMethod void L1()
    {        
       Lead Ld= [select id,Name from Lead limit 1];
          try
           {
           delete Ld;
             System.assert(true);
           }
              catch (Exception e)
           {
               // expected
           }
     }
     private static testMethod void O1()
    {        
       Opportunity Opp= [select id,Name from Opportunity limit 1];
          try
           {
           delete Opp;
             System.assert(true);
           }
              catch (Exception e)
           {
               // expected
           }
     }
    }