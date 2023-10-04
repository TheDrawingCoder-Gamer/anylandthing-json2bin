package thinghandler;

enum abstract BehaviorScriptOperator(Int) from Int to Int {
	var lte;
	var gte;
	var eq;
	var neq;
	var neq2;
	var lte2;
	var gte2;
	var neq3;
	var lt;
	var gt;
	var eq2;

	@:to
	public function toString():String {
		return switch (this) {
			case lte:
				"<=";
			case gte:
				">=";
			case eq: "==";
			case neq: "<>";
			case neq2: "!=";
			case lte2: "=<";
			case gte2: "=>";
			case neq3: "><";
			case lt: "<";
			case gt: ">";
			case eq2: "=";
			case _: "?";
		}
	}

	@:from
	public static function fromString(s:String) {
		return switch (s) {
			case "<=": lte;
			case ">=": gte;
			case "==": eq;
			case "<>": neq;
			case "!=": neq2;
			case "=<": lte2;
			case "=>": gte2;
			case "><": neq3;
			case "<": lt;
			case ">": gt;
			case "=": eq2;
			case _: throw "Unknown operator";
		}
	}
}

class BehaviorScript {
	public static var reservedNames = ["false", "true", "is", "when", "then", "and", "or", "if", "not"];
}
