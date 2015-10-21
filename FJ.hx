import sys.FileSystem;
import sys.io.File;
import com.richsearle.modules.Hello;
import com.richsearle.modules.Av;
import com.richsearle.modules.Input;
import sys.io.Process;
import haxe.Http;

typedef Command = {
    command:String,
    args:Array<String>,
    pid:Int,
    exitcode:Int,
    stdout:String,
    }


class FJ {

    static var args:Array<String>;
    static var commandHistory:Array<Command>;

    static function main() {
        commandHistory = new Array<Command>();

        args = Sys.args();



        if (args.length > 0 && Sys.systemName() == "Windows") args.shift();

        if(args[0]!= null)
        {
            var moduleName = args.shift();
            //need to uppercase the first letter (remember this for modules);
            moduleName = moduleName.substring(0,1).toUpperCase() + moduleName.substring(1);

            //take the method and save the rest for params
            var methodName = args.shift();
            var methodParams = args;

            println("loading "+ moduleName +" module");

           // print("" +  ));

            if(Type.resolveClass("com.richsearle.modules."+moduleName) == null){
                println(moduleName +" module not found");
                return;
            }
            var module = Type.createInstance(Type.resolveClass("com.richsearle.modules."+moduleName),[]);

            println("loading "+ methodName +" method");

            if(Reflect.isFunction(Reflect.field(module,methodName))){

                //method found
                Reflect.callMethod(module, Reflect.field(module,methodName), [args]);
            } else if(Reflect.isFunction(Reflect.field(module,"main"))){

                //desired method not found, lets call Main

                //lets pop the module back in the args incase
                args.unshift(moduleName);

                Reflect.callMethod(module, Reflect.field(module,"main"), [args]);

            } else {
                print("no method found possible options are:");

                var allFields = Type.getInstanceFields(Type.resolveClass("com.richsearle.modules."+moduleName));
                for( ff in allFields ){
                  if(Reflect.isFunction(Reflect.field(module,ff))){
                    println(ff);
                  }
                }

            }

        } else {
            println("no module defined loading system status...");
        }


    }

    public static function print(s:String){
        neko.Lib.print(s);
    }

    public static function println(s:String){
        neko.Lib.println(s);
    }

    public static function userInput(prompt:String, options:Array<String>):String {
        neko.Lib.print("\n");
        neko.Lib.print(prompt);
        if(options.length > 0){ neko.Lib.print(" "+options.toString());}
        neko.Lib.print(" : ");
        return Sys.stdin().readLine();
    }

    public static function listFolder(dir:String = "./"):Array<String>{
        // get directory listing for subdir
            var files = sys.FileSystem.readDirectory(dir);
            var filesFound = new Array<String>();
            for( ff in files)
              filesFound.push(ff);

             return filesFound;
    }

    public static function runCommand(commandin:String, argsin:Array<String>,  showOutput:Bool = false):String{
        var p = new Process(commandin, argsin);

        var stdout = p.stdout.readAll().toString();
        if(showOutput){
            println(stdout);
        }
        

        commandHistory.push({command:commandin,args:argsin,pid:p.getPid(),exitcode: p.exitCode(), stdout:stdout });
        p.close();
        return stdout;
    }

    public static function getURL(url:String, showOutput:Bool = false):String {

       var result =  Http.requestUrl(url);
       if(showOutput){
        println(result);
       }

       return result;
    }



}