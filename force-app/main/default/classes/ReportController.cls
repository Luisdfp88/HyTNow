public with sharing class ReportController {
    public ReportController() {

    }
    public static void renameReport(){
        Integer aux = Integer.valueOf([SELECT COUNT() FROM Report__c WHERE CreatedDate = TODAY]);
        String today = Datetime.now().format('yyyyMMdd');
        List<Report__c> getLastReport = [SELECT Id, Name FROM Report__c ORDER BY CreatedDate DESC LIMIT 1];
        if(getLastReport.size() > 0){
            if(today != getLastReport[0].Name.substring(0,8)){
                aux = 0;
            }
            for(Report__c r : (List<Report__c>)Trigger.new){
                r.Name = today+ '-' + String.valueOf(aux).leftPad(4, '0');
                aux++;
            }
        }else{
            for(Report__c r : (List<Report__c>)Trigger.new){
                r.Name = today+ '-' + String.valueOf(aux).leftPad(4, '0');
                aux++;
            }
        }
        
    }

    //THIS WILL SET THE TIME FIELD WITH THE CURRENT TIME
    public static void setTime(){
        for(Report__c r : (List<Report__c>)Trigger.new){
            r.CreationTime__c = Time.newInstance(Datetime.now().hour(), Datetime.now().minute(), 0, 0);
        }
    }

    public static List<Report__c> getAllReports(){
        List<Report__c> reports = new List<Report__c>();
        reports = [select Id, Name, Temperature__c, Humidity__c from Report__c];
        return reports;
    }

    //THIS WILL GET THE LAST INTRODUCED REPORT
    @AuraEnabled
    public static Report__c getLastReport(){
        List<Report__c> reports = [SELECT Id, Name, Temperature__c, Humidity__c FROM Report__c WHERE CreatedDate = TODAY ORDER BY CreatedDate DESC LIMIT 1];
        return reports[0];
    }
    //AT 12PM THIS WILL DELETE ALL THE REPORTS THAT DON'T NEED REVISION
    public static void deleteAllGoodReports(Decimal humMax, Decimal humMin, Decimal tempMax, Decimal tempMin){
        delete [Select Id from Report__c WHERE Humidity__c < :humMax AND Humidity__c > :humMin AND Temperature__c < :tempMax AND Temperature__c > :tempMin];
    }

    //THIS WILL DELETE AN SPECIFIC REPORT. THIS ACTION NEEDS TO BE CALLED BY THE USER
    public static void deleteReport(Id id){
        delete [Select Id from Report__c WHERE Id = :id];
    }

    //THIS WILL DELETE ALL THE REPORTS.
    public static void deleteAllReports(){
        delete [Select Id from Report__c];
    }

    //THIS WILL GET THE REPORT WITH THE HIGHEST TEMPERATURE
    @AuraEnabled
    public static Report__c getHighestTemperature(){
        List<Report__c> reports = [SELECT Id, Name, Temperature__c FROM Report__c WHERE CreatedDate = TODAY ORDER BY Temperature__c DESC LIMIT 1];
        return reports[0];
    }
    
    //THIS WILL GET THE REPORT WITH THE HIGHEST HUMIDITY
    @AuraEnabled
    public static Report__c getHighestHumidity(){
        List<Report__c> reports = [SELECT Id, Name, Humidity__c FROM Report__c WHERE CreatedDate = TODAY ORDER BY Humidity__c DESC LIMIT 1];
        return reports[0];
    }

    //THIS WILL GET THE REPORT WITH THE LOWEST TEMPERATURE
    @AuraEnabled
    public static Report__c getLowestTemperature(){
        List<Report__c> reports = [SELECT Id, Name, Temperature__c FROM Report__c WHERE CreatedDate = TODAY ORDER BY Temperature__c ASC LIMIT 1];
        return reports[0];
    }

    //THIS WILL GET THE REPORT WITH THE LOWEST HUMIDITY
    @AuraEnabled
    public static Report__c getLowestHumidity(){
        List<Report__c> reports = [SELECT Id, Name, Humidity__c FROM Report__c WHERE CreatedDate = TODAY ORDER BY Humidity__c ASC LIMIT 1];
        return reports[0];
    }

    //THIS WILL COUNT THE REPORTS SUBMITTED TODAY
    @AuraEnabled
    public static Integer countReports(){
        Integer count = [SELECT COUNT() FROM Report__c WHERE CreatedDate = TODAY];
        return count;
    }
}
