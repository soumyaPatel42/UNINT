@isTest
public class SYS_IntegrationLogOutboundQueueableTest {
    @isTest static void getJSONChunckedValuesTest(){
    string resJson = '{"Customer":{"Taxable":true,"BillAddr":{"Id":"322","Line1":"Delaware","City":"Corolla","Country":"United States","CountrySubDivisionCode":"NC","PostalCode":"27927"},"ShipAddr":{"Id":"323","Line1":"Delaware","City":"Corolla","Country":"United States","CountrySubDivisionCode":"NC","PostalCode":"27927"},"Job":false,"BillWithParent":false,"Balance":0,"BalanceWithJobs":0,"CurrencyRef":{"value":"USD","name":"United States Dollar"},"PreferredDeliveryMethod":"Print","IsProject":false,"domain":"QBO","sparse":false,"Id":"106","SyncToken":"0","MetaData":{"CreateTime":"2021-10-21T14:15:17-07:00","LastUpdatedTime":"2021-10-21T14:15:17-07:00"},"FamilyName":"AccountTesting","FullyQualifiedName":"sk15","DisplayName":"sk15","PrintOnCheckName":"AccountTesting","Active":true,"Mobile":{"FreeFormNumber":"+19999999999"},"PrimaryEmailAddr":{"Address":"js@gmail.com"},"DefaultTaxCodeRef":{"value":"2"}},"time":"2021-10-21T14:16:17.286-07:00"}';
        SYS_IntegrationLogOutboundQueueable.getJSONChunckedValues(resJson);
         SYS_IntegrationLogOutboundQueueable.getJSONChunckedValues('');
        //system.asser
    }
}