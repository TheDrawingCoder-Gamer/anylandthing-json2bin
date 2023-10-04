package thinghandler;

enum abstract TextureProperty(UInt) from UInt to UInt {
	var ScaleY;
	var ScaleX;
	var Strength;
	var Rotation;
	var OffsetY;
	var OffsetX;
	var Glow;
	var Param1;
	var Param2;
	var Param3;
}

@:forward
@:build(bulby.macro.Macro.buildMap())
@:publish
abstract TexturePropertyMap<T>(Map<TextureProperty, T>) to Map<TextureProperty, T> {
	@:key(ScaleY)
	var scaleY:T;
	@:key(ScaleX)
	var scaleX:T;
	@:key(Strength)
	var strength:T;
	@:key(Rotation)
	var rotation:T;
	@:key(OffsetY)
	var offsetY:T;
	@:key(OffsetX)
	var offsetX:T;
	@:key(Glow)
	var glow:T;
	@:key(Param1)
	var param1:T;
	@:key(Param2)
	var param2:T;
	@:key(Param3)
	var param3:T;

	static function getDefaultMap():Map<TextureProperty, Float> {
		return [
			ScaleX => 0.5, ScaleY => 0.5, OffsetX => 0, OffsetY => 0, Strength => 0.5, Rotation => 0, Glow => 0, Param1 => 0.5, Param2 => 0.5, Param3 => 0.5
		];
	}

	function new(map:Map<TextureProperty, T>) {
		this = map;
	}

	@:from
	private static function fromMap(map:Map<TextureProperty, Null<Float>>):TexturePropertyMap<Float> {
		var result = getDefaultMap();
		for (property => value in map) {
			if (value != null)
				result.set(property, value);
		}
		return new TexturePropertyMap<Float>(result);
	}
}
