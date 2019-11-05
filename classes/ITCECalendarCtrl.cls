/*************************************************************************************
 * Name : ITCECalendarCtrl
 * Description : Apex controller for the ITCE calendar implemented. the calendar shows
 *                               all engagements of a presenter 
 * Author : Aditya S
 * Created Date : Feb 17th 2017
 * Modification history
 * Aditya S - May 19th,2017 : added Pm view functionality in the code
 * Aditya S - June 6th, 2017 : added ability to check permission sets in the code
 * Aditya S/Prateek Bansal - June 6th, 2017 : Added shadow functionality in the code
 *************************************************************************************/ 
public class ITCECalendarCtrl
{

  //JSON Strings to store the session and request ID Details
  public String sessionArray {get; set;}
  public String requestIDArray {get; set;}
  
  //JSON Strings to Store the Presenters List for PM view and Shadow view
  public String presenterListArray {get; set;}
  public String presenterListArrayPMOnly {get;set;}
  private Integer sessionLastNDays;
    
  //stores the custom settings values
  List<ITCE_Calendar_Parameters__c> calParams;
    
  //TAG value for debugging purpose
  private final String TAG = 'ITCECalendarCtrl - ';
    
  //where clause Query Params used only for Shadow user  
  private String briefingCenterQueryParam;
  private String reportingStructureQueryParam;
 
  //variables to store the query results
  public List<CEE_Attendee__c> IDListq{get;set;}
  public List<CEE_Attendee__c> PresenterListq{get;set;}
  public List<CEE_Attendee__c> sessions{get;set;}
  
  //static variable to store the request ID's which have been assigned to a PM
  static Set<String> pmMyRequestIDs;
  
  //variables to store the logged in user details
  public String userEmail {get;set;}
  public String username {get;set;}
  public String userId {get;set;}

  
  //variables to find out the permission set of the user logged in
  public boolean isPmScheduler {get;set;}
  public boolean isShadower {get;set;}
  
  //other variables
  public boolean available {get;set;}
  public String instanceURL {get; set;}
  public Set<String> IDList{get;set;}
  
  //Wrapper class which sends data back to the visual force page
  public class ITCEWrapper{
      private Set<String> requestIDArray;
      private List<CEE_Attendee__c> sessionArray;
      public ITCEWrapper(Set<String> requestIDArray,List<CEE_Attendee__c> sessionArray)
      {
          this.requestIDArray = requestIDArray;
          this.sessionArray = sessionArray;
      }
  }

  //initial constructor
  public ITCECalendarCtrl()
  {
    available = true;
	sessionLastNDays = 90;
    calParams = ITCE_Calendar_Parameters__c.getall().values();
    briefingCenterQueryParam = '';
    reportingStructureQueryParam = '';
    instanceURL = System.URL.getSalesforceBaseURL().toExternalForm();
    isPmScheduler = checkIfPmScheduler();
    isShadower = checkIfShadower();
    if(isShadower)
    {
      	System.debug(TAG+'getting the Custom Setting Parameters for ITCE Calendar');
        briefingCenterQueryParam = getBriefingCenterQueryParam();
        reportingStructureQueryParam = getReportingStructureQueryParam();
        
    }
    if(isPmScheduler)
    {
        fetchPresenterLists();
    }
    userEmail = getUserEmail();
    username = UserInfo.getName();
    
    
    try
    {
      //check if the logged in user is a pm scheduler and load PM view
      if(isPmScheduler)
      {
          loadPmSchedulerView();
      }
      //check if the logged in user is a Shadower and load the shadower view
      else if(isShadower)
      {
          loadShadowerView();
      }
      //if logged in user is a presenter then load the presenter view
      else
      {
          loadPresenterView();
      }


    }
    catch(Exception e)
    {
      available = false;
    }
  }

  //function to get the logged in users email
  public String getUserEmail()
  {
    String userName = UserInfo.getUserName();

    User activeUser = [Select Alias From User where Username = :userName limit 1];
    return(activeUser.Alias);
  }

