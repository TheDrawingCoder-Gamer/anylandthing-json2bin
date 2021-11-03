package bulby;

@:publish
@:static
class BulbyMath {
	function roundf(f:Float, to:Int) {
		return Math.round(f * (Math.pow(10, to))) / Math.pow(10, to);
	}
	function lerp(a:Float, b:Float, t:Float) {
		return a * (1 - t) + b * t;
	}
	function alphaBlend(a:Float, b:Float, alpha:Float) {
		return (a * alpha) + (b * (1 - alpha));
	}
}

private typedef Vector2Raw = {
	var x:Float;
	var y:Float;
};

@:forward
abstract Vector2(Vector2Raw) from Vector2Raw to Vector2Raw {
	@:op(A == B) public function eq(b) {
		return (this.x == b.x && this.y == b.y);
	}

	public function new(x:Float, y:Float) {
		this = {x: x, y: y};
	}

	@:from
	static public function fromArray(arr:Array<Float>) {
		return new Vector2(arr[0], arr[1]);
	}

	public static function nearlyequals(a:Vector2, b:Vector2) {
		return BulbyMath.roundf(a.x, 7) == BulbyMath.roundf(b.x, 7) && BulbyMath.roundf(a.y, 7) == BulbyMath.roundf(b.y, 7);
	}

	@:to
	public function asArray() {
		return [this.x, this.y];
	}

	@:to
	public function toString() {
		return 'Vector2 {${this.x} ${this.y}}';
	}
}

private typedef Vector3Raw  = {
	var x:Float;
	var y:Float;
	var z:Float;
}

@:forward
// ok so lets define what coord system we're using.
// we're going to use a right handed coordinate system, with y up.
abstract Vector3(Vector3Raw) from Vector3Raw to Vector3Raw {
	public inline static function empty() {
		return new Vector3(0, 0, 0);
	}

	public function new(x:Float, y:Float, z:Float) {
		this = {x: x, y: y, z: z};
	}

	public inline function dot(b:Vector3) {
		return this.x * b.x + this.y * b.y + this.z + b.z;
	}

	@:op(A == B) inline static function equals(a:Vector3, b:Vector3) {
		return a.x == b.x && a.y == b.y && a.z == b.z;
	}

	public static function nearlyequals(a:Vector3, b:Vector3) {
		return BulbyMath.roundf(a.x, 7) == BulbyMath.roundf(b.x, 7) && BulbyMath.roundf(a.y, 7) == BulbyMath.roundf(b.y, 7) && BulbyMath.roundf(a.z, 7) == BulbyMath.roundf(b.z, 7);
	}

	@:to public function toArray() {
		return [this.x, this.y, this.z];
	}

	@:from static public function fromArray(arr:Array<Float>) {
		return new Vector3(arr[0], arr[1], arr[2]);
	}

	@:to public function toString() {
		return 'Vector3 {${this.x} ${this.y} ${this.z}}';
	}

	/**
	 * Normalize this vector. Modifies this in place.
	 */
	public function normalize() {
		var mag = Math.pow(Math.pow(this.x, 2) + Math.pow(this.y, 2) + Math.pow(this.z, 2), 1 / 2);
		this.x /= mag;
		this.y /= mag;
		this.z /= mag;
		return this;
	}

	public function abs() {
		return new Vector3(Math.abs(this.x), Math.abs(this.y), Math.abs(this.z));
	}

	/**
	 * Sets this vector's values to another vectors values, correcting for unity's coordinate system
	 * @param unity Unity Vector
	 */
	public function fromUnity(unity:Vector3) {
		this.x = -unity.x;
		this.y = unity.y;
		this.z = unity.z;
		return this;
	}

	public function toUnity() {
		return new Vector3(-this.x , this.y, this.z);
	}
	// Ok so Y definetly needs to be flipped. Idk what else needs flipping tho :sob:
	public function fromUnityEuler(unity:Vector3) {
		this.x = -unity.x;
		this.y = unity.y;
		this.z = unity.z;
		return this;
	}
	public function toUnityEuler() {
		return new Vector3(-this.x, this.y, this.z);
	}
	@:op(A + B)
	function add(b:Vector3) {
		return new Vector3(this.x + b.x, this.y + b.y, this.z + b.z);
	}
	@:op(A / B)
	function divide(b:Float):Vector3 {
		return new Vector3(this.x / b, this.y / b, this.z / b);
	}
	@:op(A - B)
	function sub(b:Vector3) {
		return new Vector3(this.x - b.x, this.y - b.y, this.z - b.z);
	}
}

