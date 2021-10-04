public class SYS_updateHashGuarantor { 
    @InvocableMethod(label = 'Update guarantor hash field')
    public static void updateHashField(List<Guarantor__c> newList) {
        System.debug('call for hash');
        String hash;
        List<Id> newIdList = new List<Id>();
        List<Guarantor__c> gtList = new List<Guarantor__c>();
        for(Guarantor__c gt : newList) {
            newIdList.add(gt.Id); 
        }
        gtList = Database.query('SELECT Id, Account__c, First_Name__c, Last_Name__c, Zip_Code__c FROM Guarantor__c WHERE Id in :newIdList');
        
        for(Guarantor__c guarantor : gtList) {
            String accidGuarantor = String.valueOf(guarantor.get('Account__c')); 
            String firstname = (guarantor.get('First_Name__c') != null)? String.valueOf(guarantor.get('First_Name__c')).toUppercase() : '';
            String lastname = (guarantor.get('Last_Name__c') != null) ? String.valueOf(guarantor.get('Last_Name__c')).toUppercase() : '';
            String zip = (guarantor.get('Zip_Code__c') != null) ? String.valueOf(guarantor.get('Zip_Code__c')).toUppercase() : '';
            hash = SYS_integrationLogHandler.getHashOfRecord(accidGuarantor + firstname + lastname + zip);
            guarantor.put('SYS_Hash__c', hash); 
        }
        try{
            Database.update(gtList);
        } catch(Exception e) {
            System.debug('guarantor hash update failed');
        }
        
    }

}