  //function to find the CEE Request ID's for all approved, rejected and pending requests
  public void fetchPresenterLists()
  {
      	
        List<CEE__c> pmMyRequestIDsoql;
        List<CEE__c> pmMyRequestIDsoqlPending;
        Set<String> pmMyRequestCEEIDstemp = new Set<String>();
        List<ProcessInstanceWorkitem> pmMyRequestCEEIDs;
        String userId = UserInfo.getUserId();

        //get the list of CEE Request ID's assigned to PM which are approved or rejected
        pmMyRequestIDsoql = [SELECT Name from CEE__c Where Id in (SELECT TargetObjectId FROM ProcessInstance where LastActorId=:userId) ];

        //get the list of CEE object ID's assigned to PM which are pending
        pmMyRequestCEEIDs = [Select ProcessInstance.TargetObjectId from ProcessInstanceWorkitem where ActorId=:userId];
        for(ProcessInstanceWorkitem r : pmMyRequestCEEIDs)
        {
          pmMyRequestCEEIDstemp.add(r.ProcessInstance.TargetObjectId);
        }

        //get the list of CEE Request ID's assigned to PM which are pending
        pmMyRequestIDsoqlPending = [SELECT Name from CEE__c Where Id in :pmMyRequestCEEIDstemp];

        //combine the CEE request ID's for approved , rejected and pending requests to one list
        pmMyRequestIDs = new Set<String>();
        for(CEE__c r : pmMyRequestIDsoql)
        {
          pmMyRequestIDs.add(r.Name);
        }
         for(CEE__c r : pmMyRequestIDsoqlPending)
        {
          pmMyRequestIDs.add(r.Name);
        }
      

  }


  //load the calendar data for the selected user. also has the context of whether it is PM view or not. also has the context whether it is shadower tab or presenter tab in shadower view
  public ITCEWrapper loadCalendarData(String selectedUser,String pmViewMyRequests,String view)
  {
      String pmOnlyRequests='';
      String agendaStartTime='';
      String briefingCenter='';
      
      //if user is not a shadower or a presenter, reset selectedUser to logged in user
      if((isShadower==false) && (isPmScheduler==false))
      {
          selectedUser = userEmail;
      }
      String iDListQueryString = 'select Customer_Engagement_Events__r.Name from CEE_Attendee__c where Salesforce_User__r.Alias=:selectedUser and Customer_Engagement_Events__r.Request_Status__c!=\'Cancelled\' and Customer_Engagement_Events__r.Request_Status__c!=\'Returned\' and Customer_Engagement_Events__r.Request_Status__c!=\'Returned (all resources released)\' and Customer_Engagement_Events__r.Request_Status__c!=\'Cancelled (all resources released)\' ';
      
      if(pmViewMyRequests.equals('My Assigned Requests') && (isPmScheduler==true))
      {
          System.debug(TAG+'Load all Requests Assigned to PM');
          pmOnlyRequests = 'and Customer_Engagement_Events__r.Name in :pmMyRequestIDs';
      }
      else
      {
          System.debug(TAG+'Load all requests');
          pmOnlyRequests = '';
      }

      //soql to get the list of CEE request ID's for the selected presenter
      if(isShadower)
      {
          if(view == 'shadower')
          {
           	System.debug(TAG+'shadower View Tab Selected');
          	agendaStartTime = 'and Agenda_Item__r.Start_Date_Time__c>=TODAY';
            briefingCenter = briefingCenterQueryParam;
          }
          else if(view == 'presenter')
          {
            System.debug(TAG+'Presenter View Tab Selected');
          	agendaStartTime = 'and Agenda_Item__r.Start_Date_Time__c>=LAST_N_DAYS:'+sessionLastNDays;
          }
      }
      else
      {
          agendaStartTime = 'and Agenda_Item__r.Start_Date_Time__c>=LAST_N_DAYS:'+sessionLastNDays;
      }
    
      System.debug(TAG+'get all the sessions of the selected presenter');
      IDListq = Database.query(iDListQueryString+agendaStartTime+pmOnlyRequests+briefingCenter);

      IDList = new Set<String>();
      for(CEE_Attendee__c r : IDListq)
      {
        IDList.add(r.Customer_Engagement_Events__r.Name);
      }

      //soql to get all the session for the selected presenter
     
      System.debug(TAG+'get all the engagements of the selected presenter');
      sessions =  [select (select Name from CEE_Attendees__r where Shadow_Approval_Status__c!='Rejected'),Customer_Engagement_Events__r.Vertical__c,(Select Outlook_Status__c,Location__c from CEE_Invites__r),Customer_Engagement_Events__r.Segment__c,Customer_Engagement_Events__r.Meeting_Delivery_Type__c,Customer_Engagement_Events__r.recordType.Name,Customer_Engagement_Events__r.EBC_CBC_Location__c,Customer_Engagement_Events__r.Start_Date_Time__c,Customer_Engagement_Events__r.Name,Customer_Engagement_Events__r.Account_Name_English__c,Customer_Engagement_Events__r.Request_Status__c,Customer_Engagement_Events__r.Primary_Account__r.Country__c,Customer_Engagement_Events__r.Additional_Solution_Details__c,Customer_Engagement_Events__r.Agenda_Objective__c,Customer_Engagement_Events__r.Engagement_Contact__r.Name,Customer_Engagement_Events__r.Engagement_Contact__r.Alias,Customer_Engagement_Events__r.CreatedBy.Name,Customer_Engagement_Events__r.CreatedBy.Alias,Agenda_Item__r.Name,Agenda_Item__r.Selected_Rooms_Display__c,Agenda_Item__r.Start_Date_Time__c,Agenda_Item__r.End_Date_Time__c,Name,Email__c,Title__c,Type__c,Salesforce_User__r.Alias from CEE_Attendee__c where Customer_Engagement_Events__r.Name IN :IDList order by Agenda_Item__r.Start_Date_Time__c];
      sessionArray = JSON.serialize(sessions);
      requestIDArray = JSON.serialize(IDList);
      ITCEWrapper wrapper = new ITCEWrapper(IDList,sessions);
      return wrapper;
  }

