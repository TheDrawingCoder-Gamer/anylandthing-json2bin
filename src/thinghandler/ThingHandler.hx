package thinghandler;

import bulby.assets.mat.Material;
import bulby.BulbyMath;
import bulby.assets.Node;
import sys.FileSystem;
import bulby.BulbyMath;
import sys.io.File;
import bulby.assets.Mesh;
import thinghandler.Thing.Axises;
import thinghandler.TextureTypes;
import thinghandler.ParticleSystemType;
import thinghandler.Thing.ImageType;
import thinghandler.MaterialTypes;
import thinghandler.ThingPartBase;
import haxe.Json;
import thinghandler.Thing.ThingPartState;
import thinghandler.Thing.SubThingAttr;
import thinghandler.Thing.SubThingInfo;
import thinghandler.Thing.ThingPart;
import haxe.Int64;
import haxe.io.BytesBuffer;
import thinghandler.Thing.HigherThingAttribute;
import thinghandler.Thing.LowerThingAttribute;
import thinghandler.Thing.HigherThingPartAttribute;
import thinghandler.Thing.LowerThingPartAttribute;

using thinghandler.BytesBufferTools;
using Lambda;
@:forward(length)
abstract ChangedVerticies(Array<Dynamic>) from Array<Dynamic> to Array<Dynamic> {
    var x(get, set):Float;
    inline function get_x() {
        return this[0];
    }
	inline function set_x(f) {
        return this[0] = f;
    }
    var y(get, set):Float;
	inline function get_y() {
        return this[1];
    }
	inline function set_y(f) {
        return this[1] = f;
    }
    var z(get, set):Float;
	inline function get_z() {
        return this[2];
    }
	inline function set_z(f) {
        return this[2] = f;
    }
    public var indexes(get, set):Array<Int>;

	inline function get_indexes():Array<Int> {
        return cast this.slice(3);
    }
    function set_indexes(arr:Array<Int>):Array<Int> {
        this.resize(3);
        this.concat(arr);
        return cast this;
    }
    @:to
    public function toVector3() {
        return new Vector3(x, y, z);
    }
}
typedef AnylandThingJson = {
    var ?n:String; // Thing name
    var ?a:Array<Int>; // Thing Attributes
    var ?d:String; // Description
    var ?inc:Array<Array<String>>; // Included name id pairs (i could really use a tuple right now)
    var ?v:Int; // Version
    
    var ?tp_m:Float;
    var ?tp_d:Float;
    var ?tp_ad:Float;
    var ?tp_lp:Array<Int>; // Stupid :angry:
    var ?tp_lr:Array<Int>;

    var p:Array<AnylandPartJson>;

};
typedef AnylandPartJson = {
    var ?b:ThingPartBase;
    var ?t:MaterialTypes;
    var ?a:Array<Int>; // Attributes
    var ?n:String;

    var ?id:String;

    var ?e:String;
    var ?lh:Float;

    var ?i:Array<IncludedSubthingJson>;
    var ?su:Array<PlacedSubthingJson>;

    var ?im:String;
    var ?imt:ImageType;

    var ?pr:ParticleSystemType;
    
    var ?t1:TextureTypes;
    var ?t2:TextureTypes;

    var ?ac:AnylandAC;
    
    var ?c:Array<ChangedVerticies>;

    var s:Array<AnylandStateJson>;
    var ?bod:IncludedBody;

    var ?sa:Int;
    var ?cx:Int;
    var ?v:Int;
}
typedef IncludedBody = {
    var ?h:NoScaleTransformJson;
    var ?ut:BodyAttachment;
    var ?lt:BodyAttachment;
    var ?ll:BodyAttachment;
    var ?lr:BodyAttachment;
    var ?ht:BodyAttachment;
    var ?al:BodyAttachment;
    var ?ar:BodyAttachment;
};
typedef NoScaleTransformJson = {
    var p:Array<Float>;
    var r:Array<Float>;
}
typedef BodyAttachment = {
    > NoScaleTransformJson,
    var i:String;
}
typedef AnylandStateJson = {
    var p:Array<Float>;
    var r:Array<Float>;
    var s:Array<Float>;
    var c:Array<Float>;
    var b:Array<String>;
}
typedef AnylandAC = {
    var id:String;
    var c:Int;
    var ?w:Int;
    var ?rp:Array<Float>;
    var ?rr:Array<Float>;
    var ?rs:Array<Float>;
}
typedef IncludedSubthingJson = {
    var t:String;
    var p:Array<Float>;
    var r:Array<Float>;
    var ?n:String;
    var ?a:Array<Int>;
}
typedef PlacedSubthingJson = {
    var i:String;
    var t:String;
    var p:Array<Float>;
    var r:Array<Float>;
}
class ThingHandler {
    public static function importJson(json:String, keepPartsSeperate:Bool = false, isForPlacement:Bool = false) {
        var data:AnylandThingJson = Json.parse(json);
        var thing = new Thing();
        thing.givenName = data.n != null ? data.n : Thing.defaultName;
        thing.version = data.v != null ? data.v : 1;
        thing.description = data.d;
        expandThingAttributeFromJson(thing, data.a);
        expandThingIncludedNameIdsFromJson(thing, data.inc);
        if (data.tp_m != null) thing.physicsMass = data.tp_m;
        if (data.tp_d != null) thing.dragMass = data.tp_d;
        if (data.tp_ad != null) thing.angularDrag = data.tp_ad;
        if (data.tp_lp != null) thing.lockedPos =  getBoolAxies(data.tp_lp);
        if (data.tp_lr != null) thing.lockedRot = getBoolAxies(data.tp_lr); 

        for (jsonpart in data.p) {
            // var baseIndex:Int = jsonpart.b != null ? cast jsonpart.b : 1;
            var thingpart = new ThingPart();

            expandPartAttributeFromJson(thingpart, jsonpart.a);
            if (jsonpart.n != null)
                thingpart.givenName = jsonpart.n;
            if (jsonpart.ac != null) {
                thingpart.autoContinuation = new ThingPartAutocomplete();
                thingpart.autoContinuation.fromJson(jsonpart.ac);
            }
            if (jsonpart.b != null) {
                thingpart.baseType = jsonpart.b;
            } else thingpart.baseType = Cube;
            if (thingpart.isText && jsonpart.e != null) {
                thingpart.text = jsonpart.e;
                if (jsonpart.lh != null) thingpart.textLineHeight = jsonpart.lh;
                
            }
            if (jsonpart.t != null) {
                thingpart.materialType = jsonpart.t;
                if (thingpart.materialType == InvisibleWhenDone) {
                    thingpart.materialType = None;
                    thingpart.partInvisible = true;
                }

            } else if (thingpart.isText && thing.version <= 3) {
                thingpart.materialType = Glow;
            }
            applyVertexChangesAndSmoothingAngles(thingpart, jsonpart, data.p);

            if (jsonpart.i != null) {
                thingpart.includedSubThings = [];
                for (subThingNode in jsonpart.i) {
                    var includedSubthing = new SubThingInfo(false);
                    includedSubthing.thingId = subThingNode.t;
                    includedSubthing.pos.fromUnity(subThingNode.p);
                    includedSubthing.rot.fromUnityEuler(subThingNode.r);
                    if (subThingNode.n != null) includedSubthing.nameOverride = subThingNode.n;
                    expandIncludedSubthingInvertAttribute(includedSubthing, subThingNode.a);
                    thingpart.includedSubThings.push(includedSubthing);
                }
            }

            if (jsonpart.su != null && jsonpart.su.length >= 1) {
                for (pSNode in jsonpart.su) {
                    if (pSNode.i != null) {
                        var placedSubthing = new SubThingInfo(true);
                        placedSubthing.thingId = pSNode.t;
                        placedSubthing.pos.fromUnity(pSNode.p);
                        placedSubthing.rot.fromUnityEuler(pSNode.r);
                    }
                }
            }

            if (jsonpart.im != null) {
                thingpart.imageUrl = jsonpart.im;
                if (jsonpart.imt != null) {
                    thingpart.imageType = cast (jsonpart.imt : ImageType);
                }
            }

            final shiftTexture2Left = jsonpart.t1 == null && jsonpart.t2 != null;

            if (jsonpart.t1 != null) {
                thingpart.textureTypes.set(0, cast (jsonpart.t1 : TextureTypes));
            }

            if (jsonpart.t2 != null) {
                thingpart.textureTypes.set(shiftTexture2Left ? 0 : 1, cast (jsonpart.t2 : TextureTypes));
            }

            if (jsonpart.pr != null) {
                thingpart.particleSystem = jsonpart.pr;
            }
            var partContainsScript = false;
            var maxStates = jsonpart.s.length;
            for (statesI in 0...(maxStates)) {
                thingpart.states[statesI] = new ThingPartState();
                final state = jsonpart.s[statesI];

                thingpart.states[statesI].position.fromUnity(state.p);
                
                thingpart.states[statesI].rotation.fromUnityEuler(state.r);
                thingpart.states[statesI].scale.fromUnity(state.s);
                // Ensure no negative scale to prevent : (
                thingpart.states[statesI].scale = thingpart.states[statesI].scale.abs();
                thingpart.states[statesI].color = state.c;
                
                if (state.b != null) {
                    partContainsScript = true;
                    for (line in state.b) {
                        thingpart.states[statesI].scriptLines.push(line);
                    }
                    // There is a shitton of extra shit that requires me to have extra functions and that don't seem worth it

                }

            }
            thing.parts.push(thingpart);

        }  

        return thing;
    }
    static function expandIncludedSubthingInvertAttribute(incSubthing:SubThingInfo, attrs:Array<Int>) {
        if (attrs != null) {
            for (attr in attrs) {
                switch (cast(attr : ThingAttribute)) {
                    case ThingAttribute.isHoldable: incSubthing.invertIsHoldable = true;
                    case invisible: incSubthing.invertInvisible = true;
                    case uncollidable: incSubthing.invertUncollidable = true;
                    default: 
                }
            }
        }
    }
    static function applyVertexChangesAndSmoothingAngles(part:ThingPart, partNode:AnylandPartJson, thingNode:Array<AnylandPartJson>) {
        if (partNode.c != null || partNode.v != null || partNode.sa != null) {
            // No Mesh Filter. This is purely a data reader
            if (partNode.v != null) {
                final indexRef = partNode.v;
                partNode.c = thingNode[indexRef].c;
                if (thingNode[indexRef].sa != null)
                {
                    partNode.sa = thingNode[indexRef].sa;
                }
                if (thingNode[indexRef].cx != null) {
                    partNode.cx = thingNode[indexRef].cx;
                }
            }

            if (partNode.c != null) {
                // Pain
                part.changedVerticies = new Map<Int, Vector3>();
                for (item in partNode.c) {
                    var vector:Vector3 = Vector3.empty().fromUnity(item.toVector3());
                    var previousVertexIndex = 0;
                    for (relVertexIndex in item.indexes) {
                        var vertexIndex = previousVertexIndex + relVertexIndex;
                        if (vertexIndex <  cast PartTypeVertCount.fromPartType(part.baseType)) {
                            previousVertexIndex = vertexIndex;
                            part.changedVerticies.set(vertexIndex, vector);
                        }
                    } 
                }
            }
            if (partNode.sa != null) {
                part.smoothingAngle = partNode.sa;
            }
            if (partNode.cx != null) {
                part.convex = partNode.cx == 1;
            }
        }
    }
    static function getBoolAxies(axies:Array<Int>) {
        var boolAxises = 0;
        if (axies[0] == 1) boolAxises |= Axises.x;
        if (axies[1] == 1) boolAxises |= Axises.y;
        if (axies[2] == 1) boolAxises |= Axises.z;
        return boolAxises;
    }
    static function expandThingIncludedNameIdsFromJson(thing:Thing, jsonNameIds:Array<Array<String>>) {
        if (jsonNameIds != null) {
            for (nameId in jsonNameIds) {
                thing.includedThingIds.set(nameId[0], nameId[1]);
            }
        }
    }
    /**
     * Generates an Obj File from a Thing. Returns Node, that contains all meshes
     * @param thing 
     * @return Node
     */
    public static function generateMeshFromThing(thing:Thing):Node {
        var node = new Node([]);
        var matCache:Map<String, Material> = new Map<String, Material>();
        for (part in thing.parts) {
            if (part.materialType == InvisibleWhenDone || part.partInvisible) 
                continue;
			if (FileSystem.exists("./res/BaseShapes/" + Std.string(part.baseType) + ".obj")) {
				var mesh = Mesh.fromObj(File.getContent("./res/BaseShapes/" + Std.string(part.baseType) + ".obj"), false);
                for (index => pos in part.changedVerticies) {
                    mesh.positions[index] = pos;
                    // We don't have to apply transformations because we do that later
                }   
				mesh.optimize();
				var matKey = '_${Math.round(part.states[0].color.r * 255)}_${Math.round(part.states[0].color.g * 255)}_${Math.round(part.states[0].color.b * 255)}_${Std.string(part.materialType)}_';
				if (matCache.exists(matKey)) {
					mesh.material = matCache.get(matKey);
				} else {
					matCache.set(matKey, new Material(matKey, part.states[0].color, null, null, part.materialType.alpha(), 0, part.materialType.illum()));
					if (part.materialType == Unshaded) {
						matCache.get(matKey).isUnshaded = true;
					}
					mesh.material = matCache.get(matKey);
				}   
                if (part.autoContinuation != null && part.autoContinuation.count != 0) {
                    var otherPart = part.autoContinuation.fromPart;
                    // Just a guess, but I think from part means this part is the 2nd in sequence.
                    // So we calculate the different with this on lhs
                    var posDiff = part.states[0].position - otherPart.states[0].position;
                    var rotDiff = part.states[0].rotation - otherPart.states[0].rotation;
                    var scaleDiff = part.states[0].scale - otherPart.states[0].scale;
                    // me when I'm lazy
                    var thisPos = part.states[0].position / 1;
                    var thisRot = part.states[0].rotation / 1;
                    var thisScale = part.states[0].scale / 1;

                    for (c in 0...part.autoContinuation.count) {
                        thisPos += posDiff;
                        thisRot += rotDiff;
                        thisScale += scaleDiff;
                        var newMesh = mesh.copy();
                        mesh.rotation = Quaternion.fromEuler(thisRot);
                        mesh.translation = thisPos / 1;
                        mesh.scale = thisScale / 1;
                        mesh.applyTransformations();
                        node.children.push(mesh);
                    }
                }
                if (part.reflectPartDepth || part.reflectPartSideways || part.reflectPartVertical) {
                    if (part.reflectPartDepth) {
                        var newMesh = mesh.copy(); 
                        // Reflect across the XY plane 
                        newMesh.scale = part.states[0].scale / 1;
                        var newRot = part.states[0].rotation / 1;
                        newRot.z = -newRot.z;
                        newMesh.rotation = Quaternion.fromEuler(newRot);
                        var newPos = part.states[0].position / 1;
                        newPos.z = -newPos.z;
                        newMesh.translation = newPos;
						node.children.push(newMesh);
                    }
                    if (part.reflectPartSideways) {
                        var newMesh = mesh.copy(); 
                        // Reflect across the YZ plane 
                        newMesh.scale = part.states[0].scale / 1;
                        var newRot = part.states[0].rotation / 1;
                        newRot.x = -newRot.x;
                        newMesh.rotation = Quaternion.fromEuler(newRot);
                        var newPos = part.states[0].position / 1;
                        newPos.x = -newPos.x;
                        newMesh.translation = newPos;
						node.children.push(newMesh);
                    }
                    if (part.reflectPartVertical) {
                        var newMesh = mesh.copy(); 
                        // Reflect across the XZ plane 
                        newMesh.scale = part.states[0].scale / 1;
                        var newRot = part.states[0].rotation / 1;
                        newRot.y = -newRot.y;
                        newMesh.rotation = Quaternion.fromEuler(newRot);
                        var newPos = part.states[0].position / 1;
                        newPos.y = -newPos.y;
                        newMesh.translation = newPos;
                        node.children.push(newMesh);
                    }
                }
                
				
               
                // var euler = part.states[0].rotation * 1;

				mesh.translation = part.states[0].position;
				mesh.rotation = Quaternion.fromEuler(part.states[0].rotation);
				mesh.scale = part.states[0].scale;
                mesh.applyTransformations();
				node.children.push(mesh);
            }
            
        }
        return node;
    }
    static function expandThingAttributeFromJson(thing:Thing, attributes:Array<Int>) {
        if (attributes != null) {
            for (attr in attributes) {
            switch (cast (attr: ThingAttribute)) {
				case ThingAttribute.isClonable: thing.isClonable = true;
				case ThingAttribute.isHoldable: thing.isHoldable = true;
				case ThingAttribute.remainsHeld: thing.remainsHeld = true;
				case ThingAttribute.isClimbable: thing.isClimbable = true;
				case ThingAttribute.isPassable: thing.isPassable = true;
                case ThingAttribute.isUnwalkable: thing.isUnwalkable = true;
				case ThingAttribute.doSnapAngles: thing.doSnapAngles = true;
                case isBouncy: thing.isBouncy = true;
                case doShowDirection: thing.doShowDirection = true;
                case keepPreciseCollider: thing.keepPreciseCollider = true;
                case doesFloat: thing.doesFloat = true;
                case doesShatter: thing.doesShatter = true;
                case isSticky: thing.isSticky = true;
                case isSlidy: thing.isSlidey = true;
                case doSnapPosition: thing.doSnapPosition = true;
                case amplifySpeech: thing.amplifySpeech = true;
                case benefitsFromShowingAtDistance: thing.showAtDistance = true;
                case scaleAllParts: thing.scaleAllParts = true;
                case doSoftSnapAngles: thing.softSnapAngles = true;
                case doAlwaysMergeParts: thing.alwaysMergeParts = true;
                case addBodyWhenAttached: thing.addBodyWhenWorn = true;
                case hasSurroundSound: thing.hasSurrondSound = true;
                case canGetEventsWhenStateChanging: thing.canGetEventsWhenStateChanging = true;
                case replacesHandsWhenAttached: thing.replacesHandsWhenAttached = true;
                case mergeParticleSystems: thing.mergeParticleSystems = true;
                case isSittable: thing.isSittable = true;
                case smallEditMovements: thing.finetuneParts = true;
                case scaleEachPartUniformly: thing.scaleUniformally = true;
                case snapAllPartsToGrid: thing.snapAllPartsToGrid = true;
                case invisibleToUsWhenAttached: thing.invisibleWhenWorn = true;
                case replaceInstancesInArea: thing.replaceInstInArea = true;
                case addBodyWhenAttachedNonClearing: thing.addBodyWhenWornNonClearing = true;
                case avoidCastShadow: thing.dontCastShadow = true;
                case avoidReceiveShadow: thing.dontRecieveShadow = true;
                case omitAutoSounds: thing.omitAutoSounds = true;
                case omitAutoHapticFeedback: thing.omitAutoHapticFeedback = true;
                case keepSizeInInventory: thing.keepSizeInInventory = true;
                case autoAddReflectionPartsSideways: thing.reflectSideways = true;
                case autoAddReflectionPartsDepth: thing.reflectDepth = true;
                case autoAddReflectionPartsVertical: thing.reflectVertical = true;
                case activeEvenInInventory: thing.activeInInventory = true;
                case stricterPhysicsSyncing: thing.stricterPhysicsSyncing = true;
                case removeOriginalWhenGrabbed: thing.removeOriginalWhenGrabbed = true;
                case persistWhenThrownOrEmitted: thing.persistWhenThrownOrEmitted = true;
                case invisible: thing.invisible = true;
                case uncollidable: thing.uncollidable = true;
                case movableByEveryone: thing.movableByEveryone = true;
                case isNeverClonable: thing.isNeverClonable = true;
                case floatsOnLiquid: thing.floatsOnLiquid = true;
                case invisibleToDesktopCamera: thing.invisibleToDesktopCamera = true;
                default: // nothing : )
            }
        }
        // No suppress holdable here :sunglasses:
        }
        
    }
    static function expandPartAttributeFromJson(part:ThingPart, attributes:Array<Int>) {
        if (attributes != null) {
            for (attr in attributes) {
                switch (cast (attr :ThingPartAttribute)) {
                    case ThingPartAttribute.offersScreen: part.offersScreen = true;
                    case scalesUniformly: part.scalesUniformally = true;
                    case videoScreenHasSurroundSound:  part.screenSurrondSound = true;
                    case isLiquid: part.isLiquid = true;
                    case offersSlideshowScreen: part.offersSlideshow = true;
                    case isCamera: part.isCamera = true;
                    case isFishEyeCamera: part.isFisheyeCamera = true;
                    case useUnsoftenedAnimations: part.useUnsoftenedAnim = true;
                    case invisible: part.partInvisible = true;
                    case isUnremovableCenter: part.isCenter = true;
                    case omitAutoSounds: part.omitAutoSoundsPart = true;
                    case doSnapTextureAngles: part.doTextureSnapAngles = true;
                    case textureScalesUniformly:part.textureScalesUniformally = true;
                    case avoidCastShadow: part.avoidCastShadow = true;
                    case looselyCoupledParticles: part.looselyCoupledParticles = true;
                    case textAlignCenter: part.textAlignCenter = true;
                    case textAlignRight: part.textAlignRight = true;
                    case isAngleLocker: part.isAngleLocker = true;
                    case isPositionLocker:part.isPositionLocker = true;
                    case isLocked: part.isLocked = true;
                    case avoidReceiveShadow: part.avoidRecieveShadow = true;
                    case isImagePasteScreen: part.isImagePasteScreen = true;
                    case allowBlackImageBackgrounds: part.allowBlackImageBackgrounds = true;
                    case videoScreenLoops: part.videoScreenLoops = true;
                    case videoScreenIsDirectlyOnMesh: part.videoScreenIsDirectlyOnMesh = true;
                    case useTextureAsSky: part.useTextureAsSky = true;
                    case stretchSkydomeSeam: part.stretchSkydomeSeam = true;
                    case subThingsFollowDelayed: part.subthingFollowDelayed = true;
                    case hasReflectionPartSideways: part.reflectPartSideways = true;
                    case hasReflectionPartVertical: part.reflectPartVertical = true;
                    case hasReflectionPartDepth: part.reflectPartDepth = true;
                    case videoScreenFlipsX: part.screenFlipsX = true;
                    case persistStates: part.persistStates = true;
                    case uncollidable: part.partUncollidable = true;
                    case isDedicatedCollider: part.isDedicatedCollider = true;
                    case personalExperience: part.personalExperience = true;
                    case invisibleToUsWhenAttached: part.partInvisbleWhenWorn = true;
                    case lightOmitsShadow: part.lightOmitsShadow = true;
                    case showDirectionArrowsWhenEditing: part.showDirectionalArrowsWhenEditing = true;
                    case isVideoButton: part.isVideoButton = true;
                    case isSlideshowButton: part.isSlideshowButton = true;
                    case isCameraButton: part.isCameraButton = true;
                }
            }
        }
        
    }
    static function expandIncludedSubThingInvertAttributes(subThing:SubThingInfo, attributes:Array<Int>) {
        if (attributes != null)
            for (attr in attributes) {
                switch (cast (attr : ThingAttribute)) {
                    case ThingAttribute.isHoldable: subThing.invertIsHoldable = true;
                    case invisible: subThing.invertInvisible= true;
                    case uncollidable: subThing.invertUncollidable = true;
                    default: // : ) Waste of JSON Space but you do you philipp
                }
            }
    }
    public static function exportBytes(thing:Thing) {
        var buf = new BytesBuffer();
        var changedVertsIndex:Map<String, Int> = [];
        if (thing.version > Thing.currentVersion)
            thing.version = Thing.currentVersion;
        // Write version first, so it'll be easier to parse later
        buf.addByte(thing.version);
        if (thing.givenName == null || thing.givenName == "")
            thing.givenName = Thing.defaultName;
        writeStringWLength(buf, thing.givenName);
        if (thing.description == null)
            thing.description = "";

        writeStringWLength(buf, thing.description);
        buf.addInt64(getAttributes(thing));
        // Map may be empty; that's ok! If we see a 0 when reading that means "Ignore this"
        writeStringMap(buf, thing.includedThingIds);
        // We can omit this because when reading, we'll read attributes first
        // which will tell us if htis is needed
        if (thing.addBodyWhenWorn || thing.addBodyWhenWornNonClearing)
            writeStringArray(buf, thing.bodyAttachments);
        buf.addInt32(thing.parts.length);
        var iInThing = 0;
        for (part in thing.parts) {
            buf.addInt64(getPartAttributes(part));
            buf.addByte(part.baseType);
            buf.addByte(part.materialType);
            buf.addByte(part.particleSystem);
            buf.addByte(part.textureTypes[0]);
            buf.addByte(part.textureTypes[1]);
            writeStringWLength(buf, part.guid);
            writeStringWLength(buf, part.givenName);
            if (part.isText) {
                buf.addFloat(part.textLineHeight);
                writeStringWLength(buf, part.text);
            }
            writeIncludedSubthings(buf, thing, part);
            writePlacedSubthings(buf, part);

            if (part.imageUrl == null || part.imageUrl.length == 0) 
                buf.addInt32(0);
            else {
                buf.addStringWLength(part.imageUrl);
                buf.addByte(part.imageType);
            }
            if (part.autoContinuation == null)
                buf.addInt32(0);
            else 
                part.autoContinuation.writeBytes(buf);
            writeChangedVertices(buf, part, changedVertsIndex, iInThing);
            if (part.smoothingAngle != null) {
                buf.addInt32(part.smoothingAngle);
            } else {
                // because 361 isn't specified as an angle : )
                buf.addInt32(361);
            }
            buf.addByte(part.convex != null ? (part.convex ? 1 : 0) : 2);
            writeStateBytes(buf, part);
            iInThing++;
        }
        return buf.getBytes();
    }
    static function writeIncludedSubthings(buf:BytesBuffer, thing:Thing, part:ThingPart) {
        if (part.includedSubThings == null) {
            buf.addInt32(0);
            return;
        }
        buf.addInt32(part.includedSubThings.length);
        for (iSubThing in part.includedSubThings) {
            writeStringWLength(buf, iSubThing.thingId);
            buf.addFloatTriplet(iSubThing.pos.toUnity());
            buf.addFloatTriplet(iSubThing.rot.toUnityEuler());
            writeStringWLength(buf, iSubThing.nameOverride != null ? iSubThing.nameOverride : thing.givenName);
            buf.addByte(getSubthingAttr(iSubThing));
        }
    }
    static function writePlacedSubthings(buf:BytesBuffer, part:ThingPart) {
        if (part.placedSubThings == null) {
            buf.addInt32(0);
            return;
        }
        buf.addInt32(Lambda.count(part.placedSubThings));
        for (placementId => pSubThing in part.placedSubThings) {
            buf.addStringWLength(placementId);
            buf.addStringWLength(pSubThing.thingId);
            buf.addFloatTriplet(pSubThing.pos.toUnity());
            buf.addFloatTriplet(pSubThing.rot.toUnityEuler());
        }
    }
    static function getSubthingAttr(subthing:SubThingInfo) {
        var bits:UInt = 0;
        if (subthing.invertUncollidable) bits |= SubThingAttr.invertUncollidable;
        if (subthing.invertInvisible) bits |= SubThingAttr.invertInvisible;
        if (subthing.invertIsHoldable) bits |= SubThingAttr.invertIsHoldable;
        return bits;
    }
    static function removeUnusedPartGuids(thing:Thing) {
        for (part in thing.parts) {
            if (part.guid != null && part.guid != "" && !isPartGuidUsed(thing, part.guid, part))
                part.guid = null;
        }
    }
    static function isPartGuidUsed(thing:Thing, guid:String, ignorePart:ThingPart) {
        for (part in thing.parts) {
            if (part != ignorePart && part.autoContinuation != null &&part.autoContinuation.fromPart.guid == guid )
                return true;
        }
        return false;
    }
    static function writeStringMap(buf:BytesBuffer, map:Map<String,String>) {
        buf.addInt32(Lambda.count(map));
        for (key => value in map) {
            writeStringWLength(buf, key);
            writeStringWLength(buf,value);
        }
    }
    static function writeStringArray(buf:BytesBuffer, array:Array<String>) {
        buf.addInt32(array.length);
        for (value in array) {
            writeStringWLength(buf, value);
        }
    }
    public static function writeStringWLength(buf:BytesBuffer, string:Null<String>) {
        if (string != null) {
			buf.addInt32(string.length);
			buf.addString(string, UTF8);
        } else {
            buf.addInt32(0);
        }
        
    }
    static function writeChangedVertices(buf:BytesBuffer, part:ThingPart, changedVertsIndexRef:Map<String, Int>, indexWithinThing:Int) {
        var indicesByPosition:Map<Vector3, Array<Int>> = [];
        var addedThings:Array<String> = [];
        for (index => pos in part.changedVerticies) {
            var unityPos = pos.toUnity();
            // I think this is only made by us so we will have the references??? Busted
            if (!addedThings.contains(Std.string(unityPos))) {
                var indices:Array<Int> = [];
                for (innerIndex => innerPos in part.changedVerticies) {
                    // this is ok because abstracts  : )
                    if (innerPos == pos) { 
                        // it's now absolute : )
                        // Not like it costs any damn storage space
                        indices.push(innerIndex);
                    }
                }
                indicesByPosition.set(unityPos, indices);
                addedThings.push(Std.string(unityPos));
            }
        }
        var indLength = Lambda.count(indicesByPosition);
        buf.addInt32(indLength);
        for (key => value in indicesByPosition) {
            buf.addFloatTriplet(key);
            buf.addIntArray(value);
            

        }
        /*
        if (indLength > 0) {
            s = '"c":[$s]';
            if (part.smoothingAngle != null) {s += Std.string(part.smoothingAngle);}
            s += "_";
            // Technically i can just write `part.convex` but then maybe null gets busted?? idrc
            if (part.convex != null) s += part.convex == true ? "1" : "0";
            
            if (changedVertsIndexRef.exists(s)) {
                var exIndex = changedVertsIndexRef.get(s);
                buf.addInt32(exIndex);
                part.smoothingAngle = null;
                part.convex = null;
            } else {
                changedVertsIndexRef.set(s, indexWithinThing);
                buf.addInt32(indexWithinThing);
            }
        }
        */

    }
    static function writeStateBytes(buf:BytesBuffer, part:ThingPart) {
        // byte because there is a hard limit at like 50 iirc
        buf.addByte(part.states.length);
        for (state in part.states) {

            buf.addFloatTriplet(state.position.toUnity());
            buf.addFloatTriplet(state.rotation.toUnityEuler());
            buf.addFloatTriplet(state.scale.toUnity());
            buf.addInt32(state.color);
            writeStringArray(buf, state.scriptLines);
            if (part.textureTypes[0] != None)
                writeStateTextureBytes(buf, part, state, 0);
            if (part.textureTypes[1] != None)
                writeStateTextureBytes(buf, part, state, 1);
            if (part.particleSystem != None)
                writeStateParticleBytes(buf, part, state);
        }
    }
    static var textureTypeWithOnlyAlphaSetting = [
        TextureTypes.SideGlow,
        TextureTypes.Wireframe,
        TextureTypes.Outline
    ];
    static var particleSystemWithOnlyAlphaSetting:Array<ParticleSystemType> = [
        NoisyWater,
        GroundSmoke,
        Rain,
        Fog,
        TwistedSmoke,
        Embers,
        Beams,
        Rays,
        CircularSmoke,
        PopSmoke,
        WaterFlow,
        WaterFlowSoft,
        Sparks,
        Flame
    ];
    static function writeStateTextureBytes(buf:BytesBuffer, part:ThingPart, state:ThingPartState, index:Int) {
        buf.addInt32(state.textureColors[index]);
        var withOnlyAlphaSetting = textureTypeWithOnlyAlphaSetting.contains(part.textureTypes[index]);
        if (withOnlyAlphaSetting) {
            // Byte because there should be less than 256 keys lmao
            buf.addByte(1);
			buf.addByte(TextureProperty.Strength);
            buf.addFloat(state.textureProperties[index].get(Strength));
        } else {
            buf.addByte(10);
            for (property in 0...10) {
                buf.addByte(property);
                buf.addFloat(state.textureProperties[index].get(property));
            }
        }
    }
    static function writeStateParticleBytes(buf:BytesBuffer, part:ThingPart, state:ThingPartState) {
        buf.addInt32(state.particleSystemColor);
        final withOnlyAlphaSetting = particleSystemWithOnlyAlphaSetting.contains(part.particleSystem);
        if (withOnlyAlphaSetting) {
            buf.addByte(1);
            buf.addByte(ParticleSystemProperty.Alpha);
            buf.addFloat(state.particleSystemProperty.get(Alpha));
        } else {
            buf.addByte(6);
            for (prop in 0...6) {
                buf.addByte(prop);
                buf.addFloat(state.particleSystemProperty.get(prop));
            }
        }
    }
    static function getAttributes(thing:Thing) {
        var lowerBits:LowerThingAttribute = 0;
        var higherBits:HigherThingAttribute = 0;
        if (thing.isClonable) lowerBits |= isClonable;
        if (thing.isHoldable) lowerBits |= isHoldable;
        if (thing.remainsHeld) lowerBits |= remainsHeld;
        if (thing.isClimbable) lowerBits |= isClimbable;
        if (thing.isPassable) lowerBits |= isPassable;
        if (thing.isUnwalkable) lowerBits |= isUnwalkable;
        if (thing.doSnapAngles) lowerBits |= doSnapAngles;
        if (thing.isBouncy) lowerBits |= isBouncy;
        if (thing.doShowDirection) lowerBits |= doShowDirection;
        if (thing.keepPreciseCollider) lowerBits |= keepPreciseCollider;
        if (thing.doesFloat) lowerBits |= doesFloat;
        if (thing.doesShatter) lowerBits |= doesShatter;
        if (thing.isSticky) lowerBits |= isSticky;
        if (thing.isSlidey) lowerBits |= isSlidey;
        if (thing.doSnapPosition) lowerBits |= doSnapPosition;
        if (thing.amplifySpeech) lowerBits |= amplifySpeech;
        if (thing.showAtDistance) lowerBits |= showAtDistance;
        if (thing.scaleAllParts) lowerBits |= scaleAllParts;
        if (thing.softSnapAngles) lowerBits |= softSnapAngles;
        if (thing.alwaysMergeParts) lowerBits |= alwaysMergeParts;
        if (thing.addBodyWhenWorn) lowerBits |= addBodyWhenWorn;
        if (thing.hasSurrondSound) lowerBits |= hasSurrondSound;
        if (thing.canGetEventsWhenStateChanging) lowerBits |= canGetEventsWhenStateChanging;
        if (thing.replacesHandsWhenAttached) lowerBits |= replacesHandsWhenAttached;
        if (thing.mergeParticleSystems) lowerBits |= mergeParticleSystems;
        if (thing.isSittable) lowerBits |= isSittable;
        if (thing.finetuneParts) lowerBits |= finetuneParts;
        if (thing.scaleUniformally) lowerBits |= scaleUniformly;
        if (thing.snapAllPartsToGrid) lowerBits |= snapAllPartsToGrid;
        if (thing.invisibleWhenWorn) lowerBits |= invisibleWhenWorn;

        if (thing.replaceInstInArea) higherBits |= replaceInstInArea;
        if (thing.addBodyWhenWornNonClearing) higherBits |= addBodyWhenWornNonClearing;
        if (thing.dontCastShadow) higherBits |= dontCastShadow;
        if (thing.dontRecieveShadow) higherBits |= dontReceiveShadow;
        if (thing.omitAutoSounds) higherBits |= omitAutoSounds;
        if (thing.omitAutoHapticFeedback) higherBits |= omitAutoHapticFeedback;
        if (thing.keepSizeInInventory) higherBits |= keepSizeInInventory;
        if (thing.reflectSideways) higherBits |= reflectSideways;
        if (thing.reflectVertical) higherBits |= reflectVertical;
        if (thing.reflectDepth) higherBits |= reflectDepth;
        if (thing.activeInInventory) higherBits |= activeInInventory;
        if (thing.stricterPhysicsSyncing) higherBits |= stricterPhysicsSyncing;
        if (thing.removeOriginalWhenGrabbed) higherBits |= removeOriginalWhenGrabbed;
        if (thing.persistWhenThrownOrEmitted) higherBits |= persistWhenThrownOrEmitted;
        if (thing.invisible) higherBits |= invisible;
        if (thing.uncollidable) higherBits |= uncollidable;
        if (thing.movableByEveryone) higherBits |= movableByEveryone;
        if (thing.isNeverClonable) higherBits |= isNeverClonable;
        if (thing.floatsOnLiquid) higherBits |= floatsOnLiquid;
        if (thing.invisibleToDesktopCamera) higherBits |= invisibleToDesktopCamera;
        if (thing.personalExperience) higherBits |= personalExperience;
        return Int64.make(higherBits, lowerBits);
    }

