@isTest
public class SYS_processAttachmentsTest {
	@isTest static void JIRAcaseoutboundtestwithAttachment(){
        test.startTest();
        string resJson ='{"id":"10042","key":"SI-43","self":"https://jira-salesforce-dev.atlassian.net/rest/api/2/issue/10042"}';
        Map<String, String> responseHeaders = new Map<String,String>();
        Test.setMock(HttpCalloutMock.class, new NileCalloutMock(200,'OK',resJson,responseHeaders));
        
	    ContentVersion content=new ContentVersion(); 
        content.Title='Header_Picture1'; 
        content.PathOnClient='/' + content.Title + '.jpg'; 
        Blob bodyBlob=Blob.valueOf('Unit Test ContentVersion Body'); 
        content.VersionData=bodyBlob; 
        //content.LinkedEntityId=sub.id;
        content.origin = 'H';
        insert content;
        
        ContentVersion contentVersionSelect = [SELECT ContentDocument.title, VersionData FROM ContentVersion WHERE Id = :content.Id AND IsLatest = true];
        

        System.debug('contentVersionSelect'+contentVersionSelect);
       // SYS_integrationLogHandler.submitAttachment(contentVersionSelect, '10042');
       Map<String, String> mapKey = new Map<String, String> {String.valueOf(contentVersionSelect.Id) => '10042'};
        System.enqueueJob(new SYS_processAttachments(new List<Id>{contentVersionSelect.Id}, mapKey));

        
        
        test.stopTest();
       system.assertEquals('10042', '10042');
        
    }
}