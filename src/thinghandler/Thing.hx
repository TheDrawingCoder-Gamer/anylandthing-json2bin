package thinghandler;

import bulby.BulbyMath;
import bulby.assets.mat.Color;
import thinghandler.TextureProperty.TexturePropertyMap;
import haxe.ds.Vector;





enum abstract Axises(UInt) from UInt to UInt {
    var x = 1;
    var y = 1 << 1;
    var z = 1 << 2;

    @:op(A | B) public static function _(_, _):UInt;
    @:op(A & B) public static function _(_,_):UInt;
}
enum abstract LowerThingAttribute (UInt) to UInt from UInt {
    var isClonable = 1;
	var isHoldable = 1 << 1;
    var remainsHeld = 1 << 2;
    var isClimbable = 1 << 3;
    var isPassable = 1 << 4;
    var isUnwalkable = 1 << 5;
    var doSnapAngles = 1 << 6;
    var deprecated_hideShapeEffects = 1 << 7;
    var isBouncy = 1 << 8;
    var currentlyUnused1 = 1 << 9;
    var doShowDirection = 1 << 10;
    var keepPreciseCollider = 1 << 11;
    var doesFloat = 1 << 12;
    var doesShatter = 1 << 13;
    var isSticky = 1 << 14;
    var isSlidey = 1 << 15;
    var doSnapPosition = 1 << 16;
    var amplifySpeech = 1 << 17;
    var showAtDistance = 1 << 18;
    var scaleAllParts = 1 << 19;
    var softSnapAngles = 1 << 20;
    var alwaysMergeParts = 1 << 21;
    var addBodyWhenWorn = 1 << 22;
    var hasSurrondSound = 1 << 23;
    var canGetEventsWhenStateChanging = 1 << 24;
    var replacesHandsWhenAttached = 1 << 25;
    var mergeParticleSystems = 1 << 26;
    var isSittable = 1 << 27;
    var finetuneParts = 1 << 28;
    var scaleUniformly = 1 << 29;
    var snapAllPartsToGrid = 1 << 30;
    var invisibleWhenWorn = 1 << 31;

    @:op(A | B) static function _(_, _):LowerThingAttribute;
}
enum abstract HigherThingAttribute (UInt) to UInt from UInt{
    var replaceInstInArea = 1;
    var addBodyWhenWornNonClearing = 1 << 1;
    var dontCastShadow = 1 << 2;
    var dontReceiveShadow = 1 << 3;
    var omitAutoSounds = 1 << 4;
    var omitAutoHapticFeedback = 1 << 5;
    var keepSizeInInventory = 1 << 6;
    var reflectSideways = 1 << 7;
    var reflectVertical = 1 << 8;
    var reflectDepth = 1 << 9;
    var activeInInventory = 1 << 10;
    var stricterPhysicsSyncing = 1 << 11;
    var removeOriginalWhenGrabbed = 1 << 12;
    var persistWhenThrownOrEmitted = 1 << 13;
    var invisible = 1 << 14;
    var uncollidable = 1 << 15;
    var movableByEveryone = 1 << 16;
    var isNeverClonable = 1 << 17;
    var floatsOnLiquid = 1 << 18;
    var invisibleToDesktopCamera = 1 << 19;
    var personalExperience = 1 << 20;
	@:op(A | B) static function _(_, _):HigherThingAttribute;

}
enum abstract AttachmentSlot(UInt) from UInt to UInt {
    var hat;
    var head;
    var leftarm;
    var rightarm;
    var uppertorso;
    var lowertorso;
    var leftleg;
    var rightleg;
}
class Thing {
    // The name given to a thing by the player. 
    public var givenName:String = "";
    public static final defaultName:String = "thing";
    public var version:Int;
    public var id:String = "1";
    public static final currentVersion:Int = 5;
    public var description:Null<String> = null;
    public var parts:Array<ThingPart> = [];
    public var includedThingIds:Map<String, String> = [];
    // I could really use a tuple right now, tuple right now, tuple right nowww
    public var bodyAttachments:Array<String> = ["0", "0", "0", "0", "0", "0", "0", "0"];
    // Attributes 
    public var isClonable:Bool = false;
    public var isHoldable:Bool = false;
    public var remainsHeld:Bool = false;
    public var isClimbable:Bool = false;
    public var isPassable:Bool = false;
    public var isUnwalkable:Bool = false;
    public var doSnapAngles:Bool = false;
    public var isBouncy:Bool = false;
    public var doShowDirection:Bool = false;
    public var keepPreciseCollider:Bool = false;
    public var doesFloat:Bool = false;
    public var doesShatter:Bool = false;
    public var isSticky:Bool = false;
    public var isSlidey:Bool = false;
    public var doSnapPosition:Bool = false;
    public var amplifySpeech:Bool = false;
    public var showAtDistance:Bool = false;
    public var scaleAllParts:Bool = false;
    public var softSnapAngles:Bool = false;
    public var alwaysMergeParts:Bool = false;
    public var addBodyWhenWorn:Bool = false;
    public var hasSurrondSound:Bool = false;
    public var canGetEventsWhenStateChanging:Bool = false;
    public var replacesHandsWhenAttached:Bool = false;
    public var mergeParticleSystems = false;
    public var isSittable = false;
    public var finetuneParts = false;
    public var scaleUniformally = false;
    public var snapAllPartsToGrid = false;
    public var invisibleWhenWorn = false;
    public var replaceInstInArea = false;
    public var addBodyWhenWornNonClearing = false;
    public var dontCastShadow = false;
    public var dontRecieveShadow = false;
    public var omitAutoSounds = false;
    public var omitAutoHapticFeedback = false;
    public var keepSizeInInventory = false;
    public var reflectSideways = false;
    public var reflectVertical = false;
    public var reflectDepth = false;
    public var activeInInventory = false;
    public var stricterPhysicsSyncing = false;
    public var removeOriginalWhenGrabbed = false;
    public var persistWhenThrownOrEmitted = false;
    public var invisible = false;
    public var uncollidable = false;
    public var movableByEveryone = false;
    public var isNeverClonable = false;
    public var floatsOnLiquid = false;
    public var invisibleToDesktopCamera = false;
    public var personalExperience = false;

