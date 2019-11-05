@isTest
public with sharing class NGCC_Rule_Assignment_Trg_Test {
	static testMethod void SingleItemTest(){
		CC_Master_Question_Answer_Bank__c ccMaster = new CC_Master_Question_Answer_Bank__c(name='M');
        insert ccMaster;
        
        
		list<NGCC_Rule_Assignment__c> rules = new list<NGCC_Rule_Assignment__c>();
        rules.add(new NGCC_Rule_Assignment__c(MODS_Leads__c='Lead Attribute',Countries__c='UK;US',Lead_Attribute__c='lastName',Priority__c='1',Rank__c='1',Theater__c='APJXC',Value__c='m1,m', Active__c= true));
        rules.add(new NGCC_Rule_Assignment__c(MODS_Q_A__c=ccMaster.id,MODS_Leads__c='MODS Q/A',Countries__c='India;US',Priority__c='2',Rank__c='2',Theater__c='APJXC',Value__c='m1,m',Active__c= true));
        rules.add(new NGCC_Rule_Assignment__c(MODS_Q_A__c=ccMaster.id,MODS_Leads__c='MODS Q/A',Countries__c='India;US',Priority__c='2',Rank__c='2',Theater__c='APJXC',Value__c='m1,m',Active__c= false));
        rules.add(new NGCC_Rule_Assignment__c(MODS_Q_A__c=ccMaster.id,MODS_Leads__c='MODS Q/A',Countries__c='India;US',Priority__c='4-N/A',Rank__c='3',Theater__c='APJ',Value__c='m1,m', Active__c= true));
        rules.add(new NGCC_Rule_Assignment__c(MODS_Q_A__c=ccMaster.id,MODS_Leads__c='MODS Q/A',Countries__c='India;US',Priority__c='4-N/A',Rank__c='3',Theater__c='APJ',Value__c='m1,m', Active__c= true));
        insert rules;
        
        list<NGCC_Rule_Assignment__c> rules2 = new list<NGCC_Rule_Assignment__c>();
        rules2.add(new NGCC_Rule_Assignment__c(MODS_Leads__c='Lead Attribute',Countries__c='UK;US',Lead_Attribute__c='lastName',Priority__c='1',Rank__c='1',Theater__c='APJXC',Value__c='m1,m', Active__c= true));
        rules2.add(new NGCC_Rule_Assignment__c(MODS_Q_A__c=ccMaster.id,MODS_Leads__c='MODS Q/A',Countries__c='India;US',Priority__c='2',Rank__c='2',Theater__c='APJXC',Value__c='m1,m',Active__c= true));
        rules2.add(new NGCC_Rule_Assignment__c(MODS_Q_A__c=ccMaster.id,MODS_Leads__c='MODS Q/A',Countries__c='India;US',Priority__c='2',Rank__c='2',Theater__c='APJXC',Value__c='m1,m',Active__c= false));
        rules2.add(new NGCC_Rule_Assignment__c(MODS_Q_A__c=ccMaster.id,MODS_Leads__c='MODS Q/A',Countries__c='India;US',Priority__c='4-N/A',Rank__c='3',Theater__c='APJ',Value__c='m1,m', Active__c= true));
        rules2.add(new NGCC_Rule_Assignment__c(MODS_Q_A__c=ccMaster.id,MODS_Leads__c='MODS Q/A',Countries__c='India;US',Priority__c='4-N/A',Rank__c='3',Theater__c='APJ',Value__c='m1,m', Active__c= true));
        insert rules2;
        
        rules[0].Priority__c='2';
        update rules2;
        
        
        /*
        list<NGCC_Rule_Assignment__c> rules2 = new list<NGCC_Rule_Assignment__c>();
        rules2.add(new NGCC_Rule_Assignment__c(MODS_Leads__c='Lead Attribute',Countries__c='UK;US',Lead_Attribute__c='lastName',Priority__c='1',Rank__c='1',Theater__c='APJXC',Value__c='m1,m', Active__c= true));
        rules2.add(rules[0]);
        rules2.add(rules[2]);
        
        
        rules2[1].Priority__c='2';
        upsert rules2;
        */
	
	}
}