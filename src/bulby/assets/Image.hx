package bulby.assets;

import haxe.io.BytesOutput;
import haxe.io.BytesInput;
import bulby.assets.mat.Color;
import haxe.io.Bytes;
import format.png.Reader as PngReader;
import format.png.Tools as PngTools;
import format.png.Writer as PngWriter;

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
		var bytes = Bytes.ofString(haxe.Http.requestUrl(url));
		return fromPngBytes(bytes);
	}
}
