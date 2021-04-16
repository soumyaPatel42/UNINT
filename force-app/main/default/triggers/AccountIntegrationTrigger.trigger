trigger AccountIntegrationTrigger on Account (before insert) { //add all event
	//TriggerHandler.process();
	//Handler will also check if particular field is changed to see if we need send it or not
	//There is static context to make sure the same operation is not done through trigger and process builder
}