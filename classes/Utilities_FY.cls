/**
   @Author <Suresh.Lakshmisetty>
   @name <FY_Utilities>
   @CreateDate <04-08-2015>
   @Description <As part of (WR-01055) BTx Project/Activities with/without Revenue - FQ & FY MAY Release>.
   @Version <1.0>
   @Usage: Use the below methods to get the Fiscal Year and Fiscal Quarter details for a given date as per Company Fiscal Year settings.
  */

global class Utilities_FY{ 
   public static List<FiscalYearSettings> fyList = [SELECT Id, PeriodId, StartDate, EndDate,  Name, IsStandardYear, YearType FROM FiscalYearSettings where yearType='custom'];   

    // Process the input date and returns the Fiscal Year based on the Custom Fiscal Year settings.
    public static String getFiscalYear(date inputDate){
       String fYear='';
       for(FiscalYearSettings lst : fyList){
        if((lst.StartDate <= inputDate) && (lst.EndDate >= inputDate)){        
            fYear = lst.name;
            break;
         }   
       }
       return fYear;
    }
   
   //Process the input date and returns the Fiscal Quarter based on the Custom Fiscal Year settings.
   public static String getFiscalQuerter(date inputDate){
        Integer fQuarter;
        Date todayDateInstance = Date.newInstance(inputDate.year(), inputDate.month(), inputDate.Day());
        
        for(FiscalYearSettings lst : fyList){
            if((lst.StartDate <= inputDate) && (lst.EndDate >= inputDate)){            
                Date sDate = date.newinstance(lst.StartDate.year(), lst.StartDate.month(), lst.StartDate.day());
                
                Integer numberDaysDue = sDate.daysBetween(todaydateinstance);
                Integer  i = ((numberDaysDue) / 7 ) + 1;
                Integer year = lst.StartDate.year()+1;
                date firstdate = Date.newInstance(year, 9, 15);
                date seconddate = Date.newInstance( 1900, 1, 7 );
                integer daysbetween= firstdate.daysBetween(seconddate);
                Integer fExtr = 0;
                IF( ( daysbetween / 7 ) == 6 ){
                    fExtr = 1;
                }else
                    fExtr = 0;  
                
                
                if (i <= 13){
                    fQuarter = 1;
                } else if (i <= 26){
                    fQuarter = 2;
                } else if (i <= 39+fExtr ){
                    fQuarter = 3;
                } else{
                    fQuarter = 4;
                }
            }
                
       }     
          return String.valueOf(fQuarter);
   } 
   }