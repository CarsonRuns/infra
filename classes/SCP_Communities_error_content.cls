public class SCP_Communities_error_content {
    
    public static String getErrorHtml(){
        String errorHtml = Label.SCP_Custom_error_content; //'Testing {0} test [0]';
        String resHtml = errorHtml;
        List <String> urlList = new List<String>();
        urlList.add('<a href="https://www.cisco.com/cisco/psn/web/workspace">');
        urlList.add('<a href="https://www.cisco.com/cisco/psn/web/workspace">');
        urlList.add('<a href="https://forums.cisco.com/ecom/web/operations-exchange/csc">');
        Integer cnt =0;
        while(cnt<3){
            Integer stIndex = errorHtml.indexOf('{'+cnt+'}');
            Integer endIndex = errorHtml.indexOf('['+cnt+']');
            system.debug('stIndex:\t'+stIndex);
            system.debug('endIndex:\t'+endIndex);
            system.debug('Result:\t'+'{'+cnt+'}');
            if(stIndex!=-1 && endIndex!=-1){
                system.debug('inside if condition');
                errorHtml = errorHtml.replace('{'+cnt+'}', urlList.get(cnt));
                errorHtml = errorHtml.replace('['+cnt+']', '</a>');
                  system.debug('inside if condition');
                
            }
            cnt++;
        }
        return errorHtml;
    }
}