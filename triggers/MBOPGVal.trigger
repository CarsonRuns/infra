trigger MBOPGVal on MBO_Partner_Group__c (before insert, before update) {

    Set<Id> trackProgramList=new Set<Id>();
    Set<Id> partnerProgramList=new Set<Id>();
    List<Id> allProgramList=new List<Id>();
    List<Id> geoList=new List<Id>();
    
    List<String> pgCountryList=new List<String>();
    List<String> pgCountryGroupList=new List<String>();
    
    
    for (MBO_Partner_Group__c pg: Trigger.New) 
    {
        allProgramList.add(pg.MBO_Program__c);
        
        if(pg.Group_Level__c =='TRACK' )
        {
            trackProgramList.add(pg.MBO_Program__c);
        } 
        
        if(pg.Group_Level__c =='PARTNER' )
        {
        	geoList.add(pg.Geography__c);
        	partnerProgramList.add(pg.MBO_Program__c);
        	
        		system.debug('***pg.Partner_Group_Type__c'+pg.Partner_Group_Type__c);
        		
        		
        		if(pg.Partner_Group_Type__c == 'Country Group' && pg.Country_Country_Group__c != null && pg.Country_Country_Group__c != '')
        		{
        			pgCountryGroupList.add(pg.Country_Country_Group__c);
        		}else
        		if(pg.Partner_Group_Type__c == 'Country' && pg.Country_Country_Group__c != null && pg.Country_Country_Group__c != '')
        		{
        			pgCountryList.add(pg.Country_Country_Group__c);
        		}
        }      
    }   
    
    Map<Id,MBO_GEO_Coverage__c> geoMap=new Map<Id,MBO_GEO_Coverage__c>([select Id,MBO_Program__c, Track__c, GEO_Type__c, GEO_Code__c from MBO_GEO_Coverage__c where Id in:geoList]);
    
    List<MBO_Partner_Group__c> allPgList=[select Id, MBO_Program__c, Group_Level__c, Geography__c,	Enrollment_Period__c, Name  from MBO_Partner_Group__c where MBO_Program__c in:allProgramList];
    
    List<MBO_Partner_Enrollment__c> enrollList=[select Id, Country__c, Country_Group__c,	Partner_Enrollment_Level__c, Name  from MBO_Partner_Enrollment__c where Country__c in:pgCountryList OR Country_Group__c in:pgCountryGroupList];
    
    //List<MBO_Partner_Group__c> allTrackPgList=[select Id, MBO_Program__c from MBO_Partner_Group__c where MBO_Program__c in:trackProgramList and Group_Level__c ='TRACK'];
    List<MBO_Partner_Group__c> allTrackPgList = new List<MBO_Partner_Group__c>();
    
    
    //List<MBO_Partner_Group__c> allPartPgList=[select Id, MBO_Program__c from MBO_Partner_Group__c where MBO_Program__c in:partnerProgramList and Group_Level__c ='PARTNER'];
    List<MBO_Partner_Group__c> allPartPgList = new List<MBO_Partner_Group__c>();
    
    for(MBO_Partner_Group__c PgRec:allPgList)
            {	
            	
		        if(pgrec.Group_Level__c =='TRACK' && trackProgramList.contains(pgrec.MBO_Program__c))
		        {
		            allTrackPgList.add(pgrec);
		        }else
		        
		        if(pgrec.Group_Level__c =='PARTNER' && partnerProgramList.contains(pgrec.MBO_Program__c))
		        {
		            allPartPgList.add(pgrec);
		        }
	        }
   
    
    
    system.debug('***'+allTrackPgList.size());
    system.debug('***'+allTrackPgList);
    
    system.debug('***'+geoMap.size());
    system.debug('***'+geoMap);
    
    
    for(MBO_Partner_Group__c pgrec: Trigger.New)
    {
        if(pgrec.Group_Level__c =='TRACK' )
        {
	        if(pgrec.Geography__c!=null)
	        {
	        	pgrec.addError('Geography can not be selected for track level Group');
	        }
	        
	        for(MBO_Partner_Group__c extPgRec:allPgList)
            {
		        if(pgrec.MBO_Program__c == extPgRec.MBO_Program__c &&extPgRec.Group_Level__c =='TRACK' && pgrec.id!= extPgRec.id && pgrec.Enrollment_Period__c == extPgRec.Enrollment_Period__c)
		        {
		            pgrec.addError('Group at Track level already exists');
		        }
	        }
	        
	        
        }
        
        if(pgrec.Group_Level__c =='PARTNER' )
        {
        	system.debug('***1'+pgrec.Geography__r.MBO_Program__c);
        	system.debug('***1B'+pgrec.Geography__r.Track__c);
        	system.debug('***2'+pgrec.MBO_Program__r.Track__c);
        	system.debug('***3'+pgrec.MBO_Program__c);
        	system.debug('***4'+pgrec.Track__c);
        	//system.debug('***5'+geoMap.get(pgrec.Geography__c).Track__c);
        	
        	
        	if(geoMap.get(pgrec.Geography__c)!=null)
        	{
	        	if(geoMap.get(pgrec.Geography__c).Track__c!=pgrec.Track__c || geoMap.get(pgrec.Geography__c).MBO_Program__c!=pgrec.MBO_Program__c )
	        	{
	        		pgrec.addError('Incorrect Geography. Please select a Geography based on Program and Track');
	        	}
        	}
        	else
        	{
        		system.debug('  *** geoMap.get(pgrec.Geography__c) is null' );
        		pgrec.addError('Geography is Mandatory for partner groups of type Partner. Please select a Geography based on Program and Track');
        		//system.debug('***5'+geoMap.get(pgrec.Geography__c).Track__c);
        	}
        	
        	for(MBO_Partner_Group__c extPartPgRec:allPgList)
            {
		        if(pgrec.MBO_Program__c == extPartPgRec.MBO_Program__c && extPartPgRec.Group_Level__c =='PARTNER'&& pgrec.id!= extPartPgRec.id && pgrec.Geography__c == extPartPgRec.Geography__c  && pgrec.Enrollment_Period__c == extPartPgRec.Enrollment_Period__c)
		        {
		            pgrec.addError('This Geography has already been selected in another partner group: ' + extPartPgRec.Name);
		        }
	        }
        
        
        
        }
        
                       
    } 
    
    
}