public class SYS_IntegrationLogTriggerHandler {  
    

    public static void handleTrigger(List<SYS_IntegrationLog__c> newLogList, System.TriggerOperation triggerEvent) {
        switch on triggerEvent {
            when  AFTER_INSERT  { //AFTER_INSERT, AFTER_UPDATE
                if(SYS_DataCache.enableCheck.get(SYS_Constants.INT_TYPE.toUpperCase()))
                    processLogAfterInsert(newLogList);
            }
        }
    }

    public static void processLogAfterInsert(List<SYS_IntegrationLog__c> newLogList){
        List<Id> newLogsFirst = new List<Id>();
        List<Id> newLogsSecond = new List<Id>();
        List<Id> newInboundFirst = new List<Id>(); 
        List<Id> newInboundSecond = new List<Id>();
        List<SYS_IntegrationLog__c> newInboundResponse = new List<SYS_IntegrationLog__c>(); 
        List<SYS_IntegrationLog__c> updateToken = new List<SYS_IntegrationLog__c>(); 

        // Boolean bypass = SYS_DataCache.objectSettingMap.get(log.QB_Entity__c).BypassTrigger__c != null
        SYS_debug.log('map=='+JSON.serialize(SYS_DataCache.objectSettingMap));
        Map<String, List<Id>> mapStringToId = new Map<String, List<Id>>();
        Integer count = 0;
        for(SYS_IntegrationLog__c log:newLogList){
            //TODO - Add constant values in class
            SYS_debug.log('inside forloop' + log.Type__c +' -- '+log.SYS_Operation_Type__c+' -- '+ log.SYS_Operation_Type__c);
            SYS_debug.log('tyoe here'+log.Type__c+' cmp'+ (log.Type__c == 'INBOUND') );
            if(log.Type__c == 'OUTBOUND'){
                if(count > 99){
                    newLogsSecond.add(log.id);
                }
                else{
                    newLogsFirst.add(log.id);
                }   
            } else if(log.Type__c == 'INBOUND' && log.SYS_Operation_Type__c == 'CDC') {
                SYS_debug.log('indise inbound'+count);
                if(count > 99){
                    newInboundSecond.add(log.id);
                }
                else{
                    newInboundFirst.add(log.id); 
                } 
            } else if(log.Type__c == 'INBOUND' && log.SYS_Operation_Type__c == 'RESPONSE' && log.Status__c == 'NEW' && !SYS_DataCache.objectSettingMap.get(log.QB_Entity__c).BypassTrigger__c ) {
                SYS_debug.log('inside response@@');
                newInboundResponse.add(log);
            } 
            count += 1;
        }
        // String inboundJobId;
        SYS_debug.log('response got size=='+ newInboundResponse.size() );
        // if(newInboundResponse.size() > 0)
        //     System.enqueueJob(new SYS_processResponse_QB(newInboundResponse));
        if(newInboundResponse.size() > 0) {
            processInboundResponse(newInboundResponse);
        }
        
        if(newLogList.size() <= 100) {
            SYS_debug.log('inside first=='); 
            if(newLogsFirst.size() > 0)
                System.enqueueJob(new SYS_IntegrationLogOutboundQueueable(newLogsFirst)); 
            if(newInboundFirst.size() > 0) {
                System.enqueueJob(new SYS_processInboundCDC_QB(newInboundFirst));
                
            }
        } else if(newLogList.size() > 100){
            if(newLogsFirst.size() > 0)
                System.enqueueJob(new SYS_IntegrationLogOutboundQueueable(newLogsFirst));
            if(newLogsSecond.size() > 0)
                System.enqueueJob(new SYS_IntegrationLogOutboundQueueable(newLogsSecond));
            if(newInboundFirst.size() > 0)
                System.enqueueJob(new SYS_processInboundCDC_QB(newInboundFirst));
            if(newInboundSecond.size() > 0)
                System.enqueueJob(new SYS_processInboundCDC_QB(newInboundSecond));
        }
    }

    public static void processInboundResponse(List<SYS_IntegrationLog__c> newList) {
        String jsonBody = '';
        for(SYS_IntegrationLog__c log : newList) {
            jsonBody = log.data0__c != null ? log.data0__c : '' +
                            log.data1__c != null ? log.data1__c : '' +
                            log.data2__c != null ? log.data2__c : '' +
                            log.data3__c != null ? log.data3__c : '' +
                            log.data4__c != null ? log.data4__c : '' +
                            log.data5__c != null ? log.data5__c : '' +
                            log.data6__c != null ? log.data6__c : '' +
                            log.data7__c != null ? log.data7__c : '' +
                            log.data8__c != null ? log.data8__c : '' +
                            log.data9__c != null ? log.data9__c : '' ; 
            
                SYS_integrationLogHandler.transformGETResponseAndUpsertQB( jsonBody , log.WhatId__c); 
        }
    }

     
}