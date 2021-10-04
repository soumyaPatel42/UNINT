trigger AccountTriggerIMS on Account (after insert, before insert, before update) {
    if(Trigger.isInsert && Trigger.isInsert) {
        AccountTriggerIMSHandler.processAfterInsert(Trigger.New);
    } if ( (Trigger.isInsert || Trigger.isUpdate ) && Trigger.isBefore) {
        AccountTriggerIMSHandler.processBefore(Trigger.New);
    }
}