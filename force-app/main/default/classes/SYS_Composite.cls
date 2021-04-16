public abstract class SYS_Composite implements SYS_Expression{
    public List<SYS_Expression> children {get; private set;}
    public SYS_Composite(){ this.children = new List<SYS_Expression>(); }
    public SYS_Expression add(SYS_Expression expr){
        children.add(expr); return this;
    }
    public SYS_Expression set(String name, Boolean value){
        for(SYS_Expression expr : children) expr.set(name,value);
        return this;
    }
    public abstract Boolean evaluate();
    public Boolean hasChildren{get{ return !children.isEmpty(); }}
}