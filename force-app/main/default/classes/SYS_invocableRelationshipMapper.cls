public class SYS_invocableRelationshipMapper {
    
    //Specific to Account object, use to map the unassociated insurance or event.
    @InvocableMethod(label='Map Insurance and Event to Account' description='Map Insurance and Event to Account')
    public static void mapChildToParent(List<sObject> newList) {
        List<String> newRecordIds = new List<String>();
        
        if(newList[0].Id.getSObjectType().getDescribe().getName() == 'Account') {
            System.debug('inside acc::');
            for(sObject obj : newList) {
                newRecordIds.add(String.valueOf(obj.get('CS_External_ID__c')));
            }

            String queryStr = 'Select Id, whatId, SYS_Parent__c from Event where SYS_Parent__c in : newRecordIds and whatid = null';
            List<sObject> data  = Database.query(queryStr);
            System.debug('query+=='+queryStr);
            
            if(data.size() > 0) {
                List<sObject> updateEventList = SYS_RelationshipMapper.mapRelationships(data);
                Database.SaveResult[] results = Database.update(updateEventList, false);
                for (Database.SaveResult result : results) {
                    if (!result.isSuccess()){ 
                        for (Database.Error err : result.getErrors()){
                        System.debug('Error: '+ err.getStatusCode() + ' ' + err.getMessage());
                        }
                    }
                }
            }
                
            
            queryStr = 'Select Id, MemberId, SYS_Parent__c from MemberPlan where SYS_Parent__c in : newRecordIds and Member.Name = \'JOHN-DOE-DUMMY-ACC\' ';
            System.debug('query+=='+queryStr);
            data  = Database.query(queryStr);
            
            if(data.size() > 0) {
                List<sObject> updateInsuranceList = SYS_RelationshipMapper.mapRelationships(data);
                Database.SaveResult[] results = Database.update(updateInsuranceList, false);
                results = Database.update(updateInsuranceList, false);
                for (Database.SaveResult result : results) {
                    if (!result.isSuccess()){
                        for (Database.Error err : result.getErrors()){
                        System.debug('Error: '+ err.getStatusCode() + ' ' + err.getMessage());
                        }
                    }
                }
            }   
        }
        
    }
}