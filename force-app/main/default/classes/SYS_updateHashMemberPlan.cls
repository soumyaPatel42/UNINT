public class SYS_updateHashMemberPlan {
    @InvocableMethod(label = 'Update MemberPlan hash field')
    public static void updateHashField(List<MemberPlan> newList) {
        System.debug('call for hash');
        String hash;
        List<Id> newIdList = new List<Id>();
        List<MemberPlan> insList = new List<MemberPlan>();
        for(MemberPlan ins : newList) {
            newIdList.add(ins.Id);
        }
        insList = Database.query('SELECT Id, SYS_Hash__c, MemberId, Policy_Number__c, Group_Number__c FROM MemberPlan WHERE Id in :newIdList');
        
        for(MemberPlan ins : insList) {
            String accidIns = String.valueOf(ins.get('MemberId'));
            String policyNo = (ins.get('Policy_Number__c') != null) ? String.valueOf(ins.get('Policy_Number__c')).toUppercase() : '';
            String groupNo = (ins.get('Group_Number__c') != null) ? String.valueOf(ins.get('Group_Number__c')).toUppercase() : '';
            hash = SYS_integrationLogHandler.getHashOfRecord(accidIns + policyNo + groupNo);
            ins.put('SYS_Hash__c', hash);
        }
        try{ 
            Database.update(insList);
        } catch(Exception e) {
            System.debug('insurance hash update failed');
        }
    }
}