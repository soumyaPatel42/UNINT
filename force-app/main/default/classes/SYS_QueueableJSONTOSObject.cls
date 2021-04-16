public class SYS_QueueableJSONTOSObject implements Queueable {
    
    public List<String> childRecList;
    public String key;
    
    public SYS_QueueableJSONTOSObject(List<String> childRecList,String key,String objName){
        this.childRecList = childRecList;
        this.key = key;
    }
    
    public void execute(QueueableContext context){
        //Set isChild to true so that the primaryobject could be set to root of related records instead of parent
        SYS_Transformer.isChild = true;
        SYS_Transformer.getSObjectsToUpsert(childRecList,key);
    }
}