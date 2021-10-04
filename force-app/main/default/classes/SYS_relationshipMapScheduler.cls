public class SYS_relationshipMapScheduler implements Schedulable {
    public void execute(SchedulableContext sc) {
        SYS_relationshipMapEventBatch evtBatch = new SYS_relationshipMapEventBatch(); 
        database.executebatch(evtBatch);
    }
}