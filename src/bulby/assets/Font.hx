package bulby.assets;

import bulby.assets.Image;
import sys.io.File;
/**
  Taken from heaps
  **/
/**
	A `FontChar` kerning information as well as linked list of kernings. See `FontChar.kerning`.
**/
class Kerning {
	/**
		A character that should precede current character in order to apply this kerning.
	**/
	public var prevChar : Int;
	/**
		A kerning offset between the character pair in pixels.
	**/
	public var offset : Float;
	/**
		The next kerning reference.
	**/
	public var next : Null<Kerning>;

	/**
		Create a new kerning instance.
		@param c The preceding character.
		@param o The kerning offset.
	**/
	public function new(c, o) {
		this.prevChar = c;
		this.offset = o;
	}
}

/**
	A single `Font` character descriptor.
**/
class FontChar {
	/**
		A Tile representing position of a character on the texture.
	**/
	public var t : Tile;
	/**
		Horizontal advance value of the character.

		On top of advance, letter spacing is affected by `FontChar.kerning` matches and `Text.letterSpacing`.
	**/
	public var width : Float;
	/**
		Linked list of kerning values.

		In order to add new kerning values use `FontChar.addKerning` and `FontChar.getKerningOffset` to retrieve kerning offsets.
	**/
	@:dox(show)
	var kerning : Null<Kerning>;

	/**
		Create a new font character.
		@param t The character Tile.
		@param width The horizontal advance of the character.
	**/
	public function new(t,w) {
		this.t = t;
		this.width = w;
	}

	/**
		Adds a new kerning to the character with specified `prevChar` and `offset`.
	**/
	public function addKerning( prevChar : Int, offset : Int ) {
		var k = new Kerning(prevChar, offset);
		k.next = kerning;
		kerning = k;
	}

	/**
		Returns kerning offset for a pair `[prevChar, currentChar]` or `0` if there was no paired kerning value.
	**/
	public function getKerningOffset( prevChar : Int ) {
		var k = kerning;
		while( k != null ) {
			if( k.prevChar == prevChar )
				return k.offset;
			k = k.next;
		}
		return 0;
	}

	/**
		Clones the character instance.
	**/
	public function clone() {
		var c = new FontChar(t.clone(), width);
		// Clone entire kerning tree in case Font got resized.
		var k = kerning;
		if ( k != null ) {
			var kc = new Kerning(k.prevChar, k.offset);
			c.kerning = kc;
			k = k.next;
			while ( k != null ) {
				var kn = new Kerning(k.prevChar, k.offset);
				kc = kc.next = kn;
				k = k.next;
			}
		}
		return c;
	}

}

/**
	An instance of a text font.

	Heaps comes with a default Font that covers basic ASCII characters, and can be retrieved via `hxd.res.DefaultFont.get()`.
**/
class Font {
	/**
		The font name. Assigned on font creation and can be used to identify font instances.
	**/
	public var name(default, null) : String;
	/**
		Current font size. Font can be resized with `resizeTo`.
	**/
	public var size(default, null) : Int;
	/**
		The baseline value of the font represents the base on which characters will sit.

		Used primarily with `HtmlText` to sit multiple fonts and images at the same line.
	**/
	public var baseLine(default, null) : Float;
	/**
		Font line height provides vertical offset for each new line of the text.
	**/
	public var lineHeight(default, null) : Float;
	/**
		Reference to the source Tile containing all glyphs of the Font.
	**/
	public var tile(default,null) : Tile;
	/**
		The resource path of the source Tile. Either relative to .fnt or to resources root.
	**/
	public var tilePath(default,null) : String;
	/**
		Font charset allows to resolve specific char codes that are not directly present in glyph map as well as detect spaces.
		Defaults to `hxd.Charset.getDefault()`.
	**/
	public var charset : Charset;
	var glyphs : Map<Int,FontChar>;
	var nullChar : FontChar;
	var defaultChar : FontChar;
	var initSize:Int;
	var offsetX:Float = 0;
	var offsetY:Float = 0;

	/**
		Creates an empty font instance with specified parameters.
		@param name The name of the font.
		@param size Initial size of the font.
		@param type The font type.
	**/
	function new(name : String, size : Int) {
		this.name = name;
		this.size = size;
		this.initSize = size;
		glyphs = new Map();
		defaultChar = nullChar = new FontChar(new Tile(null, 0, 0, 0, 0),0);
		charset = Charset.getDefault();
		if (name != null)
			this.tilePath = haxe.io.Path.withExtension(name, "png");
	}

	/**
		Returns a `FontChar` instance corresponding to the `code`.
		If font char is not present in glyph list, `charset.resolveChar` is called.
		Returns `null` if glyph under specified charcode does not exist.
		@param code The charcode to search for.
	**/
	public inline function getChar( code : Int ) {
		var c = glyphs.get(code);
		if( c == null ) {
			c = charset.resolveChar(code, glyphs);
			if( c == null )
				c = code == "\r".code || code == "\n".code ? nullChar : defaultChar;
		}
		return c;
	}

