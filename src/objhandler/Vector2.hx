package objhandler;

typedef Vector2Raw = {
    var x:Float;
    var y:Float;
};

@:forward(x, y)
abstract Vector2(Vector2Raw) from Vector2Raw to Vector2Raw {
	@:op(A == B) public function eq(b) {
		return (this.x == b.x && this.y == b.y);
	}

	public function asJsonArrayNoBrackets():String {
		return '${this.x},${this.y}';
	}

	public function asJsonArray():String {
		return '[${asJsonArrayNoBrackets()}]';
	}

	public function new(x:Float, y:Float) {
		this = {x: x, y: y};
	}

	@:from
	static public function fromArray(arr:Array<Float>) {
		return new Vector2(arr[0], arr[1]);
	}

	@:to
	public function asArray() {
		return [this.x, this.y];
	}

	@:to
	public function toString() {
		return asJsonArrayNoBrackets();
	}
}