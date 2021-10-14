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
@:build(thinghandler.AbstractHelper.buildMap())
abstract TexturePropertyMap<T>(Map<TextureProperty, T>) from Map<TextureProperty, T> to Map<TextureProperty, T> {
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
}