trigger NGCC_Assignment_Rule_Update on Campaign (after update, after insert, before delete) {

    List<CC_Assignment_Ruleset_Program_Event__c> assignment_list;
    List<Campaign> campaigns;
    
    if(trigger.isUpdate){
        Integer updatecount=0;
        for(Campaign c: trigger.old){
            if(trigger.newMap.get(c.id).Program_Originating_Country__c != c.Program_Originating_Country__c){
                updatecount++;
            }
            if(trigger.newMap.get(c.id).Outbound_Call_Center__c != c.Outbound_Call_Center__c){
                updatecount++;
            }
        }
        if(updatecount==0){
            return;
        }
    }
    
    
    //delete old ones for update and delete
    if(trigger.isUpdate || trigger.isDelete){
        assignment_list = [select id from CC_Assignment_Ruleset_Program_Event__c where Campaign__c in :trigger.old];
        delete assignment_list;
    }
    
    //insert new ones for update and insert
    if(trigger.isUpdate || trigger.isInsert){
        
        assignment_list = new List<CC_Assignment_Ruleset_Program_Event__c>();
        campaigns = trigger.new;
        
        String countries_str = '';
        String cc_name_str = '';
        //generate the list of call centers and originating countries
        for(Campaign c : campaigns){
            
            if(String.isNotBlank(c.Outbound_Call_Center__c)){
                cc_name_str = cc_name_str +'\'' + c.Outbound_Call_Center__c + '\',';
            }
            else if(String.isNotBlank(c.Program_Originating_Country__c)){
                countries_str = countries_str + '\'' + String.escapeSingleQuotes(c.Program_Originating_Country__c ) + '\',';
            }
        }
        if(countries_str.endswith(',')){
            countries_str = countries_str.substring(0, countries_str.length() - 1);
        }
        if(cc_name_str.endswith(',')){
            cc_name_str = cc_name_str.substring(0, cc_name_str.length() - 1);
        }
        String soql = 'select id, name, Country__c from CC_Call_Center_Country_Assignment__c ';
        String condition;
        //generate the dynamic query based on whether call center is set or originating country is set
        if(String.isNotBlank(cc_name_str) && String.isBlank(countries_str)){
            condition = 'where name in ('+ cc_name_str +')';
        }
        else if(String.isNotBlank(countries_str) && String.isBlank(cc_name_str)){
            condition = 'where Country__c includes ('+ countries_str +')';
        }      
        else if(String.isNotBlank(cc_name_str) && String.isNotBlank(countries_str)){
            condition = 'where name in ('+cc_name_str+') or Country__c includes ('+ countries_str +')';
        }
        else{
            return;
        }
        soql = soql + condition;
        system.debug('soql='+soql);
        
        List<CC_Call_Center_Country_Assignment__c> cc_countries = Database.query(soql);
        
        //get the default rulesets for the call centers
        List<CC_Assignment_Ruleset__c> rulesets = [select id, Contact_Center__c, Contact_Center__r.name from CC_Assignment_Ruleset__c where isDefault__c = true and Contact_Center__c in :cc_countries];
        
        
        for(Campaign c: campaigns){
            for(CC_Call_Center_Country_Assignment__c cc_country: cc_countries){
                for(CC_Assignment_Ruleset__c ruleset : rulesets){
                    //system.debug('cc_country.Country__c='+cc_country.Country__c);
                    //system.debug('c.Program_Originating_Country__c='+c.Program_Originating_Country__c);
                    //system.debug('cc_country.name='+cc_country.name);
                    //system.debug('ruleset.Contact_Center__c='+ruleset.Contact_Center__c);
                    //system.debug('condition='+(cc_country.Country__c.contains(c.Program_Originating_Country__c) && (cc_country.name == ruleset.Contact_Center__r.name)));
                    
                    //if the campaign orginating country is in the list of contact center assigned countries, then add the default ruleset for that call center to the campaign
                    if(String.isNotBlank(c.Program_Originating_Country__c)){
                        if(String.isNotBlank(cc_country.Country__c)){
                            //if((cc_country.Country__c.contains(c.Program_Originating_Country__c) || (cc_country.name == c.Outbound_Call_Center__c)) && (cc_country.name == ruleset.Contact_Center__r.name)){
                            //Changes made by dchamola
                            if((cc_country.Country__c.contains(c.Program_Originating_Country__c) || (cc_country.name == c.Outbound_Call_Center__c)) && (cc_country.id == ruleset.Contact_Center__r.id)){
                            //End of changes
                                CC_Assignment_Ruleset_Program_Event__c pe_ruleset = new CC_Assignment_Ruleset_Program_Event__c();
                                pe_ruleset.campaign__c = c.id;
                                pe_ruleset.CC_Assignment_Ruleset__c = ruleset.id;
                                assignment_list.add(pe_ruleset);
                            }
                        }
                    }
                    //if the campaign orginating country is blank, then add the default ruleset for campaign's specified outbound call center
                    else{
                        //if ((cc_country.name == c.Outbound_Call_Center__c) && (cc_country.name == ruleset.Contact_Center__r.name)){
                        //Changes made by dchamola
                        if ((cc_country.name == c.Outbound_Call_Center__c) && (cc_country.id == ruleset.Contact_Center__r.id)){
                        //End of changes
                            CC_Assignment_Ruleset_Program_Event__c pe_ruleset = new CC_Assignment_Ruleset_Program_Event__c();
                            pe_ruleset.campaign__c = c.id;
                            pe_ruleset.CC_Assignment_Ruleset__c = ruleset.id;
                            assignment_list.add(pe_ruleset);
                        }
                    } 
                }
            }
        }
        
        insert assignment_list;
    }
    
    
}