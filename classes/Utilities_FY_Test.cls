@isTest
private class Utilities_FY_Test{
    static testmethod void testFyutilities(){
      date myDate = date.today();
      Utilities_FY.getFiscalYear(mydate.addDays(1));
      Utilities_FY.getFiscalQuerter(mydate.addDays(1));
    }
}