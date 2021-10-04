public class MemberPlanTriggerHandler {
    public static void processBeforeInsert(List<MemberPlan> newList) {
        associateMemberAccount(newList);
    }
    
    public static void associateMemberAccount(List<MemberPlan> newList) {
        List<MemberPlan> filter = new List<MemberPlan>();
        System.debug('val=='+newList[0].SYS_Parent__c);
        for(MemberPlan iter : newList) {
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