public class SYS_createLineHashFromQuote {
    @InvocableMethod(label='Create hash for Quote')
    public static void createHashForLineItems(List<SBQQ__Quote__c> newList) {

        
        List<Id> lineId = new List<Id>();
        List<SBQQ__Quote__c> updatedList  = new List<SBQQ__Quote__c>();
        for(SBQQ__Quote__c line: newList) {
            lineId.add(line.Id);
        }
        List<SBQQ__QuoteLine__c> lineList = [SELECT Id, SBQQ__Quote__r.Quickbooks_Id__c ,SBQQ__Product__r.Quickbooks_Id__c, SBQQ__Quantity__c FROM SBQQ__QuoteLine__c WHERE SBQQ__Quote__c in :lineId];
        for(SBQQ__QuoteLine__c line : lineList) {
            String quote = line.SBQQ__Quote__r.Quickbooks_Id__c;
            String prod = line.SBQQ__Product__r.Quickbooks_Id__c;
            String qty = line.SBQQ__Quantity__c + '';
            String hash = SYS_integrationLogHandler.getHashOfRecord(quote + prod + qty);
            line.SYS_Hash__c = hash;  
        }
        Database.update(lineList); 
    }
}