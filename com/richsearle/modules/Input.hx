package com.richsearle.modules;

import ihx.ConsoleReader;

class Input extends ModuleBase {

	public var console:ConsoleReader;
	
	public function new(){
		super();
	}

	override public function main(params:Array<Dynamic>) {
		super.main(params);

		console = new ConsoleReader();
        while( true )
                {
                    // initial prompt
                    console.cmd.prompt = ">> ";
                    FJ.print(">> ");

                    while (true)
                    {
                        
                        var line:String = console.readLine();
						//do what we want with the command here (this is per line)
						continue;

                        FJ.print(">> ");
                    }
                }
	}


	public function _default(params:Array<Dynamic>) {

	}

}