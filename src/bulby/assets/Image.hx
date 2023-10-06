package bulby.assets;

import haxe.io.BytesOutput;
import haxe.io.BytesInput;
import bulby.assets.mat.Color;
import haxe.io.Bytes;
import format.png.Reader as PngReader;
import format.png.Tools as PngTools;
import format.png.Writer as PngWriter;
import bulby.BulbyMath;

using StringTools;

@:publish
class Image {
	var data:Bytes;
	var width:Int;
	var height:Int;

	function new(width:Int, height:Int, ?data:Bytes) {
		this.width = width;
		this.height = height;
		this.data = data != null ? data : Bytes.alloc(width * height * 4);
	}

	function getPixel(x:Int, y:Int) {
		var colorBytes = data.getInt32((x + y * width) * 4);
		return Color.fromARGB(colorBytes);
	}

	function copy() {
		return new Image(width, height, Bytes.ofHex(data.toHex()));
	}

	function setPixel(x:Int, y:Int, color:Color) {
		data.setInt32((x + y * width) * 4, color.asARGB());
	}

	function invert():Image {
		var result = new Image(width, height);
		for (y in 0...height) {
			for (x in 0...width) {
				var color = getPixel(x, y);
				result.setPixel(x, y, color.invert());
			}
		}
		return result;
	}

	function times(color:Color) {
		var result = new Image(width, height);
		for (y in 0...height) {
			for (x in 0...width) {
				var pixel = getPixel(x, y);
				result.setPixel(x, y, pixel * color);
			}
		}
		return result;
	}

	// All textures are grayscale; This represents the alpha afaik.
	function colortexture(color:Color, alphacap:Int = 255) {
		var result = new Image(width, height);

		for (y in 0...height) {
			for (x in 0...width) {
				var pixel = getPixel(x, y);
				result.setPixel(x, y, new Color(color.r, color.g, color.b, Std.int(Math.min(Math.min(pixel.r, alphacap), color.a))));
			}
		}
		return result;
	}

	static function filled(width:Int, height:Int, color:Color) {
		var result = new Image(width, height);
		for (y in 0...height) {
			for (x in 0...width) {
				result.setPixel(x, y, color);
			}
		}
		return result;
	}

	function blend(other:Image):Image {
		var w = Std.int(Math.min(this.width, other.width));
		var h = Std.int(Math.min(this.height, other.height));
		var image = new Image(w, h);
		for (y in 0...h) {
			for (x in 0...w) {
				var p1 = this.getPixel(x, y);
				var p2 = other.getPixel(x, y);
				var p = Color.blend(p1, p2);
				image.setPixel(x, y, p);
			}
		}
		return image;
	}

	static function procedural(width:Int, height:Int, tex:thinghandler.TextureTypes, ?param1:Float, ?param2:Float, ?param3:Float):Image {
		switch (tex) {
			case Gradient:
				var colorArray = [];
				for (i in 0...height) {
					colorArray.push(Color.lerp(Color.black, Color.white, i / height));
				}
				var image = new Image(width, height);
				for (y in 0...height) {
					for (x in 0...width) {
						image.setPixel(x, y, colorArray[y]);
					}
				}
				return image;
			case PerlinNoise1:
				if (param1 == null)
					throw "Perlin noise expects param1.";
				var perlin = new hxnoise.Perlin();
				var image = new Image(width, height);
				for (y in 0...height) {
					for (x in 0...width) {
						if (param1 != null) {
							var noise = BulbyMath.clamp(perlin.OctavePerlin(x, y, 0, 1, 0.5, 2), 0, 1);
							image.setPixel(x, y, Color.fromFloat(noise, noise, noise, 1));
						}
					}
				}
				return image;
			case QuasiCrystal:

			case VoronoiDots:

			case VoronoiPolys:

			case WavyLines:

			case WoodGrain:

			case PlasmaNoise:

			case Pool:

			case Bio:

			case FractalNoise:

			case LightSquares:

			case Machine:

			case SweptNoise:

			case Abstract:

			case Dashes:

			case LayeredNoise:

			case SquareRegress:

			case Swirly:

			default:
				return null;
		}
		return null;
	}

	private static function applyToPoint(mat:Matrix3, x:Float, y:Float) {
		return {
			x: x * mat.a + y * mat.b + mat.c,
			y: x * mat.d + y * mat.e + mat.f
		}
	}

	function transformTiled(matrix:Matrix3):Image {
		final a = matrix.a;
		final b = matrix.b;
		final c = matrix.c;
		final d = matrix.d;
		final e = matrix.e;
		final f = matrix.f;
		final tileBy:Int = Math.ceil(Math.max(1 / Math.abs(a), 1 / Math.abs(e)));
		final output = Image.filled(this.width, this.height, Color.white);
		for (tile in 0...tileBy) {
			for (y in 0...this.height) {
				for (x in 0...this.width) {
					final p = applyToPoint(matrix, x + (this.width * tile), y + (this.height * tile));
					if (p.x >= 0 && p.x < output.width && p.y >= 0 && p.y < output.height) {
						var x2 = Math.floor(p.x), y2 = Math.floor(p.y);
						output.setPixel(x2, y2, this.getPixel(x, y));
					}
				}
			}
		}
		return output;
	}

