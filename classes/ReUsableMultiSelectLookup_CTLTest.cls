@isTest
public class ReUsableMultiSelectLookup_CTLTest {
    @isTest
    static void testMethod1()
    {
        String searchKeyword;
        String objectName ='Contact';
        List<Contact> ExcludeitemsList =[select Id, Name from Contact limit 1];
        for(Contact so:ExcludeitemsList)
            searchKeyword = so.Name;
        ReUsableMultiSelectLookup_CTL.fetchLookUpValues(searchKeyword,objectName,ExcludeitemsList);
    }
}