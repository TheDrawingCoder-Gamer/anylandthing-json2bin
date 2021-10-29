package bulby.assets;

import bulby.assets.mat.Color;
import haxe.io.Bytes;
import format.png.Reader as PngReader;
import format.png.Tools as PngTools;
import format.png.Writer as PngWriter;
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
        return ARGB255.fromARGB(colorBytes);
    }
    function copy() {
        return new Image(width, height, Bytes.ofHex(data.toHex()));
    }
    function setPixel(x:Int, y:Int, color:ARGB255) {
        data.setInt32((x + y * width) * 4, color.asARGB());
    }
    function blend(other:Image):Image {
        var w = Std.int(Math.min(this.width, other.width));
        var h = Std.int(Math.min(this.height, other.height));
        var image = new Image(w, h);
        for (y in 0...h) {
            for (x in 0...w) {
                var p1 = this.getPixel(x, y);
                var p2 = other.getPixel(x, y);
                var p = ARGB255.blend(p1, p2);
                image.setPixel(x, y, p);
            }
        }
        return image;
    }
    static function fromPng(png:String) {
        var fin = sys.io.File.read(png);
        var pdata = new PngReader(fin).read();
        var header = PngTools.getHeader(pdata);
        return new Image(header.width, header.height, PngTools.extract32(pdata));
    }
    function writePng(file:String) {
        var fout = sys.io.File.write(file);
        new PngWriter(fout).write(PngTools.build32BGRA(width, height, data));
        fout.close();
    }
}