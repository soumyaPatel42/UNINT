public class SYS_createLineHash {
    @InvocableMethod(label='Create hash for QuoteLine')
    public static void mapProductToQuoteLine(List<SBQQ__QuoteLine__c> newList) {

        
        List<Id> lineId = new List<Id>(); 
        List<SBQQ__QuoteLine__c> updatedList  = new List<SBQQ__QuoteLine__c>();
        for(SBQQ__QuoteLine__c line: newList) {
            lineId.add(line.Id);
        }
        List<SBQQ__QuoteLine__c> lineList = [SELECT Id, SBQQ__Quote__r.Quickbooks_Id__c ,SBQQ__Product__r.Quickbooks_Id__c, SBQQ__Quantity__c FROM SBQQ__QuoteLine__c WHERE Id in :lineId];
        for(SBQQ__QuoteLine__c line : lineList) {
            String quote = line.SBQQ__Quote__r.Quickbooks_Id__c;  
            String prod = line.SBQQ__Product__r.Quickbooks_Id__c;
            String qty = Integer.valueOf(line.SBQQ__Quantity__c) + ''; 
            String hash = SYS_integrationLogHandler.getHashOfRecord(quote + prod + qty);
            line.SYS_Hash__c = hash;  
        }
        Database.update(lineList); 
    }
}