public class SYS_GetChangedRecords {
    
    public static Boolean isString(String val){
        try{
            String.valueOf(val);
            return true;
        }catch(Exception e){
            return false;
        }
    }
    
    public static Boolean isBoolean(String val){
        try{
            Boolean.valueOf(val);
            return true;
        }catch(Exception e){
            return false;
        }
    }
    
    
    
    public class Expr{
        Object lhs;
        Object rhs;
        String op;
        sObject currentObj;
        //Map<String,String> v = new Map<String,String>{'a'=>'1','b'=>'2','c'=>'3','e'=>'4'};
        public Expr(String tokenExpr,sObject obj){
            currentObj = obj;
            String expr = '';
            if((expr = tokenExpr.replace('>=','#')).indexOf('#')>0){
                op = '>=';
            }
            else if((expr = tokenExpr.replace('<=','#')).indexOf('#')>0){
                op = '<=';
            }
            else if((expr = tokenExpr.replace('>','#')).indexOf('#')>0){
                op = '>';
            }
            else if((expr =tokenExpr.replace('<','#')).indexOf('#')>0){
                op = '<';
            }
            else if((expr =tokenExpr.replace('==','#')).indexOf('#')>0){
                op = '==';
            }
            else if((expr =tokenExpr.replace('!=','#')).indexOf('#')>0){
                op = '!=';
            }
            else{ 
                System.debug('Operator is invalid');
            }
            
            lhs = currentObj.get(expr.substringBefore('#').trim());
            rhs = objectify(currentObj,expr.substringAfter('#').trim());
        }
        
        public Object objectify(sObject currentObj,String operand){
            Object obj;
            //operand is a string
            if(operand.contains('"')){
                obj = operand.replace('"','');   
            }
            else if(operand.toLowerCase()=='null'){
                obj = null;
            }
            else if(operand.isNumeric()){
                obj = operand;
            }
            else if(SYS_GetChangedRecords.isBoolean(operand)){
                obj = Boolean.valueOf(operand);
            }
            else{
                //operand is an API name
                obj = currentObj.get(operand);
            }
            
            return obj;
        }
        
        public Boolean evaluate(){
            
            /*
            SObjectType r = (currentObj).getSObjectType();
            DescribeSObjectResult d = r.getDescribe();
            String fieldType = d.fields
                        		.getMap()
                        		.get(String.valueOf(lhs))
                        		.getDescribe()
                        		.getType()+'';
            
            //TODO Possible fieldtypes DATETIME, INTEGER, STRING, BOOLEAN, PICKLIST, DOUBLE, CURRENCY, REFERENCE
            System.debug('field type:'+fieldType);
			*/
            
            System.debug('Checking If '+lhs+' '+op+' '+rhs);
            switch on op {
                when '<=' {
                    return (Double.valueOf(lhs) <= Double.valueOf(rhs));
                }	
                when '>=' {
                    return (Double.valueOf(lhs) >= Double.valueOf(rhs));
                }
                when '<' {
                    return (Double.valueOf(lhs) < Double.valueOf(rhs));
                }
                when '>' {
                    return (Double.valueOf(lhs) > Double.valueOf(rhs));
                }
                when '!=' {
                    return (lhs != rhs);
                }
                when '==' {
                    return (lhs == rhs);
                }
                when else {
                    return false;
                }
            }
        }
    }
    

    public static String charAt(String str,Integer index){
        return str.substring(index,index+1);
    }
    
