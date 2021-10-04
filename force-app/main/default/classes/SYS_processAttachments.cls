public class SYS_processAttachments implements Queueable, Database.AllowsCallouts {
    public List<Id> contentVerId = new List<Id>();
    public Map<String, String> mapVerToKey = new Map<String, String>();

    public SYS_processAttachments(List<Id> idList, Map<String, String> keyMap) {
        this.contentVerId = idList;
        this.mapVerToKey = keyMap;
    }
    public void execute(QueueableContext context){  
        if(contentVerId.size() > 0) {
            String contentId = String.valueOf(contentVerId[0]); 
            System.debug('inattachments'+contentId);
            String query = 'SELECT Id, ContentDocument.title, VersionData FROM ContentVersion WHERE Id = :contentId AND IsLatest = true';
            System.debug('queryy=='+query); 
            List<ContentVersion> contentList = Database.query(query);
            if(contentList.size() > 0) {
                SYS_integrationLogHandler.submitAttachment(contentList[0], mapVerToKey.get(contentList[0].Id)); 
            }
            contentVerId.remove(0);
        }
        if(contentVerId.size() > 0)
            System.enqueueJob(new SYS_processAttachments(contentVerId, mapVerToKey)); 
    }
    // System.enqueueJob(new SYS_processAttachments());
}