package objhandler;

import objhandler.Mesh.Vector3;

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
@:forward(a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p)
abstract Matrix4(MatrixRaw) from MatrixRaw to MatrixRaw{
    @:op(A * B) public static function times(a:Matrix4, b:Vector4):Vector4 {
        var resMat = new Matrix4(a.a * b.x, a.b * b.x, a.c * b.x, a.d * b.x, a.e * b.y, a.f * b.y, a.g * b.y, a.h * b.y, a.i * b.z, a.j * b.z, a.k * b.z, a.l * b.z, a.m * b.w, a.n * b.w, a.o * b.w, a.p * b.w);
        var retVector = new Vector4(resMat.a + resMat.b + resMat.c + resMat.d, resMat.e + resMat.f + resMat.g + resMat.h, resMat.i + resMat.j + resMat.k + resMat.l, resMat.m + resMat.n + resMat.o + resMat.p);
        return retVector;
    }
    @:op(A * B) public static function timesSelf(a:Matrix4, b:Matrix4):Matrix4 {
		return new Matrix4(a.a * b.a, a.b * b.b, a.c * b.c, a.d * b.d, a.e * b.e, a.f * b.f, a.g * b.g, a.h * b.h, a.i * b.i, a.j * b.j, a.k * b.k, a.l * b.l, a.m * b.m, a.n * b.n, a.o * b.o, a.p * b.p);
    }
    public function new(a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p) {
        this = {a: a, b: b, c: c, d: d, e: e, f: f, g: g, h: h, i: i, j: j, k: k, l: l, m: m, n: n, o: o, p : p};
    }
    public static inline function identity() {
        return new Matrix4(
            1, 0, 0, 0,
            0, 1, 0, 0,
            0, 0, 1, 0,
            0, 0, 0, 1
        );
    }
	public static function rotation(yaw:Float, pitch:Float, roll:Float):Matrix4 {
        var sy = Math.sin(yaw);
        var cy = Math.cos(yaw);
        var sx = Math.sin(pitch);
        var cx = Math.cos(pitch);
        var sz = Math.sin(roll);
        var cz = Math.cos(roll);
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
        var resMat = new Matrix3(a.a * b.x, a.b * b.x, a.c * b.x, a.d * b.y, a.e * b.y, a.f * b.y, a.g * b.z, a.h * b.z, a.i * b.z);
        var retVector = new Vector3(resMat.a + resMat.b + resMat.c, resMat.d + resMat.e + resMat.f, resMat.g + resMat.h + resMat.i);
    }
    public function new(a, b, c, d, e, f, g, h, i) {
        this = {a : a, b: b, c: c, d: d, e: e, f: f, g: g, h: h, i: i};
    }
    
}