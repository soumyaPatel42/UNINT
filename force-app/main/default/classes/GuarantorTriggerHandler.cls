public class GuarantorTriggerHandler {
    public static void processAfterInsert(List<Guarantor__c> newList) {
        associateGuarantorAccount(newList);
    }

    public static void associateGuarantorAccount(List<Guarantor__c> newList) {
        List<Guarantor__c> filter = new List<Guarantor__c>();
        System.debug('val=='+newList[0].SYS_Parent__c);
        for(Guarantor__c iter : newList) {
            System.debug('ins parent=='+iter.SYS_Parent__c +'check ==' +(iter.SYS_Parent__c == 'null' ));
            if(iter.SYS_Parent__c != null && iter.SYS_Parent__c != 'null') {
                filter.add(iter);
            }
        }
        System.debug('filter size=='+filter.size());
        if(filter.size() > 0)
            SYS_RelationshipMapper.mapRelationships(filter);
    }
}