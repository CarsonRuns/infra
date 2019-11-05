global Class OpptyPartnerUpdate{

    private static boolean opptyPartnerUpdated = false;

    public static void setOpptyPartnerUpdated(boolean status){
        opptyPartnerUpdated = status;
    }
    
    public static boolean getOpptyPartnerUpdated(){
        return opptyPartnerUpdated;
    }
    
        static testMethod void test_PartnerUpdateTrigger() {
        Account[] accts = new Account[]{};
        Opportunity[] opptys = new Opportunity[]{};
        Account a = new Account( Name='SCRUM');
        accts.add(a);
    
        for(Integer i = 0; i < 5; i++){ 
            Account p = new Account( Name='Partner', RecordTypeId='0123000000004aV' );
            accts.add(p);       
        }
        insert accts;
        
        Opportunity o = new Opportunity(name='sprint2',AccountId=a.id,CloseDate=Date.newInstance(2008,10,13),stageName='Open',Forecast_Discount__c=0.0,Primary_Partner__c = accts[1].Id,Partner_2__c=accts[2].Id,Partner_3__c=accts[3].Id,Partner_4__c=accts[4].Id,Partner_5__c=accts[5].Id ); 
        Opportunity o2 = new Opportunity(name='sprint3',AccountId=a.id,CloseDate=Date.newInstance(2008,10,13),stageName='Open',Forecast_Discount__c=0.0,Primary_Partner__c = accts[1].Id,Partner_2__c=accts[2].Id,Partner_3__c=accts[3].Id,Partner_4__c=accts[4].Id,Partner_5__c=accts[5].Id ); 
        Opportunity o3 = new Opportunity(name='sprint4',AccountId=a.id,CloseDate=Date.newInstance(2008,10,13),stageName='Open',Forecast_Discount__c=0.0,Primary_Partner__c = accts[1].Id,Partner_2__c=accts[2].Id,Partner_3__c=accts[3].Id,Partner_4__c=accts[4].Id,Partner_5__c=accts[5].Id ); 
        
        opptys.add(o);
        opptys.add(o2);
        opptys.add(o3);              
        
        insert opptys;
         
        //Opportunity o3 = new Opportunity(Id=o2.Id, Primary_Partner__c = accts[5].Id,Partner_2__c=accts[4].Id,Partner_3__c=null,Partner_4__c=accts[2].Id,Partner_5__c=accts[1].Id );
       
        o.Primary_Partner__c = accts[5].Id;
        o.Partner_2__c=accts[4].Id;
        o.Partner_3__c=accts[2].Id;
        o.Partner_4__c=accts[3].Id;
        o.Partner_5__c=accts[1].Id;
        
 
        o2.Primary_Partner__c = null;
        o2.Partner_2__c= null;
        o2.Partner_3__c= null;
        o2.Partner_4__c= null;
        o2.Partner_5__c= null;
        
           
        o3.Primary_Partner_Role__c = 'Partner';
        o3.Role_2__c= 'Partner';
        o3.Role_3__c= 'Partner';
        o3.Role_4__c= 'Partner';
        o3.Role_5__c= 'Partner';
        
        OpptyPartnerUpdate.setOpptyPartnerUpdated(false);
        update opptys;
     
     
     
    }

}