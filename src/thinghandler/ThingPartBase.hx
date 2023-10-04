package thinghandler;

import bulby.assets.Mesh;
import sys.FileSystem;
import sys.io.File;

enum abstract ThingPartBase(UInt) from UInt to UInt {
	var Cube = 1;
	var Pyramid;
	var Sphere;
	var Cone;
	var Cylinder;
	var Triangle;
	var Trapeze;
	var Hedra;
	var Icosphere;
	var LowpolySphere;
	var Ramp;
	var JitterCube;
	var ChampferCube;
	var Spike;
	var LowpolyCylinder;
	var HalfSphere;
	var JitterSphere;
	var TextArialBold;
	var TextTimesBold;
	var TextArCenter;
	var TextGeometr;
	var TextRockwell;
	var TextGillSans;
	var BigDialog = 25;
	var QuarterPipe1;
	var QuarterPipe2;
	var QuarterPipe3;
	var QuarterPipe4;
	var QuarterPipe5;
	var QuarterPipe6;
	var QuarterTorus1;
	var QuarterTorus2;
	var QuarterTorus3;
	var QuarterTorus4;
	var QuarterTorus5;
	var QuarterTorus6;
	var CurvedRamp;
	var CubeRotated;
	var QuarterPipeRotated1;
	var QuarterPipeRotated2;
	var QuarterPipeRotated3;
	var QuarterPipeRotated4;
	var QuarterPipeRotated5;
	var QuarterPipeRotated6;
	var QuarterTorusRotated1;
	var QuarterTorusRotated2;
	var QuarterTorusRotated3;
	var QuarterTorusRotated4;
	var QuarterTorusRotated5;
	var QuarterTorusRotated6;
	var Hexagon;
	var HexagonBevel;
	var Ring1;
	var Ring2;
	var Ring3;
	var Ring4;
	var Ring5;
	var Ring6;
	var CubeBevel1;
	var CubeBevel2;
	var CubeBevel3;
	var Triangle2;
	var HalfCylinder;
	var QuarterCylinder;
	var QuarterSphere;
	var SphereEdge;
	var RoundCube;
	var Capsule;
	var Heptagon;
	var Pentagon;
	var Octagon;
	var Highpolysphere;
	var Bowl1;
	var Bowl2;
	var Bowl3;
	var Bowl4;
	var Bowl5;
	var Bowl6;
	var BowlCube;
	var QuarterBowlCube;
	var CubeHole;
	var HalfCubeHole;
	var BowlCubeSoft;
	var QuarterBowlCubeSoft;
	var Bowl1Soft;
	var QuarterSphereRotated;
	var HalfBowlSoft;
	var QuarterBowlSoft;
	var TextOrbitron;
	var TextAlfaSlab;
	var TextAudioWide;
	var TextBangers;
	var TextBowlby;
	var TextCantata;
	var TextChewy;
	var TextComingSoon;
	var TextExo;
	var TextFredoka;
	var TextKaushan;
	var TextMonoton;
	var TextPatrick;
	var TextPirata;
	var TextShrikhand;
	var TextSpinnaker;
	var TextDiplomata;
	var TextHanalei;
	var TextJoti;
	var TextMedieval;
	var TextSancreek;
	var TextStalinist;
	var TextTradewinds;
	var TextBaloo;
	var TextBubbler;
	var TextCaesarDressing;
	var TextDhurjati;
	var TextFascinateInline;
	var TextFelipa;
	var TextInknutAntiqua;
	var TextKeania;
	var TextLakkiReddy;
	var TextLondrinaSketch;
	var TextLondrinaSolid;
	var TextMetalMania;
	var TextMolle;
	var TextRisque;
	var TextSarpanch;
	var TextUncialAntiqua;
	var Text256Bytes;
	var TextAeroviasBrasil;
	var TextAnitaSemiSquare;
	var TextBeefd;
	var TextCrackdown;
	var TextCreampuff;
	var TextDataControl;
	var TextEndor;
	var TextFreshMarker;
	var TextHeavyData;
	var TextPropaganda;
	var TextRobotoMono;
	var TextTitania;
	var TextTobagoPoster;
	var TextViafont;
	var Wheel;
	var Wheel2;
	var Wheel3;
	var Wheel4;
	var WheelVariant;
	var Wheel2Variant;
	var JitterCubeSoft;
	var JitterSphereSoft;
	var LowJitterCube;
	var LowJitterCubeSoft;
	var JitterCone;
	var JitterConeSoft;
	var JitterHalfCone;
	var JitterHalfConeSoft;
	var JitterChamferCylinder;
	var JitterChamferCylinderSoft;
	var Gear;
	var GearVariant;
	var GearVariant2;
	var GearSoft;
	var GearVariantSoft;
	var GearVariant2Soft;
	var Branch;
	var Bubbles;
	var HoleWall;
	var JaggyWall;
	var Rocky;
	var RockySoft;
	var RockyVerySoft;
	var Spikes;
	var SpikesSoft;
	var SpikesVerySoft;
	var WavyWall;
	var WavyWallVariant;
	var WavyWallVariantSoft;
	var Quad;
	var FineSphere;
	var Drop;
	var Drop2;
	var Drop3;
	var DropSharp;
	var DropSharp2;
	var DropSharp3;
	var Drop3Flat;
	var DropSharp3Flat;
	var DropCut;
	var DropSharpCut;
	var DropRing;
	var DropRingFlat;
	var DropPear;
	var DropPear2;
	var Drop3Jitter;
	var DropBent;
	var DropBent2;
	var SharpBent;
	var Tetrahedron;
	var Pipe;
	var Pipe2;
	var Pipe3;
	var ShrinkDisk;
	var ShrinkDisk2;
	var DirectionIndicator;

