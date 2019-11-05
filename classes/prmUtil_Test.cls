@isTest(seealldata=true)
public class prmUtil_Test {
 public static testMethod void prmtest()
 {
        
        prmFilterUtility.getLangkey();
        prmFilterUtility.refreshFilterviews();
        List < String > value = new List<string>();
        value.add('Actively Working');
        prmFilterUtility.getMultiPickSelectedValue(value);
        prmFilterUtility.whereClauseforViewForStringSelectedView('a3U340000000Z97');
        prmFilterUtility.whereClauseforTPTechnology('Collab Applications',true);
        prmFilterUtility.whereClauseforTPTechnology('Collab Voice',true);       
        prmFilterUtility.whereClauseforTPTechnology('DataCenter UCS',true);       
        prmFilterUtility.whereClauseforTPTechnology('Other',true);       
        prmFilterUtility.whereClauseforTPTechnology('Routing',true);       
        prmFilterUtility.whereClauseforTPTechnology('Security',true); 
        prmFilterUtility.whereClauseforTPTechnology('Services',true); 
        prmFilterUtility.whereClauseforTPTechnology('Switching',true); 
        prmFilterUtility.whereClauseforTPTechnology('Telepresence',true); 
        prmFilterUtility.whereClauseforTPTechnology('Wirless',true); 
        prmFilterUtility.convertToMultiselectPickList('test,one'); 
        prmFilterUtility.communityPrefix();     
        prmFilterUtility.gettp_statusMap();
        List<string> lst = new List<string>();
        lst.add('All');
        prmFilterUtility.getMappedIndustries(lst);
        List<string> lst1 = new List<string>();
        lst1.add('test');
        prmFilterUtility.getMappedIndustries(lst1);
        try{
        prmFilterUtility.getDatePosition('Lead','a3U80000000DIon'); 
        prmFilterUtility.getDatePosition('TP','a3U80000000DIon');   
        }catch(Exception e){}   
    }
 }