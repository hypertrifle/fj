package com.richsearle.modules;

class Av extends ModuleBase {
	
	public function new(){
		super();
	}

	override public function main(params:Array<Dynamic>) {
		super.main(params);

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