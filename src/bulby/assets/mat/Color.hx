package bulby.assets.mat;

import bulby.BulbyMath;

using StringTools;
/**
 * An Color Int represented in ARGB format
 */
@:build(bulby.macro.Macro.buildProduceNewInstFromVar())
@:publish 
abstract Color(Int) {
	public var r(get, set):Int;
	public function new(r:Int, g:Int, b:Int, a:Int = 255) {
		this = (a << 24) | (r << 16) | (g << 8) | b;
	}
	public static function fromFloat(r:Float, g:Float, b:Float, a:Float = 1) {
		return new Color(Std.int(r * 255), Std.int(g * 255), Std.int(b * 255), Std.int(a * 255));
	}
	@:from
	static function fromVector4(vector4:Vector4) {
		return fromFloat(vector4.x, vector4.y, vector4.z, vector4.w);
	}
	@:to
	function asVector4() {
		return new Vector4(r / 255, g / 255, b / 255, a / 255);
	}

	@:to
	public inline function asARGB():Int {
		return this;
	}
	public function asBGRA():Int {
		return (b << 24) | (g << 16) | (r << 8) | a;
	}
	public function asRGBA():Int {
		return (r << 24) | (g << 16) | (b << 8) | a;
	}
	@:from
	public static inline function fromARGB(argb:Int) {
		return new Color((argb >> 16) & 0xFF, (argb >> 8) & 0xFF, argb & 0xFF, (argb >> 24) & 0xFF);
	}
	public static function fromBGRA(bgra:Int) {
		return new Color((bgra >> 8) & 0xFF, (bgra >> 16) & 0xFF, (bgra >> 24) & 0xFF, (bgra) & 0xFF);
	}
	public static function fromRGBA(rgba:Int) {
		return new Color((rgba >> 24) & 0xFF, (rgba >> 16) & 0xFF, (rgba >> 8) & 0xFF, (rgba) & 0xFF);
	}
	private inline function get_r():Int {
		return this >> 16 & 0xFF;
	}
	// Copilot it's ARGB
	private inline function set_r(r:Int) {
		return this = (this & 0xFF00FFFF) | (r << 16);
	}

	public var g(get, set):Int;
	private inline function get_g():Int {
		return this >> 8 & 0xFF;
	}
	private inline function set_g(g:Int) {
		return this = (this & 0xFFFF00FF) | (g << 8);
	}

	public var b(get, set):Int;
	private inline function get_b():Int {
		return this & 0xFF;
	}
	private inline function set_b(b:Int) {
		return this = (this & 0xFFFFFF00) | b;
	}

	public var a(get, set):Int;
	private inline function get_a():Int {
		return this >> 24 & 0xFF;
	}
	private inline function set_a(a:Int) {
		return this = (this & 0x00FFFFFF) | (a << 24);
	}
	var rfloat(get, set):Float;
	private inline function get_rfloat():Float {
		return r / 255;
	}
	private inline function set_rfloat(r:Float) {
		return this = (this & 0x00FFFFFF) | (Std.int(r * 255) << 16);
	}
	var gfloat(get, set):Float;
	private inline function get_gfloat():Float {
		return g / 255;
	}
	private inline function set_gfloat(g:Float) {
		return this = (this & 0xFFFF00FF) | (Std.int(g * 255) << 8);
	}
	var bfloat(get, set):Float;
	private inline function get_bfloat():Float {
		return b / 255;
	}
	private inline function set_bfloat(b:Float) {
		return this = (this & 0xFFFFFF00) | Std.int(b * 255);
	}
	var afloat(get, set):Float;
	private inline function get_afloat():Float {
		return a / 255;
	}
	private inline function set_afloat(a:Float) {
		return this = (this & 0xFF00FFFF) | (Std.int(a * 255) << 24);
	}
	// backwards compatibility
	@:from
	static function fromArrayFloat(arr:Array<Float>) {
		if (arr.length != 3 && arr.length != 4) {
			throw "Array must have 3 or 4 elements";
		}
		if (arr.length == 3)
			arr.push(1);
		return Color.fromFloat(arr[0], arr[1], arr[2], arr[3]);
	}
	public static function blend(bottom:Color, top:Color):Color {
		var top_a = top.a / 255;
		var bottom_a = bottom.a / 255;
		var top_r_a = (top.r / 255) * top_a;
		var top_g_a = (top.g / 255) * top_a;
		var top_b_a = (top.b / 255) * top_a;
		var bottom_r_a = (bottom.r / 255) * bottom_a;
		var bottom_g_a = (bottom.g / 255) * bottom_a;
		var bottom_b_a = (bottom.b / 255) * bottom_a;
		var alpha_final = (bottom_a + top_a - bottom_a * top_a);
		
		return new Color(blend_internal(top_r_a, bottom_r_a, top_a, bottom_a, alpha_final), blend_internal(top_g_a, bottom_g_a, top_a, bottom_a, alpha_final), blend_internal(top_b_a, bottom_b_a, top_a, bottom_a, alpha_final), Std.int(alpha_final * 255));
	}
	inline function hex():String {
		return "#" + this.hex(8);
	}
	inline function invert() {
		return new Color(255 - r, 255 - g, 255 - b, a);
	}
	@:op(A * B)
	function times(other:Color) {
		var v1 = asVector4();
		var v2 = other.asVector4();
		var v3 = new Vector4(v1.x * v2.x, v1.y * v2.y, v1.z * v2.z, v1.w * v2.w);
		return Color.fromVector4(v3);
	}
	private static function blend_internal(top_c_a:Float, bottom_c_a:Float, top_a:Float, bottom_a:Float, alpha_final:Float) {

		return Std.int(255 * ((top_c_a + bottom_c_a * (1 - top_a)) / alpha_final));
	}
	public static var white:Color = 0xFFFFFFFF;
}

