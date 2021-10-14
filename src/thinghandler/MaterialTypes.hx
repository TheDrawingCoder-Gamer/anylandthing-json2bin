package thinghandler;

enum abstract MaterialTypes(UInt) from UInt to UInt{
    var None = 0;
    var Metallic;
    var Glow;
    var PointLight;
    var SpotLight;
    var Particles;
    var ParticlesBig;
    var Transparent;
    @:deprecated
    var InvisibleWhenDone;
    var Plastic;
    var Unshiny;
    var VeryMetallic;
    var DarkMetallic;
    var BrightMetallic;
    var TransparentGlossy;
    var TransparentGlossyMetallic;
    var VeryTransparent;
    var VeryTransparentGlossy;
    var SlightyTransparent;
    var Unshaded;
    var Inversion;
    var Brightness;
    var TransparentTexture;
    var TransparentGlowTexture;
}