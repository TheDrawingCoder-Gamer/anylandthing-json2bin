package thinghandler;
import objhandler.Vector3;
@:build(thinghandler.AbstractHelper.buildForwardFields())
@:build(thinghandler.AbstractHelper.buildProduceNewInstFromVar())
abstract Color(Vector3) from Vector3 to Vector3 {
	@:forwardfield(x)
	public var r:Float;
	@:forwardfield(y)
	public var g:Float;
	@:forwardfield(z)
	public var b:Float;

	public function new(r:Float, g:Float, b:Float) {
		this = new Vector3(r, g, b);
	}

	@:createinstonread(thinghandler.Color, 1, 1, 1)
	public static var white:Color;
}