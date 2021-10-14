package thinghandler;

import haxe.io.Encoding;
import thinghandler.Thing.Quadlet;
import thinghandler.Thing.Triplet;
import haxe.io.BytesBuffer;

class BytesBufferTools {
    public static function addFloatTriplet(buf:BytesBuffer, triplet:Triplet<Float>) {
		trace(triplet);
        if (buf != null && triplet != null) {
			buf.addFloat(triplet.x != null ? triplet.x : 0);
			buf.addFloat(triplet.y != null ? triplet.y : 0);
			buf.addFloat(triplet.z != null ? triplet.z : 0);
        } else {
            buf.addFloat(0);
            buf.addFloat(0);
            buf.addFloat(0);
        }
        
    }
	public static function addFloatQuadlet(buf:BytesBuffer, quadlet:Quadlet<Float>) {
		buf.addFloat(quadlet.x);
		buf.addFloat(quadlet.y);
		buf.addFloat(quadlet.z);
        buf.addFloat(quadlet.w);
	}
    public static function addStringWLength(buf:BytesBuffer, string:String, ?encoding:Encoding = UTF8) {
        buf.addInt32(string.length);
        buf.addString(string, encoding);
    }
    public static function addIntArray(buf:BytesBuffer, arr:Array<Int>) {
        buf.addInt32(arr.length);
        for (int in arr) {
            buf.addInt32(int);
        }
    }
     
}