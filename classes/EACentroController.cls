public with sharing class EACentroController
{
public string eaDashboardId{ get;set;}
public string eaDashboardSize{ get;set;}

public EACentroController ()
{
String dashboardName = ApexPages.currentPage().getParameters().get('dashboardName');
list <DashboardNameIdMapping__mdt> dashboardList = [select developername, DashboardID__c, DashboardSize__c from DashboardNameIdMapping__mdt where developername = :dashboardname limit 1];
if (!dashboardList.isempty())
{
eaDashboardId = dashboardList [0].DashboardID__c;
eaDashboardSize = dashboardList [0].DashboardSize__c;
}
}
}