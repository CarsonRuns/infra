@isTest(seealldata=true)
public class OpptySearch_Test{
    public static testMethod void testMethods()
    {   
        OpptySearch_CT inst = new OpptySearch_CT();
        inst.AcctName='test';
        inst.PartnerName='test';
        inst.OpptyName='test';
        inst.OwnOpptys=false;        
        inst.myPaginator.setMy_list('select name from Opportunity limit 20');
        List<Opportunity> result2 = inst.getOpptySet();
        inst.setPageSize(10);
        Integer result3 = inst.getPageSize();
        Integer result4 = inst.getResultSize();
        Boolean result6 = inst.getHasNext();
        inst.next();
        Boolean result5 = inst.getHasPrevious();
        inst.previous();
        inst.setOrderColumn('name');
        string result8 = inst.getOrderColumn();
        PageReference result7 ;
        result7= inst.newOppty();
        result7 = inst.go();
        result7 = inst.view();
        result7 = inst.cancel();
        result7=inst.SortResultsOwner();
        result7= inst.SortResultsCloseDate();
        result7= inst.SortResultsStage();
        result7= inst.SortResultsAddress();
        result7= inst.SortResultsAccount();
        result7= inst.SortResultsName();
        result7= inst.SortResults('name');
    }    
}