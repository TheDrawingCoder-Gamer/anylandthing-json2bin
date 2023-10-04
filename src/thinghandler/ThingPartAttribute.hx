package thinghandler;

enum abstract ThingPartAttribute(UInt) to UInt from UInt {
	var offersScreen = 1;
	var scalesUniformly = 3;
	var videoScreenHasSurroundSound = 4;
	var isLiquid = 5;
	var offersSlideshowScreen = 6;
	var isCamera = 8;
	var isFishEyeCamera = 10;
	var useUnsoftenedAnimations = 11;
	var invisible = 12;
	var isUnremovableCenter = 13;
	var omitAutoSounds = 14;
	var doSnapTextureAngles = 15;
	var textureScalesUniformly = 16;
	var avoidCastShadow = 17;
	var looselyCoupledParticles = 18;
	var textAlignCenter = 19;
	var textAlignRight = 20;
	var isAngleLocker = 21;
	var isPositionLocker = 22;
	var isLocked = 23;
	var avoidReceiveShadow = 24;
	var isImagePasteScreen = 25;
	var allowBlackImageBackgrounds = 26;
	var videoScreenLoops = 27;
	var videoScreenIsDirectlyOnMesh = 28;
	var useTextureAsSky = 29;
	var stretchSkydomeSeam = 30;
	var subThingsFollowDelayed = 31;
	var hasReflectionPartSideways = 32;
	var hasReflectionPartVertical = 33;
	var hasReflectionPartDepth = 34;
	var videoScreenFlipsX = 35;
	var persistStates = 36;
	var uncollidable = 37;
	var isDedicatedCollider = 38;
	var personalExperience = 39;
	var invisibleToUsWhenAttached = 40;
	var lightOmitsShadow = 41;
	var showDirectionArrowsWhenEditing = 42;

	// Deprecated as now possible via scripting;
	// will load but not save after clone-editing:
	var isVideoButton = 2;
	var isSlideshowButton = 7;
	var isCameraButton = 9;
}
