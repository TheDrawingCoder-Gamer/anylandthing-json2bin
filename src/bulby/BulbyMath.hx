package bulby;

@:publish
@:static
class BulbyMath {
	inline function roundf(f:Float, to:Int) {
		return Math.round(f * (Math.pow(10, to))) / Math.pow(10, to);
	}

	inline function lerp(a:Float, b:Float, t:Float):Float {
		return a + (b - a) * t;
	}

	inline function sCurve(t:Float):Float {
		return t * t * (3 - 2 * t);
	}

	inline function alphaBlend(a:Float, b:Float, alpha:Float) {
		return (a * alpha) + (b * (1 - alpha));
	}

	inline function clamp(a:Float, min:Float, max:Float) {
		return Math.min(Math.max(a, min), max);
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

private typedef Vector3Raw = {
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
		return BulbyMath.roundf(a.x, 7) == BulbyMath.roundf(b.x, 7)
			&& BulbyMath.roundf(a.y, 7) == BulbyMath.roundf(b.y, 7)
			&& BulbyMath.roundf(a.z, 7) == BulbyMath.roundf(b.z, 7);
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
	public static function fromUnity(unity:Vector3) {
		return new Vector3(-unity.x, unity.y, unity.z);
	}

	public function toUnity() {
		return new Vector3(-this.x, this.y, this.z);
	}

	// Ok so Y definetly needs to be flipped. Idk what else needs flipping tho :sob:
	public static function fromUnityEuler(unity:Vector3) {
		return new Vector3(unity.x, -unity.y, unity.z);
	}

	public function toUnityEuler() {
		return new Vector3(this.x, -this.y, this.z);
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

abstract Vector3FromUnity(Vector3) to Vector3 {
	public function new(x:Float, y:Float, z:Float) {
		this = new Vector3(x, y, z);
	}

	@:from static public function obj(x:Vector3Raw) {
		return new Vector3FromUnity(-x.x, x.y, x.z);
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

	public function magnitude() {
		return Math.pow(Math.pow(this.x, 2) + Math.pow(this.y, 2) + Math.pow(this.z, 2) + Math.pow(this.w, 2), 1 / 2);
	}

	/**
	 * Normalizes this vector. Modifies this in place.
	 */
	public function normalize() {
		final mag = Math.pow(Math.pow(this.x, 2) + Math.pow(this.y, 2) + Math.pow(this.z, 2) + Math.pow(this.w, 2), 1 / 2);
		this.x /= mag;
		this.y /= mag;
		this.z /= mag;
		this.w /= mag;
		return this;
	}

	@:op(A / B)
	public function div(b:Float) {
		return new Vector4(this.x / b, this.y / b, this.z / b, this.w / b);
	}

	public static function nearlyequals(a:Vector4, b:Vector4) {
		return BulbyMath.roundf(a.x, 7) == BulbyMath.roundf(b.x, 7)
			&& BulbyMath.roundf(a.y, 7) == BulbyMath.roundf(b.y, 7)
			&& BulbyMath.roundf(a.z, 7) == BulbyMath.roundf(b.z, 7)
			&& BulbyMath.roundf(b.w, 7) == BulbyMath.roundf(a.w, 7);
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
	
	@:op(A / B) static inline function divf(a: Matrix4, b: Float) {
		return a * (1 / b);
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

		return new Matrix4(inline a1.dot(b1), inline a1.dot(b2), inline a1.dot(b3), inline a1.dot(b4), inline a2.dot(b1), inline a2.dot(b2), inline a2.dot(b3),
			inline a2.dot(b4), inline a3.dot(b1), inline a3.dot(b2), inline a3.dot(b3), inline
			a3.dot(b4), inline a4.dot(b1), inline a4.dot(b2), inline a4.dot(b3), inline a4.dot(b4));
	}
	/**
	  * Extract a matrix with only the scale portion of this matrix
	*/
	public function extractScaleMat(): Matrix4 {
		return new Matrix4(this.a, 0, 0, 0, 0, this.f, 0, 0, 0, 0, this.k, 0, 0, 0, 0, 1);	
	}
	public function extractScale(): Vector3 {
		return new Vector3(this.a, this.f, this.k);
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

	/**
	  * Drop the translation part of this matrix and return a mat3.
	  */
	public function mat3() {
		return new Matrix3(
			m11, m12, m13,
			m21, m22, m23,
			m31, m32, m33
				);
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

	@:forwardfield(a)
	public var m11: Float;
	@:forwardfield(b)
	public var m12: Float;
	@:forwardfield(c)
	public var m13: Float;
	@:forwardfield(d)
	public var m14: Float;
	@:forwardfield(e)
	public var m21: Float;
	@:forwardfield(f)
	public var m22: Float;
	@:forwardfield(g)
	public var m23: Float;
	@:forwardfield(h)
	public var m24: Float;
	@:forwardfield(i)
	public var m31: Float;
	@:forwardfield(j)
	public var m32: Float;
	@:forwardfield(k)
	public var m33: Float;
	@:forwardfield(l)
	public var m34: Float;
	@:forwardfield(m)
	public var m41: Float;
	@:forwardfield(n)
	public var m42: Float;
	@:forwardfield(o)
	public var m43: Float;
	@:forwardfield(p)
	public var m44: Float;

}

@:forward
abstract Matrix3(Matrix3Raw) from Matrix3Raw to Matrix3Raw {
	@:op(A * B) inline static function timesMatrix(a:Matrix3, b:Matrix3) {
		final a1 = new Vector3(a.a, a.b, a.c);
		final a2 = new Vector3(a.d, a.e, a.f);
		final a3 = new Vector3(a.g, a.h, a.i);

		final b1 = new Vector3(b.a, b.d, b.g);
		final b2 = new Vector3(b.b, b.e, b.h);
		final b3 = new Vector3(b.c, b.f, b.i);

		return new Matrix3(a1.dot(b1), a1.dot(b2), a1.dot(b3), a2.dot(b1), a2.dot(b2), a2.dot(b3), a3.dot(b1), a3.dot(b2), a3.dot(b3));
	}

	@:op(A * B) public static function timesVector(a:Matrix3, b:Vector3) {
		var resMat = new Matrix3(a.a * b.x, a.b * b.y, a.c * b.z, a.d * b.x, a.e * b.y, a.f * b.z, a.g * b.x, a.h * b.y, a.i * b.z);
		var retVector = new Vector3(resMat.a + resMat.b + resMat.c, resMat.d + resMat.e + resMat.f, resMat.g + resMat.h + resMat.i);
		return retVector;
	}
	@:op(A * B) @:commutative inline static function timesf(a: Matrix3, b: Float) {
		return new Matrix3(a.a * b, a.b * b, a.c * b, a.d * b, a.e * b, a.f * b, a.g * b, a.h * b, a.i * b);
	}
	@:op(A / B) inline static function divf(a: Matrix3, b: Float) {
		return a * (1 / b);
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

	public static inline function identity() {
		return new Matrix3(1, 0, 0, 0, 1, 0, 0, 0, 1);
	}

	public static inline function scale(x:Float, y:Float):Matrix3 {
		return new Matrix3(x, 0, 0, 0, y, 0, 0, 0, 1);
	}

	public static inline function translate(x:Float, y:Float):Matrix3 {
		return new Matrix3(1, 0, x, 0, 1, y, 0, 0, 1);
	}

	public static inline function rotate(angle:Float) {
		final cos = Math.cos(angle), sin = Math.sin(angle);
		return new Matrix3(cos, -sin, 0, sin, cos, 0, 0, 0, 1);
	}

	public static inline function rotateDegrees(angle:Float) {
		return rotate(angle * (Math.PI / 180));
	}

	public function inverse() {
		final detA =
			m11 * m22 * m33
			+ m12 * m23 * m31
			+ m13 * m21 * m32
			- m13 * m22 * m31
			- m11 * m23 * m32
			- m12 * m21 * m33;
		if (detA == 0)
			return null;
		final mat =
			new Matrix3(m22 * m33 - m23 * m32, m13 * m32 - m12 * m33, m12 * m23 - m13 * m22,
				    m23 * m31 - m21 * m33, m11 * m33 - m13 * m31, m13 * m21 - m11 * m23,
				    m21 * m32 - m22 * m31, m12 * m31 - m11 * m32, m11 * m22 - m12 * m21);
		return mat / detA;
	}
	public inline function transpose() {
		return new Matrix3(
				m11, m21, m31,
				m12, m22, m32,
				m13, m23, m33
				);
	}
	@:forwardfield(a)
	public var m11: Float;
	@:forwardfield(b)
	public var m12: Float;
	@:forwardfield(c)
	public var m13: Float;
	@:forwardfield(d)
	public var m21: Float;
	@:forwardfield(e)
	public var m22: Float;
	@:forwardfield(f)
	public var m23: Float;
	@:forwardfield(g)
	public var m31: Float;
	@:forwardfield(h)
	public var m32: Float;
	@:forwardfield(i)
	public var m33: Float;
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

	public function toXYZW() {
		return [this.x, this.y, this.z, this.w];
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
		// Rotation x axis
		var qx = new Quaternion(sx, 0, 0, cx);
		// Rotation Y axis
		var qy = new Quaternion(0, sy, 0, cy);
		// Rotation Z axis
		var qz = new Quaternion(0, 0, sz, cz);
		final q1 = qx * qz;
		final q2 = qy * q1;
		return q2;
	}

	public static function fromUnityEuler(unity:Vector3) {
		return fromEuler(Vector3.fromUnityEuler(unity));
	}

	/*
		public function matrix() {
			final s = Math.pow(this.magnitude(), -2);
			return new Matrix4(
				1 - 2 * s * (Math.pow(this.w, 2) + Math.pow(this.x, 2)), 2 * s * (this.x * this.y - this.w * this.z), 2 * s *(this.x * this.z + this.w * this.y), 0,
				2 * s * (this.x * this.y + this.z * this.w), 1 - 2 * s * (Math.pow(this.x, 2) + Math.pow(this.z, 2)), 2 * s * (this.y * this.z - this.x * this.w), 0,
				2 * s * (this.x * this.z - this.y * this.w), 2 * s * (this.y * this.z + this.x * this.w), 1 - 2 * s * (Math.pow(this.x, 2) + Math.pow(this.y, 2)), 0,
				0, 0, 0, 1
			);
		}
	 */
	public static inline function identity() {
		return new Quaternion(0, 0, 0, 1);
	}

	@:op(A * B)
	public inline function mult(b:Quaternion) {
		final w0 = this.w;
		final x0 = this.x;
		final y0 = this.y;
		final z0 = this.z;

		final w1 = b.w;
		final x1 = b.x;
		final y1 = b.y;
		final z1 = b.z;

		final wr = (w0 * w1) - (x0 * x1) - (y0 * y1) - (z0 * z1);
		final xr = (w0 * x1) + (x0 * w1) + (y0 * z1) - (z0 * y1);
		final yr = (w0 * y1) - (x0 * z1) + (y0 * w1) + (z0 * x1);
		final zr = (w0 * z1) + (x0 * y1) - (y0 * x1) + (z0 * w1);

		return new Quaternion(xr, yr, zr, wr);
	}

	public inline function conjugate() {
		return new Quaternion(-this.x, -this.y, -this.z, this.w);
	}

	public inline function inverse():Quaternion {
		return cast conjugate().div(this.dot(this));
	}

	public inline function norm():Float {
		return Math.sqrt(Math.pow(this.x, 2) + Math.pow(this.y, 2) + Math.pow(this.z, 2) + Math.pow(this.w, 2));
	}

	@:op(A * B) public static inline function timesv(a:Quaternion, b:Vector4):Vector4 {
		final good = a * (cast b : Quaternion) * a.conjugate();
		return cast good;
	}

	public inline function matrix():Matrix4 {
		final s = norm();
		final qi = this.x;
		final qj = this.y;
		final qk = this.z;
		final qr = this.w;
		function sq(f:Float):Float {
			return Math.pow(f, 2);
		}
		return new Matrix4(1
			- 2 * s * (sq(qj) + sq(qk)), 2 * s * (qi * qj - qk * qr), 2 * s * (qi * qk + qj * qr), 0, 2 * s * (qi * qj + qk * qr),
			1
			- 2 * s * (sq(qi) + sq(qk)), 2 * s * (qj * qk - qi * qr), 0, 2 * s * (qi * qk - qj * qr), 2 * s * (qj * qk + qi * qr),
			1
			- 2 * s * (sq(qi) + sq(qj)), 0, 0, 0, 0, 1);

	}
}

abstract QuaternionFromUnity(Quaternion) to Quaternion {
	public function new(x:Float, y:Float, z:Float, w:Float) {
		this = new Quaternion(x, y, z, w);
	}

	@:from static public function obj(x:Vector3Raw) {
		return cast Quaternion.fromUnityEuler(x);
	}
}
