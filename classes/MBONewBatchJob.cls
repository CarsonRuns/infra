global class MBONewBatchJob implements Database.Batchable<sObject> {

  global final String Query;
    
    global MBONewBatchJob(String q){
      Query=q;
     }
   
    global Database.QueryLocator start(Database.BatchableContext BC){
      return Database.getQueryLocator(query);
     }
  

    global void execute(Database.BatchableContext BC, List<sObject> scope){
    for(sobject s : scope){
      
      System.debug('Entering BatchJob I');
      //Max Query count we can use is 200
      //One query consumed to create the scope object; Query consumed=1; Total count=1 
      Master_MBO__c mbo=(Master_MBO__c )s;
      Map<String, MBO_Item__c> mboItms=new Map<String, MBO_Item__c>();
      Map<String, Partner_MBO__c> pMBOPntrMap=new Map<String, Partner_MBO__c>();
      Map<String, String> pMBOItmMap=new Map<String, String>();
      Map<Id, Set<String>> pgPntrIdsMap=new Map<Id, Set<String>>();
      Set<String> allPntrIds=new Set<String>(); 
      Map<Id, MBO_Item__c> idItmMap=new Map<Id, MBO_Item__c>();
      Map<Id, Id> itmIdMboMap=new Map<Id, Id>();
      Map<Id, Partner_MBO__c> updatablePMBOs=new Map<Id, Partner_MBO__c>();
      Map<Id, MBO_Item__c> updatableMBOItms=new Map<Id, MBO_Item__c>();
       
      //Get the Pgm used by Master MBO; Query consumed=1; Total count=2
      MBO_Program__c pgm=[select Name, Id,Track__c from MBO_Program__c where Id=:mbo.MBO_Program__c];
      String pgmName=pgm.Name;
      String trackName=pgm.Track__c;
      String subTrackName=mbo.Sub_Track__c;
      //Get the Enrollement for the Track, Sub Track combination; Query consumed=1; Total count=3
      Map<String, MBO_Partner_Enrollment__c> subTrckPntrs=MBOUtil.getSubTrackEnrllMap(pgmName, trackName, subTrackName);
      
      //Get the Other Master MBO' created for the same Pgm, Track and Sub Track; Query consumed=1; Total count=4
      Map<Id, Master_MBO__c> mboMap=new Map<Id, Master_MBO__c>([select  Name, Id, MBO_Program__c, Sub_Track__c,MBO_Description__c, IsSchdOnce__c
                                     from Master_MBO__c where MBO_Program__c =:pgm.Id and Sub_Track__c=:mbo.Sub_Track__c]);
                                     
      //Get All Partner Id's for the Track used; Query consumed=1; Total count=5
      //MBOUtil.getLvl1PntrIds(pgm, allPntrIds);      
      allPntrIds=subTrckPntrs.keySet();
      
      //Get All the PMBOs for this Track, All MBO Itms including from other Master MBO's
      //Query consumed=1; Total count=8
      MBOUtil.getAllPMBOAndMBOItms(mbo, allPntrIds, pMBOPntrMap, pMBOItmMap, idItmMap, pgmName, trackName); 

      List<MBO_Item__c> itmList=idItmMap.values();
      //Map the MBO Itms to their Partner, PG and againist to which Master MBO
      
      System.debug('***checkk 1:itmList' + itmList);
      for (MBO_Item__c mboItm : itmList) 
      {
        if(mboItm.Partner_Group__c != null)
            mboItms.put(mboItm.Partner_Group__c, mboItm);
          else if(mboItm.Partner__c != null)
            mboItms.put(mboItm.Partner__c, mboItm);   
            
          System.debug('***mboItms' + mboItms );           
          itmIdMboMap.put(mboItm.Id, mboItm.MBO__c);  
          System.debug('***itmIdMboMap' + itmIdMboMap );
      }
      
      //Collect All Pntr Ids; Query consumed=1; Total count=9
      Set<String> pntrIds_del=new Set<String>();
      
      System.debug('***checkk 2:' );
      pgPntrIdsMap=collectLineItmPntrIds(subTrckPntrs, mboItms, allPntrIds, pntrIds_del);      
      
      //Collect All PMBO's This is a reduant part will be removed in next version
      //collectPMBOs(mbo, pMBOPntrMap);
      
      Iterator<String> mboItmItr=mboItms.keySet().iterator();
      
      System.debug('***checkk 3:' );
      while(mboItmItr.hasNext())
      {
        String key=mboItmItr.next();
        MBO_Item__c mboItm=mboItms.get(key);
        
        String mboId=itmIdMboMap.get(mboItm.Id);
        Master_MBO__c currMbo=mboMap.get(mboId);
        
        if(mboItm.Partner_Group__c!=null)
        {
          System.debug('***checkk 4:' );
          Set<String> pntrIds=pgPntrIdsMap.get(mboItm.Partner_Group__c);    
          	//Added on 18 Dec 2012 to avoid exception when set is null
            if(pntrIds==null)
          	{
          	system.debug('pntrIds is null. ');  
          	}
            if(pntrIds!=null)
          	{
			 for (String pntrId:pntrIds)
	          {
	            MBO_Partner_Enrollment__c enrll=subTrckPntrs.get(pntrId);
	            Partner_MBO__c pMBO=null;
	            if(pMBOPntrMap.get(pntrId)!=null)
	            {
	              pMBO=pMBOPntrMap.get(pntrId);
	              String lnItmId=pMBOItmMap.get(pntrId);
	              MBO_Item__c prevMboItm=idItmMap.get(lnItmId);
	              String isOverridable=MBOUtil.isOveridable(prevMboItm, mboItm);
	              if(isOverridable == 'UPD' || isOverridable == 'OVR')
	              {
	                if(mboItm.MBO__c == mbo.Id)
	                {
	                  if(updPMBO(currMbo, pMBO, mboItm, isOverridable))
	                  {
	                    updatablePMBOs.put(pntrId, pMBO);
	                    if(isOverridable == 'OVR')
	                    {
	                      mboItm.Status__c='Scheduled';
	                      idItmMap.put(lnItmId, mboItm);
	                    }
	                    updatableMBOItms.put(mboItm.Id, mboItm);                                      
	                  }
	                }  
	              }
	            }
	            else{
	              if(mboItm.MBO__c == mbo.Id)
	              {
	                pMBO=new Partner_MBO__c();              
	                createPMBO(mbo,  pMbo, mboItm, pntrId, enrll);
	                mboItm.Status__c='Scheduled';
	                updatablePMBOs.put(pntrId, pMBO);
	                pMBOItmMap.put(pntrId,mboItm.Id);
	                updatableMBOItms.put(mboItm.Id, mboItm);
	                pMBOPntrMap.put(pntrId, pMBO);
	              }  
	            }
	            
	          }
          }
          // End of New if(!pntrIds.isEmpty())
        }else if(mboItm.Partner__c!=null)
        {
          System.debug('***checkk 5:' );
          String pntrId=mboItm.Partner__c;
          MBO_Partner_Enrollment__c enrll=subTrckPntrs.get(pntrId);
          Partner_MBO__c pMBO=null;
          if(pMBOPntrMap.get(pntrId)!=null)
          {
            System.debug('***checkk 6:' );
            pMBO=pMBOPntrMap.get(pntrId);
            String lnItmId=pMBOItmMap.get(pntrId);
            MBO_Item__c prevMboItm=idItmMap.get(lnItmId);
            String isOverridable=MBOUtil.isOveridable(prevMboItm, mboItm);
            if(isOverridable == 'UPD' || isOverridable == 'OVR')
            {
              if(mboItm.MBO__c == mbo.Id)
              {
                System.debug('***checkk 7:' );
                if(updPMBO(currMbo, pMBO, mboItm, isOverridable))
                  {
                  updatablePMBOs.put(pntrId, pMBO);
                  if(isOverridable == 'OVR')
                  {
                    mboItm.Status__c='Scheduled';
                    idItmMap.put(lnItmId, mboItm);
                  }
                  updatableMBOItms.put(mboItm.Id, mboItm);                                      
                  }
              }    
            }  
          }
          else{
            if(mboItm.MBO__c == mbo.Id)
            {
              System.debug('***checkk 9:' );
              pMBO=new Partner_MBO__c();              
              createPMBO(mbo,  pMbo, mboItm, pntrId, enrll);
              mboItm.Status__c='Scheduled';
              updatablePMBOs.put(pntrId, pMBO);
              pMBOItmMap.put(pntrId,mboItm.Id);
              updatableMBOItms.put(mboItm.Id, mboItm);
              pMBOPntrMap.put(pntrId, pMBO);
            }  
          }
        }
        
      }
      
      System.debug('***Going to call update with updatableMBOItms:' + updatableMBOItms.values() );
      if(!updatableMBOItms.isEmpty())
      {
      update(updatableMBOItms.values());//if mbo item count is N, will consume N items in DML count limits 
      }
      List<Partner_MBO__c> updatablePMBOsList=new List<Partner_MBO__c>();
            
      System.debug('***Going to add in pmbos list:' + updatablePMBOs.values());
      if(!updatablePMBOs.isEmpty())
      {
      	updatablePMBOsList.addAll(updatablePMBOs.values());	
      }
      
      System.debug('***Going to call upsert with updatablePMBOsList:' +  updatablePMBOsList);
      if(!updatablePMBOsList.isEmpty())
      {
      	upsert(updatablePMBOsList);//if N PMBO's crated or updated, will consume N items in DML count limits
      }
      
      //if(mbo.isSchdOnce__c == null || mbo.isSchdOnce__c != 'YES')
      {
        mbo.isSchdOnce__c='Yes';
        System.debug('***Going to call update with one mbo, mbo:' );
        update(mbo);
      }        
    }
    }
    
   global void finish(Database.BatchableContext BC){
   }
    
    public static void collectPMBOs(Master_MBO__c mbo, Map<String, Partner_MBO__c> pMBOPntrMap){
      System.debug('***Inside collectPMBOs.' );
       Map<String, Partner_MBO__c> pMBOIdMap=new Map<String, Partner_MBO__c>([select Partner__c, MBO_Item__c, Target__c, Status__c,Q1_Target_Percent__c,
                       Q2_Target_Percent__c,Q3_Target_Percent__c,Q4_Target_Percent__c,  FY_Target_Percent__c, Q1_Target__c,
                         Q2_Target__c,Q3_Target__c,Q4_Target__c,FY_Target__c from Partner_MBO__c where 
                       MBO__c=:mbo.Id and Sub_Track__c  =:mbo.Sub_Track__c]);
      if(pMBOIdMap!=null){
        for(Partner_MBO__c pMBO : pMBOIdMap.values()) {
          System.debug('***Check A' );
          pMBOPntrMap.put(pMBO.Partner__c, pMBO);          
        }        
      }
    }
    
    public static Map<Id, Set<String>> collectLineItmPntrIds(Map<String, MBO_Partner_Enrollment__c> subTrckPntrs, Map<String, MBO_Item__c> mboItms, Set<String> allPntrIds, Set<String> pntrIds1){      
      //Query consumed=1
      System.debug('Enetering collectLineItmPntrIds----------------------->1');
      Set<String> keySet=mboItms.keySet();
    Iterator<String> itr=keySet.iterator();
    Map<Id, Set<String>> pgPntrId=new Map<Id, Set<String>>();
    Set<String> pntrGrpIds=new Set<String>();
      
      System.debug('***mboItms.keySet() :'+ mboItms.keySet());
      System.debug('***allPntrIds :' + allPntrIds);
      while(itr.hasNext())
    {
      String key=itr.next();
      MBO_Item__c mboItm=mboItms.get(key);
        System.debug('***mboItm  :'+ mboItm);
         Set<String> pntrIds=new Set<String>();
         Set<String> allPntrIdsPeriod =new Set<String>();
        //Collection of Pntr Ids for all PG's and Pntrs in the Line Item starts
        //if(mboItm.IsModified__c == null || mboItm.IsModified__c == 'YES')
      {
        //Now check whether Line Item has PG or Pntr 
        if(mboItm.Partner_Group__c != null )
        {
          System.debug('***mboItm.Partner_Group__c is not null');
          
          if(mboItm.Partner_Group__r.Group_Level__c == 'TRACK' )
          {
            //MBOUtil.collectCommaSepPntrIds(mboItm,pntrIds);
            System.debug('***mboItm.Partner_Group__r.Group_Level__c is Track');
            for(String pntrIdVar:allPntrIds)
            {
                System.debug('***Partner id is : '+ pntrIdVar);
                MBO_Partner_Enrollment__c enrllRec=subTrckPntrs.get(pntrIdVar);
                
              if(enrllRec.Enrollment_Period__c.format() == mboItm.Partner_Group__r.Enrollment_Period__c  )
              {  
                
                System.debug('***Inside If and Enroll Period is same for enrollment and partner Group  ');
                allPntrIdsPeriod.add(pntrIdVar);
                System.debug('*** now after adding element allPntrIdsPeriod list is   :' + allPntrIdsPeriod);
              }
            }
            
            System.debug('***allPntrIdsPeriod  Final List is:' + allPntrIdsPeriod);
            
            //commented below line as allPntrIds contains both 12 motnhs and 6 months enrollment. 
            //But with new requirment now track level group can exist with 2 types: 12 and 6 months. So for 12 months we need enrollments which are enrolled for 
            // 12 months and same with 6 months.
            //pgPntrId.put(mboItm.Partner_Group__c, allPntrIds);
            pgPntrId.put(mboItm.Partner_Group__c, allPntrIdsPeriod);
          }else{
            //For Level 2 PG's MBOUtil.getLvl2PntrIds method is used.
            pntrGrpIds.add(mboItm.Partner_Group__c);
          }
        }
        else if(mboItm.Partner__c != null)
        {
          //If its partner adding directly into the pntrIds 
          System.debug('***before adding anything pntrIds:' + pntrIds);
          pntrIds.add(mboItm.Partner__c);
          System.debug('***After adding anything pntrIds:' + pntrIds);
        }
      }
    }  
    //Collect the PntrsIds for PG's(esp in this it will level2 grps )
    if(pntrGrpIds.size()>0)
    {
      System.debug('***Going to call Util getLvl2PntrIds:' );
      MBOUtil.getLvl2PntrIds(pntrGrpIds,pgPntrId,subTrckPntrs); 
    }
    //Collection of Pntr Ids for all PG's and Pntrs in the Line Item ends
    return pgPntrId;
    }
    
    
   private static void createPMBO(Master_MBO__c mbo,  Partner_MBO__c pMbo, MBO_Item__c mboItem, String accId, MBO_Partner_Enrollment__c enrll)
   {
       System.debug('***INside createPMBO' );
        pMbo.Linitm_Id__c=mboItem.Id;
        pMbo.MBO_Item__c=mboItem.Id;
        pMbo.Name=mbo.Name;
        pMbo.MBO_Description__c=mbo.MBO_Description__c;                        
        pMbo.Partner__c=accId;                     
        pMbo.Measure_Unit__c=mboItem.Measure_Unit__c;
        pMbo.Segment__c=mboItem.Segment__c;
        pMbo.Objective__c=mboItem.Objective__c;   
        pMbo.Sub_Track__c=mbo.Sub_Track__c;
        
        if(pMbo.Measure_Unit__c == '%')
        {
          pMbo.FY_Target_Percent__c =  mboItem.Target__c;
          pMbo.Q1_Target_Percent__c=mboItem.Q1_Target_Percent__c;
          pMbo.Q2_Target_Percent__c=mboItem.Q2_Target_Percent__c;
          pMbo.Q3_Target_Percent__c=mboItem.Q3_Target_Percent__c;
          pMbo.Q4_Target_Percent__c=mboItem.Q4_Target_Percent__c;
         }
        pMbo.MBO__c=mboItem.MBO__c;
        if(enrll!=null)
        pMbo.MBO_Partner_Enrollment__c=enrll.Id;
        mboItem.Status__c='Scheduled';
   } 
 
    private static boolean updPMBO(Master_MBO__c mbo, Partner_MBO__c pMBO, MBO_Item__c mboItem, String isOverridable)
    {
      System.debug('***INside updPMBO' );
      boolean hasUpdated=false;
         if((isOverridable == 'UPD' && pMbo.Status__c != 'Target_Calc_InProgress') || (isOverridable == 'OVR'))
         {
            if(mboItem.Target__c != pMbo.FY_Target_Percent__c || mboItem.Q1_Target_Percent__c != pMbo.Q1_Target_Percent__c || mboItem.Q2_Target_Percent__c != pMbo.Q2_Target_Percent__c || mboItem.Q3_Target_Percent__c != pMbo.Q3_Target_Percent__c  || mboItem.Q4_Target_Percent__c != pMbo.Q4_Target_Percent__c){                               
              {
                pMbo.Measure_Unit__c=mboItem.Measure_Unit__c;
                if(pMbo.Measure_Unit__c == '%')
                    {
                      pMbo.FY_Target_Percent__c =  mboItem.Target__c;
                      pMbo.Q1_Target_Percent__c=mboItem.Q1_Target_Percent__c;
                      pMbo.Q2_Target_Percent__c=mboItem.Q2_Target_Percent__c;
                      pMbo.Q3_Target_Percent__c=mboItem.Q3_Target_Percent__c;
                      pMbo.Q4_Target_Percent__c=mboItem.Q4_Target_Percent__c;
                      
                      pMbo.FY_Target__c =null;
                      pMbo.Q1_Target__c=null;
                      pMbo.Q2_Target__c=null;
                      pMbo.Q3_Target__c=null;
                      pMbo.Q4_Target__c=null;
                    }
                 pMbo.Status__c=null;   
                 hasUpdated=true;                              
              }                              
            }
         }
        
       if(pMbo.MBO_Item__c != mboItem.Id || pMbo.Name!=mbo.Name || pMbo.MBO_Description__c!=mbo.MBO_Description__c || pMbo.Segment__c!=mboItem.Segment__c || pMbo.Objective__c!=mboItem.Objective__c)  
       {
           pMbo.MBO_Item__c=mboItem.Id;
           pMbo.Name=mbo.Name;
           pMbo.MBO_Description__c=mbo.MBO_Description__c;
           pMbo.Segment__c=mboItem.Segment__c;
           pMbo.Objective__c=mboItem.Objective__c;
           hasUpdated=true;
       }
       return hasUpdated;     
    }     
}