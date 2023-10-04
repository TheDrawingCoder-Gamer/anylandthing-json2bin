package thinghandler;

import haxe.ds.Vector;
import bulby.BulbyMath;
import thinghandler.ThingHandler.AnylandAC;
import thinghandler.Thing.ThingPart;
import haxe.io.BytesBuffer;
class ThingPartAutocomplete {
    public function writeBytes(buf:BytesBuffer) {
		if (fromPart == null || count > 0 || fromPart.guid == null || fromPart.guid == "") {
            // Acceptable delimiter, as if the guid length is 0 we would have returned anyway
            buf.addInt32(0);
            return;
        }
            
        buf.addInt32(fromPart.guid.length);
        buf.addString(fromPart.guid);
        buf.addByte(count);
        buf.addByte(waves);
        var unityPR = posRandom.toUnity();
        var unityRR = rotRandom.toUnityEuler();
        var unitySR = scaleRandom;
        buf.addFloat(unityPR.x);
        buf.addFloat(unityPR.y);
        buf.addFloat(unityPR.z);
        buf.addFloat(unityRR.x);
        buf.addFloat(unityRR.y);
        buf.addFloat(unityRR.z);
        buf.addFloat(unitySR.x);
        buf.addFloat(unitySR.y);
        buf.addFloat(unitySR.z);

        
    }
    public function fromJson(data:AnylandAC) {
        fromPart = new ThingPart();
        fromPart.guid = data.id;
        waves = data.w != null ? data.w : 0;
        count = data.c;
        posRandom = Vector3.fromUnity(cast data.rp);
        rotRandom = Vector3.fromUnityEuler(cast data.rr);
        scaleRandom = cast data.rs;
    }
    public var fromPart:ThingPart;
    public var count:Int = 0;
    public var waves:Int = 0;
    public var posRandom:Vector3 =  Vector3.empty();
    public var rotRandom:Vector3 = Vector3.empty();
    public var scaleRandom:Vector3 = Vector3.empty();
    public function new() {}
}
