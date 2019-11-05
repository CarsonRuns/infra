global class LeadScoreNightlyRefresh implements Database.Batchable < sObject > {
    
    global Date CurrDate = Date.today();
    global  String Run_mode;
    global final String g_strQuery = 'select id, Lead_Prioritization_Score__c  from lead '+'where lead_record_type_name__c in (\'eLeads\', \'Manual\') and (status = \'1 Waiting\' OR (status = \'2 Accepted-Mine/Channel\' AND isconverted = false))';
    fiscalyearsettings FiscalYear = [select name, startdate, enddate from fiscalyearsettings where  Startdate <= :CurrDate  and Enddate >= :CurrDate] ; 
    String Countrylist = '\'A';
    String strQuery;
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String restStrQuery = '';
        List <Lead_Prioritization_Model__c> model = [select ID, theatre__c,sub_region__c,lastmodifieddate from lead_prioritization_model__C 
                                                     where  lastmodifieddate >= :CurrDate]; 
        
        if (model.size()>0)
        {
            List <LPRegionMapping__c> RegionMap = [select region__c,Sub_Region__c, Country__c  from LPRegionMapping__c ];
            
            for(Lead_Prioritization_Model__c m: model)
            {
                if (m.sub_region__c != 'ALL')
                {
                    for (LPRegionMapping__c a: [select region__c,Sub_Region__c, Country__c  from LPRegionMapping__c  
                                                where region__c = :m.Theatre__c and sub_region__c = :m.Sub_Region__C])
                    {
                        
                        if (a.country__c != null) //
                            Countrylist +=  '\',\''+  a.Country__c  ;    
                        
                    }
                }
                
                if (m.Sub_Region__c == 'ALL')
                {
                    for (LPRegionMapping__c a: [select region__c,Sub_Region__c, Country__c  from LPRegionMapping__c  
                                                where region__c = :m.Theatre__c ])
                    {
                        
                        if (a.country__c != null ) 
                            Countrylist +=  '\',\''+  a.Country__c  ;    
                        
                    } 
                    
                }
                
                
            }
            countrylist += '\'';
            system.debug('Country List'+ countrylist);
            Datetime t1 = FiscalYear.StartDate;
            Datetime t2 = FiscalYear.EndDate;
            
            Datetime t5 = CurrDate;
            String fromstr1 = t1.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
            String tostr1 = t2.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
            
            String currD = t5.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
            
            restStrQuery = '  and ((customcountry__c in ( '+ countrylist +') and CreatedDate >= '
                +fromstr1+' and CreatedDate <= ' + tostr1 +' ) OR CreatedDate >= '+ currD +')';
            
            
        }
        else {
            
            Datetime t5 = CurrDate;
            String currD = t5.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
            restStrQuery = ' and CreatedDate >= '+ currD ;
            
        }
        
        if (Test.isRunningTest())
        {
            Datetime t5 = CurrDate;
            String currD = t5.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
            restStrQuery = ' and lastmodifieddate >= '+ currD + ' LIMIT 5';
            
            
            
        }
        
        strQuery = g_strQuery + restStrQuery;
        
        return Database.getQueryLocator(strQuery);
    }
    
    
    global void execute(Database.BatchableContext BC, List < sObject > scope) {
        LPExtension obj1 = new LPExtension();
        List < Lead > lstLeadToUpdate = new List < Lead > ();   
        Map<String, Integer> scoremap = obj1.Calcscore((List <Lead> ) scope);
        
        for (Lead l: (List < Lead > ) scope) {  
            if (l.id !=null)
            {
                
                if (scoremap.containsKey(l.Id) == true)
                {
                    
                    l.Lead_Prioritization_Score__c = Double.valueOf(scoremap.get(l.Id)); 
                     
                    lstLeadToUpdate.add(l);
                }
                else
                {
                    l.Lead_Prioritization_Score__c = 0;
                      
                    lstLeadToUpdate.add(l);
                    
                }
                
            }
        }
        Database.SaveResult[] SaveResult = Database.update(lstLeadToUpdate, false);
        
        
        //Iterating over the save result and validating if any error occurred
        Integer iRows = 0;
        List < Tx_Log__c > lstLog = new List < Tx_Log__c > ();
        for (Database.SaveResult dsr: SaveResult) {
            Tx_Log__c newErrorRecord = new Tx_Log__c(name = lstLeadToUpdate[iRows].id, originated__c = 'Lead Prioritization Nightly Refresh', type__c = 'Lead', exception__c = true);
            if (dsr.isSuccess() != true) {
                if (dsr.getErrors().size() > 0) {
                    newErrorRecord.message__c = 'STATUS CODE: ' + dsr.getErrors()[0].getStatusCode() +
                        '\n ERROR: ' + dsr.getErrors()[0].getMessage() +
                        '\n AFFECTED FIELD: ' + dsr.getErrors()[0].getFields();
                }
                lstLog.add(newErrorRecord);
            }
            iRows++;
        }
        if (lstLog.size() > 0)
            Database.insert(lstLog, false);
        
    }
    global void finish(Database.BatchableContext BC) {
        
        AsyncApexJob aObj = [SELECT Id, Status, JobItemsProcessed, TotalJobItems, NumberOfErrors
                             FROM AsyncApexJob WHERE ID = : BC.getJobId()
                            ];
        
        String EmailToNotify = 'lead_prioritization_nightly_refresh_updates@cisco.com';
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {
            EmailToNotify
                };
                    mail.setToAddresses(toAddresses);
        mail.setSubject('Lead Score Batch Processing - ' + System.Today());
        String MailBody = 'Status : ' + aObj.Status + '<br/>';
        MailBody = MailBody + 'Total Batches : ' + aObj.TotalJobItems + '<br/>';
        MailBody = MailBody + 'Total Batches Procesed : ' + aObj.JobItemsProcessed + '<br/>';
        MailBody = MailBody + 'Failed Batches : ' + aObj.NumberOfErrors + '<br/>';
        mail.setHtmlBody(MailBody);
        
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {
            mail
                });
    }
}