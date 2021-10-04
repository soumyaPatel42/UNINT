public class SYS_eventTriggerHandler {
    public static void processBeforeInsert(List<Event> newList) {
        processAccountRelationship(newList);
    }

    public static void processAccountRelationship(List<Event> newList) {
        List<Event> filter = new List<Event>();
        System.debug('val=='+newList[0].SYS_Parent__c);
        for(Event iter : newList) {
            if(iter.SYS_Parent__c != null) {
                filter.add(iter);
            }
        }
        SYS_RelationshipMapper.mapRelationships(filter);
    }
}