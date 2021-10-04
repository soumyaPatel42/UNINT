public class SYS_IntegrationLogTriggerHandler {
    
    public static void processLogAfterInsert(List<SYS_IntegrationLog__c> newLogList){
        List<Id> newLogsFirst = new List<Id>();
        List<Id> newLogsSecond = new List<Id>();
        List<Id> newInboundFirst = new List<Id>();
        List<Id> newInboundSecond = new List<Id>();
        List<Id> newInboundResponse = new List<Id>();

        Map<String, List<Id>> mapStringToId = new Map<String, List<Id>>();
        Integer count = 0;
        for(SYS_IntegrationLog__c log:newLogList){
            //TODO - Add constant values in class
            System.debug('inside forloop' + log.Type__c +' -- '+log.SYS_Operation_Type__c+' -- '+ log.SYS_Operation_Type__c);
            System.debug('tyoe here'+log.Type__c+' cmp'+ log.Type__c == 'INBOUND');
            if(log.Type__c == 'OUTBOUND'){
                if(count > 99){
                    newLogsSecond.add(log.id);
                }
                else{
                    newLogsFirst.add(log.id);  
                }   
            } else if(log.Type__c == 'INBOUND' && log.SYS_Operation_Type__c == 'RESPONSE' && log.Status__c == 'NEW') {
                System.debug('inside response@@');
                newInboundResponse.add(log.Id);
            }
            count += 1;
        }
        // String inboundJobId;
        System.debug('response got size=='+ newInboundResponse.size() );
        if(newInboundResponse.size() > 0)
            System.enqueueJob(new SYS_processInboundResponse(newInboundResponse));
        if(newLogList.size() <= 100) { 
            System.debug('inside first==');
            if(newLogsFirst.size() > 0)
                System.enqueueJob(new SYS_IntegrationLogOutboundQueueable(newLogsFirst));
            // if(newInboundFirst.size() > 0) {
            //     System.enqueueJob(new SYS_processInboundCDC_QB(newInboundFirst));
                
            // }
        } else if(newLogList.size() > 100){
            if(newLogsFirst.size() > 0)
                System.enqueueJob(new SYS_IntegrationLogOutboundQueueable(newLogsFirst));
            if(newLogsSecond.size() > 0)
                System.enqueueJob(new SYS_IntegrationLogOutboundQueueable(newLogsSecond));
            // if(newInboundFirst.size() > 0)
            //     System.enqueueJob(new SYS_processInboundCDC_QB(newInboundFirst));
            // if(newInboundSecond.size() > 0)
            //     System.enqueueJob(new SYS_processInboundCDC_QB(newInboundSecond));
        }
    }
}