@isTest
public class SYS_createLineHashTest {
    @isTest static void mapProductToQuoteLineTest(){
     Product2 prob = QuickbooksTestDataFactory.productCreate();
        insert prob;
      PricebookEntry pe =QuickbooksTestDataFactory.PricebookEntryCreate(prob.Id);
        insert pe;
      SBQQ__Quote__c quote = QuickbooksTestDataFactory.Quotecreation2();  
        insert quote;
       SBQQ__QuoteLine__c quoteline = QuickbooksTestDataFactory.quotelinecreation(quote.Id,prob.Id,pe.Id);  
        insert quoteline;
        list<SBQQ__QuoteLine__c> quotelineList = [select name,SBQQ__Quote__c,SBQQ__Product__c,SBQQ__Quantity__c from SBQQ__QuoteLine__c];
        SYS_createLineHash.mapProductToQuoteLine(quotelineList);
        SYS_quoteLineMapper.mapProductToQuoteLine(quotelineList);
        system.assert(quotelineList.size()>0);
    }

}