	static function fromPng(png:String) {
		var fin = sys.io.File.read(png);
		return fromInputPng(fin);
	}

	function writePng(file:String) {
		var fout = sys.io.File.write(file);
		toOutputPng(fout);
	}

	static function fromPngBytes(bytes:Bytes) {
		var bin = new BytesInput(bytes);
		return fromInputPng(bin);
	}

	function getPngBytes():Bytes {
		var bout = new BytesOutput();
		toOutputPng(bout);
		return bout.getBytes();
	}

	static function fromJpegBytes(bytes:Bytes):Image {
		final res = NanoJpeg.decode(bytes);
		PngTools.reverseBytes(res.pixels);
		return new Image(res.width, res.height, res.pixels);
	}

	private static function fromInputPng(input:haxe.io.Input) {
		var pdata = new PngReader(input).read();
		var header = PngTools.getHeader(pdata);
		return new Image(header.width, header.height, PngTools.extract32(pdata));
	}

	private function toOutputPng(output:haxe.io.Output) {
		var pdata = PngTools.build32BGRA(width, height, data);
		new PngWriter(output).write(pdata);
		output.close();
	}

	static function fromPngUrl(url:String) {
		var bytes = fetchBytes(url);
		return fromPngBytes(bytes);
	}

	static function fromJpegUrl(url:String) {
		final bytes = fetchBytes(url);
		return fromJpegBytes(bytes);
	}

	// ???
	static function fromUrl(url:String) {
		final bytes = fetchBytes(url);
		if (bytes.length < 2)
			throw "Not an image";
		if (bytes.get(0) == 0xFF && bytes.get(1) == 0xD8) {
			return fromJpegBytes(bytes);
		}
		return fromPngBytes(bytes);
	}

	private static function fetchBytes(url:String):Bytes {
		final http = new haxe.Http(url);
		var r = null;
		http.onBytes = function(b) {
			r = b;
		}
		http.onError = function(e) {
			throw e;
		}
		http.request(false);
		return r;
	}
}

@:allow(bulby.assets)
class Tile {
	var innerImg: Image;

	var u: Float;
	var v: Float;
	var u2: Float;
	var v2: Float;

	public var x(default, null): Float;
	public var y(default, null): Float;
	
	public var width(default, null): Float;
	public var height(default, null): Float;

	public var dx: Float;
	public var dy: Float;

	public var ix(get, never): Int;
	inline function get_ix() return Math.floor(x);

	public var iy(get, never): Int;
	inline function get_iy() return Math.floor(y);

	public var iwidth(get, never): Int;
	inline function get_iwidth() return Math.ceil(width + x) - ix;

	public var iheight(get, never): Int;
	inline function get_iheight() return Math.ceil(height + y) - iy;


	function new(img: Image, x: Float, y: Float, w: Float, h: Float, dx: Float = 0, dy: Float = 0) {
		this.innerImg = img;
		this.x = x;
		this.y = y;
		this.width = w;
		this.height = h;
		this.dx = dx;
		this.dy = dy;
		if (img != null) setTexture(img);
	}
	function setTexture(img: Image) {
		this.innerImg = img;
		updateUV();
	}
	function updateUV() {
		final img = this.innerImg;
		if (img != null) {
			this.u = x / img.width;
			this.v = y / img.height;
			this.u2 = (x + width) / img.width;
			this.v2 = (y + height) / img.height;
		}
	}
	public static function fromImage(img: Image): Tile {
		return new Tile(img, 0, 0, img.width, img.height);
	}
	public function setPosition(x: Float, y: Float): Void {
		this.x = x;
		this.y = y;
		updateUV();
	}
	public function setSize(w: Float, h: Float): Void {
		this.width = w;
		this.height = h;
		updateUV();
	}
	public function draw(on: Image): Void {
		var rx = Math.floor(dx);
		var ry = Math.floor(dy);
		for (y in iy...iheight) {
			final cy = ry++;
			for (x in ix...iwidth) {
				final cx = rx++;
				final p1 = on.getPixel(cx, cy);
				final p2 = this.innerImg.getPixel(x, y);
				on.setPixel(cx, cy, Color.blend(p1, p2));
			}
		}	
	}
	public function clone(): Tile {
		final t =new Tile(null, x, y, width, height, dx, dy);
		t.innerImg = innerImg;
		t.u = u;
		t.v = v;
		t.u2 = u2;
		t.v2 = v2;
		return t;
	}
	public function scaleToSize(w: Float, h: Float): Void {
		this.width = w;
		this.height = h;
	}
	public function dispose(): Void {
		this.innerImg = null;
	}
}
