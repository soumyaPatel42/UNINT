public class SYS_AndComposite extends SYS_Composite{
	public override Boolean evaluate(){
        for(SYS_Expression expr : children) if(!expr.evaluate()) return false;
        return true;
    }
}