  //function to load the presenter list
  public void loadAllPresenters()
  {
       //load the entire presenter list for pm view
       PresenterListq = [select Name,Salesforce_User__r.Alias from CEE_Attendee__c where  Type__c='Presenter' and Agenda_Item__r.Start_Date_Time__c>=LAST_N_DAYS:90 and Customer_Engagement_Events__r.Request_Status__c!='Cancelled' and Customer_Engagement_Events__r.Request_Status__c!='Returned' and Customer_Engagement_Events__r.Request_Status__c!='Returned (all resources released)' and Customer_Engagement_Events__r.Request_Status__c!='Cancelled (all resources released)' ];
       presenterListArray = JSON.serialize(PresenterListq);

       //load the presenter list, for the requests assigned to the logged in PM
       PresenterListq = [select Name,Salesforce_User__r.Alias from CEE_Attendee__c where  Type__c='Presenter' and Agenda_Item__r.Start_Date_Time__c>=LAST_N_DAYS:90 and Customer_Engagement_Events__r.Request_Status__c!='Cancelled' and Customer_Engagement_Events__r.Request_Status__c!='Returned' and Customer_Engagement_Events__r.Request_Status__c!='Returned (all resources released)' and Customer_Engagement_Events__r.Request_Status__c!='Cancelled (all resources released)' and Customer_Engagement_Events__r.Name in :pmMyRequestIDs];
       presenterListArrayPMOnly = JSON.serialize(PresenterListq);
  }
  
  //function to load all the presenters for the shadower view
  public void loadAllPresentersFuture()
  {
      	String presenterListQuery = 'select Name,Salesforce_User__r.Alias from CEE_Attendee__c where Type__c=\'Presenter\' and Agenda_Item__r.Start_Date_Time__c>=TODAY and Customer_Engagement_Events__r.Request_Status__c!=\'Cancelled\' and Customer_Engagement_Events__r.Request_Status__c!=\'Returned\' and Customer_Engagement_Events__r.Request_Status__c!=\'Returned (all resources released)\' and Customer_Engagement_Events__r.Request_Status__c!=\'Cancelled (all resources released)\'';
        //PresenterListq = [select Name,Salesforce_User__r.Alias from CEE_Attendee__c where  Agenda_Item__r.Start_Date_Time__c>=TODAY and Customer_Engagement_Events__r.Request_Status__c!='Cancelled' and Customer_Engagement_Events__r.Request_Status__c!='Returned' and Customer_Engagement_Events__r.Request_Status__c!='Returned (all resources released)' and Customer_Engagement_Events__r.Request_Status__c!='Cancelled (all resources released)' ];
        presenterListq = Database.query(presenterListQuery+reportingStructureQueryParam+briefingCenterQueryParam);
        presenterListArray = JSON.serialize(PresenterListq);

  }
    
