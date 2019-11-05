public class Spark_MessageDelete_Batch implements Database.Batchable<String>, Database.AllowsCallouts {
      
        public String bearerToken   {get; set;}
        public list<String> mlist   {get; set;}

        public void setToken(final String token)
        {
            this.bearerToken = token;
        }
        
        public void setMsgIdList(final list<string> mlist)
        {
            this.mlist = mlist;
        }
        public list<string> getMsgIdList()
        {
            return this.mlist;
        }
            
        
        public Iterable<String> start(final Database.BatchableContext BC) {
            return getMsgIdList();
        }

        public void execute(final Database.BatchableContext info, final List<String> strings) {
        
            for (String m : strings)
            {
                Spark_Message_API.deleteMessage(m, this.bearerToken);    
            }
        }
      
        public void finish(final Database.BatchableContext BC)
        {
            /* To Be Implemented */
        }   

}