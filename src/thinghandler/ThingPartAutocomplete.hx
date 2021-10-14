package thinghandler;

import thinghandler.ThingHandler.AnylandAC;
import thinghandler.Thing.ThingPart;
import haxe.io.BytesBuffer;
import thinghandler.Thing.Triplet;
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
        buf.addFloat(posRandom.x);
        buf.addFloat(posRandom.y);
        buf.addFloat(posRandom.z);
        buf.addFloat(rotRandom.x);
        buf.addFloat(rotRandom.y);
        buf.addFloat(rotRandom.z);
        buf.addFloat(scaleRandom.x);
        buf.addFloat(scaleRandom.y);
        buf.addFloat(scaleRandom.z);

        
    }
    public function fromJson(data:AnylandAC) {
        fromPart = new ThingPart();
        fromPart.guid = data.id;
        waves = data.w != null ? data.w : 0;
        count = data.c;
        posRandom = cast data.rp;
        rotRandom = cast data.rr;
        scaleRandom = cast data.rs;
    }
    public var fromPart:ThingPart;
    public var count:Int = 0;
    public var waves:Int = 0;
    public var posRandom:Triplet<Float> =  {x: 0, y: 0, z: 0};
    public var rotRandom:Triplet<Float> = {x : 0, y: 0, z: 0};
    public var scaleRandom:Triplet<Float> = {x:0, y: 0, z: 0};
    public function new() {}
}