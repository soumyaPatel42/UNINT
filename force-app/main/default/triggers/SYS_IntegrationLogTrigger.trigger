trigger SYS_IntegrationLogTrigger on SYS_IntegrationLog__c (after insert) {
    if(Trigger.isInsert && Trigger.isAfter){
        SYS_IntegrationLogTriggerHandler.processLogAfterInsert(Trigger.new);
    }
}