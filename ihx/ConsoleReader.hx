/* ************************************************************************ */
/*                                                                          */
/*  Copyright (c) 2009-2013 Ian Martins (ianxm@jhu.edu)                     */
/*                                                                          */
/* This library is free software; you can redistribute it and/or            */
/* modify it under the terms of the GNU Lesser General Public               */
/* License as published by the Free Software Foundation; either             */
/* version 3.0 of the License, or (at your option) any later version.       */
/*                                                                          */
/* This library is distributed in the hope that it will be useful,          */
/* but WITHOUT ANY WARRANTY; without even the implied warranty of           */
/* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU        */
/* Lesser General Public License or the LICENSE file for more details.      */
/*                                                                          */
/* ************************************************************************ */

package ihx;

import neko.Lib;

typedef CodeSet = {
    var arrow     :Int;
    var up        :Int;
    var down      :Int;
    var right     :Int;
    var left      :Int;
    var home      :Int;
    var end       :Int;
    var backspace :Int;
    var ctrlc     :Int;
    var enter     :Int;
    var ctrla     :Int;
    var ctrle     :Int;
    var ctrlb     :Int;
    var ctrlf     :Int;
    var ctrld     :Int;
    var ctrlp     :Int;
    var ctrln     :Int;
    var ctrlk     :Int;
    var ctrlu     :Int;
    var ctrly     :Int;
    var tab       :Int;  
}

/**
   read a command from the console.  handle arrow keys.
**/
class ConsoleReader
{
    public  var cmd(default,null) :PartialCommand;
    private var code :Int;
    public var prediction :Predict;
    private var codeSet :CodeSet;
    private var predictionCallback:String->Array<String>;

    public static function main()
    {
        
        var cr = new ConsoleReader(null);
        var cmdStr = cr.readLine();
        Lib.println("\n" + cmdStr);
    }

    public function new(_pc:String->Array<String>)
    {
        predictionCallback = _pc;
        code = 0;
        cmd = new PartialCommand();
        prediction = new Predict();
        if( std.Sys.systemName() == "Windows" )
            codeSet = {arrow: 224, up: 72, down: 80, right: 77, left: 75, home: 71, end: 79,
                       backspace: 8, ctrlc: 3, enter: 13,
                       ctrla: 1, ctrle: 5, ctrlb: 2, ctrlf: 6, ctrld: 83,
                       ctrlp: -1, ctrln: -1, ctrlk: -1, ctrlu: -1, ctrly: -1, tab:9
            };
        else
            codeSet = {arrow: 27, up: 65, down: 66, right: 67, left: 68, home: 72, end: 70,
                       backspace: 127, ctrlc: 3, enter: 13,
                       ctrla: 1, ctrle: 5, ctrlb: 2, ctrlf: 6, ctrld: 4,
                       ctrlp: 16, ctrln: 14, ctrlk: 11, ctrlu: 21, ctrly: 25, tab:9
            };
    }

    public function handleFoward(){
       // var p = prediction.forward();
       // if( p != ""){
       //     cmd.set(p);
       // } else {
            cmd.cursorForward();
       // }
    }

    public function addChar(code){
        cmd.addChar(String.fromCharCode(code));
        prediction.predict(cmd.toString());
    }

    // get a command from the console
    public function readLine()
    {
        cmd.set("");
        while( true )
        {
            var clearPrevCommand = cmd.clearString();
            code = Sys.getChar(false);
            //FJ.println("\ngot: " + code +"\n");
            if( code == codeSet.arrow ) // arrow keys
            {
                if( std.Sys.systemName() != "Windows" )
                    Sys.getChar(false); // burn extra char
                code = Sys.getChar(false);
                switch( code )
                {
                case _ if(code == codeSet.up ):    cmd.setPredictionString(prediction.prev());
                case _ if(code == codeSet.down):   cmd.setPredictionString(prediction.next());
                case _ if(code == codeSet.right):  handleFoward();
                case _ if(code == codeSet.left):   cmd.cursorBack();
                case _ if(code == codeSet.home):   cmd.home();
                case _ if(code == codeSet.end):    cmd.end();
                case _ if(code == codeSet.tab):    cmd.predictComplete();
                case _ if(code == codeSet.ctrld && std.Sys.systemName() == "Windows"): cmd.del();
                }
            }
            else
            {
                switch( code )
                {
                case _ if(code == codeSet.ctrlc):
                    if( cmd.toString().length > 0 )
                    {
                        cmd.set("");
                    }
                    else
                    {
                        Lib.println("");
                        std.Sys.exit(1);
                    }
                case _ if(code == codeSet.enter):
                    Lib.println("");
                    //prediction.add(cmd.toString());
                    return cmd.toString();
                case _ if(code == codeSet.ctrlp): cmd.set(prediction.prev());
                case _ if(code == codeSet.ctrln): cmd.set(prediction.next());
                case _ if(code == codeSet.ctrlk): cmd.killRight();
                case _ if(code == codeSet.ctrlu): cmd.killLeft();
                case _ if(code == codeSet.ctrly): cmd.yank();
                case _ if(code == codeSet.ctrld): cmd.del(); // del shares code with tilde?
                case _ if(code == codeSet.ctrla): cmd.home();
                case _ if(code == codeSet.ctrle): cmd.end();
                case _ if(code == codeSet.tab): cmd.predictComplete();
                case _ if(code == codeSet.ctrlf): cmd.cursorForward();
                case _ if(code == codeSet.ctrlb): cmd.cursorBack();
                case _ if(code == codeSet.backspace): cmd.backspace();
                case _ if( code>=32 && code<=126 ): addChar(code);
                }
            }
            //FJ.println("cmd :" + cmd.toString());

            var results = predictionCallback(cmd.toString());
            

            prediction.setPredictions(results);
            cmd.setPredictionString(prediction.current());
            Lib.print(clearPrevCommand);
            Lib.print(cmd.toConsole());
        }
        return "";
    }
}