    static function getPartAttributes(part:ThingPart) {
        var higherBits:HigherThingPartAttribute = 0;
        var lowerBits:LowerThingPartAttribute = 0;
        if (part.offersScreen) lowerBits |= offersScreen;
        if (part.isVideoButton) lowerBits |= isVideoButton;
        if (part.scalesUniformally) lowerBits |= scalesUniformally;
        if (part.screenSurrondSound) lowerBits |= screenSurrondSound;
        if (part.isLiquid) lowerBits |= isLiquid;
        if (part.offersSlideshow) lowerBits |= offersSlideshow;
        if (part.isSlideshowButton) lowerBits |= isSlideshowButton;
        if (part.isCamera) lowerBits |= isCamera;
        if (part.isCameraButton) lowerBits |= isCameraButton;
        if (part.isFisheyeCamera) lowerBits |= isFisheyeCamera;
        if (part.useUnsoftenedAnim) lowerBits |= useUnsoftenedAnim;
        if (part.partInvisible) lowerBits |= partInvisible;
        if (part.isCenter) lowerBits |= isCenter;
        if (part.omitAutoSoundsPart) lowerBits |= omitAutoSoundsPart;
        if (part.doTextureSnapAngles) lowerBits |= doTextureSnapAngles;
        if (part.textureScalesUniformally) lowerBits |= textureScalesUniformally;
        if (part.textAlignCenter) lowerBits |= textAlignCenter;
        if (part.textAlignRight) lowerBits |= textAlignRight;
        if (part.isAngleLocker) lowerBits |= isAngleLocker;
        if (part.isPositionLocker) lowerBits |= isPositionLocker;
        if (part.isLocked) lowerBits |= isLocked;
        if (part.avoidRecieveShadow) lowerBits |= avoidRecieveShadow;
        if (part.isImagePasteScreen) lowerBits |= isImagePasteScreen;
        if (part.allowBlackImageBackgrounds) lowerBits |= allowBlackImageBackgrounds;
        if (part.videoScreenLoops) lowerBits |= videoScreenLoops;
        if (part.videoScreenIsDirectlyOnMesh) lowerBits |= videoScreenIsDirectlyOnMesh;
        if (part.useTextureAsSky) lowerBits |= useTextureAsSky;
        if (part.stretchSkydomeSeam) lowerBits |= stretchSkydomeSeam;
        if (part.subthingFollowDelayed) lowerBits |= subthingFollowDelayed;
        if (part.reflectPartSideways) lowerBits |= reflectPartSideways;

        if (part.reflectPartDepth) higherBits |= reflectPartDepth;
        if (part.reflectPartVertical) higherBits |= reflectPartVertical;
        if (part.screenFlipsX) higherBits |= screenFlipsX;
        if (part.persistStates) higherBits |= persistStates;
        if (part.partUncollidable) higherBits |= partUncollidable;
        if (part.isDedicatedCollider) higherBits |= isDedicatedCollider;
        if (part.personalExperience) higherBits |= personalExperiencePart;
        if (part.partInvisbleWhenWorn) higherBits |= partInvisbleWhenWorn;
        if (part.lightOmitsShadow) higherBits |= lightOmitsShadow;
        if (part.showDirectionalArrowsWhenEditing) higherBits |= showDirectionalArrowsWhenEditing;
        if (part.isText) higherBits |= isText;
        return Int64.make(higherBits, lowerBits);

    }
}