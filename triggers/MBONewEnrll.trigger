trigger MBONewEnrll on MBO_Partner_Enrollment__c (after insert) {
  List<Partner_MBO__c> newPMBOsList=new List<Partner_MBO__c>();
  Set<String> enrollRecs = new Set<String>();  
  Set<String> subTracks=new Set<String>{'PRODUCT','SERVICE'};
  
  system.debug('***Trigger.New ' + Trigger.New.size());
  
  List<MBO_Partner_Group__c> newPGList=new List<MBO_Partner_Group__c>();  
  for(String currSubTrack:subTracks)
  {
       system.debug('***Sub Track is :' + currSubTrack);
     Set<String> trckNames=new Set<String>();
     Set<String> pgmNames=new Set<String>();
     Set<Id> pntrIds=new Set<Id>();
     Map<String, Set<String>> pgmSubTrckPntrs=new Map<String, Set<String>>();
      Map<String, Set<String>> pgmSubTrckPntrsPeriod=new Map<String, Set<String>>();
     Map<String, MBO_Partner_Enrollment__c> pgmEnrllMap=new Map<String, MBO_Partner_Enrollment__c>();
     List<MBO_Partner_Group_Map__c> newMapList=new List<MBO_Partner_Group_Map__c>(); 
     String pgmQuery='';
    for(MBO_Partner_Enrollment__c enrll: Trigger.New)  
    {
       system.debug('***Current Enrollment is  :' + enrll);
       if(enrll.SubTrack_Name__c == currSubTrack)
       {         
         system.debug('***Current Enrollment Subtrack is same  :');
         pntrIds.add(enrll.Partner__c);
         pgmEnrllMap.put(enrll.Program_Name__c+enrll.Track_Name__c+enrll.Partner__c,enrll);
         
         if(pgmSubTrckPntrs.get(enrll.Program_Name__c+enrll.Track_Name__c)==null)
         {
           Set<String> enrllPntrIds=new Set<String>();
           enrllPntrIds.add(enrll.Partner__c);
           pgmSubTrckPntrs.put(enrll.Program_Name__c+enrll.Track_Name__c,enrllPntrIds);
         }else
         {
           Set<String> enrllPntrIds=pgmSubTrckPntrs.get(enrll.Program_Name__c+enrll.Track_Name__c);
           enrllPntrIds.add(enrll.Partner__c);           
         }
         
         system.debug('***Current Enrollment Subtrack is same  :');
         if(pgmSubTrckPntrsPeriod.get(enrll.Program_Name__c+enrll.Track_Name__c+enrll.Enrollment_Period__c.format())==null)
         {
           Set<String> enrllPntrIds=new Set<String>();
           enrllPntrIds.add(enrll.Partner__c);
           pgmSubTrckPntrsPeriod.put(enrll.Program_Name__c+enrll.Track_Name__c+enrll.Enrollment_Period__c.format(),enrllPntrIds);
            system.debug('***Inside If and pgmSubTrckPntrsPeriod is:' + pgmSubTrckPntrsPeriod);
         }else
         {
           Set<String> enrllPntrIds=pgmSubTrckPntrsPeriod.get(enrll.Program_Name__c+enrll.Track_Name__c+enrll.Enrollment_Period__c.format());
           enrllPntrIds.add(enrll.Partner__c); 
           system.debug('***Inside Else and pgmSubTrckPntrsPeriod is' + pgmSubTrckPntrsPeriod);          
         }
         
         trckNames.add(enrll.Track_Name__c);
         pgmNames.add(enrll.Program_Name__c);
         if(pgmQuery=='')
           pgmQuery='(Name =\''+enrll.Program_Name__c+'\' and Track__c =\''+enrll.Track_Name__c+'\')';
         else
           pgmQuery=pgmQuery+'OR (Name =\''+enrll.Program_Name__c+'\' and Track__c =\''+enrll.Track_Name__c+'\')';
           
         //New Code Added for Nov Release
           
       }
    }
    if(pgmNames.size()>0)
    {
        if(pgmQuery != '')
        pgmQuery='select Id, Name, Track__c from MBO_Program__c where '+pgmQuery;
        Map<Id, MBO_Program__c> pgms=new Map<Id, MBO_Program__c>((List<MBO_Program__c>)Database.query(pgmQuery));
        Map<Id, MBO_Partner_Group__c> pgList=new Map<Id, MBO_Partner_Group__c>([select Id, Group_Level__c, Enrollment_period__c ,MBO_Program__r.Enrollment_Level__c, MBO_Program__r.Name, MBO_Program__r.Track__c, Partner_Group_Type__c, Country_Country_Group__c,Name  from MBO_Partner_Group__c where MBO_Program__c in: pgms.keySet() and Group_Level__c =:'PARTNER']);
        
        system.debug('***pgList is' + pgList);
        //Added Later
        for(MBO_Partner_Enrollment__c enrllRec: Trigger.New) //
        {
	        system.debug('***enrllRec:'+enrllRec.Partner__c+enrllRec.Program_Name__c+enrllRec.Track_Name__c+enrllRec.Enrollment_Period__c.format());
	        system.debug('***enrllRecs set size:'+ enrollRecs.size());
	        if(!enrollRecs.contains(enrllRec.Partner__c+enrllRec.Program_Name__c+enrllRec.Track_Name__c+enrllRec.Enrollment_Period__c.format()))
	        {
	        system.debug('*** IF enrollRecs.contains(');
	        Boolean pgExist = false;
	        for(MBO_Partner_Group__c pgRec: pgList.values())
	        {
	        
	        	system.debug('*** pgRec' + pgRec);
	        	if(pgRec.MBO_Program__r.Name ==  enrllRec.Program_Name__c && pgRec.MBO_Program__r.Track__c ==  enrllRec.Track_Name__c 
	        	&& pgRec.Group_Level__c ==  'PARTNER' 
	        	&& (pgRec.MBO_Program__r.Enrollment_Level__c ==  enrllRec.Partner_Enrollment_Level__c || (pgRec.MBO_Program__r.Enrollment_Level__c ==  'BEGEO' && enrllRec.Partner_Enrollment_Level__c=='BE_GEO'))
	        	&& pgRec.Enrollment_period__c ==  enrllRec.Enrollment_period__c.format())
	        	{
	        		system.debug('***enrllRec.Country__c' + enrllRec.Country__c);
	        		system.debug('***enrllRec.Country_Account__c' + enrllRec.Country_Account__c);
	        		
	        		system.debug('***enrllRec.Country_Group__c ' + enrllRec.Country_Group__c);
	        		system.debug('***enrllRec.Country_Group_Account__c ' + enrllRec.Country_Group_Account__c);
	        		
	        		
	        		if(enrllRec.Country__c!=null && enrllRec.Country__c!= '')
	        		{
	        			system.debug('***enrllRec.Partner__c' + enrllRec.Partner__c);
	        			
	        			if(pgRec.Partner_Group_Type__c=='Country' && pgRec.Country_Country_Group__c == enrllRec.Country_Account__c )
	        			{
	        				MBO_Partner_Group_Map__c pgMapRec=new MBO_Partner_Group_Map__c();
			        		pgMapRec.Account__c = enrllRec.Partner__c;
			        		pgMapRec.MBO_Partner_Group__c = pgRec.id;
			        		system.debug('***Inside If newMapList' + newMapList);
			        		newMapList.add(pgMapRec);
			        		system.debug('***Inside If newMapList' + newMapList);
			        		enrollRecs.add(enrllRec.Partner__c+enrllRec.Program_Name__c+enrllRec.Track_Name__c+enrllRec.Enrollment_Period__c.format());
			        		pgExist = True;
			        		system.debug('***Inside If ' + enrollRecs.size());
	        			}
	        		}
	        		else 
	        		{
	        			system.debug('***Inside Else '+ pgRec.Country_Country_Group__c + enrllRec.Country_Group_Account__c );
	        			if(pgRec.Partner_Group_Type__c=='Country Group' && pgRec.Country_Country_Group__c == enrllRec.Country_Group_Account__c)
	        			{
	        				system.debug('***Inside If Again ' );
	        				MBO_Partner_Group_Map__c pgMapRec=new MBO_Partner_Group_Map__c();
			        		pgMapRec.Account__c = enrllRec.Partner__c;
			        		pgMapRec.MBO_Partner_Group__c = pgRec.id;
			        		system.debug('***Inside If newMapList' + newMapList);
			        		newMapList.add(pgMapRec);
			        		system.debug('***Inside If newMapList' + newMapList);
			        		enrollRecs.add(enrllRec.Partner__c+enrllRec.Program_Name__c+enrllRec.Track_Name__c+enrllRec.Enrollment_Period__c.format());
			        		pgExist = True;
			        		system.debug('***Inside Else ' + enrollRecs.size());
	        			}
	        		}
	        		system.debug('***Outside If- else ' + enrollRecs.size());
	        		
	        		
	        	}
	        }
	   /*     if(pgExist == false)
	        {
	        	MBO_Partner_Group__c pgRec=new MBO_Partner_Group__c();
	        		
	        		
	        			
	        			
        		pgRec.Active__c = True;
        		pgRec.Enrollment_period__c = enrllRec.Enrollment_period__c.format();
        		//pgRec.Geo_Coverage__c = enrllRec.Partner__c;
        		pgRec.Group_Level__c = 'PARTNER' ;
        		//pgRec.MBO_Program__c = enrllRec.Partner__c;
        		
        		newPGList.add(pgRec);
	        	
	        } */
	        }
        }
        	
        system.debug('***newMapList ' + newMapList);
        
        try{	
          insert newMapList;
        }
        Catch(Exception e)
        {
        	
        }
        
        
        //
        
        Map<Id, MBO_Partner_Group_Map__c> pntrPGMap=new Map<Id, MBO_Partner_Group_Map__c>([select Id,Account__c,MBO_Partner_Group__c, MBO_Partner_Group__r.MBO_Program__c from MBO_Partner_Group_Map__c where MBO_Partner_Group__c in:pgList.keySet() and Account__c=:pntrIds]);             
        Map<Id, MBO_Item__c> pgItms=new Map<Id, MBO_Item__c>([select MBO__r.Name,MBO__r.MBO_Description__c,MBO__r.Sub_Track__c, MBO__c,Partner_Group__c,
                          Partner__c,IsModified__c, Measure_Unit__c, Segment__c, Objective__c, Target__c, MBO__r.MBO_Program__c,
                         Q1_Target_Percent__c, Q2_Target_Percent__c,Q3_Target_Percent__c,Q4_Target_Percent__c, Partner_Group__r.Group_Level__c, Type__c    
         from MBO_Item__c where Partner_Group__c in:pgList.keySet() and MBO__r.MBO_Program__c in:pgms.keySet() and MBO__r.Sub_Track__c =:currSubTrack]);    
         
        system.debug('*** pntrPGMap :'+ pntrPGMap);
        system.debug('*** pgItms :'+ pgItms);
                
        
        Set<String> pntrGrpIds=new Set<String>();
        Map<Id, Set<String>> pgPntrId=new Map<Id, Set<String>>();
        MBOUtil.getPGPntrIds(pntrGrpIds, pntrPGMap.values(), pgPntrId);
        
        system.debug('*** ');
        for(MBO_Item__c mboItem:pgItms.values())
        {
          system.debug('*** Name' + mboItem.MBO__r.Name  + '  ' +mboItem.Partner_Group__c);
          if(pgPntrId.get(mboItem.Partner_Group__c)!=null)
          {
            Set<String> pgPntrIds=pgPntrId.get(mboItem.Partner_Group__c);
            
            system.debug('*** pgPntrIds for this Item' + pgPntrIds);
            
            for(String pntrId:pgPntrIds)
            {
              system.debug('*** Going to Add : ' + pntrId);
              Partner_MBO__c pMbo=new Partner_MBO__c();
              MBOUtil.createPMBO(pMbo, mboItem, pntrId, pgmSubTrckPntrs, pgms, newPMBOsList, pgmEnrllMap);
            }
        }
        }
        
        
        //system.debug('***pgmEnrllMap.values():'+pgmEnrllMap.values());
        
        
        
        ////Track Level PMBO Starts////
        pgList=new Map<Id, MBO_Partner_Group__c>([select Id,MBO_Program__r.Name,MBO_Program__r.Track__c, Enrollment_Period__c from MBO_Partner_Group__c where MBO_Program__c in: pgms.keySet() and Group_Level__c =:'TRACK']);
        pgItms=new Map<Id, MBO_Item__c>([select MBO__r.Name,MBO__r.MBO_Description__c,MBO__r.Sub_Track__c, MBO__c,Partner_Group__c,
                          Partner__c,IsModified__c, Measure_Unit__c, Segment__c, Objective__c, Target__c, MBO__r.MBO_Program__c,
                         Q1_Target_Percent__c, Q2_Target_Percent__c,Q3_Target_Percent__c,Q4_Target_Percent__c, Partner_Group__r.Group_Level__c, Type__c    
         from MBO_Item__c where Partner_Group__c in:pgList.keySet() and MBO__r.MBO_Program__c in:pgms.keySet() and MBO__r.Sub_Track__c =:currSubTrack ]);
         
        system.debug('***pgList'+pgList);
        system.debug('***pgItms'+pgItms);
        
        for(MBO_Item__c mboItem:pgItms.values())
        {
          system.debug('***mboItem'+mboItem);
          MBO_Partner_Group__c  pg=pgList.get(mboItem.Partner_Group__c);
          
          system.debug('***pg'+pg);
          
          Set<String> enrllPntrIds=pgmSubTrckPntrsPeriod.get(pg.MBO_Program__r.Name+pg.MBO_Program__r.Track__c+pg.Enrollment_Period__c);
          
          system.debug('***pg'+enrllPntrIds);
          
          if(enrllPntrIds!=null)
          {
          for(String pntrId:enrllPntrIds)
          {
            
            Partner_MBO__c pMbo=new Partner_MBO__c();
            MBOUtil.createPMBO(pMbo, mboItem, pntrId, pgmSubTrckPntrs, pgms, newPMBOsList, pgmEnrllMap);
            
          } 
          } 
        }
        ////Track Level PMBO Ends////
      
      }  
      system.debug('***newPMBOsList'+newPMBOsList);
      system.debug('***newPMBOsList size'+newPMBOsList.size());
      upsert(newPMBOsList);
  }  
  

//  insert newPGList;
}