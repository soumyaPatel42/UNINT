@isTest
public class ClosedOpportunityTriggerTest {
    @isTest static void ClosedOpportunityTriggerTest() {
        Account acc = new Account();
        acc.Name = 'Sample Accoount';
        acc.BillingStreet = 'California 1';
        acc.BillingCity = 'Long Beach';
        acc.BillingPostalCode = '20001';
        acc.BillingState = 'CA';
        acc.BillingCountry = 'United States';
        acc.ShippingStreet = 'California 1';
        acc.ShippingCity = 'Long Beach';
        acc.ShippingPostalCode = '20001';
        acc.ShippingState = 'CA';
        insert acc;
        Opportunity nopp= new Opportunity();
        nopp.AccountId = acc.Id;
        nopp.Name = 'Test Follow Up Test Task';
        nopp.StageName = 'Closed Won';
        nopp.CloseDate = System.Today().addMonths(12);
        insert nopp;
        List<Task> tsks = [SELECT WhatId,Subject FROM Task];
        Task tsk = (tsks.size() > 0)? tsks[0] : new Task();
        system.assertEquals(tsk.Subject,'Follow Up Test Task');     
    }
}