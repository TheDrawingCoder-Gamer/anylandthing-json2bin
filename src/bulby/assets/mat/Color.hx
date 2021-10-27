package bulby.assets.mat;

import bulby.BulbyMath;
@:build(bulby.macro.Macro.buildForwardFields())
@:build(bulby.macro.Macro.buildProduceNewInstFromVar())
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

	@:createinstonread(bulby.assets.mat.Color, 1, 1, 1)
	public static var white:Color;
}