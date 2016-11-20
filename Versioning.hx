import haxe.macro.Context;
import haxe.macro.Expr;

class Versioning {
	
  public static function make(): Array<Field> {
    // get existing fields from the context from where build() is called
    var fields = Context.getBuildFields();
	var version = DateTools.format(Date.now(), "%y.%m.%d");
	var version_year = DateTools.format(Date.now(), "%Y");
    
    // append a field
    fields.push({
      name: "VERSION",
      access: [Access.APublic, Access.AStatic, Access.AInline],
      kind: FieldType.FVar(macro:String, macro $v{version}), 
      pos: Context.currentPos(),
    });
    fields.push({
      name: "VERSION_YEAR",
      access: [Access.APublic, Access.AStatic, Access.AInline],
      kind: FieldType.FVar(macro:String, macro $v{version_year}), 
      pos: Context.currentPos(),
    });
    
    return fields;
  }
}