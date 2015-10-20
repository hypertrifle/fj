package com.richsearle.modules;

class Input extends ModuleBase {
	
	public function new(){
		super();
	}

	override public function main(params:Array<Dynamic>) {
		super.main(params);

		var cr = new ConsoleReader();
        var cmdStr = cr.readLine();
        Lib.println("\n" + cmdStr);

	}

	public function one(params:Array<Dynamic>) {


	}

	public function twitch(params:Array<Dynamic>) {
		var args:Array<String> = new Array<String>();

		args.push(params.shift());
		args.push('high');
		args.push('--player-passthrough=hls');
		FJ.runCommand('livestreamer',args);
	}

	public function _default(params:Array<Dynamic>) {

	}

}