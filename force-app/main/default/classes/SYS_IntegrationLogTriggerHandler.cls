public without sharing class SYS_IntegrationLogTriggerHandler {
    
    public static void processLogAfterInsert(List<SYS_IntegrationLog__c> newLogList){
        List<Id> newLogsFirst = new List<Id>();
        List<Id> newLogsSecond = new List<Id>();
        Integer count = 0;
        for(SYS_IntegrationLog__c log:newLogList){
            //TODO - Add constant values in class
            if(log.Type__c != 'RESPONSE'){
                if(count > 99){
                    newLogsSecond.add(log.id);
                }
                else{
                    newLogsFirst.add(log.id);
                }   
            }
            count += 1;
        }
        if(newLogList.size() <= 100) {
            System.enqueueJob(new SYS_IntegrationLogOutboundQueueable(newLogsFirst));
        } else {
            System.enqueueJob(new SYS_IntegrationLogOutboundQueueable(newLogsFirst));
            System.enqueueJob(new SYS_IntegrationLogOutboundQueueable(newLogsSecond));
        }
    }
}