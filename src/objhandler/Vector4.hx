package objhandler;

import objhandler.ObjImporter.roundf;

private typedef Vector4Raw = {
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
		return 'Vector4 {${this.x} ${this.y} ${this.z} ${this.w}}';
	}
	@:op(A + B)
	public function add(b:Vector4) {
		return new Vector4(this.x + b.x, this.y + b.y, this.z + b.z, this.w + b.w);
	}
	/**
	 * Normalizes this vector's x, y, and z components. Modifies this in place.
	 */
	public function normalize() {
		var vec3 = new Vector3(this.x, this.y, this.z).normalize();
		this.x = vec3.x;
		this.y = vec3.y;
		this.z = vec3.z;
		return this;
	}
	@:op(A / B)
	public function div(b:Float) {
		return new Vector4(this.x / b, this.y / b, this.z / b, this.w / b);
	}
	public static function nearlyequals(a:Vector4, b:Vector4) {
		return roundf(a.x, 7) == roundf(b.x, 7) && roundf(a.y, 7) == roundf(b.y, 7) && roundf(a.z, 7) == roundf(b.z, 7) && roundf(b.w, 7) == roundf(a.w, 7);
	}

}