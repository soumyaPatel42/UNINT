@isTest
private class ADTOutboundTest {
    public static SYS_IntegrationLog__c insertedlog;
    public static Map<String, String> responseHeaders = new Map<String,String>();
    @isTest static void CheckADTA04OutboundRequest() {
        String adtJson = IMSTestDataFactory.ADTA04JSONStatic(1);
        responseHeaders.put('Content-Type', 'application/json');
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new IMSCalloutMock(200,'OK',adtJson,responseHeaders)); 

        Test.StartTest();
        //Get Account Sobject
        List<Account> accList = IMSTestDataFactory.getAccountSobject(adtJson);
        System.debug('Account Sobject ' + accList);

        //Test Starts Here Create Account
        Database.UpsertResult[] upsertResult = Database.upsert(accList, false);
        Account acc = IMSTestDataFactory.getAccountDetails();                
        System.debug('Account Data : '+ acc);
        
        //Get Member Plan Sobject
        String accId = acc.ID;
        String accExtid = acc.CS_External_ID__c;
        List<MemberPlan> insuranceList = IMSTestDataFactory.getInsuranceSobject(adtJson, accId, accExtid);
        System.debug('Insurance Sobject ' + insuranceList);
        
        for(Database.UpsertResult itr : upsertResult) {
            if(itr.isSuccess()) {
                System.debug('Successful Account upsert!!');
                Database.UpsertResult[] upsertResultIns = Database.upsert(insuranceList, false);
            }
        }                        
        
        //Get Inserted SysLog Record
        insertedlog = IMSTestDataFactory.getSyslog();
        System.debug('Inserted SysLog : '+ insertedlog);
        List< MemberPlan > insurances = IMSTestDataFactory.getInsuranceDetails(accExtid);    

        Test.StopTest();
        System.debug('Accounts Size ' + accList.size());
        System.assertEquals('OUTBOUND',insertedlog.Type__c,'OutBound Request Received Successfully');
        System.assertNotEquals(accList.size(),0,'Successfully Generated Account Sobject');
        System.assertEquals('75412',acc.CS_External_ID__c, 'Successfully Created Account');
        System.assertEquals('ADT_A04',acc.Last_Event__c, 'Successfully Created Account Event Type');
        System.assertNotEquals(insurances.size(),0, 'Successfully Created Insurance');
        
        for(MemberPlan insur:insurances){
            System.assertEquals('ANTHEM BLUE CROSS BLUE SHIELD',insur.Insurance_Company_Organization_Name__c, 'Successfully Created Insurance Plan');
            System.assertEquals('75412',insur.SYS_Parent__c, 'Insurance Successfully Linked to Account');
            System.debug('Insurance Data : '+ insur);
        }
        
    }
    @isTest static void CheckADTA04MultiInsurance() {
        String adtJson = IMSTestDataFactory.ADTA04JSONStatic(2);
        responseHeaders.put('Content-Type', 'application/json');
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new IMSCalloutMock(200,'OK',adtJson,responseHeaders)); 

        Test.StartTest();
        //Get Account Sobject
        List<Account> accList = IMSTestDataFactory.getAccountSobject(adtJson);
        System.debug('Account Sobject ' + accList);

        //Test Starts Here Create Account
        Database.UpsertResult[] upsertResult = Database.upsert(accList, false);
        Account acc = IMSTestDataFactory.getAccountDetails();                
        System.debug('Account Data : '+ acc);
        
        //Get Member Plan Sobject
        String accId = acc.ID;
        String accExtid = acc.CS_External_ID__c;
        List<MemberPlan> insuranceList = IMSTestDataFactory.getInsuranceSobject(adtJson, accId, accExtid);
        System.debug('Insurance Sobject ' + insuranceList);
        
        for(Database.UpsertResult itr : upsertResult) {
            if(itr.isSuccess()) {
                System.debug('Successful Account upsert!!');
                Database.UpsertResult[] upsertResultIns = Database.upsert(insuranceList, false);
            }
        }                        
        
        //Get Inserted SysLog Record
        insertedlog = IMSTestDataFactory.getSyslog();
        System.debug('Inserted SysLog : '+ insertedlog);
        List< MemberPlan > insurances = IMSTestDataFactory.getInsuranceDetails(accExtid);    

        Test.StopTest();
        System.debug('Accounts Size ' + accList.size());
        System.assertEquals('OUTBOUND',insertedlog.Type__c,'OutBound Request Received Successfully');
        System.assertNotEquals(accList.size(),0,'Successfully Generated Account Sobject');
        System.assertEquals('75412',acc.CS_External_ID__c, 'Successfully Created Account');
        System.assertEquals('ADT_A04',acc.Last_Event__c, 'Successfully Created Account Event Type');
        System.assertNotEquals(insurances.size(),0, 'Successfully Created Insurance');
        
        for(MemberPlan insur:insurances){
            System.assertEquals('ANTHEM BLUE CROSS BLUE SHIELD',insur.Insurance_Company_Organization_Name__c, 'Successfully Created Insurance Plan');
            System.assertEquals('75412',insur.SYS_Parent__c, 'Insurance Successfully Linked to Account');
            System.debug('Insurance Data : '+ insur);
        }
        
    }
}