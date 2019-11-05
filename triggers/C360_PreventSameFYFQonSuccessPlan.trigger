/************************************************************************************************************************************
Name    : C360_PreventSameFYFQonSuccessPlan
Author  : C360 Dev team
Purpose : Trigger for Preventing Same Cisco FY/FQ field on QSR object
Date    : 28/06/2019
Change History : None
*************************************************************************************************************************************/
trigger C360_PreventSameFYFQonSuccessPlan on QSR__c (before insert) {
C360_QsrHandler qsrHan = new C360_QsrHandler();
    if(trigger.isInsert){
        qsrHan.DuplicateChecker(trigger.new);
    }
}