private typedef Vector4Raw = {
	var x:Float;
	var y:Float;
	var z:Float;
	var w:Float;
};

@:forward
abstract Vector4(Vector4Raw) from Vector4Raw to Vector4Raw {
	@:op(A == B) public inline function eq(b) {
		return (this.x == b.x && this.y == b.y && this.z == b.z && this.w == b.w);
	}

	public inline function dot(b:Vector4) {
		return this.x * b.x + this.y * b.y + this.z * b.z + this.w * b.w;
	}

	public function new(x:Float, y:Float, z:Float, w:Float) {
		this = {
			x: x,
			y: y,
			z: z,
			w: w
		};
	}

	@:from
	static public inline function fromArray(arr:Array<Float>) {
		return new Vector4(arr[0], arr[1], arr[2], arr[3]);
	}

	@:to
	public inline function asArray() {
		return [this.x, this.y, this.z, this.w];
	}

	@:to
	inline function toString() {
		return 'Vector4 {${this.x} ${this.y} ${this.z} ${this.w}}';
	}

	@:op(A + B)
	public inline function add(b:Vector4) {
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
		return BulbyMath.roundf(a.x, 7) == BulbyMath.roundf(b.x, 7) && BulbyMath.roundf(a.y, 7) == BulbyMath.roundf(b.y, 7) && BulbyMath.roundf(a.z, 7) == BulbyMath.roundf(b.z, 7) && BulbyMath.roundf(b.w, 7) == BulbyMath.roundf(a.w, 7);
	}
}

typedef MatrixRaw = {
	var a:Float;
	var b:Float;
	var c:Float;
	var d:Float;
	var e:Float;
	var f:Float;
	var g:Float;
	var h:Float;
	var i:Float;
	var j:Float;
	var k:Float;
	var l:Float;
	var m:Float;
	var n:Float;
	var o:Float;
	var p:Float;
}

typedef Matrix3Raw = {
	var a:Float;
	var b:Float;
	var c:Float;
	var d:Float;
	var e:Float;
	var f:Float;
	var g:Float;
	var h:Float;
	var i:Float;
}

