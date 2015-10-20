package com.richsearle.modules;

class Hello extends ModuleBase {
	
	public function new(){
		super();
	}

	override public function main(params:Array<Dynamic>) {
		super.main(params);

	}

	public function fj(params:Array<Dynamic>) {

		FJ.print("Hi Rich!");
	}

	public function cmd(params:Array<Dynamic>) {
		FJ.runCommand("ls",['-n'],true);
	}

	public function net(params:Array<Dynamic>) {
		var result = FJ.getURL("http://www.google.com");
		FJ.print(result);
	}

	public function media(params:Array<Dynamic>) {

	}
}