  //function to get the where clause query param for Briefing Center
  public String getBriefingCenterQueryParam()
  {
      List<String> briefingCenter = new List<String>();
      for(ITCE_Calendar_Parameters__c val: calParams)
      {
		  if(val.Reporting_Structure__c==Null)
          {
             briefingCenter.add(val.Briefing_Center__c);
          }
      }
      if(briefingCenter.size()<=0)
      {
          return '';
      }
      return getQueryParam(briefingCenter,'OR','Customer_Engagement_Events__r.EBC_CBC_Location__c');
  }
    
  //function to get the where clause query param for Reporting Structure
  public String getReportingStructureQueryParam()
  {
      List<String> reportingStructure = new List<String>();
      for(ITCE_Calendar_Parameters__c val: calParams)
      {
		  if(val.Briefing_Center__c==Null)
          {
             reportingStructure.add(val.Reporting_Structure__c);
          }
      }
      if(reportingStructure.size()<=0)
      {
          return '';
      }
      return getQueryParam(reportingStructure,'OR','Salesforce_User__r.Reporting_Up_Manager_Chain__c');
  }
    
  //function to prepare the where clause query param for the paramName parameter
  public String getQueryParam(String[] items,String operator,String field)
  {
      String queryParam = ' and (';
      for (Integer key = 0;key < items.size();key++)
      {
          queryParam += field +' LIKE \'%'+items[key]+'%\'';
          if(key!=items.size()-1)
          {
              queryParam += ' '+operator+' ';
          }
          else
          {
              queryParam += ')';
          }
      }
      return queryParam;
  }

  //function to check if logged in user is PM scheduler
  public boolean checkIfPmScheduler()
  {
     System.debug(TAG+'check if user is PM Scheduler');
     return checkPermissions('CEE_Scheduler_Program_Manager');
  }
  
  //function to check if the logged in user is a Shadower
  public boolean checkIfShadower()
  {
     System.debug(TAG+'check if user is Shadower');
     return checkPermissions('CEE_Shadow');
     //return true;
  }

  //function to check if 'permission' is present in one of the permission sets assigned to the user 
  public boolean checkPermissions(String permission)
  {
      System.debug(TAG+'checking user permissions');
      String userId = UserInfo.getUserId();
      List<PermissionSetAssignment> permissionSetList = [SELECT p.PermissionSet.Name FROM PermissionSetAssignment p WHERE p.PermissionSet.IsOwnedByProfile = false AND p.Assignee.Id = :userId ORDER BY  p.PermissionSetId];
      boolean isPermissionAssigned = false;
      Set<String> ceePermissionSet = new Set<String>();
      ceePermissionSet.add(permission);
      for(PermissionSetAssignment r : permissionSetList)
      {
          for(String key : ceePermissionSet)
          {
              if(key.equals(r.PermissionSet.Name))
              {
                  isPermissionAssigned = true;
                  break;
              }
          }
      }

      return isPermissionAssigned;
  }


  //function called through visualforce remoting
  @RemoteAction
  public static ITCEWrapper loadSelectedPresenterData(String userEmail,String pmViewMyRequests,String view)
  {
       return (new ITCECalendarCtrl()).loadCalendarData(userEmail,pmViewMyRequests,view);

  }

  //function to load the setup for PM view
  public void loadPmSchedulerView()
  {
      
	  System.debug(TAG+'load PM Scheduler View');
      loadAllPresenters();
  }

  //function to load the setup for Presenter View
  public void loadPresenterView()
  {
      System.debug(TAG+'load Presenter View');
  }

  //function to load the setup for Shadower view
  public void loadShadowerView()
  {
	  System.debug(TAG+'load Shadower View');     
      loadAllPresentersFuture();
  }
}