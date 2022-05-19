trigger ReportTrigger on Report__c (before insert, after insert) {

    /*
     _         _ _     _          __            
    | |__ _  _| | |__ | |__  ___ / _|___ _ _ ___
    | '_ \ || | | / / | '_ \/ -_)  _/ _ \ '_/ -_)
    |_.__/\_,_|_|_\_\ |_.__/\___|_| \___/_| \___| 
    */       
    if(Trigger.isBefore) {
        if(Trigger.isInsert) {
            ReportController.renameReport();
            ReportController.setTime();
        }
        if(Trigger.isUpdate) {}
    }

    if(Trigger.isAfter) {
        if(Trigger.isInsert) {
            
        }
        if(Trigger.isUpdate) {}
    }
            

    /*                         _           _   _            
         _ _ ___ __ ___ _ _ __| |  __ _ __| |_(_)___ _ _  ___
        | '_/ -_) _/ _ \ '_/ _` | / _` / _|  _| / _ \ ' \(_-<
        |_| \___\__\___/_| \__,_| \__,_\__|\__|_\___/_||_/__/
    */
    // for(Object__c opp : (List<Object__c>) Trigger.new) {
    //     if(Trigger.isBefore) {
    //         if(Trigger.isInsert) {}
    //         if(Trigger.isUpdate) {}
    //     }

    //     if(Trigger.isAfter) {
    //         if(Trigger.isInsert) {}
    //         if(Trigger.isUpdate) {}
    //     }
    // }
    // delete [select Id from Report__c];

    /*
         _         _ _           __ _          
        | |__ _  _| | |__  __ _ / _| |_ ___ _ _
        | '_ \ || | | / / / _` |  _|  _/ -_) '_|
        |_.__/\_,_|_|_\_\ \__,_|_|  \__\___|_| 
    */
        
    if(Trigger.isBefore) {
        if(Trigger.isInsert) {}
        if(Trigger.isUpdate) {}
    }

    if(Trigger.isAfter) {
        if(Trigger.isInsert) {}
        if(Trigger.isUpdate) {}
    }
}
 
//       
//        .__(.)< (CUAQ)
//         \___)
//  ~~~~~~~~~~~~~~~~~~