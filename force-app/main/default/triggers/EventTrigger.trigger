trigger EventTrigger on Event (before insert, before update) {
    if(Trigger.isBefore) {
        if(Trigger.isInsert || Trigger.isUpdate) {
            SYS_eventTriggerHandler.processBeforeInsert(Trigger.New);
        }
    }
}