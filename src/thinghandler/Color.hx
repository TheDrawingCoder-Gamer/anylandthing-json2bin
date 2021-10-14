package thinghandler;

import thinghandler.Thing.Triplet;
@:build(thinghandler.AbstractHelper.buildForwardFields())
@:build(thinghandler.AbstractHelper.buildProduceNewInstFromVar())
abstract Color(Triplet<Float>) from Triplet<Float> to Triplet<Float> {
	@:forwardfield(x)
	public var r:Float;
	@:forwardfield(y)
	public var g:Float;
	@:forwardfield(z)
	public var b:Float;

	public function new(r:Float, g:Float, b:Float) {
		this = {x: r, y: g, z: b};
	}

	@:createinstonread(thinghandler.Color, 1, 1, 1)
	public static var white:Color;
}