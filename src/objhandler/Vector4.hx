package objhandler;

typedef Vector4Raw = {
	var x:Float;
	var y:Float;
    var z:Float;
    var w:Float;
};

@:forward
abstract Vector4(Vector4Raw) from Vector4Raw to Vector4Raw {
	@:op(A == B) public function eq(b) {
		return (this.x == b.x && this.y == b.y && this.z == b.z && this.w == b.w);
	}
	public inline function dot(b:Vector4) {
		return this.x * b.x + this.y * b.y + this.z * b.z + this.w * b.w;
	}
	public function asJsonArrayNoBrackets():String {
		return '${this.x},${this.y},${this.z},${this.w}';
	}

	public function asJsonArray():String {
		return '[${asJsonArrayNoBrackets()}]';
	}

	public function new(x:Float, y:Float, z:Float, w:Float) {
		this = {x: x, y: y, z: z, w: w};
	}

	@:from
	static public function fromArray(arr:Array<Float>) {
		return new Vector4(arr[0], arr[1], arr[2], arr[3]);
	}

	@:to
	public function asArray() {
		return [this.x, this.y, this.z, this.w];
	}

	@:to
	public function toString() {
		return asJsonArrayNoBrackets();
	}

}