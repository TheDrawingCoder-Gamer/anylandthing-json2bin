package bulby.assets;

import bulby.assets.mat.Color;
import bulby.assets.Image;

enum Align {
	Center;
	Left;
	Right;
}

class Text {
	static function splitRawText(text:String, leftMargin = 0., afterData = 0., font:Font, ?sizes:Array<Float>, ?prevChar:Int = -1) {
		var x = leftMargin;
		for (i in 0...text.length) {
			var cc = text.charCodeAt(i);
			var e = font.getChar(cc);
			var newline = cc == '\n'.code;
			var esize = e.width + e.getKerningOffset(prevChar);
			if (e != null && cc != '\n'.code)
				x += esize;
			if (newline) {
				if (sizes != null)
					sizes.push(x);
				x = 0;
				prevChar = -1;
			} else
				prevChar = cc;
		}
		return text;
	}

	static public function write(text:String, align:Align, font:Font, lineSpacing:Float):{img:Image, lw:Float, nlines:Int} {
		var x = 0., y = 0., xMax = 0., xMin = 0., yMin = 0., prevChar = -1, linei = 0;
		var lines = new Array<Float>();
		var dl = font.lineHeight + lineSpacing;
		var t = splitRawText(text, 0, 0, font, lines);
		final glyphs:Array<{x:Float, y:Float, t:Tile}> = [];
		for (lw in lines) {
			if (lw > x)
				x = lw;
		}

		switch (align) {
			case Center, Right:
				var max = 0;
				var k = align == Center ? 0.5 : 1;
				for (i in 0...lines.length)
					lines[i] = Math.ffloor((max - lines[i]) * k);
				x = lines[0];
				xMin = x;
			case Left:
				x = 0;
		}

		for (i in 0...t.length) {
			var cc = t.charCodeAt(i);
			var e = font.getChar(cc);
			var offs = null;
			var esize = null;
			if (e != null) {
				offs = e.getKerningOffset(prevChar);
				esize = e.width + offs;
			}

			if (cc == '\n'.code) {
				if (x > xMax)
					xMax = x;
				switch (align) {
					case Left:
						x = 0;
					case Right, Center:
						x = lines[++linei];
						if (x < xMin)
							xMin = x;
				}
				y += dl;
				prevChar = -1;
			} else {
				if (e != null) {
					glyphs.push({x: x + offs, y: y, t: e.t});
					if (y == 0 && e.t.dy < yMin)
						yMin = e.t.dy;
					x += esize;
				}
				prevChar = cc;
			}
		}
		if (x > xMax)
			xMax = x;

		final calcWidth = xMax - xMin;
		final calcHeight = y + font.lineHeight;

		final image = Image.filled(Math.ceil(calcWidth), Math.ceil(calcHeight), Color.fromRGBA(0xFFFFFF00));
		for (glyph in glyphs) {
			glyph.t.draw(glyph.x, glyph.y, image);
		}
		return {img: image, lw: xMax, nlines: lines.length};
	}
}
