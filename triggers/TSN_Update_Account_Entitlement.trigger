// This trigger update the TSN_Enrollment_Programs__c Account Field with associated TSN PartnerSpecialization Names present in Custom Setting

trigger TSN_Update_Account_Entitlement on Partner_Specialization__c (after insert, after update) {
TSN_Partner_Enrollment_Programs__c TSNPrograms = TSN_Partner_Enrollment_Programs__c.getValues('Enrollment Programs') ;
String programs = TSNPrograms.Partner_Programs__c ;

Set<String> setOfPrograms=new Set<String>();
String[] arrayOfPrograms;

if(programs != null)
   arrayOfPrograms=programs.split(',');  
   
for(String programName : arrayOfPrograms){  
   setOfPrograms.add(programName.trim().toLowerCase());
}

Set<Id> setOfPartnerCompanyAccountIds=new Set<Id>();

for (Partner_Specialization__c  psc  : Trigger.new) {
    if (setOfPrograms!= null){
          for(String programName:setOfPrograms){
             if(psc.Name.toLowerCase().contains(programName)){
                setOfPartnerCompanyAccountIds.add(psc.Partner_Company__c);  
           }
        }
    }
}

//creation of Map from Partner Company Account Id  To Partner Program Enrollment Name String
List<Partner_Specialization__c>  listOfPSC=null;
if(setOfPartnerCompanyAccountIds.size()>0){
 listOfPSC = [select id,Name,Partner_Company__c,Status__c from Partner_Specialization__c where Partner_Company__c in :setOfPartnerCompanyAccountIds limit 50000];
}
//creation of map which contains Partner Company Account Id as a key and its associated EntitledProgram String as a value.
Map<Id,Set<String>> mapOfPartnerCompanyAccountIdToPSCString = new Map<Id,Set<String>>();

if(listOfPSC!=null){
for(Partner_Specialization__c psc:listOfPSC) {
   if (setOfPrograms != null){
   
          for(String programName:setOfPrograms){
             if(psc.Name.toLowerCase().contains(programName) &&  psc.Status__c == 'Active'){
             Set<String> pscStringSet = mapOfPartnerCompanyAccountIdToPSCString.get(psc.Partner_Company__c);
             
     if(pscStringSet == null){
        pscStringSet =new Set<String>();
        pscStringSet.add(psc.name);
          
        mapOfPartnerCompanyAccountIdToPSCString.put(psc.Partner_Company__c,pscStringSet);
     }
     else
     {
      pscStringSet.add(psc.name);
      mapOfPartnerCompanyAccountIdToPSCString.put(psc.Partner_Company__c,pscStringSet);
     }  
//Following solution to enhance the trigger to update the Account for inactive partner specialization for INC000030091635.
      }else{
        
        if(psc.Name.toLowerCase().contains(programName) &&  psc.Status__c == 'Inactive'){
         Set<String> pscStringSet = mapOfPartnerCompanyAccountIdToPSCString.get(psc.Partner_Company__c);
         
     if(pscStringSet == null){
        pscStringSet =new Set<String>();
        pscStringSet.add('');
        
        mapOfPartnerCompanyAccountIdToPSCString.put(psc.Partner_Company__c,pscStringSet);
     }
     else
     {
      pscStringSet.add('');
      mapOfPartnerCompanyAccountIdToPSCString.put(psc.Partner_Company__c,pscStringSet);
     }
      
      }
      }
    }
   }
  }
}  
              
//Updation of Account TSN_Enrollment_Programs__c Field  whose Partner Company Account's Enrollment has changed  
if(setOfPartnerCompanyAccountIds.size()>0)  {
 List<Account> AccountList =[select id,TSN_Enrollment_Programs__c from Account where id in :setOfPartnerCompanyAccountIds];
 for(Account act:AccountList)
    {
      Set<String> psStringSet=mapOfPartnerCompanyAccountIdToPSCString.get(act.id);
      String psString='';
      for(String ps:psStringSet)
         {
          String comma= (psString=='') ? '' : ',' ;
          psString+=comma+ps;
         }
       act.TSN_Enrollment_Programs__c=psString;
    }
    
 try{
     update AccountList;
    }
 catch(Exception e){
    }  
  }  
}