	/**
		Offsets all glyphs by specified amount.
		Affects each glyph `Tile.dx` and `Tile.dy`.
		@param x The X offset of the glyphs.
		@param y The Y offset of the glyphs.
	**/
	public function setOffset( x : Float, y :Float ) {
		var dx = x - offsetX;
		var dy = y - offsetY;
		if( dx == 0 && dy == 0 ) return;
		for( g in glyphs ) {
			g.t.dx += dx;
			g.t.dy += dy;
		}
		this.offsetX += dx;
		this.offsetY += dy;
	}

	/**
		Creates a copy of the font instance.
	**/
	public function clone() {
		var f = new Font(name, size);
		f.baseLine = baseLine;
		f.lineHeight = lineHeight;
		f.tile = tile.clone();
		f.charset = charset;
		f.defaultChar = defaultChar.clone();
		f.offsetX = offsetX;
		f.offsetY = offsetY;
		for( g in glyphs.keys() ) {
			var c = glyphs.get(g);
			var c2 = c.clone();
			if( c == defaultChar )
				f.defaultChar = c2;
			f.glyphs.set(g, c2);
		}
		return f;
	}

	/**
		Resizes the Font instance to specified size.

		For BitmapFonts it can be used to create smoother fonts by rasterizing them with double size while still keeping the original glyph size by downscaling the font.
		And SDF fonts can be resized to arbitrary sizes to produce scalable fonts of any size.

		@param size The new font size.
	**/
	public function resizeTo( size : Int ) {
		var ratio = size / initSize;
		for( c in glyphs ) {
			c.width *= ratio;
			c.t.scaleToSize(c.t.width * ratio, c.t.height * ratio);
			c.t.dx *= ratio;
			c.t.dy *= ratio;
			var k = @:privateAccess c.kerning;
			while ( k != null ) {
				k.offset *= ratio;
				k = k.next;
			}
		}
		lineHeight = Math.ceil(lineHeight * ratio);
		baseLine = Math.ceil(baseLine * ratio);
		this.size = size;
	}

	/**
		Checks if character is present in glyph list.
		Compared to `getChar` does not check if it exists through `Font.charset`.
		@param code The charcode to look up.
	**/
	public function hasChar( code : Int ) : Bool {
		return glyphs.get(code) != null;
	}

	/**
		Disposes of the Font instance. Equivalent to `Tile.dispose`.
	**/
	public function dispose() {
		tile.dispose();
	}

	/**
	 	Calculate a baseLine default value based on available glyphs.
	 */
	public function calcBaseLine() {
		var padding : Float = 0;
		var space = glyphs.get(" ".code);
		if( space != null )
			padding = (space.t.height * .5);

		var a = glyphs.get("A".code);
		if( a == null )
			a = glyphs.get("a".code);
		if( a == null )
			a = glyphs.get("0".code); // numerical only
		if( a == null )
			return lineHeight - 2 - padding;
		return a.t.dy + a.t.height - padding;
	}

}

import haxe.io.Input;

class Reader {

	var i : Input;

	public function new( i : Input ) {
		this.i = i;
	}

	public function read( resolveTile: String -> Tile ) : Font {

		if (i.readString(4) != "BFNT" || i.readByte() != 0) throw "Not a BFNT file!";

		var font : Font = null;

		switch (i.readByte()) {
			case 1:
				font = new h2d.Font(i.readString(i.readUInt16()), i.readInt16());
				font.tilePath = i.readString(i.readUInt16());
				var tile = font.tile = resolveTile(font.tilePath);
				font.lineHeight = i.readInt16();
				font.baseLine = i.readInt16();
				var defaultChar = i.readInt32();
				var id : Int;
				while ( ( id = i.readInt32() ) != 0 ) {
					var t = tile.sub(i.readUInt16(), i.readUInt16(), i.readUInt16(), i.readUInt16(), i.readInt16(), i.readInt16());
					var glyph = new h2d.Font.FontChar(t, i.readInt16());
					font.glyphs.set(id, glyph);
					if (id == defaultChar) font.defaultChar = glyph;

					var prevChar : Int;
					while ( ( prevChar = i.readInt32() ) != 0 ) {
						glyph.addKerning(prevChar, i.readInt16());
					}
				}
			case ver:
				throw "Unknown BFNT version: " + ver;
		}

		return font;
	}

	public static inline function parse(bytes : haxe.io.Bytes, resolveTile : String -> Tile ) : Font {
		return new Reader(new haxe.io.BytesInput(bytes)).read(resolveTile);
	}
	public static function parseFont(font: String): Font {
		final fntFile = './res/Fonts/$font.fnt';
		if (File.exists(fntFile)) {
			final bytes = File.getBytes(fntFile);
			parse(bytes, name => {
				return Tile.fromImage(Image.fromPng("./res/Fonts/" + name));
			});
		}
	}

}