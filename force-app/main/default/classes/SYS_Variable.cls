public class SYS_Variable implements SYS_Expression{
    public String  name  {get;private set;}
    public Boolean value {get;private set;}
    public SYS_Variable(String name){ this.name = name; }
    public SYS_Expression add(SYS_Expression expr){ return this; }
    public SYS_Expression set(String name, Boolean value){
        if(this.name != null && this.name.equalsIgnoreCase(name))
            this.value = value;
        return this;
    }
    public Boolean evaluate(){ return value; }
}