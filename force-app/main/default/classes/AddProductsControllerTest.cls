@isTest
private class AddProductsControllerTest {
  @isTest static  void myUnitTest(){
       Product2 prod = new Product2(Name = 'Laptop X200', Family = 'Hardware', ProductCode = 'code', Description = 'desc');
        test.startTest();
      insert prod;

        Id pricebookId = Test.getStandardPricebookId();

        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id, UnitPrice = 10000, IsActive = true);
        insert standardPrice;

        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB;

        PricebookEntry customPrice = new PricebookEntry(Pricebook2Id = customPB.Id, Product2Id = prod.Id, UnitPrice = 12000, IsActive = true);
        insert customPrice;

      	String paRecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient Account').getRecordTypeId();
        Account acc = new Account(LastName='TestPAccount', FirstName='TestPAccount', Phone='7175551212', 
              PersonMobilePhone='7175551313', RecordTypeId=paRecordTypeID, Type='Patient');
        insert acc;

        Opportunity opp = new Opportunity(Name = 'TestOpportunity', AccountId = acc.Id, CloseDate = Date.Today(), StageName = 'Suspect', Pricebook2Id = customPB.Id);
        insert opp;

        OpportunityLineItem oli = new OpportunityLineItem(OpportunityId = opp.Id, Quantity = 5, PricebookEntryId = customPrice.Id, Description='description' , TotalPrice= 10000);
        
        insert oli;
        test.stopTest();
         
        Quote quttest = new Quote ();
        quttest.Name = 'qoutetest' ;
        quttest.OpportunityId = opp.id ;
        quttest.Pricebook2Id = customPB.Id;
        //insert quttest ;

        QuoteLineItem qliliner1 = new QuoteLineItem();
        qliliner1.QuoteId = quttest.id;
        qliliner1.PriceBookEntryID = customPrice.Id;
        qliliner1.Quantity = 4;
        qliliner1.UnitPrice = 5;
        //insert qliliner1;

        List<QuoteLineItem> qliList = new List<QuoteLineItem>{qliliner1};
        AddProductsController.createQuoteLineItem(quttest, qliList);

        AddProductsController.getOpportunityLineItem(opp.Id);
        Map<String, Schema.SObjectType> globalDescMap=Schema.getGlobalDescribe();
        Schema.SObjectType targetType=globalDescMap.get('QuoteLineItem');
        sObject sObj=targetType.newSObject();
        AddProductsController.fetchPickListValue(sObj,'Discount_Reason__c');
    }
}