trigger guarantorTrigger on Guarantor__c (before insert, before update) {
    if((Trigger.isUpdate || Trigger.isInsert) && Trigger.isBefore ) {
        GuarantorTriggerHandler.processAfterInsert(Trigger.New);
    }
}