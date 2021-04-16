@isTest
public class SYS_Transformer_QBTest_MS {
    
    @isTest
	static void qbAccountTest() {
        Account ac = new Account(Name = 'Abc inc', BillingStreet = '1 Market st', Phone = '123', SYS_Key__c = '001');
        insert ac;
        
        Contact c = new Contact(AccountId = ac.Id, LastName = 'LTest', FirstName = 'FTest', Phone = '123', email = 'abc@example.com', SYS_Key__c = '001');
        insert c;
        
        //Create Product
        Product2 pro = new Product2(Name = 'iPhone X', Family = 'Mobile' , SYS_Key__c = '001');
        Insert pro;
        
        Product2 pro2 = new Product2(Name = 'iPhone 12 Mini', Family = 'Mobile' , SYS_Key__c = '002');
        Insert pro2;
         
        //Instantiate the Pricebook2 record with StandardPricebookId
        Pricebook2 standardPricebook = new Pricebook2(
            Id = Test.getStandardPricebookId(),
            IsActive = true, SYS_Key__c = '001'
        );
         
        //Execute an update DML on the Pricebook2 record, to make IsStandard to true
        Update standardPricebook;
         
        //Query for the Pricebook2 record, to check IsStandard field
        standardPricebook = [SELECT Id, IsStandard FROM Pricebook2 WHERE Id = :standardPricebook.Id];
        //It should return true
        System.assertEquals(true, standardPricebook.IsStandard);
         
         
        //Create the PricebookEntry
        List<PricebookEntry> pbeList = new List<PricebookEntry>();
        PricebookEntry pbe = new PricebookEntry(
            Pricebook2Id = standardPricebook.Id,
            Product2Id = pro.Id,
            UnitPrice = 1020,
            IsActive = true,
            SYS_Key__c = '001'
        );
        
        pbeList.add(pbe);
        
        pbe = new PricebookEntry(
            Pricebook2Id = standardPricebook.Id,
            Product2Id = pro2.Id,
            UnitPrice = 1020,
            IsActive = true,
            SYS_Key__c = '002'
        );
        pbeList.add(pbe);
        Insert pbeList;
        
        Opportunity op = new Opportunity(IsPrivate=true,OrderNumber__c='123',AccountId = ac.Id,CustomInteger__c=4,SYS_Parent1__c='001', Name = 'TestOp', CloseDate = Date.Today(), Pricebook2Id  = standardPricebook.Id, SYS_Key__c = '001', StageName = 'Closed Won');
        insert op;
        
        
        
        List<OpportunityLineItem> opliList = new List<OpportunityLineItem>();
        for(integer i=0;i<2;i++){
          OpportunityLineItem opl1 = new OpportunityLineItem (Quantity=2, OpportunityId = op.Id ,UnitPrice=0.01,Description='Sample',PriceBookEntryId = pbeList[i].id, SYS_Key__c = '00'+i);
  		  opliList.add(opl1);
        }
        insert opliList;
        
        Date myDate = Date.newInstance(1960, 2, 17);
        op.CloseDate = myDate.addDays(5);
        SYS_TriggerHandler.isExecuted = false;
        upsert op SYS_Key__c;
        
        
        //System.debug('hbdebug '+ JSON.serialize(SYS_Transformer_MS_MS.getRequestJson(new List<sObject>{ac})));
        //System.debug('hbdebug '+ JSON.serialize(SYS_Transformer_MS.getRequestJson(new List<sObject>{c})));
        //--System.debug('************** hbdebug '+ JSON.serialize(SYS_Transformer.getRequestJson(new List<sObject>{op})));
        /*
        Map<Id, String> json = SYS_Transformer.getRequestJson(new List<sObject>{op}); 
        List<Id> keys = new List<Id>(json.keySet());
       
        String jsonStr = json.get(keys[0]);
        List<String> jsonList = new List<String>{jsonStr};
        List<Opportunity> oppObjs = (List<Opportunity>)SYS_Transformer.getSObjectsToUpsert(jsonList, 'invoice');
        
        System.debug('\n\n************** \n json2obj '+ oppObjs +'\n************** \n\n');
        upsert oppObjs SYS_Key__c;
        System.debug('\n\n************** \n Opp Ids '+ oppObjs +'\n************** \n\n');
		*/
    }
    

        
        
    static void createTestMetaData() {

    }
}