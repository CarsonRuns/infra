/*
    Author          : Shivi Srivastava
    Release         : March 29, 2019 Release
    Created         : March 26, 2019
    Functionality   : lxMultiSelectPicklist Test Class

                      
    Modification History:
    Itrack#        Date        Author              Change  
*/
@isTest(seealldata=true)
public class lxMultiSelectPicklist_Test {
static testMethod void multiSelectPicklistTest(){
String ObjectName = 'User';
String field = 'Name';

Test.startTest();
lxMultiSelectPicklist.fetchLookUpValues(ObjectName,field);
lxMultiSelectPicklist.getReportees();
Test.stopTest();
lxMultiSelectPicklist.forCheck multipickList = new lxMultiSelectPicklist.forCheck(); 
}
}