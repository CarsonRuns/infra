@isTest
public class Pagination_Test
{
    public static testMethod void testMethods()
    {
        Pagination p = new Pagination(5);
        p.counter=10;
        Integer i = p.getListSize();
        p.setMy_list('select name from Opportunity limit 30');
        p.Pg_setPageSize(20);
        boolean result2 = p.Pg_HasNext();
        p.Pg_next();
        boolean result1 = p.Pg_HasPrevious();
        p.counter=20;
        p.Pg_previous();
        p.counter=30;
        p.Pg_previous();
        p.Pg_setPageSize(10);
        SObject[] result3= p.getList();
        Integer j = p.getListSize();
    }
}