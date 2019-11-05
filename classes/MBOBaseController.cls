public class MBOBaseController{
   
    //This class acts as controller class for MBO Admin and MBO Master Add/Edit page
    public MBOBaseController(ApexPages.StandardController controller) {
        Id id = ApexPages.currentPage().getParameters().get('id');
        // I think we need to add Partner_Group__c field as well, added Type already         
        if(id == null){
            bMbo =  new Master_MBO__c ();
            lineItemWrp=new LineItemWrapper[]{};
            MBO_Item__c bMboItem=new MBO_Item__c();      
            pgsMap= new Map<Id, MBO_Partner_Group__c>();   
            lineItemWrp.add(new LineItemWrapper(bMboItem, pgsMap));             
         }else{
            if(pgCnt==null)
            pgCnt=0;
            pgCnt++;
            bMbo = [SELECT Name,Status__c,MBO_Description__c, isSchdOnce__c,MBO_Program__c, MBO_Program__r.Name, MBO_Program__r.Track__c, Sub_Track__c FROM Master_MBO__c WHERE id = :id];         
            MBO_Program__c pgm=[select Id,Name,Track__c from MBO_Program__c where Id=:bMbo.MBO_Program__c];
            program=pgm.Name;
            track=pgm.Track__c;
            hiddenTrack=pgm.Track__c;
            pgsMap= new Map<Id, MBO_Partner_Group__c>([select Id from MBO_Partner_Group__c where MBO_Program__r.Track__c=:track]);
            //lineItemWrp = new LineItemWrapper[]{};
            for( MBO_Item__c item: [SELECT Segment__c,Objective__c,Measure__c,Target__c,Name,MBO__c,
                Q1_Target_Percent__c,Q2_Target_Percent__c,Q3_Target_Percent__c,Q4_Target_Percent__c, Measure_Unit__c,
                Partner_Group__c,Partner_Information__c, Status__c, Type__c, Partner__c   
                FROM MBO_Item__c WHERE MBO__c = :bMbo.id]) {
                lineItemWrp.add( new LineItemWrapper(item, pgsMap) );  
            }   
          } 
    }    

    List<LineItemWrapper> lineItemWrp= new List<LineItemWrapper>();
    public List<LineItemWrapper> getLineItemWrp(){
        return lineItemWrp;
    }
    public Master_MBO__c bMbo {get; private set;}
    private List<MBO_Item__c> bMboItms {get; private set;}
    private List<Master_MBO__c> mboList {get; private set;}   
    private List<MBO_Program__c> mboPgmList {get; private set;}
    public Map<Id, MBO_Partner_Group__c> pgsMap {get; private set;}
     
     
    public ID batchprocessid; 
     
    public MBOBaseController() {
        Id id = ApexPages.currentPage().getParameters().get('id');
        if(id == null){
         bMbo =  new Master_MBO__c ();
         lineItemWrp=new LineItemWrapper[]{};
         MBO_Item__c bMboItem=new MBO_Item__c();    
         pgsMap= new Map<Id, MBO_Partner_Group__c>();     
         lineItemWrp.add(new LineItemWrapper(bMboItem, pgsMap));
         }else{
            bMbo = [SELECT Name,Status__c,MBO_Description__c, isSchdOnce__c,MBO_Program__c, MBO_Program__r.Track__c,  
                    MBO_Program__r.Name, Sub_Track__c FROM Master_MBO__c WHERE id = :id];         
            MBO_Program__c pgm=[select Id,Name,Track__c from MBO_Program__c where Id=:bMbo.MBO_Program__c];
            program=pgm.Name;
            track=pgm.Track__c;
            pgsMap= new Map<Id, MBO_Partner_Group__c>([select Id from MBO_Partner_Group__c where MBO_Program__r.Track__c=:track]);
            hiddenTrack=pgm.Track__c;
            //lineItemWrp = new LineItemWrapper[]{};
            for( MBO_Item__c item: [SELECT Segment__c,Objective__c,Measure__c,Target__c,Name,MBO__c,
                Q1_Target_Percent__c,Q2_Target_Percent__c,Q3_Target_Percent__c,Q4_Target_Percent__c, Measure_Unit__c,
                Partner_Group__c,Partner_Information__c, Status__c, Type__c, Partner__c  
                FROM MBO_Item__c WHERE MBO__c = :bMbo.id]) {
            lineItemWrp.add( new LineItemWrapper(item, pgsMap) );  
            }          
          } 
    }       
    
    //Retrieves the Mastre MBO for MBo Admin Tab
    public List<Master_MBO__c> getBMBOList() {
        mboList = [SELECT Name,Status__c,MBO_Description__c,
          Sub_Track__c
        FROM Master_MBO__c];
        return mboList ;
    }
    
    public List<MBO_Program__c> getPgmList() {
        mboPgmList=[select Name from MBO_Program__c  ];
        return mboPgmList;
    }
    
    public Master_MBO__c getBMBO() {
        Id id = ApexPages.currentPage().getParameters().get('id');
        bMbo = (id == null) ? new Master_MBO__c () : 
        [SELECT Name,Status__c,MBO_Description__c,
          Sub_Track__c
        FROM Master_MBO__c WHERE id = :id];
        return bMbo;
    }
    
     public List<LineItemWrapper> getBMBOItem() {              
        return lineItemWrp;
    }
    
    public List<Master_MBO__c> getMBOList() {
        mboList=[SELECT Name, Status__c, MBO_Description__c,
         CreatedById FROM Master_MBO__c];
        return mboList;
    }
    
    //Creates new MBO Line Item when user clicks new Assignment button
    public PageReference newBMBOItem() { 
        String returnURL='/apex/MBOBaseAddEdit?id='+bMbo.id;
        MBO_Item__c bMboItem = new MBO_Item__c();
        //LineItemWrapper lineItemWrpr=new LineItemWrapper(bMboItem, pgsMap);
        //lineItemWrp.add(lineItemWrpr);        
         if(lineItemWrp != null && lineItemWrp.size() <= 20)
        {
            LineItemWrapper lineItemWrpr=new LineItemWrapper(bMboItem, pgsMap);
            lineItemWrp.add(lineItemWrpr);
        }else if(lineItemWrp != null && lineItemWrp.size() > 20){   
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO , 'Can\'t add more than 20 Line Items'));            
        }
        return new ApexPages.Pagereference(returnURL);
    }
    
    public PageReference deleteBMBOItem() { 
        Integer i=0;
        if(lineItemWrp != null)        
        {
            MBO_Program__c pgm=[select Name,Track__c from MBO_Program__c where Id =:bMbo.MBO_Program__c];           
            Set<String> pgids=new Set<String>();
            Set<MBO_Item__c> mboItemId=new Set<MBO_Item__c>();
            List<LineItemWrapper> sltdLineItemWrp= new List<LineItemWrapper>(); 
            for(LineItemWrapper lineItemWrpr: lineItemWrp){
                if(lineItemWrpr != null && lineItemWrpr.selected != null && lineItemWrpr.selected){
                     mboItemId.add(lineItemWrpr.mboItem);
                     if(lineItemWrpr.mboItem.Type__c != null && lineItemWrpr.mboItem.Type__c == 'Partner Group' && lineItemWrpr.mboItem.Partner_Group__c != null)
                        pgids.add(lineItemWrpr.mboItem.Partner_Group__c);
                     else if(lineItemWrpr.mboItem.Type__c != null && lineItemWrpr.mboItem.Type__c == 'Partners' && lineItemWrpr.mboItem.Partner__c != null)
                        pgids.add(lineItemWrpr.mboItem.Partner__c);           
                }
                else{
                     sltdLineItemWrp.add(lineItemWrpr);
                }
            }
            
            List<MBO_Item__c> itmList=[select Id from MBO_Item__c where Id in:mboItemId];
            //SCAVA FIX
            if (MBO_Item__c.sObjectType.getDescribe().isDeletable())
               {
                    delete(itmList);
                 }
            if(itmList.size()>1)
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO , 'Assignments deleted successfully'));
            else if(itmList.size() == 1)
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO , 'Assignment deleted successfully'));
            updPGUsage(pgids, 'DELETE', bMbo, pgm.Name, pgm.Track__c);
            lineItemWrp=sltdLineItemWrp;
        }    
        String returnURL='/apex/MBOBaseAddEdit?id='+bMbo.id;
        return new ApexPages.Pagereference(returnURL);
    }    
    
    public PageReference getSelected() {
        return null;
    }
    
    public PageReference scheduleAssignments(){
        boolean isValid=valAndSave();
        if(isValid == true)
        {
            //MBOUtil.lineItemPntrIds(bMbo);
            System.debug('Calling job to execute');
            String query='select Name, id, isSchdOnce__c,Status__c,MBO_Description__c,Sub_Track__c,MBO_Program__c from Master_MBO__c where id=\''+bMbo.id+'\'';
            MBONewBatchJob  pgmBatchJob=new MBONewBatchJob(query);
            batchprocessid = Database.executeBatch(pgmBatchJob);
            System.debug('JobId:'+batchprocessid );
            
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO , 'Assignments scheduled successfully'));   
        }                      
        String returnURL='/apex/MBOBaseAddEdit?id='+bMbo.id;
        return new ApexPages.Pagereference(returnURL);
    }
    

     public boolean valAndSave(){
        if(lineItemWrp != null && lineItemWrp.size()>0)
        {
            upsert bMbo;
            MBO_Program__c pgm=[select Name, Track__c from MBO_Program__c where Id =:bMbo.MBO_Program__c];
            if(pgsMap == null || pgsMap.size() == 0 )
            {
                pgsMap= new Map<Id, MBO_Partner_Group__c>([select Id from MBO_Partner_Group__c where MBO_Program__r.Track__c=:pgm.Track__c ]);
            }   
            
           Map<Id,MBO_Item__c> mboItmMap=new Map<Id,MBO_Item__c>([SELECT Partner_Group__c,Partner_Information__c, Status__c, Type__c, Partner__c  
                FROM MBO_Item__c WHERE MBO__c = :bMbo.id]);
            
            
            Set<String> pgIds=new Set<String>();
            Set<String> unUsedPGIds=new Set<String>();
            for(LineItemWrapper lineItemWrp1: lineItemWrp) {
                String errorMsg=validateItemTrgt(lineItemWrp1.mboItem, pgsMap);
                if(errorMsg == null)
                errorMsg=valPGUsage(lineItemWrp1, pgIds, pgsMap);
                
              if(errorMsg == null)
              {
                 if(mboItmMap.get(lineItemWrp1.mboItem.Id)!=null)
                    {
                        MBO_Item__c oldItmRec=mboItmMap.get(lineItemWrp1.mboItem.Id);
                        if(lineItemWrp1.mboItem.Type__c =='Partners')
                        {
                            if(lineItemWrp1.mboItem.Partner__c != oldItmRec.Partner__c )
                            {
                                unUsedPGIds.add(oldItmRec.Partner__c);
                            }
                        }
                        else if(lineItemWrp1.mboItem.Type__c =='Partner Group')
                        {
                            if(lineItemWrp1.mboItem.Partner_Group__c != oldItmRec.Partner_Group__c )
                            {
                                unUsedPGIds.add(oldItmRec.Partner_Group__c);
                            }
                        }   
                    }
                 if(lineItemWrp1.mboItem.MBO__c == null)
                 {
                        lineItemWrp1.mboItem.MBO__c=bMbo.Id;
                 } 
                upsert lineItemWrp1.mboItem;
              }
              else
              {
                if(pgIds.size()>0)
                 updPGUsage(pgIds,'UPDATE', bMbo, pgm.Name, pgm.Track__c);
                 
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO , 'Changes are not saved, Please review the errors shown below'));
                return false;
              }      
            }
            if(pgIds.size()>0)
              updPGUsage(pgIds,'UPDATE', bMbo, pgm.Name, pgm.Track__c);
            if(unUsedPGIds.size()>0)
             updPGUsage(unUsedPGIds,'DELETE', bMbo, pgm.Name, pgm.Track__c);
              
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO , 'Saved successfully'));
        }else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO , 'Atleast one Target Assignment is required to save or schedule')); 
            return false;               
        }  
        return true;
     }

     public PageReference save(){
        String returnURL='';
        String debugMsg=''; 
        
        if(lineItemWrp != null && lineItemWrp.size()>0)
        {
            upsert bMbo;
            MBO_Program__c pgm=[select Name,Track__c from MBO_Program__c where Id =:bMbo.MBO_Program__c];
            if(pgsMap == null || pgsMap.size() == 0 )
            {
                pgsMap= new Map<Id, MBO_Partner_Group__c>([select Id from MBO_Partner_Group__c where MBO_Program__r.Track__c=:pgm.Track__c ]);
            }   
            
            Map<Id,MBO_Item__c> mboItmMap=new Map<Id,MBO_Item__c>([SELECT Partner_Group__c,Partner_Information__c, Status__c, Type__c, Partner__c  
            FROM MBO_Item__c WHERE MBO__c = :bMbo.id]);
            
            
            Set<String> pgIds=new Set<String>();
            Set<String> unUsedPGIds=new Set<String>();          
            for(LineItemWrapper lineItemWrp1: lineItemWrp) {
                String errorMsg=validateItemTrgt(lineItemWrp1.mboItem, pgsMap); 
                if(errorMsg==null)
                errorMsg=valPGUsage(lineItemWrp1, pgIds, pgsMap);
                
                if(lineItemWrp1.mboItem.MBO__c == null)
                 {
                      lineItemWrp1.mboItem.MBO__c=bMbo.Id;
                 }   
              if(errorMsg == null)
               {
                 if(mboItmMap.get(lineItemWrp1.mboItem.Id)!=null)
                    {
                        MBO_Item__c oldItmRec=mboItmMap.get(lineItemWrp1.mboItem.Id);
                        if(lineItemWrp1.mboItem.Type__c =='Partners')
                        {
                            if(lineItemWrp1.mboItem.Partner__c != oldItmRec.Partner__c )
                            {
                                unUsedPGIds.add(oldItmRec.Partner__c);
                            }
                        }
                        else if(lineItemWrp1.mboItem.Type__c =='Partner Group')
                        {
                            if(lineItemWrp1.mboItem.Partner_Group__c != oldItmRec.Partner_Group__c )
                            {
                                unUsedPGIds.add(oldItmRec.Partner_Group__c);
                            }
                        }   
                    }
                upsert lineItemWrp1.mboItem;
               }
              else
              {
                if(pgIds.size()>0)
                 updPGUsage(pgIds,'UPDATE', bMbo,pgm.Name, pgm.Track__c);
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO , 'Please review the errors shown below to save the changes'));
                 returnURL='/apex/MBOBaseAddEdit?id='+bMbo.id;
                return new ApexPages.Pagereference(returnURL);
              }      
            }
                if(pgIds.size()>0)
                 updPGUsage(pgIds,'UPDATE', bMbo,pgm.Name, pgm.Track__c);
                if(unUsedPGIds.size()>0)
                 updPGUsage(unUsedPGIds,'DELETE', bMbo,pgm.Name, pgm.Track__c);
                 
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO , 'Saved successfully'));
            returnURL='/apex/MBOBaseAddEdit?id='+bMbo.id;
        }
        else
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO , 'Atleast one Target Assignment is required to save'));
            returnURL='/apex/MBOBaseAddEdit?id='+bMbo.id;                               
        }  
        returnURL='/apex/MBOBaseAddEdit?id='+bMbo.id;       
        return new ApexPages.Pagereference(returnURL);
     }

     //Update the count of PG usage 
     public static void updPGUsage(Set<String> pgIds, String updType, Master_MBO__c bMbo, String pgmName, String trackName)
     {
        String subTrackName=bMbo.Sub_Track__c;
        //String trackName=bMbo.MBO_Program__r.Track__c;
        //String pgmName=bMbo.MBO_Program__r.Name;
        
        List<MBO_Partner_Group__c> pgList=[select Id, UsedBy__c from MBO_Partner_Group__c where Id in: pgIds];
        for(MBO_Partner_Group__c pg:pgList)
        {
            if(updType.equalsIgnoreCase('UPDATE') && (pg.UsedBy__c == null || !pg.UsedBy__c.contains(subTrackName)))
                if(pg.UsedBy__c==null)
                    pg.UsedBy__c=subTrackName;
                else
                    pg.UsedBy__c=pg.UsedBy__c+subTrackName;
            else if(updType.equalsIgnoreCase('DELETE'))
                {
                    system.debug('***pg.UsedBy__c11'+pg.UsedBy__c);
                    
                    if(pg.UsedBy__c != null && pg.UsedBy__c != '')
                    {
                        system.debug('***pg.UsedBy__c'+pg.UsedBy__c);
                        if(pg.UsedBy__c.contains(subTrackName))
                        {
                            system.debug('***pg.UsedBy__c'+pg.UsedBy__c);
                            pg.UsedBy__c=pg.UsedBy__c.replaceAll(subTrackName,'').trim();
                        }
                    }
                }               
        }
        update(pgList);
        
        List<MBO_Partner_Enrollment__c> pntrList=[select Id, Used_Count__c from MBO_Partner_Enrollment__c where Partner__c in: pgIds and
        Track_Name__c=:trackName and Program_Name__c=:pgmName and SubTrack_Name__c =:subTrackName];
        for(MBO_Partner_Enrollment__c pntr:pntrList)
        {           
            if(updType.equalsIgnoreCase('UPDATE'))
                pntr.Used_Count__c=1;
            else
                pntr.Used_Count__c=null;
        }
        update(pntrList);
     }        
     //Only once PG's can be assigned through out the Program 
     public static String valPGUsage(LineItemWrapper lineItemWrp, Set<String> pgIds, Map<Id, MBO_Partner_Group__c> pgsMap)
     {
        String errorMsg=null; 
        ID idVal = null;
        if(lineItemWrp.mboItem.Type__c != null && lineItemWrp.mboItem.Type__c == 'Partner Group' )
        { 
            if(lineItemWrp.mboItem.Partner_Group__c !=null)
            {
                
                if(pgIds.contains(lineItemWrp.mboItem.Partner_Group__c))
                {
                    lineItemWrp.errMsg='An Assignement already exist for this Partner Group.';  
                    errorMsg='One of the Partner Group has more than one assignment';
                }
                else if(pgsMap.get(lineItemWrp.mboItem.Partner_Group__c)==null)
                {
                    lineItemWrp.errMsg='An Assignement already exist for this Partner Group.';
                    errorMsg='Not a Valid Partner Group for the selected Program';
                }
                else
                {
                    pgIds.add(lineItemWrp.mboItem.Partner_Group__c);
                }
            }
            else{
                    lineItemWrp.errMsg='Not a Valid Partner Group.';    
                    errorMsg='Not a Valid Partner Group.';
            }                           
        }       
        else
        {
            if(lineItemWrp.mboItem.Partner__c != null)
            {
                if(pgIds.contains(lineItemWrp.mboItem.Partner__c))
                {
                    lineItemWrp.errMsg='An Assignement already exist for this Partner.';
                    errorMsg='One of the Partner has more than one assignment';
                }
                else
                {
                    pgIds.add(lineItemWrp.mboItem.Partner__c);
                }
            }else{              
                    lineItemWrp.errMsg='Not a Valid Partner';
                    errorMsg='Not a Valid Partner';
            }
        }
        return errorMsg;
     }
     
      public MBO_Item__c[] getBMBOItems() {
           bMboItms =[SELECT Segment__c,Objective__c,Measure__c,Target__c,Name,MBO__c
          FROM MBO_Item__c ];
        return bMboItms;
    }
    
    //Validating MBO Line Items before Save or Schedule Assignments
    public static String validateItemTrgt(MBO_Item__c mboItem, Map<Id, MBO_Partner_Group__c> pgsMap) {
        
        if(mboItem.Target__c !=null && mboItem.Q1_Target_Percent__c!=null && mboItem.Q2_Target_Percent__c != null && mboItem.Q3_Target_Percent__c!=null && mboItem.Q4_Target_Percent__c != null)
        {
            if( mboItem.Q1_Target_Percent__c < 0 || mboItem.Q2_Target_Percent__c < 0 || mboItem.Q3_Target_Percent__c < 0 || mboItem.Q4_Target_Percent__c < 0)
            {
                return 'Target Percentage cannot be negative';
            }
            if(mboItem.Target__c == 0 && ((mboItem.Q1_Target_Percent__c + mboItem.Q2_Target_Percent__c + mboItem.Q3_Target_Percent__c + mboItem.Q4_Target_Percent__c) > 0))
            {
                return 'Fiscal Target percentage is 0';
            }
            if((mboItem.Q1_Target_Percent__c+mboItem.Q2_Target_Percent__c+mboItem.Q3_Target_Percent__c+mboItem.Q4_Target_Percent__c) != 100.00)
            {
                return 'Sum of Target % should be 100, current sum is '+(mboItem.Q1_Target_Percent__c+mboItem.Q2_Target_Percent__c+mboItem.Q3_Target_Percent__c+mboItem.Q4_Target_Percent__c);
            }
        }   
        
        if(pgsMap.size()>0 && mboItem.Partner__c==null)
        {
            //pgsMap.get(mboItem.Partner_Group__c);
            if(mboItem.Partner_Group__c != null && pgsMap.get(mboItem.Partner_Group__c) == null)
            {
              return 'Not a Valid Partner Group for the selected Program, please delete the Line Item or chose the correct Program';                
            }
        }
        
        return null; 
    }
    
    public void exeCalJob() {
       // MBOPgmCalJob mBOPgmCalJob=new MBOPgmCalJob();
        //mBOPgmCalJob.execute();
        System.debug('Calling job to execute');
        String query='select Name, id, Status__c from Master_MBO__c where Master_MBO__c.status__c=:\'Active For Assignment\'';
        //MBOPgmCalBatchJob pgmBatchJob=new MBOPgmCalBatchJob(query);
        //batchprocessid = Database.executeBatch(pgmBatchJob);
        //System.debug('JobId:'+batchprocessid );
        //return null;
    }       
    
    //Sets the headers for the MBO ITEM tables        
    public string[] getheaders() { 
        if(lineItemWrp==null || (lineItemWrp !=null && lineItemWrp.size() == 0))
        {           
            return new string [] {};
        }else
        return new string [] {'','Segment','Measure Unit','Objective','Target','Q1','Q2','Q3','Q4','Type','Partner/Partner Group'} ; }

    public String selectedValue{get;set;}
    
    //Wrapper around MBO Line Item to enable checkbox selection, display error message for each line item in the MBO Line section
    public class LineItemWrapper{ 
       boolean selected;
       String errMsg;
       String anyPMBOUndrCalc;       
       Decimal dd;
       MBO_Item__c  mboItem; 
       Map<Id, MBO_Partner_Group__c> pgsMap;
       public LineItemWrapper(MBO_Item__c item, Map<Id, MBO_Partner_Group__c> lclPgsMap) {
        mboItem=item;
        pgsMap=lclPgsMap;
        }           
       public MBO_Item__c  getMBOItem() { return mboItem; }
       public Map<Id, MBO_Partner_Group__c>  getPgsMap() { return pgsMap; }    
       public boolean getSelected() { return selected; }
       public String getErrMsg() { 
       String trgtErrMsg=validateItemTrgt(mboItem, pgsMap);
       if(trgtErrMsg != null)
       {
           errMsg=trgtErrMsg;
           return errMsg;
       } 
       else{
         errMsg=null;
       }          
        return errMsg; }
        
      public String getAnyPMBOUndrCalc() 
      { 
        Integer pmboCnt=[Select count() From Partner_MBO__c p where p.Status__c='Target_Calc_InProgress' and p.MBO_Item__c =: mboItem.Id ];
        
        if( mboItem.Id != null && pmboCnt>0) 
         return 'true';
         
        return 'false'; 
      }
        
       public void setSelected(boolean sb) { selected = sb; }
       
    }
    
    public String program {get; public set;}
    public String track {get; public set;}
    public String hiddenTrack {get; public set;}
    public static Integer pgCnt {get; public set;}
    
}