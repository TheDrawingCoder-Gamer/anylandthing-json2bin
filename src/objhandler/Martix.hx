package objhandler;


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
abstract Matrix4(MatrixRaw) from MatrixRaw to MatrixRaw{
	@:op(A == B) inline static function equal(a:Matrix4, b:Matrix4) {
		return a.a == b.a && a.b == b.b && a.c == b.c && a.d == b.d && a.e == b.e && a.f == b.f && a.g == b.g && a.h == b.h
			&& a.i == b.i && a.j == b.j && a.k == b.k && a.l == b.l && a.m == b.m && a.n == b.n && a.o == b.o && a.p == b.p;
	}
    @:op(A * B) public static function times(a:Matrix4, b:Vector4):Vector4 {
        var resMat = new Matrix4(a.a * b.x, a.b * b.y, a.c * b.z, a.d * b.w, a.e * b.x, a.f * b.y, a.g * b.z, a.h * b.w, a.i * b.x, a.j * b.y, a.k * b.z, a.l * b.w, a.m * b.x, a.n * b.y, a.o * b.z, a.p * b.w);
        var retVector = new Vector4(resMat.a + resMat.b + resMat.c + resMat.d, resMat.e + resMat.f + resMat.g + resMat.h, resMat.i + resMat.j + resMat.k + resMat.l, resMat.m + resMat.n + resMat.o + resMat.p);
        return retVector;
    }
    @:commutative
    @:op(A * B) public static function timesf(a:Matrix4, b:Float) {
        return new Matrix4(
			a.a * b, a.b * b, a.c * b, a.d * b,
			a.e * b, a.f * b, a.g * b, a.h * b,
			a.i * b, a.j * b, a.k * b, a.l * b,
			a.m * b, a.n * b, a.o * b, a.p * b
		);
    }
    @:commutative
    @:op(A + B)
    public static function addf(a:Matrix4, b:Float) {
        return new Matrix4(
            a.a + b, a.b + b, a.c + b, a.d + b,
            a.e + b, a.f + b, a.g + b, a.h + b,
            a.i + b, a.j + b, a.k + b, a.l + b,
            a.m + b, a.n + b, a.o + b, a.p + b
        );
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
    public function new(a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p) {
        this = {a: a, b: b, c: c, d: d, e: e, f: f, g: g, h: h, i: i, j: j, k: k, l: l, m: m, n: n, o: o, p : p};
    }
    @:op(A + B)
    public static inline function addition(a:Matrix4, b:Matrix4) {
        return new Matrix4(
          a.a + b.a, a.b + b.b, a.c + b.c, a.d + b.d,
          a.e + b.e, a.f + b.f, a.g + b.g, a.h + b.h, 
          a.i + b.i, a.j + b.j, a.k + b.k, a.l + b.l,
          a.m + b.m, a.n + b.n, a.o + b.o, a.p + b.p  
        );
    }
    public static inline function identity() {
        return new Matrix4(
            1, 0, 0, 0,
            0, 1, 0, 0,
            0, 0, 1, 0,
            0, 0, 0, 1
        );
    }
	/**
	 * Makes a rotation matrix. Expects degrees.
	 * @param yaw 
	 * @param pitch 
	 * @param roll 
	 * @return Matrix4
	 */
	public static function rotation(yaw:Float, pitch:Float, roll:Float):Matrix4 {
        var yawr = yaw * (Math.PI / 180);
        var pitchr = pitch * (Math.PI / 180);
        var rollr = roll * (Math.PI /180);
        var sy = Math.sin(yawr);
        var cy = Math.cos(yawr);
        var sx = Math.sin(pitchr);
        var cx = Math.cos(pitchr);
        var sz = Math.sin(rollr);
        var cz = Math.cos(rollr);
        return new Matrix4(
            cx * cy, cx * sy * sz - sx * cz, cx * sy * cz + sx * sz, 0,
            sx * cy, sx * sy * sz + cx * cz, sx * sy * cz - cx * sz, 0,
            -sy, cy * sz, cy * cz, 0,
            0, 0, 0, 1 
        );
    }
    public static inline function translation(x:Float, y:Float, z:Float) {
        return new Matrix4(
            1, 0, 0, x,
            0, 1, 0, y,
            0, 0, 1, z,
            0, 0, 0, 1
        );
    }
    public static inline function scale(x:Float, y:Float, z:Float) {
        trace (x);
        return new Matrix4(
            x, 0, 0, 0,
            0, y, 0, 0,
            0, 0, z, 0,
            0, 0, 0, 1
        );
    }
}

@:forward(a,b,c,d,e,f,g,h,i)
abstract Matrix3(Matrix3Raw) from Matrix3Raw to Matrix3Raw {
    @:op(A * B) public static function timesSelf(a:Matrix3, b:Matrix3) {
        return new Matrix3(a.a * b.a, a.b * b.b, a.c * b.c, a.d * b.d, a.e * b.e, a.f * b.f, a.g * b.g, a.h * b.h, a.i * b.i);
    }
    @:op(A * B) public static function timesVector(a:Matrix3, b:Vector3) {
        var resMat = new Matrix3(a.a * b.x, a.b * b.y, a.c * b.z, a.d * b.x, a.e * b.y, a.f * b.z, a.g * b.x, a.h * b.y, a.i * b.z);
        var retVector = new Vector3(resMat.a + resMat.b + resMat.c, resMat.d + resMat.e + resMat.f, resMat.g + resMat.h + resMat.i);
    }
    public function new(a, b, c, d, e, f, g, h, i) {
        this = {a : a, b: b, c: c, d: d, e: e, f: f, g: g, h: h, i: i};
    }
    
}