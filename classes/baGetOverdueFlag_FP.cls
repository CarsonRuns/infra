global class baGetOverdueFlag_FP {

webservice static string getOverdueflag (string terrID,date fp_start_date)
{
 String flag='NOOVERDUE';
 
 system.debug('terrID is :   '+terrID+'   ,fp_start_date  : '+ fp_start_date+' fp_start_date-30 is : '+(fp_start_date-30)+' fp_start_date-14 : '+(fp_start_date-14)   );

 AT_WORKSPACE__C[] opty = [select          
                        id        
                from AT_WORKSPACE__C a
                where a.PSS_Workspace_Status__c = 'Active'
                and   a.Opportunity__r.DealID__c  <> null    and a.Opportunity__r.StageName <>'1 - Prospect'  and a.AT_Forecast_Status__c <> 'Not Forecastable' and a.Forecast_Position_ID__c <>null and  a.Forecast_Position_ID__c <>'0'
                and   (a.Forecast_Position_ID__c = :terrID or a.PSS__r.Username = :terrID)
                and a.AT_Expected_Book_Date__c>=:fp_start_date-30 and a.AT_Expected_Book_Date__c<=:fp_start_date-14 limit 1
                ];

 if(opty.size() > 0)
    flag = 'OVERDUE_LT30';
 //return opty;
        AT_WORKSPACE__C[] opty1 = [select
                                id
                                from AT_WORKSPACE__C a
                where a.PSS_Workspace_Status__c = 'Active'
                and   a.Opportunity__r.DealID__c  <> null    and a.Opportunity__r.StageName <>'1 - Prospect'  and a.AT_Forecast_Status__c <> 'Not Forecastable' and a.Forecast_Position_ID__c <>null and a.Forecast_Position_ID__c <>'0'
                                and (a.Forecast_Position_ID__c = :terrID or a.PSS__r.Username = :terrID)
                               and a.AT_Expected_Book_Date__c<:fp_start_date-30 limit 1
                                ];
 if(opty1.size() > 0)
         flag = 'OVERDUE_GT30';
system.debug('flag is '+flag+'   fp_start_date-30  : '+ (fp_start_date-30) );
return  flag;
}
}