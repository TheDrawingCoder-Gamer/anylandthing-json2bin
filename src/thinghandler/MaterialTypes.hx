package thinghandler;

enum abstract MaterialTypes(UInt) from UInt to UInt {
	var None = 0;
	var Metallic;
	var Glow;
	var PointLight;
	var SpotLight;
	var Particles;
	var ParticlesBig;
	var Transparent;
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

	// me when github copilot writes my code for me : )
	@:to inline function toString() {
		switch (this) {
			case MaterialTypes.None:
				return "None";
			case MaterialTypes.Metallic:
				return "Metallic";
			case MaterialTypes.Glow:
				return "Glow";
			case MaterialTypes.PointLight:
				return "PointLight";
			case MaterialTypes.SpotLight:
				return "SpotLight";
			case MaterialTypes.Particles:
				return "Particles";
			case MaterialTypes.ParticlesBig:
				return "ParticlesBig";
			case MaterialTypes.Transparent:
				return "Transparent";
			case MaterialTypes.InvisibleWhenDone:
				return "InvisibleWhenDone";
			case MaterialTypes.Plastic:
				return "Plastic";
			case MaterialTypes.Unshiny:
				return "Unshiny";
			case MaterialTypes.VeryMetallic:
				return "VeryMetallic";
			case MaterialTypes.DarkMetallic:
				return "DarkMetallic";
			case MaterialTypes.BrightMetallic:
				return "BrightMetallic";
			case MaterialTypes.TransparentGlossy:
				return "TransparentGlossy";
			case MaterialTypes.TransparentGlossyMetallic:
				return "TransparentGlossyMetallic";
			case MaterialTypes.VeryTransparent:
				return "VeryTransparent";
			case MaterialTypes.VeryTransparentGlossy:
				return "VeryTransparentGlossy";
			case MaterialTypes.SlightyTransparent:
				return "SlightyTransparent";
			case MaterialTypes.Unshaded:
				return "Unshaded";
			case MaterialTypes.Inversion:
				return "Inversion";
			case MaterialTypes.Brightness:
				return "Brightness";
			case MaterialTypes.TransparentTexture:
				return "TransparentTexture";
			case MaterialTypes.TransparentGlowTexture:
				return "TransparentGlowTexture";
			default:
				return "Unknown";
		}
	}

	public inline function alpha() {
		switch (this) {
			case MaterialTypes.Transparent | MaterialTypes.TransparentGlossy | TransparentGlossyMetallic:
				return 0.5;
			case MaterialTypes.SlightyTransparent:
				return 0.82;
			case VeryTransparent | VeryTransparentGlossy:
				return 0.2;
			default:
				return 1;
		}
	}

	public inline function illum() {
		switch (this) {
			case Unshaded:
				return 1;
			default:
				return 2;
		}
	}
}
