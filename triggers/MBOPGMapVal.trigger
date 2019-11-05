trigger MBOPGMapVal on MBO_Partner_Group_Map__c (before insert, before update) {
 
    System.debug('*** Inside Trigger');
    
    for (MBO_Partner_Group_Map__c pgMap: Trigger.New) 
    {  
        MBO_Partner_Group__c pg=[select Id,Group_Level__c,MBO_Program__r.Enrollment_Level__c from MBO_Partner_Group__c where Id=: pgMap.MBO_Partner_Group__c ];
        System.debug('*** pg'+ pg);
        if(pg.Group_Level__c == 'PARTNER')
        {
            //List<MBO_Partner_Group_Map__c> pgMapLst=[select Id from MBO_Partner_Group_Map__c where Account__c =:pgMap.Account__c ]; 
            List<MBO_Partner_Group_Map__c> pgMapLst=[select Id from MBO_Partner_Group_Map__c where Account__c =:pgMap.Account__c and MBO_Partner_Group__r.MBO_Program__c=: pg.MBO_Program__r.id ];  
            Account acc=[select RecordType.Name,ParentId, RecordTypeId, Country__c, BE_GEO_Name_Country_Group__c from Account  where Id=:pgMap.Account__c];
            if(acc.RecordTypeId!=null )                                 
            {
                RecordType recType=[select Id,Name from RecordType where Id=:acc.RecordTypeId];
                if(recType!=null && recType.Name == 'Channel')
                {
                   System.debug('*** Channel');
                    if(pg.MBO_Program__r.Enrollment_Level__c == 'BEGEO')    
                    {
                        pgMap.addError('Account with type as "Channel" cannot be associated to this Partner group, as Group has "BEGEO" level Enrollment');
                    } 
                    else
                    {
                        //List<Account> prntAccList=[select RecordType.Name, RecordTypeId, Country__c, BE_GEO_Name_Country_Group__c from Account  where Id=:acc.ParentId];
                      //  if(acc.ParentId != null && prntAccList!= null && prntAccList.size()>0)                      
                      //  {
                      //    Account prntAcc=prntAccList[0];
                            Integer geoCvrgCnt=[select count() from MBO_GEO_Coverage__c where MBO_Program__c=:pg.MBO_Program__r.Id and GEO_Code__c like: '%'+acc.Country__c+'%' ];
                            if(geoCvrgCnt == 0)
                            {
                                System.debug('*** Geo Coverage count is  zero');
                                String msg='Country of the selected account is '+acc.Country__c+' which cannot be associated to this Partner Group';
                                pgMap.addError(msg);
                            }
                     //   } 
                       /* else{
                            String msg='Not able to find the Parent Account';
                            pgMap.addError(msg);
                        }  */
                    }
                    //Select a.RecordType.Name, a.RecordTypeId,  a.Country__c, a.BE_GEO_Name_Country_Group__c From Account a  where a.RecordType.Name='Partner Company'
                }
                else if(recType!=null && recType.Name == 'Partner Company'){
                	System.debug('*** Partner Company');
                    if(pg.MBO_Program__r.Enrollment_Level__c == 'BEC' )
                    {
                         System.debug('***BEC');
                         pgMap.addError('Account with type as "Partner Company" cannot be associated to this Partner group, as Group has "BEC" level Enrollment');
                    }
                    else
                    {
                         System.debug('***NOT BEC');
                        Integer geoCvrgCnt=[select count() from MBO_GEO_Coverage__c where MBO_Program__c=:pg.MBO_Program__r.Id and GEO_Code__c like: '%'+acc.BE_GEO_Name_Country_Group__c+'%' ];
                        System.debug('***geoCvrgCnt' + geoCvrgCnt);
                        if(geoCvrgCnt == 0)
                        {
                            System.debug('*** Geo Coverage count is  zero');
                            String msg='Country Group of the selected account is '+acc.BE_GEO_Name_Country_Group__c+' which cannot be associated to this Partner Group.';
                            pgMap.addError(msg);
                        }
                    }
                    
                }else{
                     String msg='Only Account with Type "Partner Company" or "Channel" can be used for association, current account type is '+recType.Name;
                     pgMap.addError(msg);
                }                   
            }   
            
            if(pgMapLst!=null && pgMapLst.size()>0)                                             
            {
                for(MBO_Partner_Group_Map__c extPGMap:pgMapLst)
                {
                    if(extPGMap.Id != pgMap.Id)
                    pgMap.addError('Current Partner has an existing association with another Partner Group.');
                }   
            }
        }
        else if(pg.Group_Level__c == 'TRACK')
        {
            pgMap.addError('Partners cannot be associated to Track Level Group.');          
        }
    }
}