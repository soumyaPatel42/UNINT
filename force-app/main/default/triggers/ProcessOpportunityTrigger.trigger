trigger ProcessOpportunityTrigger on Opportunity (after insert,after update) {
    SYS_TriggerHandler.process();
}