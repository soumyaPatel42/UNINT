public class SYS_relationshipMapEventBatch implements Database.Batchable<sObject>{
    public Database.QueryLocator start(Database.BatchableContext BC){
        String query = 'SELECT Id, whatId, SYS_Parent__c FROM Event WHERE SYS_Parent__c != null AND whatId = null';
        return Database.getQueryLocator(query);
     }
  
     public void execute(Database.BatchableContext BC, List<sObject> scope){
        List<sObject> newList = SYS_RelationshipMapper.mapRelationships(scope);
        update scope;
    }
  
     public void finish(Database.BatchableContext BC){
     }
}