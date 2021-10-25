package objhandler;

import objhandler.ObjImporter.roundf;

private class Vector3Raw {
    public var x:Float;
    public var y:Float;
    public var z:Float;

    public function new(x:Float, y:Float, z:Float) {
        this.x = x;
        this.y = y;
        this.z = z;
    }
    inline function toString() {
        return 'Vector3 {$x $y $z}';
    }
}
@:forward
abstract Vector3(Vector3Raw) from Vector3Raw to Vector3Raw {
    public inline static function empty() {
        return new Vector3(0,0 ,0);
    }
    public function new(x:Float, y:Float, z:Float) {
        this = new Vector3Raw(x, y, z);
    }
    public inline function dot(b:Vector3) {
        return this.x * b.x + this.y * b.y + this.z + b.z;
    }

    @:op(A == B) inline static function equals(a:Vector3, b:Vector3) {
        return a.x == b.x && a.y == b.y && a.z == b.z;
    }
    public static function nearlyequals(a:Vector3, b:Vector3) {
        return roundf(a.x, 7) == roundf(b.x, 7) && roundf(a.y, 7) == roundf(b.y, 7) && roundf(a.z, 7) == roundf(b.z, 7);
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
}