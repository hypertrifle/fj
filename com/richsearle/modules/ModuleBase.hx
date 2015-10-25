package com.richsearle.modules;

class ModuleBase {

	public var options:Array<String>;

	public function new(){
		
	}

	public function main(params:Array<Dynamic>){

	}
	
	public static function list(){
		
	}

	public function buildOptions(){

		this.options = new Array<String>();
		this.options.push("test fruit apple");
		this.options.push("test fruit bannana");
		this.options.push("test fruit pear");
		this.options.push("test car ford");
		this.options.push("test car honda");
		this.options.push("test car vw");
		this.options.push("test car bmw");
		this.options.push("test name rich");
		this.options.push("test name chris");
		this.options.push("music start");
		this.options.push("music stop");
		this.options.push("music pause");


	}

	public function predictionMethod(currentText:String):Array<String> {

		//get all avalible options for this class (2 /3 nested for loops ->classNames->MethodName->parameters)

		if(this.options == null){
			this.buildOptions();
		}
		var all = this.options;
		var matched = new Array<String>();
		var biggest = 0;

		//see which options have a simular start (use str pos = 0);
		for (i in 0...all.length) {
			if(all[i].indexOf(currentText) == 0){
				var partial = all[i].substring(currentText.length);
				var breakpos = partial.indexOf(' ',0); 

				var final = (breakpos == -1) ? partial : partial.substring(0,breakpos);
				if(matched.indexOf(final) == -1){
					matched.push(final);
					biggest = (final.length > biggest)? final.length : biggest;
				}
				

				
			}
		}

		for (i in 0...matched.length) {
			//pad out with spaces so we draw over other options


		}


		return matched;
	}


}