	var Cube3x2 = 207;
	var Cube4x2;
	var Cube5x2;
	var Cube6x2;
	var Cube2x3;
	var Cube3x3;
	var Cube4x3;
	var Cube5x3;
	var Cube6x3;
	var Cube2x4;
	var Cube3x4;
	var Cube4x4;
	var Cube5x4;
	var Cube6x4;
	var Cube2x5;
	var Cube3x5;
	var Cube4x5;

	var Cube5x6deprecated;

	var Cube5x5 = 252;

	var Cube6x5 = 225;
	var Cube6x6;

	var Quad3x2;
	var Quad4x2;
	var Quad5x2;
	var Quad6x2;
	var Quad2x3;
	var Quad3x3;
	var Quad4x3;
	var Quad5x3;
	var Quad6x3;
	var Quad2x4;
	var Quad3x4;
	var Quad4x4;
	var Quad5x4;
	var Quad6x4;
	var Quad2x5;
	var Quad3x5;
	var Quad4x5;
	var Quad5x5;
	var Quad6x5;
	var Quad6x6;

	var Icosahedron;
	var Cubeoctahedron;
	var Dodecahedron;
	var Icosidodecahedron;
	var Octahedron;
}

enum abstract PartTypeVertCount(UInt) from UInt to UInt {
	var Cube = 8;
	var Pyramid = 5;
	var Sphere = 42;
	var Cone = 9;
	var Cylinder = 36;
	var Triangle = 5;
	var Trapeze = 8;
	var Hedra = 6;
	var Icosphere = 42;
	var LowpolySphere = 26;
	var Ramp = 8;
	var JitterCube = 226;
	var ChampferCube = 24;
	var Spike = 18;
	var LowpolyCylinder = 25;
	var HalfSphere = 49;
	var JitterSphere = 182;
	var BigDialog = 36;
	var QuarterPipe1 = 36;
	var QuarterPipe2 = 36;
	var QuarterPipe3 = 36;
	var QuarterPipe4 = 36;
	var QuarterPipe5 = 36;
	var QuarterPipe6 = 36;
	var QuarterTorus1 = 90;
	var QuarterTorus2 = 90;
	var QuarterTorus3 = 90;
	var QuarterTorus4 = 90;
	var QuarterTorus5 = 90;
	var QuarterTorus6 = 90;
	var CurvedRamp = 20;
	var CubeRotated = 8;
	var QuarterPipeRotated1 = 36;
	var QuarterPipeRotated2 = 36;
	var QuarterPipeRotated3 = 36;
	var QuarterPipeRotated4 = 36;
	var QuarterPipeRotated5 = 36;
	var QuarterPipeRotated6 = 36;
	var QuarterTorusRotated1 = 90;
	var QuarterTorusRotated2 = 90;
	var QuarterTorusRotated3 = 90;
	var QuarterTorusRotated4 = 90;
	var QuarterTorusRotated5 = 90;
	var QuarterTorusRotated6 = 90;
	var Hexagon = 14;
	var HexagonBevel = 20;
	var Ring1 = 192;
	var Ring2 = 192;
	var Ring3 = 192;
	var Ring4 = 192;
	var Ring5 = 192;
	var Ring6 = 192;
	var CubeBevel1 = 24;
	var CubeBevel2 = 24;
	var CubeBevel3 = 24;
	var Triangle2 = 8;
	var HalfCylinder = 26;
	var QuarterCylinder = 16;
	var QuarterSphere = 81;
	var SphereEdge = 44;
	var RoundCube = 266;
	var Capsule = 241;
	var Heptagon = 18;
	var Pentagon = 14;
	var Octagon = 20;
	var HipolySphere = 386;
	var Bowl1 = 290;
	var Bowl2 = 290;
	var Bowl3 = 290;
	var Bowl4 = 290;
	var Bowl5 = 290;
	var Bowl6 = 290;
	var BowlCube = 105;
	var QuarterBowlCube = 36;
	var CubeHole = 60;
	var HalfCubeHole = 35;
	var BowlCubeSoft = 105;
	var QuarterBowlCubeSoft = 36;
	var Bowl1Soft = 290;
	var QuarterSphereRotated = 81;
	var HalfBowlSoft = 161;
	var QuarterBowlSoft = 93;
	var Wheel = 96;
	var Wheel2 = 96;
	var Wheel3 = 96;
	var Wheel4 = 96;
	var WheelVariant = 96;
	var Wheel2Variant = 96;
	var JitterCubeSoft = 226;
	var JitterSphereSoft = 182;
	var LowJitterCube = 602;
	var LowJitterCubeSoft = 602;
	var JitterCone = 25;
	var JitterConeSoft = 25;
	var JitterHalfCone = 73;
	var JitterHalfConeSoft = 73;
	var JitterChamferCylinder = 96;
	var JitterChamferCylinderSoft = 96;
	var Gear = 128;
	var GearVariant = 64;
	var GearVariant2 = 32;
	var GearSoft = 128;
	var GearVariantSoft = 64;
	var GearVariant2Soft = 32;
	var Branch = 84;
	var Bubbles = 457;
	var HoleWall = 292;
	var JaggyWall = 162;
	var Rocky = 386;
	var RockySoft = 386;
	var RockyVerySoft = 386;
	var Spikes = 127;
	var SpikesSoft = 127;
	var SpikesVerySoft = 127;
	var WavyWall = 162;
	var WavyWallVariant = 36;
	var WavyWallVariantSoft = 36;
	var Quad = 4;
	var FineSphere = 4034;
	var Drop = 98;
	var Drop2 = 98;
	var Drop3 = 98;
	var DropSharp = 62;
	var DropSharp2 = 62;
	var DropSharp3 = 62;
	var Drop3Flat = 98;
	var DropSharp3Flat = 62;
	var DropCut = 73;
	var DropSharpCut = 37;
	var DropRing = 24;
	var DropRingFlat = 24;
	var DropPear = 98;
	var DropPear2 = 98;
	var Drop3Jitter = 98;
	var DropBent = 98;
	var DropBent2 = 98;
	var SharpBent = 82;
	var Tetrahedron = 4;
	var Pipe = 70;
	var Pipe2 = 70;
	var Pipe3 = 66;
	var ShrinkDisk = 32;
	var ShrinkDisk2 = 32;
	var DirectionIndicator = 16;

