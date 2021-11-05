package thinghandler;

enum abstract TextureTypes(UInt) from UInt to UInt {
    var None = 0;
    // Noise
    var Gradient = 2;
    var Geometry_Gradient = 161;
    var WoodGrain = 3;
    var VoronoiPolys;
    var WavyLines;
    var VoronoiDots;
    var PerlinNoise1;
    var QuasiCrystal;
        var PlasmaNoise = 12;
        var Pool;
        var Bio;
        var FractalNoise;
        var LightSquares;
        var Machine;
        var SweptNoise;
        var Abstract;
        var Dashes;
        var LayeredNoise;
        var SquareRegress;
        var Swirly;

        var SideGlow = 10;

        var Ground_Spotty = 24;
        var Ground_SpottyBumpMap;
        var Ground_LineBumpMap;
    var Ground_SplitBumpMap;
    var Ground_Wet;
        var Ground_Rocky;
        var Ground_RockyBumpMap;
    var Ground_Broken;
    var Ground_BrokenBumpMap;
    var Ground_Pebbles;
    var Ground_PebblesBumpMap;
        var Ground_1BumpMap;
        var Misc_IceSoft = 11;
        var Misc_CrackedIce = 36;
        var Misc_CrackedGround;
        var Misc_LinesPattern;
        var Misc_StoneGround;
        var Misc_Lava;
        var Misc_LavaBumpMap;
    var Misc_StraightIce;
    var Misc_CrackedIce2;
    var Misc_Shades;
    var Misc_Cork;
    var Misc_Wool;
    var Misc_Salad;
    var Misc_CrossLines;
    var Misc_Holes;
    var Misc_Waves;
    var Misc_WavesBumpMap;
    var Misc_1 = 155;
    var Misc_1BumpMap = 52;
    var Misc_2;
    var Misc_2BumpMap;
    var Misc_3;
    var Misc_3BumpMap;
    var Misc_SoftNoise;
    var Misc_SoftNoiseBumpMap;
    var Misc_SoftNoiseBumpMapVariant = 157;
    var Misc_Stars = 59;
    var Misc_StarsBumpMap;
    var Misc_CottonBalls;
    var Misc_4;
    var Misc_4BumpMap;
    var Misc_5;
    var Misc_5BumpMap;
    // The point where I give up and copy paste from it with edit
    var Misc_Glass              = 66;
    
	var Geometry_Circle_1               = 67;
	var Geometry_Circle_2               = 68;
	var Geometry_Circle_3               = 69;
	var Geometry_Half                   = 70;
	var Geometry_TiltedHalf             = 71;
	var Geometry_Pyramid                = 72;
	var Geometry_Dots                   = 73;
    var Geometry_MultiGradient          = 74;
    var Geometry_Wave                   = 75;
	var Geometry_Checkerboard           = 76;
	var Geometry_CheckerboardBumpMap    = 77;
    var Geometry_Lines                  = 78;
    var Geometry_LinesBumpMap           = 79;
	var Geometry_DoubleGradient         = 80;
    var Geometry_Rectangles             = 81;
    var Geometry_RectanglesBumpMap      = 82;
	var Geometry_Border_1               = 156;
	var Geometry_Border_2               = 83;
	var Geometry_Border_3               = 84;
	var Geometry_Border_4               = 85;
	var Geometry_Border_2BumpMap        = 86;
	var Geometry_Circle_2BumpMap        = 87;
    var Geometry_Lines2                 = 88;
    var Geometry_Lines2Blurred          = 89;
    var Geometry_RoundBorder            = 90;
    var Geometry_RoundBorder2           = 91;
    var Geometry_RoundBorderBumpMap     = 92;
    var Geometry_Line_1                 = 93;
    var Geometry_Line_2                 = 94;
    var Geometry_Line_3                 = 95;
    var Geometry_Line_2BumpMap          = 96;
    var Geometry_Octagon_1              = 97;
    var Geometry_Octagon_2              = 98;
    var Geometry_Octagon_3              = 99;
    var Geometry_Hexagon                = 100;
    var Geometry_Hexagon2               = 101;
    var Geometry_Hexagon2BumpMap        = 102;
    
	var Metal_1     = 103;
    var Metal_2     = 104;
    var Metal_Wet   = 105;
    
    var Marble_1    = 106;
    var Marble_2    = 107;
    var Marble_3    = 108;

    var Tree_1BumpMap   = 109;
    var Tree_2          = 110;
    var Tree_3          = 111;
    var Tree_4          = 112;

    var Grass_4         = 113;
    var Grass_4BumpMap  = 114;
    var Grass_3         = 115;
    var Grass_3BumpMap  = 116;
    var Grass_2         = 117;
	var Grass_1         = 119;
	var Grass_1BumpMap  = 120;
	var Grass_2BumpMap  = 118;
	var Grass_5         = 121;
	var Grass_5BumpMap  = 122;
	var Grass_6BumpMap  = 123;
	
	var Wall_1                      = 124;
	var Wall_1BumpMap               = 125;
    var Wall_2                      = 126;
    var Wall_2BumpMap               = 127;
	var Wall_3BumpMap               = 128;
    var Wall_Rocky                  = 129;
    var Wall_RockyBumpMap           = 130;
    var Wall_Freckles               = 131;
    var Wall_FrecklesBumpMap        = 132;
    var Wall_Freckles2              = 133;
    var Wall_Freckles2BumpMap       = 134;
    var Wall_Scratches              = 135;
    var Wall_ScratchesBumpMap       = 136;
    var Wall_Mossy                  = 137;
    var Wall_MossyBumpMap           = 138;
    var Wall_Wavy                   = 139;
    var Wall_WavyBumpMap            = 140;
	var Wall_Lines                  = 141;
	var Wall_LinesBumpMap           = 142;
    var Wall_Lines2                 = 143;
    var Wall_Lines2BumpMap          = 144;
    var Wall_Lines3                 = 145;
    var Wall_Lines3BumpMap          = 146;
    var Wall_ScratchyLines          = 147;
    var Wall_ScratchyLinesBumpMap   = 148;

    var Cloth_1         = 149;
    var Cloth_2         = 150;
    var Cloth_2BumpMap  = 151;
    var Cloth_3         = 152;
    var Cloth_4         = 153;
    var Cloth_4BumpMap  = 154;
    
    var Geometry_RadialGradient = 158;
    var Geometry_MoreLines      = 159;
    var Geometry_MoreRectangles = 160;
    
    var Filled = 162;
    
    var Vertex_Scatter = 163;
    var Vertex_Expand  = 165;
    var Vertex_Slice   = 166;
    
    var Wireframe = 167;
    var Outline = 168;

    public static function isProcedural(tex:TextureTypes) {
        switch (tex) {
            case TextureTypes.Gradient
            | TextureTypes.PerlinNoise1
            | QuasiCrystal
            | VoronoiDots
            | VoronoiPolys
            | WavyLines
            | WoodGrain
            | PlasmaNoise
            | Pool
            | Bio
            | FractalNoise
            | LightSquares
            | Machine
            | SweptNoise 
            | Abstract
            | Dashes
            | LayeredNoise
            | SquareRegress
            | Swirly: 
                return true;
            default: 
                return false; 
        }
    } 
}