@isTest
public class PortfolioListViewRenewals_Test {
    static testMethod void testgetRelatedItems(){
        User admin = CEE_TestUtility.getUser('admin', true);
        system.Runas(admin) {
            Renewals_Portfolio__c renewalPortfoloi = new Renewals_Portfolio__c();
            renewalPortfoloi.products__c = 'product1';
            renewalPortfoloi.services__c = 'service1';
            renewalPortfoloi.Default_Timeline__c = 'default';
            renewalPortfoloi.Stages__c = 'stage1';
            renewalPortfoloi.Timelines__c = 'timeline';
            
            renewalPortfoloi.Sav_limit__c = '10';
            renewalPortfoloi.Territory_Limit__c = '10';
            insert renewalPortfoloi;
            
            //Insert record in Object Record type custom setting for Account creation
            ObjectRecordTypeIds__c objR = new ObjectRecordTypeIds__c();
            objR.Opportunity_Parent_Mobile_RecordTypeId__c = '01234000000GGKw';
            insert objR;
            Account_Group__c sav = new Account_Group__c();
            sav.Name = 'Test-Sav';
            sav.Renewal_Manager__c =  admin.Id;
            insert sav;
            PortfolioListViewRenewals.resultWrapper RelItems=new PortfolioListViewRenewals.resultWrapper();
            RelItems = PortfolioListViewRenewals.getRelatedItems();
            
            Account acc = GenericStaticTestData.getTestEndUserAccountRecordRed();
            //  Account acc1 = GenericStaticTestData.gettestChannelAccountRecord1();
            
            Account_Group_Relationship__c accGroupRelation = new Account_Group_Relationship__c();
            accGroupRelation.Account_ID__c = acc.Id;
            accGroupRelation.Account_Group__c= sav.id;
            
            insert accGroupRelation;
            
        }
        
    } 
    static testMethod void testGetacc(){
        User admin = CEE_TestUtility.getUser('admin', true);
        system.Runas(admin) {
            Renewals_Portfolio__c renewalPortfoloi = new Renewals_Portfolio__c();
            renewalPortfoloi.products__c = 'product1';
            renewalPortfoloi.services__c = 'service1';
            renewalPortfoloi.Default_Timeline__c = 'default';
            renewalPortfoloi.Stages__c = 'stage1';
            renewalPortfoloi.Timelines__c = 'timeline';
            renewalPortfoloi.Territory_Limit__c='100';
            insert renewalPortfoloi;
            list<string> accid = new list<string>();
            accid.add('a0S3400000ljLSs');
            PortfolioListViewRenewals.getAccountsMultipleSav(accid);
            
            PortfolioListViewRenewals.getUserTerritory();
            //PortfolioListViewRenewals.getSAVsByTerr('04T340000006U6UEAU');
        }
    }
    static testMethod void testgetSAVsByTerr(){
        User admin = CEE_TestUtility.getUser('admin', true);
        system.Runas(admin) {
            Renewals_Portfolio__c renewalPortfoloi = new Renewals_Portfolio__c();
            renewalPortfoloi.products__c = 'product1';
            renewalPortfoloi.services__c = 'service1';
            renewalPortfoloi.Default_Timeline__c = 'default';
            renewalPortfoloi.Stages__c = 'stage1';
            renewalPortfoloi.Timelines__c = 'timeline';
            renewalPortfoloi.Territory_Limit__c='100';
            renewalPortfoloi.Sav_Limit__c='200';
            insert renewalPortfoloi;
            
            list<Account_Group__c> savList = new list<Account_Group__c>();
            //savList = PortfolioListViewRenewals.getSAVsByTerr('04T340000006U6UEAU'); /*Level 7 */
            //savList = PortfolioListViewRenewals.getSAVsByTerr('04T300000004I14EAE'); /*Level 5 */
            //savList = PortfolioListViewRenewals.getSAVsByTerr('04T800000001LeUEAU'); /*Level 6 */
            
            
            list<Territory2> trrList2 = [select id from territory2 where Territory_Level__c in (6.0) limit 1];
            
            for(Territory2 t : trrList2){
                savList = PortfolioListViewRenewals.getSAVsByTerr(t.id); /*Level 5 */
                
            }
            
            list<Territory2> trrList3 = [select id from territory2 where Territory_Level__c in (7.0) limit 1];
            
            for(Territory2 t : trrList3){
                savList = PortfolioListViewRenewals.getSAVsByTerr(t.id); /*Level 5 */
                
            }
        }
    }
    
    static testMethod void testSavsByTerritoryIdandSavSearch () {
        User admin = CEE_TestUtility.getUser('admin', true);
        system.Runas(admin) { 
            Renewals_Portfolio__c renewals = Renewals_Portfolio__c.getOrgDefaults();
            renewals.Sav_Limit__c='100';
            insert  renewals ;
            
            String searchText = 'abc' ;
            string territoryID = '04T300000004I0lEAE';
            
            PortfolioListViewRenewals.SavsByTerritoryIdandSavSearch ( searchText,territoryID) ;
            
             list<Territory2> trrList2 = [select id from territory2 where Territory_Level__c in (6.0) limit 1];
            
            for(Territory2 t : trrList2){
                 PortfolioListViewRenewals.SavsByTerritoryIdandSavSearch(searchText, t.id); /*Level 6 */
                
            }
            
            
        }
        
    }
}