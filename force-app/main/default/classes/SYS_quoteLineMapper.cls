public class SYS_quoteLineMapper {
    @InvocableMethod(label='Map Product to QuoteLine')
    public static void mapProductToQuoteLine(List<SBQQ__QuoteLine__c> newList) {

        
        List<Id> lineId = new List<Id>();
        List<SBQQ__QuoteLine__c> updatedList  = new List<SBQQ__QuoteLine__c>();
        for(SBQQ__QuoteLine__c line: newList) {
            lineId.add(line.Id);
        }
        List<SBQQ__QuoteLine__c> lineList = [SELECT Id, SYS_Parent__c FROM SBQQ__QuoteLine__c WHERE Id in :lineId];
        if(newList.size() > 0) {
            SYS_debug.log('map Product');  
            updatedList = SYS_RelationshipMapper.mapRelationships(lineList);

        }
        Database.update(updatedList);
    }
    
}