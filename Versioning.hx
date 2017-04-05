import haxe.macro.Context;
import haxe.macro.Expr;
import sys.FileSystem;
import sys.io.File;
import haxe.io.Path;

class Versioning {
	
  public static function make(): Array<Field> {
    // get existing fields from the context from where build() is called
    var fields = Context.getBuildFields();
	var version = DateTools.format(Date.now(), "%y.%m.%d");
	var version_year = DateTools.format(Date.now(), "%Y");
	
	// Save version to file
	var mainFilePath = FileSystem.fullPath( Context.resolvePath( "Versioning.hx" ) );
	var classFilePath = Path.directory(mainFilePath) + "/build/version.txt";
	File.saveContent( classFilePath, version );
    
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