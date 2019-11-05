/**
 * Name : EventTrigger_Test
 * Author :  Unit Test Generator
 * Description : Test class used for testing the EventTrigger
 * Date : 9/16/14 2:31 PM 
 * Version : <intial Draft> 
 */
@isTest
private class EventTrigger_Test { 
     static testMethod  void testEventTrigger(){
        Event eventTest =  new Event(DurationInMinutes=23,ActivityDateTime=system.now());
        insert eventTest;
        //delete eventTest;
        eventTest.ActivityDate=system.Today();
        update eventTest;
    }
}