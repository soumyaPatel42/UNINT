public class SYS_TriggerHandler {
	public static Boolean isExecuted = false;
    
    public static void process() {
        System.debug('\n\n********* In TH:'+isExecuted); 
        if(isExecuted || !Trigger.isExecuting || !Trigger.isAfter) {
            return;
        }
        isExecuted = true;
        //This is a trigger, now route to the right handler
        if(Trigger.isInsert) {
          SYS_OutBoundBatchHandler.processInsert(Trigger.new);  
        } else if(Trigger.isUpdate) {
          SYS_OutBoundBatchHandler.processUpdate(Trigger.oldMap, Trigger.newMap);  
        }
        else if(Trigger.isDelete) {
          SYS_OutBoundBatchHandler.processDelete(Trigger.old);  
        }
        else if(Trigger.isUndelete) {
          SYS_OutBoundBatchHandler.processUndelete(Trigger.new);  
        }
    }
}