global Class Pagination{

    public Integer counter;
    public Integer i;
    SObject[] my_plist;
     String testid='test';
    public Integer pageSize;
    
    public SObject[] my_list;
    
    public Pagination(Integer i){pageSize = i;}

    public Integer getListSize() {
        if(my_list == null)
            return 0;
        else
            return my_list.size();
    }

    public void Pg_previous() {
    System.debug('counter is ' + counter );
    System.debug('page size is' + pageSize);
        if((counter - pageSize) >= 0){
            Integer remainder = math.mod(getListSize(), pageSize);
            System.debug('list size' + getListSize());
            if(counter == getListSize() && remainder > 0){
                i = i - remainder;
                counter = counter - (pageSize + remainder);
            }
            else{
                i = counter - pageSize;
                if((counter - pageSize*2) < 0)
                    counter = 0;
                else    
                    counter = counter - (pageSize*2);
            }
        }
        else
            counter = 0;
    } 
    public Boolean Pg_HasPrevious() {
        if(counter <= pageSize || getListSize() == 0)
            return false;
        else
            return true;    
    }
    public void Pg_next() {
        if((counter + pageSize) < getListSize())
            i = counter + pageSize;
        else
            i = getListSize();
    } 
    public Boolean Pg_HasNext() {
        if(getListSize() == counter || getListSize() == 0 || getListSize() < pageSize)
            return false;
        else    
            return true;
    }
    
    public void Pg_setPageSize(Integer ps) {
        if(ps != pageSize){       
            if(counter - pageSize > 0)    
                counter = counter - pageSize;
            else
                counter = 0;
        if((counter + ps) > getListSize())
            i = getListSize();
        else    
            i = counter + ps;
           
        pageSize = ps;
        }
    }


    public void setMy_list(String s){
       my_list = Database.query(s);
       counter = 0;
       i = 0;
    }

    public SObject[] getList(){
        if(getListSize() > pageSize){
            my_plist = my_list.deepClone();
            my_plist.clear();
         
            if(counter == 0)
                i = counter + pageSize;
        
            while(counter < i){
                SObject s = my_list[counter];
                my_plist.add(s);
                counter++;
            }
        
            return my_plist;
        }        
        return my_list;
    }

}