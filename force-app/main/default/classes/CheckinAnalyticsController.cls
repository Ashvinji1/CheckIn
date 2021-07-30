/*
Author: Purushottam Bhaigade
class: CheckinAnalyticsController
Description: This class demonstrates different ways to use constructor in specifying the limit for 
            top n visitors for reporting purpose
*/

public class CheckinAnalyticsController {
    
    Integer limitVar = 0;
    
    public CheckinAnalyticsController(){
        this.limitVar = 3;
    }
    
    public CheckinAnalyticsController(Integer lVar){
        this.limitVar = lVar;
    }
    
    public void getTopVisitors(){
        
        Map<String, Integer> visitorAndVisitMap = new Map<String, Integer>();
        List<AggregateResult> checkInList = [select Contact__r.Name cname, count(Contact__c) tVisit 
                                             from Check_In__c 
                                             group by Contact__r.Name 
                                             order by count(Contact__c) desc 
                                             limit :limitVar];
        
        for(AggregateResult result :checkInList){
            visitorAndVisitMap.put((String)result.get('cname'),(Integer)result.get('tVisit'));
        }

        /*for(integer i=0; i < AggregateResult.size(); i++){
            visitorAndVisitMap.put((String)AggregateResult[i].get('cname'),(Integer)AggregateResult[i].get('tVisit'));
        }*/
        
        system.debug('Visitor Map results are --> '+visitorAndVisitMap);
    }


    public static void getTopVisitorsStaticDemo(Integer topNConut){
        
        Map<String, Integer> visitorAndVisitMap = new Map<String, Integer>();
        List<AggregateResult> checkInList = [select Contact__r.Name cname, count(Contact__c) tVisit 
                                             from Check_In__c 
                                             group by Contact__r.Name 
                                             order by count(Contact__c) desc 
                                             limit :topNConut];
        
        for(AggregateResult result :checkInList){
            visitorAndVisitMap.put((String)result.get('cname'),(Integer)result.get('tVisit'));
        }
        
        system.debug('Visitor Map results are --> '+visitorAndVisitMap);
    }
}