    public static List<sObject> querySObject(String rawInfixExpr,List<sObject> currentObjs){
        if(rawInfixExpr == ''){
        	return currentObjs;
        }
        List<sObject> filteredList = new List<sObject>();
        
        List<String> output = new List<String>();//array that holds the output in postfix notation
        SYS_Stack stack = new SYS_Stack();//stack for holding the operators during conversion
        List<String> infixAsToken = new List<String>();//array of inputStr as tokens  
        List<String> operators = new List<String>{'^', '*'};//holds array of operators
        List<String> braces = new List<String>{'(', ')'};//host array of braces
        String temp = '';
        Boolean error = false;//if there is an error this variable is set to true
        Map<String,Integer> precedence = new Map<String,Integer>{'^'=>3, '*'=>2, '/'=>2, '+'=>1, '-'=>1, '('=>0, ')'=>0};//holds an array of operators and their precedence value
        Integer opCnt = 0;
        rawInfixExpr = (!rawInfixExpr.contains('&&') && !rawInfixExpr.contains('||'))?rawInfixExpr+'||'+rawInfixExpr:rawInfixExpr;
        String infixExpr = rawInfixExpr.replace('&&','*').replace('||','^');
        System.debug('infixExpr:'+infixExpr);
        /****************************************** T O K E N I Z A T I O N starts ***********************************/
        if ((charAt(infixExpr,0) == '+') || (charAt(infixExpr,0) == '-')) {
            infixExpr = '0' + infixExpr;
        }
        
        //loop through all the values
        for (integer i = 0; i < infixExpr.length(); i++) {
            //check if its an operator or a braces
            //Also checks if the temp buffer is empty. If its not, it pushes it unto the stack and emptys the temp
            if (operators.contains(charAt(infixExpr,i)) || braces.contains(charAt(infixExpr,i))) {
                if (temp.length() != 0) {
                    infixAsToken.add(temp);
                    temp = '';
                }
                infixAsToken.add(charAt(infixExpr,i));
                continue;
            }
            //if the character is a decimal no add it to the temp
            if (charAt(infixExpr,i) == '.') {
                temp = temp + '.';
                continue;
            }
            //if the character is a no, then add it to temp
            //if(!isNaN(inputStr.charAt(i))){
            temp = temp + charAt(infixExpr,i);
            continue;
            //}
        } //loop ends
        
        //check if there are still values in the temp after running through the array
        if (temp.length() != 0) {
            infixAsToken.add(temp);
            temp = '';
        }
        /****************************************** T O K E N I Z A T I O N ends ***********************************/
        System.debug('infixAsToken:'+infixAsToken);
    	for (integer i = 0; i < infixAsToken.size(); i++) {
            if (infixAsToken[i].isNumeric()) { //if its a no, push to the output stack
                output.add(infixAsToken[i]);
        
            } else if (operators.contains(infixAsToken[i])) { //if its an operator
                opCnt = opCnt+1;
                if (stack.size() == 0) { //if the stack is empty, push the new operator to the stack
                    stack.push(infixAsToken[i]); //push to stack
                } else {
                    //while whats at the top of the stack has greater precedence, pop it off to the output
                    while (precedence.get((String)stack.peek()) >= precedence.get(infixAsToken[i])) {
                        //if both the new entry and previous entry top of the stack are ^. Just push to output
                        if ((infixAsToken[i] == '^') && (precedence.get((String)stack.peek()) == precedence.get(infixAsToken[i]) )) {
                            break;
                        }
                        output.add((String)stack.pop());
                        if (stack.size() == 0) { //after poping of, if the stack is now empty exit loop
                            break;
                        }
                    }
                    stack.push(infixAsToken[i]);
                }
                
            } else if (braces.contains(infixAsToken[i])) { //if its a braces
                if (infixAsToken[i] == '(') { //if its a left brace, push into the stack
                    stack.push('(');
                } else {
                    while (stack.peek() != '(') { //if its a right, pop off
                        output.add((String)stack.pop());
                    }
                    stack.pop(); //get the ( out of the stack
                }
            } else if (isString(infixAsToken[i])) {
                output.add(infixAsToken[i]);
            }
        }
        
        if (stack.size() != 0) {
            while (stack.size() != 0) {
                output.add((String)stack.pop());
            }
        }
        System.debug('opCnt:'+opCnt);
        System.debug('Postfix:'+output);
        SYS_Expression expr;
        
     	Map<String,String> exprTokenMap = new Map<String,String>();
        Integer key=0;
        for (integer j = 0; j < output.size(); j++) {
            System.debug('Final evaluation:'+j);
            
            if (operators.contains(output[j])) {
                                
                if (output[j] == '*') {
                    if (expr == NULL) {
                        exprTokenMap.put(key + '', output[j - 1]);
                        exprTokenMap.put((key+1) + '', output[j - 2]);
                        expr = 	(new SYS_AndComposite())
                            	.add(new SYS_Variable(key+''))
                            	.add(new SYS_Variable((key+1)+''));
                		key=key+2;
                        
                        output.remove(j);
                        output.remove(j-1);
                        output.remove(j-2);
                        j=j-3;
                    } else {
                        exprTokenMap.put(key + '', output[j - 1]);
                        SYS_Expression prevExpr = expr;
                        expr = (new SYS_ANDComposite())
                            	.add(new SYS_Variable(key+''))
                                .add(prevExpr);
                        key=key+1;
                        output.remove(j);
                        output.remove(j-1);
                        j=j-2;
                    }
            
            
                } else if (output[j] == '^') {
                    if (expr == NULL) {
                        exprTokenMap.put(key + '', output[j - 1]);
                        exprTokenMap.put((key+1) + '', output[j - 2]);
                        expr = 	(new SYS_ORComposite())
                            	.add(new SYS_Variable(key+''))
                            	.add(new SYS_Variable((key+1)+''));
                		key=key+2;
                        
                        output.remove(j);
                        output.remove(j-1);
                        output.remove(j-2);
                        j=j-3;
                        
                    } else {
                        exprTokenMap.put(key + '', output[j - 1]);
                        SYS_Expression prevExpr = expr;
                        expr = (new SYS_ORComposite())
                            	.add(new SYS_Variable(key+''))
                                .add(prevExpr);
                        key=key+1;
                        output.remove(j);
                        output.remove(j-1);
                        j=j-2;
                    }
                }
            
            }

        }
        
        
        System.debug('Expression Map:'+exprTokenMap);
        
        for(sObject currentObj : currentObjs){
            for(String k:exprTokenMap.keySet()){
                Expr e = new Expr(exprTokenMap.get(k),currentObj);
                expr.set(k,e.evaluate());
            }
            System.debug('Expression:'+expr);
            System.debug('Expression evaluation:'+expr.evaluate());
            
            if(expr.evaluate())
                filteredList.add(currentObj);
        }

        return filteredList;
    }
    