	var Cube3x2 = 12;
	var Cube4x2 = 16;
	var Cube5x2 = 20;
	var Cube6x2 = 24;
	var Cube2x3 = 12;
	var Cube3x3 = 18;
	var Cube4x3 = 24;
	var Cube5x3 = 30;
	var Cube6x3 = 36;
	var Cube2x4 = 16;
	var Cube3x4 = 24;
	var Cube4x4 = 32;
	var Cube5x4 = 40;
	var Cube6x4 = 48;
	var Cube2x5 = 24;
	var Cube3x5 = 36;
	var Cube4x5 = 48;
	var Cube5x5 = 60;
	var Cube6x5 = 60;
	var Cube6x6 = 72;
	var Quad3x2 = 6;
	var Quad4x2 = 8;
	var Quad5x2 = 10;
	var Quad6x2 = 12;
	var Quad2x3 = 6;
	var Quad3x3 = 9;
	var Quad4x3 = 12;
	var Quad5x3 = 15;
	var Quad6x3 = 18;
	var Quad2x4 = 8;
	var Quad3x4 = 12;
	var Quad4x4 = 16;
	var Quad5x4 = 20;
	var Quad6x4 = 24;
	var Quad2x5 = 10;
	var Quad3x5 = 15;
	var Quad4x5 = 20;
	var Quad5x5 = 25;
	var Quad6x5 = 30;
	var Quad6x6 = 36;

