public with sharing class MBOUtil {

	/////////////////Below methods are getting used in MBOBatchJob starts\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
	public static void getLvl2PntrIds(Set<String> pntrGrpIds, Map<Id, Set<String>> pgPntrId, Map<String, MBO_Partner_Enrollment__c> subTrckPntrs)
	{ 
		Set<String> pntrIds=new Set<String>();
		List<MBO_Partner_Group_Map__c> pntrList=[select Account__c,MBO_Partner_Group__c from MBO_Partner_Group_Map__c where MBO_Partner_Group__c in :pntrGrpIds
											 order by MBO_Partner_Group__c];
		Iterator<MBO_Partner_Group_Map__c> itr=pntrList.iterator();
		
		Id currPG=null;
		while(itr.hasNext())
		{			
			MBO_Partner_Group_Map__c pntrGPPntrMap=itr.next();
			
			if(currPG == null && pntrGPPntrMap.MBO_Partner_Group__c!= null){
				if(subTrckPntrs.get(pntrGPPntrMap.Account__c)!=null)
				{
					pntrIds.add(pntrGPPntrMap.Account__c);			
				}
				currPG=pntrGPPntrMap.MBO_Partner_Group__c;
				pgPntrId.put(pntrGPPntrMap.MBO_Partner_Group__c,pntrIds);	
			}
			else if(currPG != null && currPG == pntrGPPntrMap.MBO_Partner_Group__c)
			{
				if(subTrckPntrs.get(pntrGPPntrMap.Account__c)!=null)
				{
					pntrIds.add(pntrGPPntrMap.Account__c);			
				}
			}
			else if(currPG != null && currPG != pntrGPPntrMap.MBO_Partner_Group__c)
			{
				//pgPntrId.put(currPG,pntrIds);
				pntrIds=new Set<String>();
				if(subTrckPntrs.get(pntrGPPntrMap.Account__c)!=null)
				{
					pntrIds.add(pntrGPPntrMap.Account__c);			
				}
				pgPntrId.put(pntrGPPntrMap.MBO_Partner_Group__c,pntrIds);
				currPG=pntrGPPntrMap.MBO_Partner_Group__c;
			}
		}
		
	}
	
	public static void getAllPMBOAndMBOItms(Master_MBO__c mbo, Set<String> allPntrIds, Map<String, Partner_MBO__c> pMBOPntrMap, Map<String, String> pMBOItmMap, Map<Id, MBO_Item__c> itmList,String pgmName, String trackName)
	{
		List<String> itmIds=new List<String>();		
		Map<String, Partner_MBO__c> pMBOIdMap=new Map<String, Partner_MBO__c>([select Name, Id, Partner__c, MBO_Item__c, Target__c, Status__c, Linitm_Id__c,
										Q1_Target_Percent__c,Q2_Target_Percent__c,Q3_Target_Percent__c,	Q4_Target_Percent__c,FY_Target_Percent__c,MBO_Description__c,Segment__c,
										Q1_Target__c, Q2_Target__c,	Q3_Target__c,Q4_Target__c,FY_Target__c, Objective__c from Partner_MBO__c where 
										   Partner__c in: allPntrIds and Program_Name__c=: pgmName and Track__c =: trackName and Sub_Track__c  =:mbo.Sub_Track__c]);
			if(pMBOIdMap!=null){
				for(Partner_MBO__c pMBO : pMBOIdMap.values()) {
					pMBOPntrMap.put(pMBO.Partner__c, pMBO);		
					pMBOItmMap.put(pMBO.Partner__c,pMBO.MBO_Item__c);
					itmIds.add(pMBO.MBO_Item__c);			
				}				
			}
		
		Map<Id, MBO_Item__c> otherMBOItmList=new Map<Id, MBO_Item__c>([SELECT Partner_Group__c,Partner__c,IsModified__c, Measure_Unit__c, Segment__c, Objective__c, Target__c, 
									   	Q1_Target_Percent__c,Q2_Target_Percent__c,Q3_Target_Percent__c,	Q4_Target_Percent__c, MBO__c, Partner_Group__r.Group_Level__c, Partner_Group__r.Enrollment_Period__c, Type__c	
									   FROM MBO_Item__c where Id IN: itmIds]);
									   
		Map<Id, MBO_Item__c> currItmList=new Map<Id, MBO_Item__c>([SELECT Partner_Group__c,Partner__c,IsModified__c, Measure_Unit__c, Segment__c, Objective__c, Target__c, 
									   Q1_Target_Percent__c,Q2_Target_Percent__c,Q3_Target_Percent__c,	Q4_Target_Percent__c,  MBO__c, Partner_Group__r.Group_Level__c, Partner_Group__r.Enrollment_Period__c, Type__c	
									   FROM MBO_Item__c WHERE MBO__c  =: mbo.Id]);		
		if(currItmList!=null && itmList!=null & otherMBOItmList != null)
		{
			itmList.putAll(otherMBOItmList);
			itmList.putAll(currItmList);
		}			
		
	}
	
	public static String isOveridable(MBO_Item__c prevMboItm, MBO_Item__c currMboItm){
		
		if(currMboItm!= null)
		{
			if(prevMboItm == null)
			{
				return 'UPD';
			}
			if(currMboItm.Id == prevMboItm.Id)
			{
				return 'UPD';
			}
			if(currMboItm.Type__c == 'Partner Group')
			{
				if(currMboItm.Partner_Group__r.Group_Level__c == 'TRACK')
				{
					return 'NO_UPD';				
				}else if(currMboItm.Partner_Group__r.Group_Level__c == 'PARTNER' && (prevMboItm.Partner_Group__r.Group_Level__c == 'TRACK' || prevMboItm.Partner_Group__r.Group_Level__c =='PARTNER'))//added || prevMboItm.Partner_Group__r.Group_Level__c =='PARTNER' later so that pMBO of existing MBO/Line item can be updated on 28 Sept 12 
				{
					return 'OVR';
				}			
			}else if(currMboItm.Type__c == 'Partners')
			{
				if(prevMboItm.Type__c == 'Partner Group')
				{
					return 'OVR';				
				}else if(prevMboItm.Type__c == 'Partners')
				{
					return 'NO_UPD';
				}	
			}	
		}
		return 'NO_UPD';
	} 
	 
	/////////////////Below methods are getting used in MBOBatchJob ends\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
		
	//To fill the MBO Items partners Id's only for Track Ids starts
	//To fill the MBO Items partners Id's only for Track Ids ends

	//To get all the Partners enrolled for the given Track and SubTrack Names
	public static Set<String> getSubTrackEnrllist(String trackName, String subTrackName)
	{
		Set<String> pntrIds=new Set<String>();
		List<MBO_Partner_Enrollment__c> enrlList=[select Partner__c from MBO_Partner_Enrollment__c where 
												 SubTrack_Name__c=:subTrackName and Track_Name__c=:trackName ];	
		Iterator<MBO_Partner_Enrollment__c> enrllItr=enrlList.iterator();
		
		while(enrllItr.hasNext())
		{
			MBO_Partner_Enrollment__c enrll=enrllItr.next();
			pntrIds.add(enrll.Partner__c);		
		}	
		return 	pntrIds;
	}
	
	//To get all the Partners enrolled for the given Track and SubTrack Names
	public static Map<String, MBO_Partner_Enrollment__c> getSubTrackEnrllMap(String pgmName, String trackName, String subTrackName)
	{
		Map<String, MBO_Partner_Enrollment__c> pntrEnrllMap=new Map<String, MBO_Partner_Enrollment__c>();
		List<MBO_Partner_Enrollment__c> enrlList=[select Partner__c, Enrollment_Period__c from MBO_Partner_Enrollment__c where Program_Name__c=:pgmName and
												 SubTrack_Name__c=:subTrackName and Track_Name__c=:trackName ];	
		Iterator<MBO_Partner_Enrollment__c> enrllItr=enrlList.iterator();
		
		while(enrllItr.hasNext())
		{
			MBO_Partner_Enrollment__c enrll=enrllItr.next();
			pntrEnrllMap.put(enrll.Partner__c, enrll);		
		}	
		return 	pntrEnrllMap;
	}
	
	
		public static void createPMBO(Partner_MBO__c pMbo, MBO_Item__c mboItem, String pntrId, Map<String, Set<String>> pgmSubTrckPntrs, Map<Id, MBO_Program__c> pgms, List<Partner_MBO__c> newPMBOsList, Map<String, MBO_Partner_Enrollment__c> pgmEnrllMap)
	{
			System.debug('Inside createPMBO');
			 pMbo.Linitm_Id__c=mboItem.Id;
	        pMbo.MBO_Item__c=mboItem.Id;
	        pMbo.Name=mboItem.MBO__r.Name;
	        pMbo.MBO_Description__c=mboItem.MBO__r.MBO_Description__c;                        
	        pMbo.Partner__c=pntrId;                     
	        pMbo.Measure_Unit__c=mboItem.Measure_Unit__c;
	        pMbo.Segment__c=mboItem.Segment__c;
	        pMbo.Objective__c=mboItem.Objective__c;   
	        pMbo.Sub_Track__c=mboItem.MBO__r.Sub_Track__c;
	        
	        if(pMbo.Measure_Unit__c == '%')
	        {
	          pMbo.FY_Target_Percent__c =  mboItem.Target__c;
	          pMbo.Q1_Target_Percent__c=mboItem.Q1_Target_Percent__c;
	          pMbo.Q2_Target_Percent__c=mboItem.Q2_Target_Percent__c;
	          pMbo.Q3_Target_Percent__c=mboItem.Q3_Target_Percent__c;
	          pMbo.Q4_Target_Percent__c=mboItem.Q4_Target_Percent__c;
	         }
	        pMbo.MBO__c=mboItem.MBO__c;
	        
	        MBO_Program__c pgm=pgms.get(mboItem.MBO__r.MBO_Program__c);
	        if(pgmEnrllMap.get(pgm.Name+pgm.Track__c+pntrId)!=null)
	        {
	        	MBO_Partner_Enrollment__c enrll= pgmEnrllMap.get(pgm.Name+pgm.Track__c+pntrId);
		        if(enrll!=null)
		        {
		        	pMbo.MBO_Partner_Enrollment__c=enrll.Id;
		        	
		        	system.debug('*** Added PMBO : ' + pMbo);
		        	newPMBOsList.add(pMbo);
		        }
		       if(pgmSubTrckPntrs.get(pgm.Name+pgm.Track__c)!=null)
		       {
		       		System.debug('Inside createPMBO to remove pntrid'+pntrId);
					Set<String> enrllPntrIds=pgmSubTrckPntrs.get(pgm.Name+pgm.Track__c);
					enrllPntrIds.remove(pntrId);				       	
		       }
	        }			        
			
	}

	////Used IN MBO New Pntr Enrll Trigger/// updated on 30 Oct 12
	public static void getPGPntrIds(Set<String> pntrGrpIds, List<MBO_Partner_Group_Map__c> pntrList, Map<Id, Set<String>> pgPntrId)
	{ 
		//Set<String> pntrIds=new Set<String>();

		Iterator<MBO_Partner_Group_Map__c> itr=pntrList.iterator();
		
		Id currPG=null;
		while(itr.hasNext())
		{			
			MBO_Partner_Group_Map__c pntrGPPntrMap=itr.next();
			
			system.debug('*** Inside getPGPntrIds() :'+ pntrGPPntrMap);
		
		if(pntrGPPntrMap.MBO_Partner_Group__c!=null )
		{	
			if(pgPntrId.get(pntrGPPntrMap.MBO_Partner_Group__c)==null)
			{
				Set<String> pntrIds=new Set<String>();
				pntrIds.add(pntrGPPntrMap.Account__c);
				pgPntrId.put(pntrGPPntrMap.MBO_Partner_Group__c,pntrIds);
				system.debug('*** New Group :'+ pgPntrId);
			}
			else
			{
				Set<String> pntrIds=pgPntrId.get(pntrGPPntrMap.MBO_Partner_Group__c);
	            pntrIds.add(pntrGPPntrMap.Account__c);  
	            system.debug('*** Old Group :'+ pgPntrId);
			}
		}
			
		}
		
	}
}