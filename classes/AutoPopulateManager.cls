/**
   @Author :Jay Dash
   @name :AutoPopulateManager
   @CreateDate : 16/10/2014
   @Description :Auto populate manager fields in pov detail page
   @Version :1.0
   
  */
  
global class AutoPopulateManager{ 
   public static void autoPopulate(List<Proof_of_Value__c> pst){
   
           Set<Id> povid = new Set<Id>();
               for(Proof_of_Value__c pov : pst){
                   povid.add(pov.Lead_SE__c);
                   povid.add(pov.Security_AM__c);
                      
               }
                
               List<user> users = new List<User>([Select id,username,Email,Manager_s_Email_Address__c from user where Id IN  :povid and IsActive=true]);
               if(!users.isEmpty()){
               String extn = users[0].username.substringAfter('@cisco.com');//To check SFDC user is from sandbox(.pov or .qtr or etc..) or production
                
                
               MAP<String ,String > mapov = new MAP<String , String>();   
               for(user u : users){
                   mapov.put(u.id, u.Manager_s_Email_Address__c);
                              
               }
              
               Set<String> povidlkp = new Set<String>();
               for(Proof_of_Value__c pv : pst){
                                
                   povidlkp.add(mapov.get(pv.Security_AM__c)+extn);
                   povidlkp.add(mapov.get(pv.Lead_SE__c)+extn);
                   
               }
               
               
               List<user> userslkp = [Select id,username,Email,Manager_s_Email_Address__c from user where username IN  :povidlkp and IsActive=true];
               MAP<String ,String > mapovlkp = new MAP<String , String >();
               MAP<String ,String > mapODmgrlkp = new MAP<String , String >();
               for(user u : userslkp){
                   mapovlkp.put(u.username, u.id);
                   mapODmgrlkp.put(u.id,u.Manager_s_Email_Address__c);   
                                         
                }
                
                
                for(Proof_of_Value__c p:pst){
                    
                    if((mapovlkp.get(mapov.get(p.Lead_SE__c)+extn)!=null))  {    
                        p.Security_SE_MGR__c=mapovlkp.get(mapov.get(p.Lead_SE__c)+extn);
                                        
                    }
                    else{
                        p.Security_SE_MGR__c=null;
                    
                    }
                    
                    
                    if((mapovlkp.get(mapov.get(p.Security_AM__c)+extn)!=null))  {
                        p.Security_RM__c=mapovlkp.get(mapov.get(p.Security_AM__c)+extn);
                        
                    }
                    else{
                        p.Security_RM__c=null;
                    
                    }
                    
                    String u3=mapODmgrlkp.get(mapovlkp.get(mapov.get(p.Security_AM__c)+extn))+extn;
                    
                    if(u3!=null){
                        try{
                            list<user> u1 = [select username,id from user where username =: u3 and IsActive=true];
                                                   
                            if(!u1.isEmpty()){
                                p.Security_OD__c=u1[0].id;
                            }
                            else{
                                p.Security_OD__c=null;
                        
                            }
                        }
                        catch(DmlException e) {
                                System.debug('user not available : ' + e.getMessage());
                        }
                    }
                    else{
                            p.Security_OD__c=null;
                        }
                }
             }
      }
     public static void submitForApproval(List<Proof_of_Value__c> lstPovNew, Map<Id,Proof_of_Value__c> mapPovOld){
        String loggedinUserId=  UserInfo.getUserId() ;
        String povUserId = Utilities.getConstant_CS('EULA_POC_User');
        List<String> povUserIdList = povUserId.split(',');
        Set<String> povUserIdSet = new Set<String>();
        for(String each :  povUserIdList ){
          povUserIdSet.add(each);         
        }  
        system.debug('!!!!!povUserIdSet!!!' + povUserIdSet + 'loggedinUserId==>'+loggedinUserId);
       
        if(povUserIdSet.contains(loggedinUserId) || povUserId == 'All' ){   
            List<Approval.ProcessSubmitRequest> approvalReqList=new List<Approval.ProcessSubmitRequest>();
            List<ProcessInstance> lstProcessInstance= [Select Id, TargetObjectId, Status From ProcessInstance WHERE TargetObjectId IN: lstPovNew];
            map<id,ProcessInstance> lstPendingApr =  new map<id,ProcessInstance>();
           for(ProcessInstance pins : lstProcessInstance){                
                if(pins.Status == 'Pending'){
                    System.debug('***pins.Status--' + pins.Status);
                    lstPendingApr.put(pins.TargetObjectId,pins);
                }           
            }
            String povCategory = Utilities.getConstant_CS('EULA_POV_Order_Category');
            List<String> povCateList = povCategory.split(',');
            Set<String> povCategorySet = new Set<String>();
            for(String each: povCateList){
                povCategorySet.add(each);
            }
            for(Proof_of_Value__c each : lstPovNew){
             system.debug('!!!!!each PoV_Order_Category__c--!!!' + each.PoV_Order_Category__c + '--each.POV_Status__c--' + each.POV_Status__c ); 
                if(((each.EULA_Status__c != mapPovOld.get(each.Id).EULA_Status__c) 
                    && (each.EULA_Status__c == Utilities.getConstant_CS('EULA_Status')) && (each.POV_Status__c != 'POV Approved') && (povCategorySet.contains(each.PoV_Order_Category__c)))){
                   system.debug('INSIDE SUBMIT FOR APPROVAL------' + each.POV_Status__c + '--old--' + mapPovOld.get(each.Id).POV_Status__c );
                   Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                   System.debug('@@@@' + lstPendingApr.containsKey(each.id));
                    if(!lstPendingApr.containsKey(each.id)){
                       System.debug('@@@@');
                       req1.setObjectId(each.id);
                       approvalReqList.add(req1);
                    }
                }
            }
            if(!approvalReqList.isEmpty()){
                List<Approval.ProcessResult> resultList = Approval.process(approvalReqList);
            }   
        }
    }    
     webservice static String submitForApproval_NonSec(String recID){
         List<Proof_of_Value__c> povRec = [select Name,Id,PoV_Order_Category__c,POV_Status__c  from Proof_of_Value__c where Id = : recID];
         List<Approval.ProcessSubmitRequest> approvalReqList=new List<Approval.ProcessSubmitRequest>();
            List<ProcessInstance> lstProcessInstance= [Select Id, TargetObjectId, Status From ProcessInstance WHERE TargetObjectId IN: povRec];
            map<id,ProcessInstance> lstPendingApr =  new map<id,ProcessInstance>();
           for(ProcessInstance pins : lstProcessInstance){                
                if(pins.Status == 'Pending'){
                    System.debug('***pins.Status--' + pins.Status);
                    lstPendingApr.put(pins.TargetObjectId,pins);
                }           
            }
         for(Proof_of_Value__c each : povRec){
            Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
             if(!lstPendingApr.containsKey(each.id)){
                           req1.setObjectId(each.id);
                           approvalReqList.add(req1);
              }
         }
         if(!approvalReqList.isEmpty()){
                List<Approval.ProcessResult> resultList = Approval.process(approvalReqList);
         } 
         
         return '1';
     }   
}