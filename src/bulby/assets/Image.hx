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
        if (!url.endsWith(".png")) {
            throw "Non-png images are currently unsupported";
        }
        var bytes = Bytes.ofString(haxe.Http.requestUrl(url));
        return fromPngBytes(bytes);
    }
}