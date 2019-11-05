//This class is a controller for the visualforcepage TSN_Case_Contributors 
//Since VF page has a one team field and a multiselect picklist field.
//Whatever the team is selected by the user ,the User of the particular team should come out in the 
//left panel, then click on the buttons >> or << to select and unselect the users, 
//On the click of save , the user selected in the right panel should be save with the seperator of ;
public class TSN_Case_Contributors_CTE{


     Public Case caserecord{get;set;}
     Public List<string> leftSelectedValuesList{get;set;}  //List containing the values which are selected in left panel
     Public List<string> rightSelectedValuesList{get;set;}  //List containing the values which are selected in right Panel
     Set<string> leftValuesSet = new Set<string>(); //Set containing all the values in left panel
     Set<string> rightValuesSet = new Set<string>();//Set containing all the values in right panel
     String originalTeam;

// On page load, Left Panel values are to be the users of team field value.
// Right Panel values are to be the case contributors which are present on the case detail page.

    public TSN_Case_Contributors_CTE(ApexPages.StandardController controller) {
       leftSelectedValuesList = new List<String>();
       rightSelectedValuesList = new List<String>();
       
//     System.debug('fetching Case Record .... ');
       String caseId = controller.getId();
       caseRecord=[select id,Team__c,CaseNumber,Case_Contributors__c from case where id=:caseId];
       originalTeam=caseRecord.team__c;
       
//     System.debug('Fetching Case contributors List from case Record :  '+ caseRecord);   
       List<String> caseContributorsList=new List<String>();
       if(caseRecord != null && caseRecord.case_contributors__c != null)
          caseContributorsList=caseRecord.case_contributors__c.split(',');
          
       if(caseContributorsList!=null)
         {
          caseContributorsList.sort();
          Set<String> caseContributorsSet=new Set<String>(caseContributorsList);
          //System.debug('Assigning the Case Contributors to the Right Panel '+caseContributorsSet);
          rightValuesSet=caseContributorsSet;
         }
         
       Set<String> usersOfTeamSet=getSetOfUserNamesForTeam(caserecord.Team__c);
       
//     System.debug('Assigning the Users of team to the Left Panel '+usersOfTeamSet);
       leftValuesSet=usersOfTeamSet;
    }

      
//Save button functionality. On click of save the values of right panel will be added to the case contributor field of the case.     
    public PageReference save()
    {
     String caseContributorsToBeAdded='';
     Set<String> caseContributorsSet=new Set<String>();
     
     //System.debug('adding the case contributors from right Panel to the set ');
     for(String casecontributors:rightValuesSet)
         caseContributorsSet.add(casecontributors);
 
     //System.debug('Creating the string for case contributors using : '+caseContributorsSet);
     for(String casecontributors:caseContributorsSet)    
        {

         if(caseContributorsToBeAdded != '')
         caseContributorsToBeAdded+=','+casecontributors;
         else
         caseContributorsToBeAdded+=casecontributors;
        }
        
    Integer caseContributorsLength=caseContributorsToBeAdded.length();
    if(caseContributorsLength<255)
      {
       caserecord.case_contributors__c=caseContributorsToBeAdded;
       caserecord.team__c=originalTeam;
       try{
           update caserecord;
       }
       catch(Exception exc)
       {
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Updation exception on the case')); 
       }
    
       PageReference detailCasePage=new PageReference('/'+caseRecord.id);
       return new PageReference('/'+caseRecord.id);
      }
    else
      {
       ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Case Contributors field can not have more than 255 characters'));    
       return null;        
      }
  
    }
    
// on click of cancel
    public PageReference cancel()
    {
     return new PageReference('/' + caseRecord.id);
    }

//  this function executes when Team field value changes since it is called by action support tag of input team field
//  It populates the users of the changed team field 
    public PageReference setListOfUsersForTeam() {

        Set<String> usersOfTeamSet=getSetOfUserNamesForTeam(caserecord.Team__c);
        leftValuesSet.clear();   

        //System.debug('Assigning the users to the Left Panel '+usersOfTeamSet);
        leftValuesSet.addAll(usersOfTeamSet);

        return null;
    }
 
//  Internal function used in the class to fetch the set of users for a team. 
    private Set<String> getSetOfUserNamesForTeam(String team)
    {
        Map<String,String> mapOfRightValues=new Map<String,String>();
        Set<String> usersOfTeamSet = new Set<String>();
        List<Id> idlist=new List<Id>();

        //System.debug('fetching the Group Id from the Group Name '+team);
        List<Group> groupList=[select id from group where name=:team];

        List<GroupMember> groupMemberlist=[select UserOrGroupId from GroupMember  where groupid in :groupList];

        for(GroupMember groupMember:groupMemberlist)
           idlist.add(groupMember.userorgroupid);
           
        //System.debug('fetching the User List from group Members Id List '+groupMemberlist);
        List<User> userList=[select name from user where id in :idlist];
        

        //System.debug('Adding the group members name to the set '+userList);
        for(String rightValue:rightValuesSet)
            mapOfRightValues.put(rightValue,rightValue);

        for(User u:userList)
            {
             if(mapOfRightValues.get(u.name)==null)
               {
                System.debug('User to be added as uname '+u.name);
                usersOfTeamSet.add(u.name);
                }
            }

        return usersOfTeamSet;
    }
     
     
     
     
/*
 *   Functionality of multiselect picklist is as follows: 
 *   Four Functions:
 *   1.public PageReference selectclick() - calls on the click of >> to select the values 
 *      and save into the right selected values
 *   2.public PageReference unselectclick() - calls on the click of << to deselect the values 
 *      and save into the left selected values
 *   3.public List<SelectOption> getleftValuesSet() - get the values of left Panel and return the list 
 *   4.public List<SelectOption> getrightValuesSet() - get the values of right Panel and return the list 
 *
 */
      
// Function executes on the click of the > arrow 
// Function remove the value from the left panel and add it to the right panel.       
      public PageReference selectclick(){
          rightSelectedValuesList.clear();
          for(String s : leftSelectedValuesList){
              leftValuesSet.remove(s);
              rightValuesSet.add(s);
          }
         return null;
      }
 // Function executes on the click of the < arrow 
// Function remove the value from the right panel and add it to the left panel.           
      public PageReference unselectclick(){
          leftSelectedValuesList.clear();
          for(String s : rightSelectedValuesList){
              rightValuesSet.remove(s);
              leftValuesSet.add(s);
          }
          return null;
      }
   
 // Function sets the Available values for the left Panel
      public List<SelectOption> getleftValuesSet(){
          List<SelectOption> options = new List<SelectOption>();
          List<string> tempList = new List<String>();
          tempList.addAll(leftValuesSet);
          tempList.sort();
          for(string s : tempList)
              options.add(new SelectOption(s,s));
          return options;
      }
   
 // Function sets the Available values for the Right Panel
      public List<SelectOption> getrightValuesSet(){
          List<SelectOption> options1 = new List<SelectOption>();
          List<string> tempList = new List<String>();
         tempList.addAll(rightValuesSet);
          tempList.sort();
          for(String s : tempList)
              options1.add(new SelectOption(s,s));
          return options1;
      }

}