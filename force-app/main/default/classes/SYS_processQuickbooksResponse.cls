global class SYS_processQuickbooksResponse {
    @InvocableMethod(label='Update Quickbooks Id')
    global static void updateIdAndToken(List<SYS_IntegrationLog__c> newList) {

        List<Id> lineId = new List<Id>(); 
        if(newList.size() > 0) {
            SYS_debug.log('inside update Id');
            SYS_integrationLogHandler.updateQuickbooksId(newList);

        }
    }
}