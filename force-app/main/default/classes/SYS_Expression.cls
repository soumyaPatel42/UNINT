public interface SYS_Expression {
    SYS_Expression add(SYS_Expression expr);
    SYS_Expression set(String name, Boolean value);
    Boolean evaluate();
}