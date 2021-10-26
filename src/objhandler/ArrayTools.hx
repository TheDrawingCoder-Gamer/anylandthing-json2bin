package objhandler;
import bulby.BulbyMath;
class ArrayTools {
    public static function indexOfVector4(arr:Array<Vector4>, v:Vector4) {
        var i = 0;
        for (v2 in arr) {
            if (v2 == null)
                continue;
            if (v == v2) 
                return i;
            i++;
        }
        return -1;
    }
    public static function indexOfVector2(arr:Array<Vector2>, v:Vector2) {
        var i = 0;
        for (v2 in arr) {
			if (v2 == null)
				continue;
            if (v == v2) 
                return i;
            i++;
        }
        return -1;
    }
}