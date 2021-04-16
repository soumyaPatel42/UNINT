@isTest
public class SYS_Transformer_QBTest {
    
    @isTest
	static void qbAccountTest() {
        Account ac = new Account(Name = 'Abc inc', BillingStreet = '1 Market st', Phone = '123', SYS_Key__c = '001');
        insert ac;
        
        Contact c = new Contact(AccountId = ac.Id, LastName = 'LTest', FirstName = 'FTest', Phone = '123', email = 'abc@example.com', SYS_Key__c = '001');
        insert c;
        
        //Create Product
        Product2 pro = new Product2(Name = 'iPhone X', Family = 'Mobile' , SYS_Key__c = '001');
        Insert pro;
         
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
        PricebookEntry pbe = new PricebookEntry(
            Pricebook2Id = standardPricebook.Id,
            Product2Id = pro.Id,
            UnitPrice = 1020,
            IsActive = true,
            SYS_Key__c = '001'
        );
        Insert pbe;
        
        Opportunity op = new Opportunity(AccountId = ac.Id, Name = 'TestOp', CloseDate = Date.Today(), Pricebook2Id  = standardPricebook.Id, SYS_Key__c = '001', StageName = 'Closed Won');
        insert op;
        
        OpportunityLineItem opl1 = new OpportunityLineItem (Quantity=2, OpportunityId = op.Id ,UnitPrice=0.01,PriceBookEntryId = pbe.id, SYS_Key__c = '001');
        insert opl1;
        
        //System.debug('hbdebug '+ JSON.serialize(SYS_Transformer.getRequestJson(new List<sObject>{ac})));
        //System.debug('hbdebug '+ JSON.serialize(SYS_Transformer.getRequestJson(new List<sObject>{c})));
        System.debug('hbdebug '+ JSON.serialize(SYS_Transformer.getRequestJson(new List<sObject>{op})));
    
    }
    

        
        
    static void createTestMetaData() {

    }
}