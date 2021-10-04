trigger MemberPlanTrigger on MemberPlan (before insert, before update, after insert) {
    if(Trigger.isBefore) {
        if(Trigger.isUpdate || Trigger.isInsert) {
            MemberPlanTriggerHandler.processBeforeInsert(Trigger.New);
        }
    } 
    
}