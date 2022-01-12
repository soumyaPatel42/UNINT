@isTest
public class SYS_createLineHashFromQuoteTest {
    @isTest static void createHashForLineItems(){
        Product2 prob = QuickbooksTestDataFactory.productCreate();
        insert prob;
      PricebookEntry pe =QuickbooksTestDataFactory.PricebookEntryCreate(prob.Id);
        insert pe;
      SBQQ__Quote__c quote = QuickbooksTestDataFactory.Quotecreation2();  
        insert quote;
       SBQQ__QuoteLine__c quoteline = QuickbooksTestDataFactory.quotelinecreation(quote.Id,prob.Id,pe.Id);  
        insert quoteline;
        list<SBQQ__Quote__c> quoteList = [select name,SBQQ__Status__c,Id,Quickbooks_Id__c,SBQQ__ExpirationDate__c from SBQQ__Quote__c];
        SYS_createLineHashFromQuote.createHashForLineItems(quoteList);
        system.assert(quoteList.size()>0);
        system.assertEquals('93',quoteList[0].Quickbooks_Id__c);
    }
}