	var Icosahedron = 12;
	var Cubeoctahedron = 12;
	var Dodecahedron = 20;
	var Icosidodecahedron = 30;
	var Octahedron = 6;

	public static function fromPartType(ptype:ThingPartBase):PartTypeVertCount {
		/*
			switch (ptype) {
				case ThingPartBase.Cube:
					return Cube;
				case ThingPartBase.Pyramid: 
					return Pyramid;
				case ThingPartBase.Sphere:
					return Sphere;
				case ThingPartBase.Cone: 
					return Cone;
				case ThingPartBase.Cylinder:
					return Cylinder;
				case ThingPartBase.Triangle:
					return Triangle;
				case ThingPartBase.Trapeze: 
					return Trapeze;
				case ThingPartBase.Hedra: 
					return Hedra;
				case ThingPartBase.Icosphere:
					return Icosphere;
				case ThingPartBase.LowpolySphere:
					return LowpolySphere;
				case ThingPartBase.Ramp: 
					return Ramp;
				case ThingPartBase.JitterCube:
					return JitterCube;
				case ThingPartBase.ChampferCube:
					return ChampferCube;
				case ThingPartBase.Spike: 
					return Spike;
				case ThingPartBase.LowpolyCylinder:
					return LowpolyCylinder;
				case ThingPartBase.HalfSphere: 
					return HalfSphere;
				case ThingPartBase.JitterSphere: 
					return JitterSphere;
				case ThingPartBase.BigDialog: 
					return BigDialog;
				case ThingPartBase.QuarterPipe1: 
					return QuarterPipe1;
				case ThingPartBase.QuarterPipe2: 
					return QuarterPipe2;
				case ThingPartBase.QuarterPipe3:
					return QuarterPipe3;
				case ThingPartBase.QuarterPipe4:
					return QuarterPipe4;
				case ThingPartBase.QuarterPipe5:
					return QuarterPipe5;
				case ThingPartBase.QuarterPipe6:
					return QuarterPipe6;
				case ThingPartBase.QuarterTorus1: 
					return QuarterTorus1;
				case ThingPartBase.QuarterTorus2: 
					return QuarterTorus2;
				case ThingPartBase.QuarterTorus3:
					return QuarterTorus3;
				case ThingPartBase.QuarterTorus4:
					return QuarterTorus4;
				case ThingPartBase.QuarterTorus5:
					return QuarterTorus5;
				case ThingPartBase.QuarterTorus6:
					return QuarterTorus6;
				case ThingPartBase.CurvedRamp: 
					return CurvedRamp;
				case ThingPartBase.CubeRotated: 
					return CubeRotated;
				case ThingPartBase.QuarterPipeRotated1: 
					return QuarterPipeRotated1;
				case ThingPartBase.QuarterPipeRotated2: 
					return QuarterPipeRotated2;
				case ThingPartBase.QuarterPipeRotated3:
					return QuarterPipeRotated3;
				case ThingPartBase.QuarterPipeRotated4:
					return QuarterPipeRotated4;
				case ThingPartBase.QuarterPipeRotated5:
					return QuarterPipeRotated5;
				case ThingPartBase.QuarterPipeRotated6:
					return QuarterPipeRotated6;
				case ThingPartBase.QuarterTorusRotated1:
					return QuarterTorusRotated1;
				case ThingPartBase.QuarterTorusRotated2:
					return QuarterTorusRotated2;
				case ThingPartBase.QuarterTorusRotated3:
					return QuarterTorusRotated3;
				case ThingPartBase.QuarterTorusRotated4:
					return QuarterTorusRotated4;
				case ThingPartBase.QuarterTorusRotated5:
					return QuarterTorusRotated5;
				case ThingPartBase.QuarterTorusRotated6:
					return QuarterTorusRotated6;
				case ThingPartBase.Hexagon: 
					return Hexagon;
				case ThingPartBase.HexagonBevel: 
					return HexagonBevel;
				case ThingPartBase.Ring1: 
					return Ring1;
				case ThingPartBase.Ring2:
					return Ring2;
				case ThingPartBase.Ring3:
					return Ring3;
				case ThingPartBase.Ring4:
					return Ring4;
				case ThingPartBase.Ring5:
					return Ring5;
				case ThingPartBase.Ring6:
					return Ring6;
				case ThingPartBase.CubeBevel1: 
					return CubeBevel1;
				case ThingPartBase.CubeBevel2:
					return CubeBevel2;
				case ThingPartBase.CubeBevel3:
					return CubeBevel3;
				case ThingPartBase.Triangle2: 
					return Triangle2;
				case ThingPartBase.HalfCylinder:
					return HalfCylinder;
				case ThingPartBase.QuarterCylinder: 
					return QuarterCylinder;
				case ThingPartBase.QuarterSphere: 
					return QuarterSphere;
				case ThingPartBase.SphereEdge: 
					return SphereEdge;
				case ThingPartBase.RoundCube: 
					return RoundCube;
				case ThingPartBase.Capsule: 
					return Capsule;
				case ThingPartBase.Heptagon: 
					return Heptagon;
				case ThingPartBase.Pentagon: 
					return Pentagon;
				case ThingPartBase.Octagon: 
					return Octagon;
				case ThingPartBase.Highpolysphere: 
					return HipolySphere;
				case ThingPartBase.Bowl1: 
					return Bowl1;
				case ThingPartBase.Bowl2:
					return Bowl2;
				case ThingPartBase.Bowl3:
					return Bowl3;
				case ThingPartBase.Bowl4:
					return Bowl4;
				case ThingPartBase.Bowl5:
					return Bowl5;
				case ThingPartBase.Bowl6:
					return Bowl6;
				case ThingPartBase.BowlCube: 
					return BowlCube;
				case ThingPartBase.QuarterBowlCube: 
					return QuarterBowlCube;
				case ThingPartBase.CubeHole: 
					return CubeHole;
				case ThingPartBase.HalfCubeHole: 
					return HalfCubeHole;
				case ThingPartBase.BowlCubeSoft: 
					return BowlCubeSoft;
				case ThingPartBase.QuarterBowlCubeSoft: 
					return QuarterBowlCubeSoft;
				case ThingPartBase.Bowl1Soft: 
					return Bowl1Soft;
				case ThingPartBase.QuarterSphereRotated: 
					return QuarterSphereRotated;
				case ThingPartBase.HalfBowlSoft: 
					return HalfBowlSoft;
				case ThingPartBase.QuarterBowlSoft: 
					return QuarterBowlSoft;
				case ThingPartBase.Wheel: 
					return Wheel;
				case ThingPartBase.Wheel2: 
					return Wheel2;
				case ThingPartBase.Wheel3: 
					return Wheel3;
				case ThingPartBase.Wheel4:
					return Wheel4;
				case ThingPartBase.WheelVariant: 
					return WheelVariant;
				case ThingPartBase.Wheel2Variant: 
					return Wheel2Variant;
				case ThingPartBase.JitterCubeSoft: 
					return JitterCubeSoft;
				case ThingPartBase.JitterSphereSoft: 
					return JitterSphereSoft;
				case ThingPartBase.LowJitterCube: 
					return LowJitterCube;
				case ThingPartBase.LowJitterCubeSoft: 
					return LowJitterCubeSoft;
				case ThingPartBase.JitterCone: 
					return JitterCone;
				case ThingPartBase.JitterConeSoft: 
					return JitterConeSoft;
				case ThingPartBase.JitterHalfCone:
					return JitterHalfCone;
				case ThingPartBase.JitterHalfConeSoft:
					return JitterHalfConeSoft;
				case ThingPartBase.JitterChamferCylinder: 
					return JitterChamferCylinder;
				case ThingPartBase.JitterChamferCylinderSoft: 
					return JitterChamferCylinderSoft;
				case ThingPartBase.Gear: 
					return Gear;
				case ThingPartBase.GearVariant: 
					return GearVariant;
				case ThingPartBase.GearVariant2: 
					return GearVariant2;
				case ThingPartBase.GearSoft: 
					return GearSoft;
				case ThingPartBase.GearVariantSoft: 
					return GearVariantSoft;
				case ThingPartBase.GearVariant2Soft: 
					return GearVariant2Soft;
				case ThingPartBase.Branch: 
					return Branch;
				case ThingPartBase.Bubbles: 
					return Bubbles;
				case ThingPartBase.HoleWall: 
					return HoleWall;
				case ThingPartBase.JaggyWall: 
					return JaggyWall;
				case ThingPartBase.Rocky: 
					return Rocky;
				case ThingPartBase.RockySoft: 
					return RockySoft;
				case ThingPartBase.RockyVerySoft: 
					return RockyVerySoft;
				case ThingPartBase.Spikes: 
					return Spikes;
				case ThingPartBase.SpikesSoft: 
					return SpikesSoft;
				case ThingPartBase.SpikesVerySoft:
					return SpikesVerySoft;
				case ThingPartBase.WavyWall: 
					return WavyWall;
				case ThingPartBase.WavyWallVariant: 
					return WavyWallVariant;
				case ThingPartBase.WavyWallVariantSoft: 
					return WavyWallVariantSoft;
				case ThingPartBase.Quad: 
					return Quad;
				case ThingPartBase.FineSphere: 
					return FineSphere;
				case ThingPartBase.Drop: 
					return Drop;
				case ThingPartBase.Drop2: 
					return Drop2;
				case ThingPartBase.Drop3:
					return Drop3;
				case ThingPartBase.DropSharp: 
					return DropSharp;
				case ThingPartBase.DropSharp2: 
					return DropSharp2;
				case ThingPartBase.DropSharp3:
					return DropSharp3;
				case ThingPartBase.Drop3Flat: 
					return Drop3Flat;
				case ThingPartBase.DropSharp3Flat:
					return DropSharp3Flat;
				case ThingPartBase.DropCut: 
					return DropCut;
				case ThingPartBase.DropSharpCut: 
					return DropSharpCut;
				case ThingPartBase.DropRing: 
					return DropRing;
				case ThingPartBase.DropRingFlat: 
					return DropRingFlat;
				case ThingPartBase.DropPear: 
					return DropPear;
				case ThingPartBase.DropPear2: 
					return DropPear2;
				case ThingPartBase.Drop3Jitter: 
					return Drop3Jitter;
				case ThingPartBase.DropBent: 
					return DropBent;
				case ThingPartBase.DropBent2: 
					return DropBent2;
				case ThingPartBase.SharpBent: 
					return SharpBent;
				case ThingPartBase.Tetrahedron: 
					return Tetrahedron;
				case ThingPartBase.Pipe: 
					return Pipe;
				case ThingPartBase.Pipe2:
					return Pipe2;
				case ThingPartBase.Pipe3:
					return Pipe3;
				case ThingPartBase.ShrinkDisk: 
					return ShrinkDisk;
				case ThingPartBase.ShrinkDisk2: 
					return ShrinkDisk2;
				case ThingPartBase.DirectionIndicator: 
					return DirectionIndicator;
				case ThingPartBase.Cube3x2: 
					return Cube3x2;
				case ThingPartBase.Cube4x2: 
					return Cube4x2;
				case ThingPartBase.Cube5x2: 
					return Cube5x2;
				case ThingPartBase.Cube6x2:
					return Cube6x2;
				case ThingPartBase.Cube2x3:
					return Cube2x3;
				case ThingPartBase.Cube3x3:
					return Cube3x3;
				case ThingPartBase.Cube4x3:
					return Cube4x3;
				case ThingPartBase.Cube5x3:
					return Cube5x3;
				case ThingPartBase.Cube6x3:
					return Cube6x3;
				case ThingPartBase.Cube2x4:
					return Cube2x4;
				case ThingPartBase.Cube3x4:
					return Cube3x4;
				case ThingPartBase.Cube4x4:
					return Cube4x4;
				case ThingPartBase.Cube5x4:
					return Cube5x4;
				case ThingPartBase.Cube6x4:
					return Cube6x4;
				case ThingPartBase.Cube2x5:
					return Cube2x5;
				case ThingPartBase.Cube3x5:
					return Cube3x5;
				case ThingPartBase.Cube4x5:
					return Cube4x5;
				case ThingPartBase.Cube5x5 | ThingPartBase.Cube5x6deprecated:
					return Cube5x5;
				case ThingPartBase.Cube6x5:
					return Cube6x5;
				case ThingPartBase.Cube6x6:
					return Cube6x6;
				case ThingPartBase.Icosahedron:
					return Icosahedron;
				case ThingPartBase.Cubeoctahedron: 
					return Cubeoctahedron;
				case ThingPartBase.Dodecahedron: 
					return Dodecahedron;
				case ThingPartBase.Icosidodecahedron: 
					return Icosidodecahedron;
				case ThingPartBase.Octahedron: 
					return Octahedron;
				default: 
					return 0;
				
			}
			return 0;
		 */

		if (ptype == ThingPartBase.Cube5x5) {
			ptype = ThingPartBase.Cube5x6deprecated;
		}
		if (FileSystem.exists("./res/BaseShapes/" + cast ptype + ".obj")) {
			return Mesh.fromObj(File.getContent("./res/BaseShapes/" + cast ptype + ".obj"), false).positions.length;
		}
		return 0;
	}
}
