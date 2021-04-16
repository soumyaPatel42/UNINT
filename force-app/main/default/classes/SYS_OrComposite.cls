public class SYS_OrComposite extends SYS_Composite{
    public override Boolean evaluate(){
        for(SYS_Expression expr : children) if(expr.evaluate()) return true;
        return false;
    }
}