@:forward
@:nullSafety(Strict)
abstract Matrix4(MatrixRaw) from MatrixRaw to MatrixRaw {
	@:op(A == B) inline static function equal(a:Matrix4, b:Matrix4) {
		return a.a == b.a && a.b == b.b && a.c == b.c && a.d == b.d && a.e == b.e && a.f == b.f && a.g == b.g && a.h == b.h && a.i == b.i && a.j == b.j
			&& a.k == b.k && a.l == b.l && a.m == b.m && a.n == b.n && a.o == b.o && a.p == b.p;
	}
	// this may be kinda stupid to inline lmao
	@:op(A * B) inline static function times(a:Matrix4, b:Vector4):Vector4 {
		var resMat = new Matrix4(a.a * b.x, a.b * b.y, a.c * b.z, a.d * b.w, a.e * b.x, a.f * b.y, a.g * b.z, a.h * b.w, a.i * b.x, a.j * b.y, a.k * b.z,
			a.l * b.w, a.m * b.x, a.n * b.y, a.o * b.z, a.p * b.w);
		var retVector = new Vector4(resMat.a
			+ resMat.b
			+ resMat.c
			+ resMat.d, resMat.e
			+ resMat.f
			+ resMat.g
			+ resMat.h,
			resMat.i
			+ resMat.j
			+ resMat.k
			+ resMat.l, resMat.m
			+ resMat.n
			+ resMat.o
			+ resMat.p);
		return retVector;
	}

	@:commutative
	@:op(A * B) static inline function timesf(a:Matrix4, b:Float) {
		return new Matrix4(a.a * b, a.b * b, a.c * b, a.d * b, a.e * b, a.f * b, a.g * b, a.h * b, a.i * b, a.j * b, a.k * b, a.l * b, a.m * b, a.n * b,
			a.o * b, a.p * b);
	}

	@:commutative
	@:op(A + B)
	static inline function addf(a:Matrix4, b:Float) {
		return new Matrix4(a.a
			+ b, a.b
			+ b, a.c
			+ b, a.d
			+ b, a.e
			+ b, a.f
			+ b, a.g
			+ b, a.h
			+ b, a.i
			+ b, a.j
			+ b, a.k
			+ b, a.l
			+ b, a.m
			+ b, a.n
			+ b,
			a.o
			+ b, a.p
			+ b);
	}

	@:op(A * B) inline static function mult(a:Matrix4, b:Matrix4):Matrix4 {
		var a1 = inline new Vector4(a.a, a.b, a.c, a.d);
		var a2 = inline new Vector4(a.e, a.f, a.g, a.h);
		var a3 = inline new Vector4(a.i, a.j, a.k, a.l);
		var a4 = inline new Vector4(a.m, a.n, a.o, a.p);

		var b1 = inline new Vector4(b.a, b.e, b.i, b.m);
		var b2 = inline new Vector4(b.b, b.f, b.j, b.n);
		var b3 = inline new Vector4(b.c, b.g, b.k, b.o);
		var b4 = inline new Vector4(b.d, b.h, b.l, b.p);

		return new Matrix4(inline a1.dot(b1), inline a1.dot(b2), inline a1.dot(b3), inline a1.dot(b4), inline a2.dot(b1), inline a2.dot(b2),
			inline a2.dot(b3), inline a2.dot(b4), inline a3.dot(b1), inline a3.dot(b2), inline a3.dot(b3), inline a3.dot(b4), inline a4.dot(b1),
			inline a4.dot(b2), inline a4.dot(b3), inline a4.dot(b4));
	}

	public function new(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p) {
		this = {
			a: a,
			b: b,
			c: c,
			d: d,
			e: e,
			f: f,
			g: g,
			h: h,
			i: i,
			j: j,
			k: k,
			l: l,
			m: m,
			n: n,
			o: o,
			p: p
		};
	}

	@:op(A + B)
	static inline function addition(a:Matrix4, b:Matrix4) {
		return new Matrix4(a.a
			+ b.a, a.b
			+ b.b, a.c
			+ b.c, a.d
			+ b.d, a.e
			+ b.e, a.f
			+ b.f, a.g
			+ b.g, a.h
			+ b.h, a.i
			+ b.i, a.j
			+ b.j, a.k
			+ b.k, a.l
			+ b.l,
			a.m
			+ b.m, a.n
			+ b.n, a.o
			+ b.o, a.p
			+ b.p);
	}

	public static inline function identity() {
		return new Matrix4(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1);
	}

	/**
	 * Makes a rotation matrix. Expects degrees.
	 * Screw right hand
	 * Right Handed Y Up
	 * Rotate around Z first, X second, Y third
	 * @param yaw 
	 * @param pitch 
	 * @param roll 
	 * @return Matrix4
	 */
	public static function rotation(yaw:Float, pitch:Float, roll:Float):Matrix4 {
		var yawr = yaw * (Math.PI / 180);
		var pitchr = pitch * (Math.PI / 180);
		var rollr = roll * (Math.PI / 180);
		var sy = Math.sin(yawr);
		var cy = Math.cos(yawr);
		var sx = Math.sin(pitchr);
		var cx = Math.cos(pitchr);
		var sz = Math.sin(rollr);
		var cz = Math.cos(rollr);
		var rZ = new Matrix4(cz, -sz, 0, 0, sz, cz, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1);
		var rY = new Matrix4(cy, 0, sy, 0, 0, 1, 0, 0, -sy, 0, cy, 0, 0, 0, 0, 1);
		var rX = new Matrix4(1, 0, 0, 0, 0, cx, -sx, 0, 0, sx, cx, 0, 0, 0, 0, 1);
		return rZ * rX * rY;
	}

	public static inline function translation(x:Float, y:Float, z:Float) {
		return new Matrix4(1, 0, 0, x, 0, 1, 0, y, 0, 0, 1, z, 0, 0, 0, 1);
	}

	public static inline function scale(x:Float, y:Float, z:Float) {
		return new Matrix4(x, 0, 0, 0, 0, y, 0, 0, 0, 0, z, 0, 0, 0, 0, 1);
	}
}

