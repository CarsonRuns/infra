public class Competitors_Email_CTC {

public List<Competitor> Competitors = new List<Competitor>();

public String EnteredCompetitors {get;set;}


public List<Competitor> getCompetitors() {
        
        if(EnteredCompetitors != null && Competitors.size()==0)
        {
            List<String> ECs = EnteredCompetitors.split(';');
            
            for(String s :  ECs)
            {
                if(Competitor_Information__c.getall().get(s)!= null)
                {
                    Competitor c = new Competitor();
                    c.Name = Competitor_Information__c.getall().get(s).name;
                    c.Competitor_Information = Competitor_Information__c.getall().get(s).Competitor_Information__c;
                    Competitors.add(c);
                }
            }
        }
       
        return Competitors;
    }

public class Competitor 
{
    public String Name {get;set;}
    public String Competitor_Information {get;set;}

}

}