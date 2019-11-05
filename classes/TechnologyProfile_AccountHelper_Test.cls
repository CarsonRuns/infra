@isTest(seealldata=True)
public class TechnologyProfile_AccountHelper_Test {

private static testMethod void AccountHelper()
{
    List<Recordtype> recordId = [select id,Name from Recordtype where name = 'End-User' LIMIT 1];
    List<Account>  actList = new List<Account>();
    //actList = [select id ,Name,RecordtypeId from Account where RecordtypeId =:recordId[0].id and account_r limit 1];  
    account newaccount=new account(name='abc');
    insert newaccount;
    actList.add(newaccount);
    system.debug('======================66=========='+actList.size());
    TechnologyProfile_AccountHelper.createTechnologyProfile(actList);
    //system.debug('================================'+actList[0].RecordtypeId);
}

}