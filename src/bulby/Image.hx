package bulby;

import format.png.Tools as PngTools;
import format.png.Reader as PngReader;
class Image {
    public var format(default, null):PixelFormat;
    public var width(default, null):Int;
    public var height(default, null):Int;
    public var data(default, null):haxe.io.Bytes;

    public function new(width:Int, height:Int, format:PixelFormat, ?bytes:haxe.io.Bytes) {
        this.width = width;
        this.height = height;
        this.format = format;
        if (bytes == null) 
            this.data = haxe.io.Bytes.alloc(width * height * bytesPerPixel(format));
        else 
            this.data = bytes;
    }
	public function clone():Image {
		return new Image(this.width, this.height, this.format, this.data.sub(0, this.data.length));
	}
	public static function fromPngBytes(b:haxe.io.Bytes):Image {
		var reader = new PngReader(new haxe.io.BytesInput(b));
		var data = reader.read();
		var header = PngTools.getHeader(data);
		var bytes = PngTools.extract32(data);
		var image = new Image(header.width, header.height, BGRA, bytes);
		image.convert(RGBA);
		return image;
	}
    public function convert(to:PixelFormat):Bool {
		if (format == to)
			return true;
		switch [format, to] {
			case [BGRA, RGBA] | [RGBA, BGRA]:
				var p = 0;
				inline function bget(i) return data.get(i);
				inline function bset(i, v) data.set(i, v);
				for (_ in 0...data.length >> 2) {
					var b = bget(p);
					var g = bget(p + 1);
					var r = bget(p + 2);
					var a = bget(p + 3);
					bset(p++, r);
					bset(p++, g);
					bset(p++, b);
					bset(p++, a);
				}

			case [BGRA, ARGB] | [ARGB, BGRA]:
				var p = 0;
				inline function bget(i) return data.get(i);
				inline function bset(i, v) data.set(i, v);
				for (_ in 0...data.length >> 2) {
					var b = bget(p);
					var g = bget(p + 1);
					var r = bget(p + 2);
					var a = bget(p + 3);
					bset(p++, a);
					bset(p++, r);
					bset(p++, g);
					bset(p++, b);
				}
			case [ARGB, RGBA]:
				var p = 0;
				inline function bget(i) return data.get(i);
				inline function bset(i, v) data.set(i, v);
				for (_ in 0...data.length >> 2) {
					var a = bget(p);
					var r = bget(p + 1);
					var g = bget(p + 2);
					var b = bget(p + 3);
					bset(p++, r);
					bset(p++, g);
					bset(p++, b);
					bset(p++, a);
				}
			case [RGBA, ARGB]:
				var p = 0;
				inline function bget(i) return data.get(i);
				inline function bset(i, v) data.set(i, v);
				for (_ in 0...data.length >> 2) {
					var r = bget(p);
					var g = bget(p + 1);
					var b = bget(p + 2);
					var a = bget(p + 3);
					bset(p++, a);
					bset(p++, r);
					bset(p++, g);
					bset(p++, b);
				}
			default:
				return false;
		}
        format = to;
        return true;
    }
	public static function bytesPerPixel(format:PixelFormat):Int {
		return switch format {
			case RGBA | BGRA | ARGB: 4;
			default: 4;
		}
	}
}

enum PixelFormat {
    RGBA;
    BGRA;
    ARGB;
}