    public static List<sObject> filterRecords(Map<Id, sObject> oldMap, Map<Id, sObject> newMap){
        List<sObject> filteredRecords = new List<sObject>(); 
        if(!Trigger.isExecuting){
            System.debug('\n\n********* In GCR first if');
            return filteredRecords;
        }
        else if(Trigger.isDelete){
            //TODO for delete
        }
        else{
            SObjectType objectType = oldMap.values()[0].getSObjectType();
        	String primaryObj = JSON.serialize(objectType.getDescribe().getName()).replace('\"','');
            System.debug('\n\n********* In GCR primaryObj:'+primaryObj);
            
            //SYS_DataCache.ObjectContext = primaryObj;
            List<String> updatedFields = new List<String>();
            List<FieldSetting__mdt> mappings = SYS_DataCache.FieldSettingMappings;
            String triggerExpression = (mappings[0].ObjectSetting__r.Trigger_Condition__c!=null)?mappings[0].ObjectSetting__r.Trigger_Condition__c:'';

            List<sObject> filteredList = querySObject(triggerExpression,newMap.values());
            for(sObject rec: filteredList){

            	for(FieldSetting__mdt mapping : mappings) {
                	System.debug('\n\n********* In GCR rec:'+rec.get('id'));
                	Id recordId = (Id)rec.get('id');
                    if(mapping.FieldApiName__c==NULL)continue;
                        
                	System.debug('\n\n********* In GCR for field:'+mapping.FieldApiName__c+' '+mapping.FieldApiName__c.indexOf('.'));
                    if(mapping.ObjectApiName__c == primaryObj && mapping.FieldApiName__c.indexOf('.')<0){
                    	System.debug('\n\n********* In GCR Old Value:'+oldMap.get(recordId).get(mapping.FieldApiName__c));   
                        System.debug('\n\n********* In GCR New Value:'+newMap.get(recordId).get(mapping.FieldApiName__c));
                        if(oldMap.get(recordId).get(mapping.FieldApiName__c)!=newMap.get(recordId).get(mapping.FieldApiName__c)){
                        	filteredRecords.add(rec);
                        }
                    }
                }
            	
            }
            
            
        }
        
        return filteredRecords;
    }

}