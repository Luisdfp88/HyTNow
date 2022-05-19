public with sharing class DailyAvgController implements Schedulable{
    public DailyAvgController() {

    }

    public static void execute(SchedulableContext ctx){
        List<Report__c> reports = [SELECT Id,Humidity__c,Temperature__c FROM Report__c WHERE CreatedDate = YESTERDAY];
        Integer i = 0;
        Decimal h = 0, t = 0;
        if(reports.size() > 0){
            for(Report__c report : reports){
                h += report.Humidity__c;
                t += report.Temperature__c;
                i++;
            }
            Daily_Avg__c dailyAvg = new Daily_Avg__c();
            dailyAvg.Avg_Humidity__c = h/i;
            dailyAvg.Avg_Temperature__c = t/i;
            dailyAvg.Highest_Temperature__c = (Decimal)([SELECT MAX(Temperature__c) max FROM Report__c][0].get('max'));
            dailyAvg.Lowest_Temperature__c = (Decimal)([SELECT MIN(Temperature__c) min FROM Report__c][0].get('min'));
            dailyAvg.Highest_Humidity__c = (Decimal)([SELECT MAX(Humidity__c) max FROM Report__c][0].get('max'));
            dailyAvg.Lowest_Humidity__c = (Decimal)([SELECT MIN(Humidity__c) min FROM Report__c][0].get('min'));
            insert dailyAvg;

            DailyAvgController.deleteReportsByDate(Datetime.now().date()-3);
        }
    }

    @AuraEnabled
    public static List<Daily_Avg__c> getLastReport(){
        return [SELECT Id,Avg_Humidity__c,Avg_Temperature__c,Highest_Temperature__c,Lowest_Temperature__c,Highest_Humidity__c,Lowest_Humidity__c FROM Daily_Avg__c ORDER BY CreatedDate DESC LIMIT 1];
    }
    
    public static void deleteReportsByDate(Datetime fecha){
        delete [Select Id from Report__c WHERE CreatedDate = :fecha];
    }
}