@:forward
abstract Matrix3(Matrix3Raw) from Matrix3Raw to Matrix3Raw {
	@:op(A * B) inline static function timesMatrix(a:Matrix3, b:Matrix3) {
		return new Matrix3(a.a * b.a, a.b * b.b, a.c * b.c, a.d * b.d, a.e * b.e, a.f * b.f, a.g * b.g, a.h * b.h, a.i * b.i);
	}

	@:op(A * B) public static function timesVector(a:Matrix3, b:Vector3) {
		var resMat = new Matrix3(a.a * b.x, a.b * b.y, a.c * b.z, a.d * b.x, a.e * b.y, a.f * b.z, a.g * b.x, a.h * b.y, a.i * b.z);
		var retVector = new Vector3(resMat.a + resMat.b + resMat.c, resMat.d + resMat.e + resMat.f, resMat.g + resMat.h + resMat.i);
	}

	public function new(a, b, c, d, e, f, g, h, i) {
		this = {
			a: a,
			b: b,
			c: c,
			d: d,
			e: e,
			f: f,
			g: g,
			h: h,
			i: i
		};
	}
}
@:forward
abstract Quaternion(Vector4) {
	public function new(x:Float, y:Float, z:Float, w:Float) {
		this = {
			x: x,
			y: y,
			z: z,
			w: w
		};
	}
	// stolen from: 
	// https://www.mathworks.com/matlabcentral/fileexchange/6335-euler-angles-to-quaternion-conversion-for-six-basic-sequence-of-rotations
	public static function fromEuler(euler:Vector3) {
		var x = euler.x * (Math.PI / 180);
		var y = euler.y * (Math.PI / 180);
		var z = euler.z * (Math.PI / 180);
		var cx = Math.cos(x / 2);
		var sx = Math.sin(x / 2);
		var cy = Math.cos(y / 2);
		var sy = Math.sin(y / 2);
		var cz = Math.cos(z / 2);
		var sz = Math.sin(z / 2);
		var qx = new Quaternion( cx, sx, 0, 0);
		var qy = new Quaternion( cy, 0, sy, 0);
		var qz = new Quaternion( cz, 0, 0, sz);
		return qz * (qx * qy);
	}
	public function matrix() {
		return new Matrix4(
			2 * (Math.pow(this.w, 2) + Math.pow(this.x, 2)) - 1, 2 * (this.x * this.y - this.w * this.z), 2 * (this.x * this.z + this.w * this.y), 0,
			2 * (this.x * this.y + this.w * this.z), 2 * (Math.pow(this.w, 2) + Math.pow(this.y, 2)) - 1, 2 * (this.y * this.z - this.w * this.x), 0,
			2 * (this.x * this.z - this.w * this.y), 2 * (this.y * this.z + this.w * this.x), 2 * (Math.pow(this.w, 2) + Math.pow(this.z, 2)) - 1, 0,
			0, 0, 0, 1
		);
	}
	public static inline function identity() {
		return new Quaternion(0, 0, 0, 1);
	}
	@:op(A * B)
	public inline function mult(b:Quaternion) {
		return new Quaternion(this.w * b.x + this.x * b.w + this.y * b.z - this.z * b.y,
			this.w * b.y - this.x * b.z + this.y * b.w + this.z * b.x,
			this.w * b.z + this.x * b.y - this.y * b.x + this.z * b.w,
			this.w * b.w - this.x * b.x - this.y * b.y - this.z * b.z);
	}

}