    // Physics
    public var physicsMass:Null<Float> = null;
    public var dragMass:Null<Float> = null;
    public var angularDrag:Null<Float> = null;
    public var lockedPos:UInt = 0;
    public var lockedRot:UInt = 0;

    public function new() {}


    public function copy() {
        return bulby.cloner.Cloner.clone(this);
    }
}
enum abstract LowerThingPartAttribute(UInt) from UInt to UInt{
    var offersScreen = 1;
    var isVideoButton = 1 << 1;
    var scalesUniformally = 1 << 2;
    var screenSurrondSound = 1 << 3;
    var isLiquid = 1 << 4;
    var offersSlideshow = 1 << 5;
    var isSlideshowButton = 1 << 6;
    var isCamera = 1 << 7;
    var isCameraButton = 1 << 8;
    var isFisheyeCamera = 1 << 9;
    var useUnsoftenedAnim = 1 << 10;
    var partInvisible = 1 << 11;
    var isCenter = 1 << 12;
    var omitAutoSoundsPart = 1 << 13;
    var doTextureSnapAngles = 1 << 14;
    var textureScalesUniformally = 1 << 15;
    var avoidCastShadow = 1 << 16;
    var looselyCoupledParticles = 1 << 17;
    var textAlignCenter = 1 << 18;
    var textAlignRight = 1 << 19;
    var isAngleLocker = 1 << 20;
    var isPositionLocker = 1 << 21;
    var isLocked = 1 <<22;
    var avoidRecieveShadow = 1 << 23;
    var isImagePasteScreen = 1 << 24;
    var allowBlackImageBackgrounds = 1 << 25;
    var videoScreenLoops = 1 << 26;
    var videoScreenIsDirectlyOnMesh = 1 << 27;
    var useTextureAsSky = 1 << 28;
    var stretchSkydomeSeam = 1 << 29;
    var subthingFollowDelayed = 1 << 30;
    var reflectPartSideways = 1 << 31;
	@:op(A | B) static function _(_, _):LowerThingPartAttribute;
}
enum abstract HigherThingPartAttribute(UInt) from UInt to UInt {
    var reflectPartVertical = 1;
    var reflectPartDepth = 1 << 1;
    var screenFlipsX = 1 << 2;
    var persistStates = 1 << 3;
    var partUncollidable = 1 << 4;
    var isDedicatedCollider = 1 << 5;
    var personalExperiencePart = 1 << 6;
    var partInvisbleWhenWorn = 1 << 7;
    var lightOmitsShadow = 1 << 8;
    var showDirectionalArrowsWhenEditing = 1 << 9;
    var isText = 1 << 10;
	@:op(A | B) static function _(_, _):HigherThingPartAttribute;
}
class ThingPart {
    public var baseType:ThingPartBase = Cube;
    public var materialType:MaterialTypes = None;
    public var guid:Null<String> = null;
    public var givenName:Null<String> = null;
    public var isText:Bool = false;
    public var textLineHeight:Float = 1;
    public var imageUrl:Null<String> = null;
    public var particleSystem:ParticleSystemType = None;
    // I could really use a tuple right now, tuple right now, tuple right now
    public var textureTypes:Vector<TextureTypes> = Vector.fromArrayCopy([TextureTypes.None, TextureTypes.None]);
    public var autoContinuation:Null<ThingPartAutocomplete>;
    public var changedVerticies:Map<Int, Vector3> = [];
    public var imageType:ImageType = NotPng;
    public static var smoothingAngles:Map<ThingPartBase, Int> = [
		ThingPartBase.Bowl1 =>  80, ThingPartBase.Bowl2 =>  80, ThingPartBase.Bowl3 =>  80, ThingPartBase.Bowl4 =>  80, ThingPartBase.Bowl5 =>  80,
		ThingPartBase.Bowl6 =>  80, ThingPartBase.Bowl1Soft =>  140, ThingPartBase.BowlCube =>  50, ThingPartBase.BowlCubeSoft =>  80,
		ThingPartBase.CubeHole =>  80, ThingPartBase.Octagon =>  10, ThingPartBase.HalfBowlSoft =>  140, ThingPartBase.HalfCubeHole =>  80,
		ThingPartBase.HalfCylinder =>  80, ThingPartBase.Heptagon =>  10, ThingPartBase.Pentagon =>  10, ThingPartBase.QuarterBowlCube =>  50,
		ThingPartBase.QuarterBowlCubeSoft =>  80, ThingPartBase.QuarterBowlSoft =>  140, ThingPartBase.QuarterCylinder =>  80, ThingPartBase.QuarterPipe1 =>  80,
		ThingPartBase.QuarterPipe2 =>  80, ThingPartBase.QuarterPipe3 =>  80, ThingPartBase.QuarterPipe4 =>  80, ThingPartBase.QuarterPipe5 =>  80,
		ThingPartBase.QuarterPipe6 =>  80, ThingPartBase.QuarterSphere =>  60, ThingPartBase.Ring1 =>  180, ThingPartBase.Ring2 =>  180,
		ThingPartBase.Ring3 =>  180, ThingPartBase.Ring4 =>  180, ThingPartBase.Ring5 =>  180, ThingPartBase.Ring6 =>  180, ThingPartBase.SphereEdge =>  80,
		ThingPartBase.QuarterTorus1 =>  180, ThingPartBase.QuarterTorus2 =>  180, ThingPartBase.QuarterTorus3 =>  180, ThingPartBase.QuarterTorus4 =>  180,
		ThingPartBase.QuarterTorus5 =>  180, ThingPartBase.QuarterTorus6 =>  180, ThingPartBase.QuarterTorusRotated1 =>  180,
		ThingPartBase.QuarterTorusRotated2 =>  180, ThingPartBase.QuarterTorusRotated3 =>  180, ThingPartBase.QuarterTorusRotated4 =>  180,
		ThingPartBase.QuarterTorusRotated5 =>  180, ThingPartBase.QuarterTorusRotated6 =>  180, ThingPartBase.QuarterSphereRotated =>  80,
		ThingPartBase.Branch =>  120, ThingPartBase.FineSphere =>  140, ThingPartBase.GearSoft =>  120, ThingPartBase.GearVariantSoft =>  120,
		ThingPartBase.GearVariant2Soft =>  60, ThingPartBase.HalfSphere =>  60, ThingPartBase.JitterChamferCylinderSoft =>  120,
		ThingPartBase.JitterConeSoft =>  120, ThingPartBase.JitterCubeSoft =>  120, ThingPartBase.JitterHalfConeSoft =>  90,
		ThingPartBase.JitterSphereSoft =>  120, ThingPartBase.LowJitterCubeSoft =>  120, ThingPartBase.Pipe =>  80, ThingPartBase.Pipe2 =>  80,
		ThingPartBase.Pipe3 =>  80, ThingPartBase.Wheel =>  20, ThingPartBase.Wheel2 =>  20, // 21
		ThingPartBase.Wheel3 =>  15, ThingPartBase.Wheel4 =>  60,
		ThingPartBase.Bubbles =>  120, ThingPartBase.HoleWall =>  60, ThingPartBase.JaggyWall =>  10, ThingPartBase.WavyWall =>  25,
		ThingPartBase.WavyWallVariantSoft =>  30, ThingPartBase.Spikes =>  15, ThingPartBase.SpikesSoft =>  90, ThingPartBase.SpikesVerySoft =>  160,
		ThingPartBase.Rocky =>  15, ThingPartBase.RockySoft =>  30, ThingPartBase.RockyVerySoft =>  120, ThingPartBase.Drop =>  60, ThingPartBase.Drop2 =>  80,
		ThingPartBase.Drop3 =>  80, ThingPartBase.Drop3Jitter =>  35, ThingPartBase.DropBent =>  80, ThingPartBase.DropBent2 =>  80, ThingPartBase.DropCut =>  80,
		ThingPartBase.DropPear =>  80, ThingPartBase.DropPear2 =>  80, ThingPartBase.DropRing =>  80, ThingPartBase.DropSharp =>  80,
		ThingPartBase.DropSharp2 =>  80, ThingPartBase.DropSharp3 =>  80, ThingPartBase.DropSharpCut =>  80, ThingPartBase.SharpBent =>  80,
		ThingPartBase.ShrinkDisk =>  60, ThingPartBase.ShrinkDisk2 =>  60, ThingPartBase.Sphere =>  60
    ];
    public var smoothingAngle:Null<Int> = null;
    public var convex:Null<Bool> = null;
    public var states:Array<ThingPartState> = [];
    public var text:Null<String> = null;
    public var includedSubThings:Null<Array<SubThingInfo>> = null;
    public var placedSubThings:Null<Map<String, SubThingInfo>> = null;
    // attributes
	public var offersScreen = false;
	public var isVideoButton = false;
	public var scalesUniformally = false;
	public var screenSurrondSound = false;
	public var isLiquid = false;
	public var offersSlideshow = false;
	public var isSlideshowButton = false;
	public var isCamera = false;
	public var isCameraButton = false;
	public var isFisheyeCamera = false;
	public var useUnsoftenedAnim = false;
	public var partInvisible = false;
	public var isCenter = false;
	public var omitAutoSoundsPart = false;
	public var doTextureSnapAngles = false;
	public var textureScalesUniformally = false;
	public var avoidCastShadow = false;
	public var looselyCoupledParticles = false;
	public var textAlignCenter = false;
	public var textAlignRight = false;
	public var isAngleLocker = false;
	public var isPositionLocker = false;
	public var isLocked = false;
	public var avoidRecieveShadow = false;
	public var isImagePasteScreen = false;
	public var allowBlackImageBackgrounds = false;
	public var videoScreenLoops = false;
	public var videoScreenIsDirectlyOnMesh = false;
	public var useTextureAsSky = false;
	public var stretchSkydomeSeam = false;
	public var subthingFollowDelayed = false;
	public var reflectPartSideways = false;
	public var reflectPartVertical = false;
	public var reflectPartDepth = false;
	public var screenFlipsX = false;
	public var persistStates = false;
	public var partUncollidable = false;
	public var isDedicatedCollider = false;
	public var personalExperience = false;
	public var partInvisbleWhenWorn = false;
	public var lightOmitsShadow = false;
	public var showDirectionalArrowsWhenEditing = false;
    public function new() {}
	public function copy() {
		return bulby.cloner.Cloner.clone(this);
	}
}
class ThingPartState {
    public var position:Vector3 = Vector3.empty();
    public var rotation:Vector3 = Vector3.empty();
    public var scale:Vector3 = new Vector3(1, 1, 1);
    public var scriptLines:Array<String> = [];
    public var textureProperties:Vector<TexturePropertyMap<Float>> = Vector.fromArrayCopy([new TexturePropertyMap<Float>([]), new TexturePropertyMap<Float>([])]);
    public var particleSystemProperty:Map<ParticleSystemProperty, Int> = [];
    public var particleSystemColor:Color = new Color(0, 0, 0);
    public var textureColors:Vector<Color> = Vector.fromArrayCopy([new Color(0, 0, 0), new Color(0,0,0)]);
    public var color:Color = Color.white;
    public function new() {}

	public function copy() {
		return bulby.cloner.Cloner.clone(this);
	}
}
enum abstract SubThingAttr(UInt) to UInt from UInt{
    var invertIsHoldable = 1;
    var invertInvisible = 1 << 1;
    var invertUncollidable = 1 << 2;
}
enum abstract ImageType(UInt) to UInt from UInt {
    var NotPng = 0;
    var Png = 1;
}
class SubThingInfo {
    public var thingId:String = "";
    public var pos:Vector3 = Vector3.empty();
    public var rot:Vector3 = Vector3.empty();
    public var invertIsHoldable = false;
    public var invertInvisible = false;
    public var invertUncollidable = false;
    public var nameOverride:Null<String> = null;
    public var placedSubThing = false;
    public function new (placedSubThing:Bool) {
        this.placedSubThing = placedSubThing;
    }
}