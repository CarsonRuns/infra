global class fdaGetOverdueFlag_FP {

webservice static string getOverdueflag (string terrname,date fp_start_date)
{
 String flag='NOOVERDUE';
 String terrID;

 Territory2[] terr = [select id from territory2 where name = :terrName];
 
if(terr.size() > 0)
{    system.debug('inside territory loop');
     terrID = terr[0].id;

 Opportunity[] opty = [select          
                        id        
                from opportunity
                where opportunity_status__c = 'Active'
                and   dealid__c <> null and StageName  <>'1 - Prospect' 
                and   territory2id = :terrID
                and closedate>=:fp_start_date-30 and closedate<=:fp_start_date-14 limit 1
                ];

 if(opty.size() > 0)
    flag = 'OVERDUE_LT30';
 //return opty;
        Opportunity[] opty1 = [select
                                id
                                from opportunity
                                where opportunity_status__c = 'Active'
                                and   dealid__c <> null and StageName  <>'1 - Prospect' 
                                and   territory2id = :terrID
                                and closedate<:fp_start_date-30 limit 1
                                ];
 if(opty1.size() > 0)
         flag = 'OVERDUE_GT30';
}
else
{ system.debug('inside user loop');
  terrname+='%';
 user[] usr = [select id from user where username like :terrName and isactive=true];
                if(usr.size() > 0)
                {
                     //terrID = terr[0].id;
                     system.debug('usr.size()'+usr.size());
                     userterritory2association[] ut = [select          
                                            territory2id        
                                            from userterritory2association
                                            where userid=:usr[0].id and isactive=true
                                    ];
                       ID[] territoryids=new ID[]{};
                       
                       for (Integer i = 0; i < ut.size(); i++) 
                       {    
                           system.debug('inside ut loop');
                           territoryids.add(ut[i].territory2id);
                           system.debug('ut[i].territoryid'+ut[i].territory2id);
                       }
                       
                     Opportunity[] opty = [select          
                                            id        
                                    from opportunity
                                    where opportunity_status__c = 'Active'
                                    and   dealid__c <> null and StageName  <>'1 - Prospect' 
                                    and   territory2id in :territoryids 
                                    and territory2.lowest_level__c=true
                                    and territory2.structure__c='CORP.REVENUE'
                                    and territory2.end_dated__c=false
                                    and ((territory2.level_2_territory__c='Global Enterprise Theatre' and territory2.territory_type__c='TEAM')
                                        OR (territory2.level_2_territory__c<>'Global Enterprise Theatre' ))
                                    and territory2.Territory_Type__c in ('AM','TEAM')
                                    and closedate>=:fp_start_date-30 and closedate<=:fp_start_date-14 limit 1
                                    ];
                
                     if(opty.size() > 0)
                        flag = 'OVERDUE_LT30';
                     //return opty;
                            Opportunity[] opty1 = [select
                                                    id
                                                    from opportunity
                                                    where opportunity_status__c = 'Active'
                                                    and   dealid__c <> null and StageName  <>'1 - Prospect' 
                                                    and   territory2id in :territoryids
                                                    and territory2.lowest_level__c=true
                                                    and territory2.structure__c='CORP.REVENUE'
                                                    and territory2.end_dated__c=false
                                                    and ((territory2.level_2_territory__c='Global Enterprise Theatre' and territory2.territory_type__c='TEAM')
                                                        OR (territory2.level_2_territory__c<>'Global Enterprise Theatre' ))
                                                    and territory2.Territory_Type__c in ('AM','TEAM')
                                                    and closedate<:fp_start_date-30 limit 1
                                                    ];
                     if(opty1.size() > 0)
                             flag = 'OVERDUE_GT30';
                }
                else
                {
                    flag = 'OVERDUE_GT30';
                }

}
system.debug('flag is '+flag);
return  flag;
}

}