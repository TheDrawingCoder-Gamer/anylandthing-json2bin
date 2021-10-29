package bulby.assets.mat;

import haxe.Int64;
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
@:build(bulby.macro.Macro.buildForwardFields())
@:build(bulby.macro.Macro.buildProduceNewInstFromVar())
abstract RGBA(Vector4) from Vector4 to Vector4 {
	@:forwardfield(x)
	public var r:Float;
	@:forwardfield(y)
	public var g:Float;
	@:forwardfield(z)
	public var b:Float;
	@:forwardfield(w)
	public var a:Float;

	public function new(r:Float, g:Float, b:Float, a:Float) {
		this = new Vector4(r, g, b, a);
	}
	public function blend(other:RGBA) {
		var a0 = other.a + (1 - other.a) * a;
		return new RGBA(blend_internal(other.r, r, other.a, a, a0), blend_internal(other.g, g, other.a, a, a0), blend_internal(other.b, b, other.a, a, a0), a0);
	}
	private function blend_internal(colortop:Float, colorbottom:Float, alphatop:Float, alphabottom:Float, a0:Float) {
		return (colortop + colorbottom * (1 - alphatop));
	}
	@:createinstonread(bulby.assets.mat.RGBA, 1, 1, 1, 1)
	public static var white:RGBA;
}
/**
 * An Color Int represented in ARGB format
 */
abstract ARGB255(Int) from Int{
	public var r(get, set):Int;
	public function new(r:Int, g:Int, b:Int, a:Int) {
		this = (a << 24) | (r << 16) | (g << 8) | b;
	}
	public function asARGB():Int {
		return this;
	}
	public function asBGRA():Int {
		return (b << 24) | (g << 16) | (r << 8) | a;
	}
	public function asRGBA():Int {
		return (r << 24) | (g << 16) | (b << 8) | a;
	}
	public static function fromARGB(argb:Int) {
		return new ARGB255((argb >> 16) & 0xFF, (argb >> 8) & 0xFF, argb & 0xFF, (argb >> 24) & 0xFF);
	}
	public static function fromBGRA(bgra:Int) {
		return new ARGB255((bgra >> 8) & 0xFF, (bgra >> 16) & 0xFF, (bgra >> 24) & 0xFF, (bgra) & 0xFF);
	}
	public static function fromRGBA(rgba:Int) {
		return new ARGB255((rgba >> 24) & 0xFF, (rgba >> 16) & 0xFF, (rgba >> 8) & 0xFF, (rgba) & 0xFF);
	}
	private function get_r():Int {
		return this >> 16 & 0xFF;
	}
	// Copilot it's ARGB
	private inline function set_r(r:Int) {
		return this = (this & 0xFF00FFFF) | (r << 16);
	}

	public var g(get, set):Int;
	private function get_g():Int {
		return this >> 8 & 0xFF;
	}
	private inline function set_g(g:Int) {
		return this = (this & 0xFFFF00FF) | (g << 8);
	}

	public var b(get, set):Int;
	private function get_b():Int {
		return this & 0xFF;
	}
	private inline function set_b(b:Int) {
		return this = (this & 0xFFFFFF00) | b;
	}

	public var a(get, set):Int;
	private function get_a():Int {
		return this >> 24 & 0xFF;
	}
	private inline function set_a(a:Int) {
		return this = (this & 0x00FFFFFF) | (a << 24);
	}

	public static function blend(bottom:ARGB255, top:ARGB255):ARGB255 {
		var top_a = top.a / 255;
		var bottom_a = bottom.a / 255;
		var top_r_a = (top.r / 255) * top_a;
		var top_g_a = (top.g / 255) * top_a;
		var top_b_a = (top.b / 255) * top_a;
		var bottom_r_a = (bottom.r / 255) * bottom_a;
		var bottom_g_a = (bottom.g / 255) * bottom_a;
		var bottom_b_a = (bottom.b / 255) * bottom_a;
		var alpha_final = (bottom_a + top_a - bottom_a * top_a);
		
		return new ARGB255(blend_internal(top_r_a, bottom_r_a, top_a, bottom_a, alpha_final), blend_internal(top_g_a, bottom_g_a, top_a, bottom_a, alpha_final), blend_internal(top_b_a, bottom_b_a, top_a, bottom_a, alpha_final), Std.int(alpha_final * 255));
	}
	private static function blend_internal(top_c_a:Float, bottom_c_a:Float, top_a:Float, bottom_a:Float, alpha_final:Float) {

		return Std.int(255 * ((top_c_a + bottom_c_a * (1 - top_a)) / alpha_final));
	}
}

