public class AccountTriggerIMSHandler {

    public static void processAfterInsert(List<Account> newList) {
        // updateExternalId(newList);
    }

    public static void processBefore(List<Account> newList) {
        // updateProviderFields(newList);

        //associateProviderFromNPI(newList);
    }

    public static void associateProviderFromNPI(List<Account> newList) {
        List<String> filter = new List<String>();
        Map<String, Account> mapNpiToAcc = new Map<String, Account>();
        for(Account acc : newList) {
            if(acc.get('Healthcare_Provider_Doctors__c') == null && acc.get('Primary_Provider_Doctor__c') != null &&
            acc.get('RecordTypeId') == Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Patient').getRecordTypeId()) {
                System.debug('inside iftrigger');
                mapNpiToAcc.put(acc.Primary_Provider_Doctor__c, acc);
                filter.add(acc.Primary_Provider_Doctor__c);
                
            }
        }
        List<HealthcareProvider> providerList = [SELECT Id, Provider_NPI_Number__c, Provider_First_Name__c, Provider_Last_Name__c FROM HealthcareProvider WHERE Provider_NPI_Number__c in :filter LIMIT 1000];
        if(providerList.size() > 0) {
            System.debug('provider='+providerList);
            for(HealthcareProvider provider : providerList) {
                if(mapNpiToAcc.get(provider.Provider_NPI_Number__c) != null ) {
                    mapNpiToAcc.get(provider.Provider_NPI_Number__c).Healthcare_Provider_Doctors__c = provider.Id;
                }
            }
        }
    }

    /*
    public static void updateProviderFields(List<Account> newList) {
        List<Id> filter = new List<Id>();
        List<Account> filterAcc = new List<Account>();
        Map<Id, Account> mapProviderToAcc = new Map<Id, Account>();
        for(Account acc : newList) {
            if(acc.get('Healthcare_Provider_Doctors__c') != null && acc.get('Primary_Provider_Doctor__c') == null &&
            acc.get('RecordTypeId') == Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Patient').getRecordTypeId()) {
                filter.add(acc.Healthcare_Provider_Doctors__c);
                filterAcc.add(acc);
                mapProviderToAcc.put(acc.Healthcare_Provider_Doctors__c, acc);
            }
        }
        List<HealthcareProvider> providerList = [SELECT Id, Provider_NPI_Number__c, Provider_First_Name__c, Provider_Last_Name__c FROM HealthcareProvider WHERE Id in :filter LIMIT 1000];
        if(providerList.size() > 0) {
            for(HealthcareProvider provider : providerList) {
                System.debug('provider found!');
                if(mapProviderToAcc.get(provider.Id) != null) {
                    mapProviderToAcc.get(provider.Id).Provider_Doctor_First_Name__c = provider.Provider_First_Name__c;
                    mapProviderToAcc.get(provider.Id).Provider_Doctor_Last_Name__c = provider.Provider_Last_Name__c;
                    mapProviderToAcc.get(provider.Id).Primary_Provider_Doctor__c = provider.Provider_NPI_Number__c;
                    mapProviderToAcc.get(provider.Id).Referring_Doctor_ID__c = provider.Provider_NPI_Number__c;
                    mapProviderToAcc.get(provider.Id).Referring_Doctor_First_Name__c = provider.Provider_First_Name__c;
                    mapProviderToAcc.get(provider.Id).Referring_Doctor_Last_Name__c = provider.Provider_Last_Name__c;
                }
            }
        }
    } */

    // System.debug(Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Patient').getRecordTypeId());
    //AccountTriggerIMSHandler.updateExternalId([select id, CS_External_ID__c,RecordTypeId from account where id = '0012F00000szpsEQAQ' ]);
    public static void updateExternalId(List<Account> newList) { //To update the externalIf after insert
        List<Account> updateAccount = new List<Account>();
        List<Id> IdList = new List<Id>();
        for(Account acc : newList) {
            if(acc.get('CS_External_ID__c') == null && 
                acc.get('RecordTypeId') == Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Patient').getRecordTypeId()) {
                System.debug('inside if');
                IdList.add(acc.Id);
            } 
        }
        for(Account acc : [SELECT Id, CS_External_ID__c FROM Account WHERE Id in : IdList]) {
            Account newAcc = acc;
            newAcc.CS_External_ID__c = 'SF' + acc.Id;
            updateAccount.add(newAcc);
        }
        update updateAccount;
    }
}