trigger Set_Account_STT_Assignment on STT_Acct_Owner__c(after delete, after insert, after update, after undelete) {

Account[] acctIds = new Account[]{};
Account[] acctToUpdate = new Account[]{};

// Looks at 'old' associated Accounts - before the transaction occured
if(Trigger.isDelete || Trigger.isUpdate) {
	
	//Get Account Ids from STT_Acct_Owner__c objects
	for(STT_Acct_Owner__c sca : System.Trigger.old) {
		Account tempACCT = new Account(id=sca.Account__c);
		acctIds.add(tempACCT);
	}
	
	//Get a Map of Account objects
	Map<Id, Account> oldAccts = new Map<Id, Account>([select Id, STT__c from Account where Id IN :acctIds]);
	
	//Remove Accounts with related STT_Acct_Owner__c objects
	for(STT_Acct_Owner__c newSCA: [select s.Id, s.Account__c from STT_Acct_Owner__c s where s.Account__c IN :acctIds]){ 
		oldAccts.remove(newSCA.Account__c);			
	}
	
	//Convert Map to Set so we can iterate through the list
	Set<Id> oa = oldAccts.keySet();
	
	//Set STT to false on these Accounts
	for(Id a1:oa){
		Account tempACCT = new Account(id=a1);
		tempACCT.STT__c = false;
		acctToUpdate.add(tempACCT);
	} 
	acctIds.clear();
			
}

// Looks at 'new' associated Accounts - after the transaction occured
if(!Trigger.isDelete){	

	//Get Account Ids from STT_Acct_Owner__c objects
	for(STT_Acct_Owner__c sca : System.Trigger.new) {
		Account tempACCT = new Account(id=sca.Account__c);
		acctIds.add(tempACCT);
	}
	
	//Get the Account objects
	Account[] accts = [select a.Id, a.STT__c from Account a where a.Id IN :acctIds];

	//If they are set to false, set them to true
	for(Account a:accts) {
		if(a.STT__c == false){
			a.STT__c = true;
			acctToUpdate.add(a);
		}	
	}
}

update acctToUpdate;

}