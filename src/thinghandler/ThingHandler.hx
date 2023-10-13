package thinghandler;

import bulby.assets.Text;
import haxe.ds.Option;
import thinghandler.TextureProperty.TexturePropertyMap;
import bulby.assets.mat.Color;
import bulby.assets.Image;
import bulby.assets.mat.Material;
import bulby.assets.Font;
import bulby.assets.FontParser;
import bulby.BulbyMath;
import bulby.assets.Node;
import sys.FileSystem;
import bulby.BulbyMath;
import sys.io.File;
import bulby.assets.Mesh;
import thinghandler.Thing.Axises;
import thinghandler.TextureTypes;
import thinghandler.ParticleSystemType;
import thinghandler.Thing.ImageType;
import thinghandler.MaterialTypes;
import thinghandler.ThingPartBase;
import haxe.Json;
import thinghandler.Thing.ThingPartState;
import thinghandler.Thing.SubThingAttr;
import thinghandler.Thing.SubThingInfo;
import thinghandler.Thing.ThingPart;
import haxe.Int64;
import haxe.io.BytesBuffer;
import thinghandler.Thing.HigherThingAttribute;
import thinghandler.Thing.LowerThingAttribute;
import thinghandler.Thing.HigherThingPartAttribute;
import thinghandler.Thing.LowerThingPartAttribute;

using thinghandler.BytesBufferTools;
using Lambda;
using StringTools;

enum MeshKind {
	NormalMesh(mesh: Mesh);
	TextMesh(font: Font);
}
@:forward(length)
abstract ChangedVerticies(Array<Dynamic>) from Array<Dynamic> to Array<Dynamic> {
	var x(get, set):Float;

	inline function get_x() {
		return this[0];
	}

	inline function set_x(f) {
		return this[0] = f;
	}

	var y(get, set):Float;

	inline function get_y() {
		return this[1];
	}

	inline function set_y(f) {
		return this[1] = f;
	}

	var z(get, set):Float;

	inline function get_z() {
		return this[2];
	}

	inline function set_z(f) {
		return this[2] = f;
	}

	public var indexes(get, set):Array<Int>;

	inline function get_indexes():Array<Int> {
		return cast this.slice(3);
	}

	function set_indexes(arr:Array<Int>):Array<Int> {
		this.resize(3);
		this.concat(arr);
		return cast this;
	}

	@:to
	public function toVector3() {
		return new Vector3(x, y, z);
	}
}

typedef AnylandThingJson = {
	var ?n:String; // Thing name
	var ?a:Array<Int>; // Thing Attributes
	var ?d:String; // Description
	var ?inc:Array<Array<String>>; // Included name id pairs (i could really use a tuple right now)
	var ?v:Int; // Version

	var ?tp_m:Float;
	var ?tp_d:Float;
	var ?tp_ad:Float;
	var ?tp_lp:Array<Int>; // Stupid :angry:
	var ?tp_lr:Array<Int>;

	var p:Array<AnylandPartJson>;
};

typedef AnylandPartJson = {
	var ?b:ThingPartBase;
	var ?t:MaterialTypes;
	var ?a:Array<Int>; // Attributes
	var ?n:String;

	var ?id:String;

	var ?e:String;
	var ?lh:Float;

	var ?i:Array<IncludedSubthingJson>;
	var ?su:Array<PlacedSubthingJson>;

	var ?im:String;
	var ?imt:ImageType;

	var ?pr:ParticleSystemType;

	var ?t1:TextureTypes;
	var ?t2:TextureTypes;

	var ?ac:AnylandAC;

	var ?c:Array<ChangedVerticies>;

	var s:Array<AnylandStateJson>;
	var ?bod:IncludedBody;

	var ?sa:Int;
	var ?cx:Int;
	var ?v:Int;
}

typedef IncludedBody = {
	var ?h:NoScaleTransformJson;
	var ?ut:BodyAttachment;
	var ?lt:BodyAttachment;
	var ?ll:BodyAttachment;
	var ?lr:BodyAttachment;
	var ?ht:BodyAttachment;
	var ?al:BodyAttachment;
	var ?ar:BodyAttachment;
};

typedef NoScaleTransformJson = {
	var p:Array<Float>;
	var r:Array<Float>;
}

typedef BodyAttachment = {
	> NoScaleTransformJson,
	var i:String;
}

typedef AnylandStateJson = {
	var p:Array<Float>;
	var r:Array<Float>;
	var s:Array<Float>;
	var c:Array<Float>;
	var b:Array<String>;
	var ?t1:ALStateTextureInfo;
	var ?t2:ALStateTextureInfo;
}

typedef ALStateTextureInfo = {
	var c:Array<Float>; // Color
	var x:Float; // X Scale
	var y:Float; // Y SCale
	var a:Float; // Alpha
	var m:Float; // X Offset
	var n:Float; // Y Offset
	var r:Float; // Rotation
	var g:Float; // Glow
	var o:Float; // Param 1
	var t:Float; // Param 2
	var e:Float; // Param 3
}

typedef AnylandAC = {
	var id:String;
	var c:Int;
	var ?w:Int;
	var ?rp:Array<Float>;
	var ?rr:Array<Float>;
	var ?rs:Array<Float>;
}

typedef IncludedSubthingJson = {
	var t:String;
	var p:Array<Float>;
	var r:Array<Float>;
	var ?n:String;
	var ?a:Array<Int>;
}

typedef PlacedSubthingJson = {
	var i:String;
	var t:String;
	var p:Array<Float>;
	var r:Array<Float>;
}

class ThingHandler {
	public static function importJson(json:String, keepPartsSeperate:Bool = false, isForPlacement:Bool = false) {
		var data:AnylandThingJson = Json.parse(json);
		var thing = new Thing();
		thing.givenName = data.n != null ? data.n : Thing.defaultName;
		thing.version = data.v != null ? data.v : 1;
		thing.description = data.d;
		expandThingAttributeFromJson(thing, data.a);
		expandThingIncludedNameIdsFromJson(thing, data.inc);
		if (data.tp_m != null)
			thing.physicsMass = data.tp_m;
		if (data.tp_d != null)
			thing.dragMass = data.tp_d;
		if (data.tp_ad != null)
			thing.angularDrag = data.tp_ad;
		if (data.tp_lp != null)
			thing.lockedPos = getBoolAxies(data.tp_lp);
		if (data.tp_lr != null)
			thing.lockedRot = getBoolAxies(data.tp_lr);

		for (jsonpart in data.p) {
			// var baseIndex:Int = jsonpart.b != null ? cast jsonpart.b : 1;
			var thingpart = new ThingPart();
			
			expandPartAttributeFromJson(thingpart, jsonpart.a);

			if (jsonpart.n != null)
				thingpart.givenName = jsonpart.n;
			if (jsonpart.ac != null) {
				thingpart.autoContinuation = new ThingPartAutocomplete();
				thingpart.autoContinuation.fromJson(jsonpart.ac);
			}
			if (jsonpart.b != null) {
				thingpart.baseType = jsonpart.b;
			} else
				thingpart.baseType = Cube;
			if (jsonpart.e != null) {
				thingpart.text = jsonpart.e;
				if (jsonpart.lh != null)
					thingpart.textLineHeight = jsonpart.lh;
			}
			if (jsonpart.t != null) {
				thingpart.materialType = jsonpart.t;
				if (thingpart.materialType == InvisibleWhenDone) {
					thingpart.materialType = None;
					thingpart.partInvisible = true;
				}
			} else if (thingpart.isText && thing.version <= 3) {
				thingpart.materialType = Glow;
			}
			applyVertexChangesAndSmoothingAngles(thingpart, jsonpart, data.p);

			if (jsonpart.i != null) {
				thingpart.includedSubThings = [];
				for (subThingNode in jsonpart.i) {
					var includedSubthing = new SubThingInfo(false);
					includedSubthing.thingId = subThingNode.t;
					includedSubthing.pos = Vector3.fromUnity(subThingNode.p);
					includedSubthing.rot = Vector3.fromUnityEuler(subThingNode.r);
					if (subThingNode.n != null)
						includedSubthing.nameOverride = subThingNode.n;
					expandIncludedSubthingInvertAttribute(includedSubthing, subThingNode.a);
					thingpart.includedSubThings.push(includedSubthing);
				}
			}

			if (jsonpart.su != null && jsonpart.su.length >= 1) {
				for (pSNode in jsonpart.su) {
					if (pSNode.i != null) {
						var placedSubthing = new SubThingInfo(true);
						placedSubthing.thingId = pSNode.t;
						placedSubthing.pos = Vector3.fromUnity(pSNode.p);
						placedSubthing.rot = Vector3.fromUnityEuler(pSNode.r);
					}
				}
			}

			if (jsonpart.im != null) {
				thingpart.imageUrl = jsonpart.im;
				if (jsonpart.imt != null) {
					thingpart.imageType = cast(jsonpart.imt : ImageType);
				}
			}

			final shiftTexture2Left = jsonpart.t1 == null && jsonpart.t2 != null;

			if (jsonpart.t1 != null) {
				thingpart.textureTypes.set(0, cast(jsonpart.t1 : TextureTypes));
			}

			if (jsonpart.t2 != null) {
				thingpart.textureTypes.set(shiftTexture2Left ? 0 : 1, cast(jsonpart.t2 : TextureTypes));
			}

			if (jsonpart.pr != null) {
				thingpart.particleSystem = jsonpart.pr;
			}
			var partContainsScript = false;
			var maxStates = jsonpart.s.length;
			for (statesI in 0...(maxStates)) {
				thingpart.states[statesI] = new ThingPartState();
				final state = jsonpart.s[statesI];

				thingpart.states[statesI].position = Vector3.fromUnity(state.p);

				thingpart.states[statesI].rotation = Vector3.fromUnityEuler(state.r);
				thingpart.states[statesI].scale = state.s;
				// Ensure no negative scale to prevent : (
				thingpart.states[statesI].scale = thingpart.states[statesI].scale.abs();
				thingpart.states[statesI].color = state.c;
				if (state.t1 != null) {
					thingpart.states[statesI].textureColors[0] = state.t1.c;
					thingpart.states[statesI].textureProperties[0] = [
						TextureProperty.ScaleY => state.t1.y,
						TextureProperty.ScaleX => state.t1.x,
						TextureProperty.Rotation => state.t1.r,
						TextureProperty.OffsetX => state.t1.m,
						TextureProperty.OffsetY => state.t1.n,
						TextureProperty.Glow => state.t1.g,
						TextureProperty.Param1 => state.t1.o,
						TextureProperty.Strength => state.t1.a,
						TextureProperty.Param2 => state.t1.t,
						TextureProperty.Param3 => state.t1.e
					];
				}
				if (state.t2 != null) {
					thingpart.states[statesI].textureColors[1] = state.t2.c;
					thingpart.states[statesI].textureProperties[1] = [
						TextureProperty.ScaleY => state.t2.y,
						TextureProperty.ScaleX => state.t2.x,
						TextureProperty.Rotation => state.t2.r,
						TextureProperty.OffsetX => state.t2.m,
						TextureProperty.OffsetY => state.t2.n,
						TextureProperty.Glow => state.t2.g,
						TextureProperty.Param1 => state.t2.o,
						TextureProperty.Strength => state.t2.a,
						TextureProperty.Param2 => state.t2.t,
						TextureProperty.Param3 => state.t2.e
					];
				}

				if (state.b != null) {
					partContainsScript = true;
					for (line in state.b) {
						thingpart.states[statesI].scriptLines.push(line);
					}
					// There is a shitton of extra shit that requires me to have extra functions and that don't seem worth it
				}
			}
			thing.parts.push(thingpart);
		}

		return thing;
	}

	static function expandIncludedSubthingInvertAttribute(incSubthing:SubThingInfo, attrs:Array<Int>) {
		if (attrs != null) {
			for (attr in attrs) {
				switch (cast(attr : ThingAttribute)) {
					case ThingAttribute.isHoldable:
						incSubthing.invertIsHoldable = true;
					case invisible:
						incSubthing.invertInvisible = true;
					case uncollidable:
						incSubthing.invertUncollidable = true;
					default:
				}
			}
		}
	}

	static function applyVertexChangesAndSmoothingAngles(part:ThingPart, partNode:AnylandPartJson, thingNode:Array<AnylandPartJson>) {
		if (partNode.c != null || partNode.v != null || partNode.sa != null) {
			// No Mesh Filter. This is purely a data reader
			if (partNode.v != null) {
				final indexRef = partNode.v;
				partNode.c = thingNode[indexRef].c;
				if (thingNode[indexRef].sa != null) {
					partNode.sa = thingNode[indexRef].sa;
				}
				if (thingNode[indexRef].cx != null) {
					partNode.cx = thingNode[indexRef].cx;
				}
			}

			if (partNode.c != null) {
				// Pain
				part.changedVerticies = new Map<Int, Vector3>();
				for (item in partNode.c) {
					var vector:Vector3 = item.toVector3();
					var previousVertexIndex = 0;
					for (relVertexIndex in item.indexes) {
						var vertexIndex = previousVertexIndex + relVertexIndex;
						if (vertexIndex < cast PartTypeVertCount.fromPartType(part.baseType)) {
							previousVertexIndex = vertexIndex;
							part.changedVerticies.set(vertexIndex, Vector3.fromUnity(vector));
						}
					}
				}
			}
			if (partNode.sa != null) {
				part.smoothingAngle = partNode.sa;
			}
			if (partNode.cx != null) {
				part.convex = partNode.cx == 1;
			}
		}
	}

	static function getBoolAxies(axies:Array<Int>) {
		var boolAxises = 0;
		if (axies[0] == 1)
			boolAxises |= Axises.x;
		if (axies[1] == 1)
			boolAxises |= Axises.y;
		if (axies[2] == 1)
			boolAxises |= Axises.z;
		return boolAxises;
	}

	static function expandThingIncludedNameIdsFromJson(thing:Thing, jsonNameIds:Array<Array<String>>) {
		if (jsonNameIds != null) {
			for (nameId in jsonNameIds) {
				thing.includedThingIds.set(nameId[0], nameId[1]);
			}
		}
	}

	/**
	 * Generates an Obj File from a Thing. Returns Node, that contains all meshes
	 * @param thing 
	 * @return Node
	 */
	public static function generateMeshFromThing(thing:Thing):Node {
		var node = new Node([]);
		var matCache:Map<String, Material> = new Map<String, Material>();
		var i = 0;
		var tn = 0;
		for (part in thing.parts) {
			if (part.materialType == InvisibleWhenDone || part.partInvisible)
				continue;
			switch (getBaseMesh(part)) {
				case Option.Some(NormalMesh(mesh)):
					var matKey = '_${part.states[0].color.hex()}_${Std.string(part.materialType)}_${part.imageUrl == null ? "NoURL" : part.imageUrl}_${part.textureTypes[0]}_${part.textureTypes[1]}_';
					if (matCache.exists(matKey)) {
						mesh.material = matCache.get(matKey);
					} else {
						var color = part.states[0].color;
						color.afloat = part.materialType.alpha();
						final mat = new Material(matKey, color, 0, 0);
						// Some material types are flat out impossible to render into Nodes. 
						switch (part.materialType) {
							case Unshaded | TransparentGlowTexture:
								mat.extensions.push(Unlit);
							case Inversion:
							// ???
							case Brightness:
							// ???
							case Glow:
								mat.emissive = color;
							case Metallic:
								mat.metalness = 0.75;
								mat.roughness = 1 - 0.65;
							case VeryMetallic:
								mat.metalness = 1;
								mat.roughness = 1 - 0.5;
							case DarkMetallic:
								mat.metalness = 1;
								mat.roughness = 1 - 0.65;
							case BrightMetallic:
								mat.metalness = 0.85;
								mat.roughness = 1 - 0.2;
							case TransparentGlossy | VeryTransparentGlossy:
								mat.metalness = 0;
								mat.roughness = 1 - 0.75;
							case TransparentGlossyMetallic:
								mat.metalness = 0.5;
								mat.roughness = 1 - 0.75;
							case Plastic: 
								mat.metalness = 0;
								mat.roughness = 1 - 0.8;
							case Unshiny:
								mat.metalness = 0;
								mat.roughness = 1 - 0;
							case TransparentTexture:
								mat.metalness = 0;
								mat.roughness = 0.25;
							case Particles | ParticlesBig:
								// ???
							default:
						}

						matCache.set(matKey, mat);
						if (part.textureTypes[0] != None || part.textureTypes[1] != None) {
							try {
								var texture1:Image = null;
								if (FileSystem.exists("./res/Textures/" + Std.string(part.textureTypes[0]) + ".png")) {
									var texture = Image.fromPng("./res/Textures/" + Std.string(part.textureTypes[0]) + ".png");
									var color = part.states[0].textureColors[0];
									color.afloat = part.states[0].textureProperties[0].strength;

									texture1 = texture.colortexture(color, textureAlphaCap(part.textureTypes[0]));
								} else if (TextureTypes.isProcedural(part.textureTypes[0])) {
									var texture = Image.procedural(2048, 2048, part.textureTypes[0], part.states[0].textureProperties[0].param1,
										part.states[0].textureProperties[0].param2, part.states[0].textureProperties[0].param3);
									if (texture != null) {
										texture1 = texture.colortexture(part.states[0].textureColors[0], textureAlphaCap(part.textureTypes[0]));
									}
								}
								var texture2:Image = null;
								if (FileSystem.exists(".res/Textures/" + Std.string(part.textureTypes[1]) + ".png")) {
									var texture = Image.fromPng("./res/Textures/" + Std.string(part.textureTypes[1]) + ".png");
									var color = part.states[0].textureColors[1];
									color.afloat = part.states[0].textureProperties[1].strength;

									texture2 = texture.colortexture(color, textureAlphaCap(part.textureTypes[1]));
								} else if (TextureTypes.isProcedural(part.textureTypes[1])) {
									var texture = Image.procedural(2048, 2048, part.textureTypes[1], part.states[0].textureProperties[1].param1,
										part.states[0].textureProperties[1].param2, part.states[0].textureProperties[1].param3);
									// Check for null because right now not everything is implemented
									if (texture != null) {
										texture2 = texture.colortexture(part.states[0].textureColors[1], textureAlphaCap(part.textureTypes[1]));
									}
								}
								if (texture1 != null || texture2 != null) {
									final colorTexture = Image.filled(2048, 2048, part.states[0].color);
									var goodTex = colorTexture;
									final res = applyAndMergeTexture(part.textureTypes[0], part.textureTypes[1], part.states[0].textureProperties[0],
										part.states[0].textureProperties[1], texture1, texture2);
									matCache.get(matKey).diffuse = Color.white;
									matCache.get(matKey).texture = goodTex.blend(res);
								}
							} catch (e:Dynamic) {}
						}

						if (part.imageUrl != null) {
							final url = readImageUrl(part.imageUrl, part.imageType);
							final img = Image.fromUrl(url);
							var color = part.states[0].color;
							var backing = Color.black;
							if ((part.isImagePasteScreen || part.states[0].color == Color.black) && !part.allowBlackImageBackgrounds) {
								backing = Color.white;
							}
							final res = switch (part.materialType) {
								case TransparentTexture | TransparentGlowTexture:
									img.times(color);
								default:
									Image.filled(img.width, img.height, backing).blend(img.times(color));
							}
							matCache.get(matKey).texture = res;
						}

						mesh.material = matCache.get(matKey);
					}

					if (part.autoContinuation != null && part.autoContinuation.count != 0) {
						var otherPart = part.autoContinuation.fromPart;
						// Just a guess, but I think from part means this part is the 2nd in sequence.
						// So we calculate the different with this on lhs
						var posDiff = part.states[0].position - otherPart.states[0].position;
						var rotDiff = Quaternion.fromEuler(part.states[0].rotation) * Quaternion.fromEuler(otherPart.states[0].rotation).inverse();
						var scaleDiff = part.states[0].scale - otherPart.states[0].scale;
						// me when I'm lazy
						var thisPos = part.states[0].position / 1;
						var thisRot = Quaternion.fromEuler(part.states[0].rotation);
						var thisScale = part.states[0].scale / 1;

						for (_ in 0...part.autoContinuation.count) {
							thisPos += posDiff;
							thisRot *= rotDiff;
							thisScale += scaleDiff;
							var newMesh = mesh.copy();
							newMesh.rotation = thisRot;
							newMesh.translation = thisPos / 1;
							newMesh.scale = thisScale.abs();
							applyReflectionIfApplicable(node, part, newMesh);
							newMesh.applyTransformations();
							node.children.push(newMesh);
						}
					}

					mesh.translation = part.states[0].position;
					mesh.rotation = Quaternion.fromEuler(part.states[0].rotation);
					mesh.scale = part.states[0].scale;
					applyReflectionIfApplicable(node, part, mesh);
					mesh.applyTransformations();
					node.children.push(mesh);
				case Option.Some(TextMesh(font)):
					if (part.text == null) {
						trace("Text is null?");
						continue;
					}
					// TODO: This isn't accurate. Font size isn't in pixels
					font.resizeTo(65);
					var align = Align.Left;
					if (part.textAlignRight)
						align = Align.Right;
					if (part.textAlignCenter)
						align = Align.Center;
					final res = Text.write(part.text, align, font, part.textLineHeight);
					
					// Taken from https://learn.microsoft.com/en-us/windows/mixed-reality/develop/unity/text-in-unity
					final dotsPerUnit = 2835;
					// This ratio is to account for the size it's rendered at vs. actual size
					final ratio = 12 / 65;
					final fwidth = res.img.width * ratio;
					final fheight = res.img.height * ratio;
					final quad = Mesh.quad(fwidth, fheight);
					final mat = new Material('text_${font.name}_${tn++}', part.states[0].color, 0, 0);
					mat.texture = res.img;
					switch (part.materialType) {
						case Glow | Unshaded:
							// Glow is similar to unshaded iirc
							// For text it's basically full bright
							mat.extensions.push(Unlit);
						default: 
							// : )
					}
					quad.material = mat;
					final scaleV = part.states[0].scale;
					final scale = Matrix4.scale(scaleV.x, scaleV.y, scaleV.z);
					var anchorTranslation = Matrix4.identity();
					final tPos = part.states[0].position;
					final translation = Matrix4.translation(tPos.x, tPos.y, tPos.z);
					final rotation = Quaternion.fromEuler(part.states[0].rotation).matrix();
					switch (align) {
						case Align.Right: 
							anchorTranslation = Matrix4.translation(-fwidth, 0, 0);
						case Align.Center:
							anchorTranslation = Matrix4.translation(-fwidth / 2, 0, 0);
						default:
							// : )
					}
					anchorTranslation = Matrix4.translation(0, -fheight, 0) * anchorTranslation;
					quad.specialTransform(translation * rotation * scale * anchorTranslation);
					node.children.push(quad);
				default:
					// nothing
					trace('Part $i is unrenderable');
			}
			i++;
		}
		return node;
	}

	static function getBaseMesh(part:ThingPart):Option<MeshKind> {
		final baseShape = './res/BaseShapes/${Std.string(part.baseType)}.obj';
		if (FileSystem.exists(baseShape)) {
			final mesh = Mesh.fromObj(File.getContent(baseShape), false);
			for (index => pos in part.changedVerticies) {
				mesh.positions[index] = pos;
			}
			return Option.Some(MeshKind.NormalMesh(mesh));
		}
		if (part.baseType.isText()) {
			final font = FontParser.parseFont(Std.string(part.baseType));
			return Option.Some(MeshKind.TextMesh(font));
		}
		return Option.None;
	}

	public static function readImageUrl(url:String, imageType:ImageType):String {
		if (url.contains("http"))
			return url;
		final base = (imageType == NotPng ? "http://" : "https://") + "steamuserimages-a.akamaihd.net/ugc/";
		return base + url;
	}

	static function modulateTextureProperties(textureType:TextureTypes, props:TexturePropertyMap<Float>):TexturePropertyMap<Float> {
		final newProps:TexturePropertyMap<Float> = props.copy();
		final isAlgo = TextureTypes.isProcedural(textureType);
		modulateStrength(newProps, textureType, isAlgo);
		if (!TextureTypes.isAlphaOnly(textureType)) {
			modulateScale(props, TextureProperty.ScaleX, isAlgo);
			modulateScale(props, TextureProperty.ScaleY, isAlgo);
			modulateOffset(props, TextureProperty.OffsetX, isAlgo);
			modulateOffset(props, TextureProperty.OffsetY, isAlgo);
			modulateRotation(props);
		}
		return newProps;
	}

	static function applyAndMergeTexture(textureType1:TextureTypes, textureType2:TextureTypes, props1:Null<TexturePropertyMap<Float>>,
			props2:Null<TexturePropertyMap<Float>>, img1:Null<Image>, img2:Null<Image>):Image {
		if (img1 == null && img2 == null)
			throw "Both textures are null";
		if (img1 == null && img2 != null)
			return applyAndMergeTexture(textureType2, None, props2, null, img2, null);
		// TODO: Sky
		if (img2 == null) {
			final props = modulateTextureProperties(textureType1, props1);
			final scaleThingie = Matrix3.scale(props.scaleX, props.scaleY);
			final translationThingie = Matrix3.translate(props.offsetX * 2048, props.offsetY * 2048);
			final rotationThingie = Matrix3.rotateDegrees(props.rotation);
			return img1.transformTiled(translationThingie * rotationThingie * scaleThingie);
		}
		final p1 = modulateTextureProperties(textureType1, props1);
		final p2 = modulateTextureProperties(textureType2, props2);
		if (p1.scaleX > 1 || p1.scaleY > 1 || p2.scaleX > 1 || p2.scaleY > 1) {
			// Find the larger of the two
			final maxX = Math.max(p1.scaleX, p2.scaleX);
			final maxY = Math.max(p1.scaleY, p2.scaleY);
			final max = Math.max(maxX, maxY);
			p1.scaleX /= max;
			p1.scaleY /= max;
			p2.scaleX /= max;
			p2.scaleY /= max;
		}
		final s1 = Matrix3.scale(p1.scaleX, p1.scaleY);
		final s2 = Matrix3.scale(p2.scaleX, p2.scaleY);
		final t1 = Matrix3.translate(p1.offsetX * 2048, p1.offsetY * 2048);
		final t2 = Matrix3.translate(p2.offsetX * 2048, p2.offsetY * 2048);
		final r1 = Matrix3.rotateDegrees(p1.rotation);
		final r2 = Matrix3.rotateDegrees(p2.rotation);
		final res1 = img1.transformTiled(t1 * r1 * s1);
		final res2 = img2.transformTiled(t2 * r2 * s2);
		return res1.blend(res2);
	}

	static function modulateStrength(props:TexturePropertyMap<Float>, textureType:TextureTypes, isAlgorithimTexture:Bool):Void {
		if (textureType != TextureTypes.SideGlow) {
			var num = props.strength;
			num = (num - 0.5) * 2;
			if (Math.abs(num) <= 0.1)
				num = 0;
			else if (num >= 0) {
				final t = (num - 1) * 1.1111112;
				num = BulbyMath.lerp(0, 1, t);
			} else {
				final t2 = Math.abs((num + 0.1) * 1.1111112);
				num = 0 - BulbyMath.lerp(0, 1, t2);
			}
			props.strength = num;
		}
	}

	static function modulateScale(props:TexturePropertyMap<Float>, key:TextureProperty, isAlgorithimTexture:Bool):Void {
		var num = props.get(key);
		if (num > 0.5) {
			num -= 0.5;
			final b = !isAlgorithimTexture ? 3.0 : 2.0;
			final p = BulbyMath.lerp(1, b, num * 2);
			num *= 100;
			num = Math.pow(num, p);
			if (num > 0)
				num /= 100;
			num += 0.5;
		}
		if (num < 0.0002) {
			num = 0.0002;
		}
		props.set(key, num);
	}

	static function modulateOffset(props:TexturePropertyMap<Float>, key:TextureProperty, isAlgorithmTexture:Bool):Void {
		final num = props.get(key);
		props.set(key,
			((!isAlgorithmTexture) ? (num * 5) : ((num <= 0.4) ? ((0 - Math.abs(num - 0.4)) * 10) : ((!(num >= 0.6)) ? 0 : (Math.abs(num - 0.6) * 10)))));
	}

	static function modulateRotation(props:TexturePropertyMap<Float>):Void {
		props.rotation = props.rotation * 360;
	}

	private static function applyReflectionIfApplicable(node:Node, part:ThingPart, mesh:Mesh):Void {
		if (!part.reflectPartDepth && !part.reflectPartSideways && !part.reflectPartVertical)
			return;
		final rot = mesh.rotation;
		if (part.reflectPartDepth) {
			final newMesh = mesh.copy();
			// Reflect across XY Plane
			final goodRot = new Quaternion(-rot.x, -rot.y, rot.z, rot.w);
			newMesh.rotation = goodRot;
			newMesh.translation.z = -newMesh.translation.z;
			newMesh.applyTransformations();
			node.children.push(newMesh);
		}
		if (part.reflectPartSideways) {
			final newMesh = mesh.copy();
			// Reflect across YZ Plane
			final goodRot = new Quaternion(rot.x, -rot.y, -rot.z, rot.w);
			newMesh.rotation = goodRot;
			newMesh.translation.x = -newMesh.translation.x;
			newMesh.applyTransformations();
			node.children.push(newMesh);
		}
		if (part.reflectPartVertical) {
			final newMesh = mesh.copy();
			// Reflect across XZ Plane
			final goodRot = new Quaternion(-rot.x, rot.y, -rot.z, rot.w);
			newMesh.rotation = goodRot;
			newMesh.translation.y = -newMesh.translation.y;
			newMesh.applyTransformations();
			node.children.push(newMesh);
		}
	}

	static function expandThingAttributeFromJson(thing:Thing, attributes:Array<Int>) {
		if (attributes != null) {
			for (attr in attributes) {
				switch (cast(attr : ThingAttribute)) {
					case ThingAttribute.isClonable:
						thing.isClonable = true;
					case ThingAttribute.isHoldable:
						thing.isHoldable = true;
					case ThingAttribute.remainsHeld:
						thing.remainsHeld = true;
					case ThingAttribute.isClimbable:
						thing.isClimbable = true;
					case ThingAttribute.isPassable:
						thing.isPassable = true;
					case ThingAttribute.isUnwalkable:
						thing.isUnwalkable = true;
					case ThingAttribute.doSnapAngles:
						thing.doSnapAngles = true;
					case isBouncy:
						thing.isBouncy = true;
					case doShowDirection:
						thing.doShowDirection = true;
					case keepPreciseCollider:
						thing.keepPreciseCollider = true;
					case doesFloat:
						thing.doesFloat = true;
					case doesShatter:
						thing.doesShatter = true;
					case isSticky:
						thing.isSticky = true;
					case isSlidy:
						thing.isSlidey = true;
					case doSnapPosition:
						thing.doSnapPosition = true;
					case amplifySpeech:
						thing.amplifySpeech = true;
					case benefitsFromShowingAtDistance:
						thing.showAtDistance = true;
					case scaleAllParts:
						thing.scaleAllParts = true;
					case doSoftSnapAngles:
						thing.softSnapAngles = true;
					case doAlwaysMergeParts:
						thing.alwaysMergeParts = true;
					case addBodyWhenAttached:
						thing.addBodyWhenWorn = true;
					case hasSurroundSound:
						thing.hasSurrondSound = true;
					case canGetEventsWhenStateChanging:
						thing.canGetEventsWhenStateChanging = true;
					case replacesHandsWhenAttached:
						thing.replacesHandsWhenAttached = true;
					case mergeParticleSystems:
						thing.mergeParticleSystems = true;
					case isSittable:
						thing.isSittable = true;
					case smallEditMovements:
						thing.finetuneParts = true;
					case scaleEachPartUniformly:
						thing.scaleUniformally = true;
					case snapAllPartsToGrid:
						thing.snapAllPartsToGrid = true;
					case invisibleToUsWhenAttached:
						thing.invisibleWhenWorn = true;
					case replaceInstancesInArea:
						thing.replaceInstInArea = true;
					case addBodyWhenAttachedNonClearing:
						thing.addBodyWhenWornNonClearing = true;
					case avoidCastShadow:
						thing.dontCastShadow = true;
					case avoidReceiveShadow:
						thing.dontRecieveShadow = true;
					case omitAutoSounds:
						thing.omitAutoSounds = true;
					case omitAutoHapticFeedback:
						thing.omitAutoHapticFeedback = true;
					case keepSizeInInventory:
						thing.keepSizeInInventory = true;
					case autoAddReflectionPartsSideways:
						thing.reflectSideways = true;
					case autoAddReflectionPartsDepth:
						thing.reflectDepth = true;
					case autoAddReflectionPartsVertical:
						thing.reflectVertical = true;
					case activeEvenInInventory:
						thing.activeInInventory = true;
					case stricterPhysicsSyncing:
						thing.stricterPhysicsSyncing = true;
					case removeOriginalWhenGrabbed:
						thing.removeOriginalWhenGrabbed = true;
					case persistWhenThrownOrEmitted:
						thing.persistWhenThrownOrEmitted = true;
					case invisible:
						thing.invisible = true;
					case uncollidable:
						thing.uncollidable = true;
					case movableByEveryone:
						thing.movableByEveryone = true;
					case isNeverClonable:
						thing.isNeverClonable = true;
					case floatsOnLiquid:
						thing.floatsOnLiquid = true;
					case invisibleToDesktopCamera:
						thing.invisibleToDesktopCamera = true;
					default: // nothing : )
				}
			}
			// No suppress holdable here :sunglasses:
		}
	}

	static function expandPartAttributeFromJson(part:ThingPart, attributes:Array<Int>) {
		if (attributes != null) {
			for (attr in attributes) {
				switch (cast(attr : ThingPartAttribute)) {
					case ThingPartAttribute.offersScreen:
						part.offersScreen = true;
					case scalesUniformly:
						part.scalesUniformally = true;
					case videoScreenHasSurroundSound:
						part.screenSurrondSound = true;
					case isLiquid:
						part.isLiquid = true;
					case offersSlideshowScreen:
						part.offersSlideshow = true;
					case isCamera:
						part.isCamera = true;
					case isFishEyeCamera:
						part.isFisheyeCamera = true;
					case useUnsoftenedAnimations:
						part.useUnsoftenedAnim = true;
					case invisible:
						part.partInvisible = true;
					case isUnremovableCenter:
						part.isCenter = true;
					case omitAutoSounds:
						part.omitAutoSoundsPart = true;
					case doSnapTextureAngles:
						part.doTextureSnapAngles = true;
					case textureScalesUniformly:
						part.textureScalesUniformally = true;
					case avoidCastShadow:
						part.avoidCastShadow = true;
					case looselyCoupledParticles:
						part.looselyCoupledParticles = true;
					case textAlignCenter:
						part.textAlignCenter = true;
					case textAlignRight:
						part.textAlignRight = true;
					case isAngleLocker:
						part.isAngleLocker = true;
					case isPositionLocker:
						part.isPositionLocker = true;
					case isLocked:
						part.isLocked = true;
					case avoidReceiveShadow:
						part.avoidRecieveShadow = true;
					case isImagePasteScreen:
						part.isImagePasteScreen = true;
					case allowBlackImageBackgrounds:
						part.allowBlackImageBackgrounds = true;
					case videoScreenLoops:
						part.videoScreenLoops = true;
					case videoScreenIsDirectlyOnMesh:
						part.videoScreenIsDirectlyOnMesh = true;
					case useTextureAsSky:
						part.useTextureAsSky = true;
					case stretchSkydomeSeam:
						part.stretchSkydomeSeam = true;
					case subThingsFollowDelayed:
						part.subthingFollowDelayed = true;
					case hasReflectionPartSideways:
						part.reflectPartSideways = true;
					case hasReflectionPartVertical:
						part.reflectPartVertical = true;
					case hasReflectionPartDepth:
						part.reflectPartDepth = true;
					case videoScreenFlipsX:
						part.screenFlipsX = true;
					case persistStates:
						part.persistStates = true;
					case uncollidable:
						part.partUncollidable = true;
					case isDedicatedCollider:
						part.isDedicatedCollider = true;
					case personalExperience:
						part.personalExperience = true;
					case invisibleToUsWhenAttached:
						part.partInvisbleWhenWorn = true;
					case lightOmitsShadow:
						part.lightOmitsShadow = true;
					case showDirectionArrowsWhenEditing:
						part.showDirectionalArrowsWhenEditing = true;
					case isVideoButton:
						part.isVideoButton = true;
					case isSlideshowButton:
						part.isSlideshowButton = true;
					case isCameraButton:
						part.isCameraButton = true;
				}
			}
		}
	}

	static function expandIncludedSubThingInvertAttributes(subThing:SubThingInfo, attributes:Array<Int>) {
		if (attributes != null)
			for (attr in attributes) {
				switch (cast(attr : ThingAttribute)) {
					case ThingAttribute.isHoldable:
						subThing.invertIsHoldable = true;
					case invisible:
						subThing.invertInvisible = true;
					case uncollidable:
						subThing.invertUncollidable = true;
					default: // : ) Waste of JSON Space but you do you philipp
				}
			}
	}

	/*
		public static function exportBytes(thing:Thing) {
			var buf = new BytesBuffer();
			var changedVertsIndex:Map<String, Int> = [];
			if (thing.version > Thing.currentVersion)
				thing.version = Thing.currentVersion;
			// Write version first, so it'll be easier to parse later
			buf.addByte(thing.version);
			if (thing.givenName == null || thing.givenName == "")
				thing.givenName = Thing.defaultName;
			writeStringWLength(buf, thing.givenName);
			if (thing.description == null)
				thing.description = "";

			writeStringWLength(buf, thing.description);
			buf.addInt64(getAttributes(thing));
			// Map may be empty; that's ok! If we see a 0 when reading that means "Ignore this"
			writeStringMap(buf, thing.includedThingIds);
			// We can omit this because when reading, we'll read attributes first
			// which will tell us if htis is needed
			if (thing.addBodyWhenWorn || thing.addBodyWhenWornNonClearing)
				writeStringArray(buf, thing.bodyAttachments);
			buf.addInt32(thing.parts.length);
			var iInThing = 0;
			for (part in thing.parts) {
				buf.addInt64(getPartAttributes(part));
				buf.addByte(part.baseType);
				buf.addByte(part.materialType);
				buf.addByte(part.particleSystem);
				buf.addByte(part.textureTypes[0]);
				buf.addByte(part.textureTypes[1]);
				writeStringWLength(buf, part.guid);
				writeStringWLength(buf, part.givenName);
				if (part.isText) {
					buf.addFloat(part.textLineHeight);
					writeStringWLength(buf, part.text);
				}
				writeIncludedSubthings(buf, thing, part);
				writePlacedSubthings(buf, part);

				if (part.imageUrl == null || part.imageUrl.length == 0) 
					buf.addInt32(0);
				else {
					buf.addStringWLength(part.imageUrl);
					buf.addByte(part.imageType);
				}
				if (part.autoContinuation == null)
					buf.addInt32(0);
				else 
					part.autoContinuation.writeBytes(buf);
				writeChangedVertices(buf, part, changedVertsIndex, iInThing);
				if (part.smoothingAngle != null) {
					buf.addInt32(part.smoothingAngle);
				} else {
					// because 361 isn't specified as an angle : )
					buf.addInt32(361);
				}
				buf.addByte(part.convex != null ? (part.convex ? 1 : 0) : 2);
				writeStateBytes(buf, part);
				iInThing++;
			}
			return buf.getBytes();
		}
		static function writeIncludedSubthings(buf:BytesBuffer, thing:Thing, part:ThingPart) {
			if (part.includedSubThings == null) {
				buf.addInt32(0);
				return;
			}
			buf.addInt32(part.includedSubThings.length);
			for (iSubThing in part.includedSubThings) {
				writeStringWLength(buf, iSubThing.thingId);
				buf.addFloatTriplet(iSubThing.pos);
				buf.addFloatTriplet(iSubThing.rot);
				writeStringWLength(buf, iSubThing.nameOverride != null ? iSubThing.nameOverride : thing.givenName);
				buf.addByte(getSubthingAttr(iSubThing));
			}
		}
		static function writePlacedSubthings(buf:BytesBuffer, part:ThingPart) {
			if (part.placedSubThings == null) {
				buf.addInt32(0);
				return;
			}
			buf.addInt32(Lambda.count(part.placedSubThings));
			for (placementId => pSubThing in part.placedSubThings) {
				buf.addStringWLength(placementId);
				buf.addStringWLength(pSubThing.thingId);
				buf.addFloatTriplet(pSubThing.pos);
				buf.addFloatTriplet(pSubThing.rot);
			}
		}
		static function getSubthingAttr(subthing:SubThingInfo) {
			var bits:UInt = 0;
			if (subthing.invertUncollidable) bits |= SubThingAttr.invertUncollidable;
			if (subthing.invertInvisible) bits |= SubThingAttr.invertInvisible;
			if (subthing.invertIsHoldable) bits |= SubThingAttr.invertIsHoldable;
			return bits;
		}
		static function removeUnusedPartGuids(thing:Thing) {
			for (part in thing.parts) {
				if (part.guid != null && part.guid != "" && !isPartGuidUsed(thing, part.guid, part))
					part.guid = null;
			}
		}
		static function isPartGuidUsed(thing:Thing, guid:String, ignorePart:ThingPart) {
			for (part in thing.parts) {
				if (part != ignorePart && part.autoContinuation != null &&part.autoContinuation.fromPart.guid == guid )
					return true;
			}
			return false;
		}
		static function writeStringMap(buf:BytesBuffer, map:Map<String,String>) {
			buf.addInt32(Lambda.count(map));
			for (key => value in map) {
				writeStringWLength(buf, key);
				writeStringWLength(buf,value);
			}
		}
		static function writeStringArray(buf:BytesBuffer, array:Array<String>) {
			buf.addInt32(array.length);
			for (value in array) {
				writeStringWLength(buf, value);
			}
		}
		public static function writeStringWLength(buf:BytesBuffer, string:Null<String>) {
			if (string != null) {
				buf.addInt32(string.length);
				buf.addString(string, UTF8);
			} else {
				buf.addInt32(0);
			}
			
		}
		static function writeChangedVertices(buf:BytesBuffer, part:ThingPart, changedVertsIndexRef:Map<String, Int>, indexWithinThing:Int) {
			var indicesByPosition:Map<Vector3, Array<Int>> = [];
			var addedThings:Array<String> = [];
			for (index => pos in part.changedVerticies) {
				var unityPos = pos;
				// I think this is only made by us so we will have the references??? Busted
				if (!addedThings.contains(Std.string(unityPos))) {
					var indices:Array<Int> = [];
					for (innerIndex => innerPos in part.changedVerticies) {
						// this is ok because abstracts  : )
						if (innerPos == pos) { 
							// it's now absolute : )
							// Not like it costs any damn storage space
							indices.push(innerIndex);
						}
					}
					indicesByPosition.set(unityPos, indices);
					addedThings.push(Std.string(unityPos));
				}
			}
			var indLength = Lambda.count(indicesByPosition);
			buf.addInt32(indLength);
			for (key => value in indicesByPosition) {
				buf.addFloatTriplet(key);
				buf.addIntArray(value);
				

			}
		}

		static function writeStateBytes(buf:BytesBuffer, part:ThingPart) {
			// byte because there is a hard limit at like 50 iirc
			buf.addByte(part.states.length);
			for (state in part.states) {

				buf.addFloatTriplet(state.position);
				buf.addFloatTriplet(state.rotation);
				buf.addFloatTriplet(state.scale);
				buf.addInt32(state.color);
				writeStringArray(buf, state.scriptLines);
				if (part.textureTypes[0] != None)
					writeStateTextureBytes(buf, part, state, 0);
				if (part.textureTypes[1] != None)
					writeStateTextureBytes(buf, part, state, 1);
				if (part.particleSystem != None)
					writeStateParticleBytes(buf, part, state);
			}
		}
	 */
	static var textureTypeWithOnlyAlphaSetting = [TextureTypes.SideGlow, TextureTypes.Wireframe, TextureTypes.Outline];
	static var particleSystemWithOnlyAlphaSetting:Array<ParticleSystemType> = [
		NoisyWater, GroundSmoke, Rain, Fog, TwistedSmoke, Embers, Beams, Rays, CircularSmoke, PopSmoke, WaterFlow, WaterFlowSoft, Sparks, Flame
	];

	static function textureAlphaCap(textureType:TextureTypes) {
		switch (textureType) {
			case QuasiCrystal | VoronoiDots | VoronoiPolys | WavyLines | WoodGrain | Machine | Dashes | SquareRegress | Swirly:
				return 128;
			default:
				return 255;
		}
	}
	/*
		static function writeStateTextureBytes(buf:BytesBuffer, part:ThingPart, state:ThingPartState, index:Int) {
			buf.addInt32(state.textureColors[index]);
			var withOnlyAlphaSetting = textureTypeWithOnlyAlphaSetting.contains(part.textureTypes[index]);
			if (withOnlyAlphaSetting) {
				// Byte because there should be less than 256 keys lmao
				buf.addByte(1);
				buf.addByte(TextureProperty.Strength);
				buf.addFloat(state.textureProperties[index].get(Strength));
			} else {
				buf.addByte(10);
				for (property in 0...10) {
					buf.addByte(property);
					buf.addFloat(state.textureProperties[index].get(property));
				}
			}
		}
		static function writeStateParticleBytes(buf:BytesBuffer, part:ThingPart, state:ThingPartState) {
			buf.addInt32(state.particleSystemColor);
			final withOnlyAlphaSetting = particleSystemWithOnlyAlphaSetting.contains(part.particleSystem);
			if (withOnlyAlphaSetting) {
				buf.addByte(1);
				buf.addByte(ParticleSystemProperty.Alpha);
				buf.addFloat(state.particleSystemProperty.get(Alpha));
			} else {
				buf.addByte(6);
				for (prop in 0...6) {
					buf.addByte(prop);
					buf.addFloat(state.particleSystemProperty.get(prop));
				}
			}
		}
		static function getAttributes(thing:Thing) {
			var lowerBits:LowerThingAttribute = 0;
			var higherBits:HigherThingAttribute = 0;
			if (thing.isClonable) lowerBits |= isClonable;
			if (thing.isHoldable) lowerBits |= isHoldable;
			if (thing.remainsHeld) lowerBits |= remainsHeld;
			if (thing.isClimbable) lowerBits |= isClimbable;
			if (thing.isPassable) lowerBits |= isPassable;
			if (thing.isUnwalkable) lowerBits |= isUnwalkable;
			if (thing.doSnapAngles) lowerBits |= doSnapAngles;
			if (thing.isBouncy) lowerBits |= isBouncy;
			if (thing.doShowDirection) lowerBits |= doShowDirection;
			if (thing.keepPreciseCollider) lowerBits |= keepPreciseCollider;
			if (thing.doesFloat) lowerBits |= doesFloat;
			if (thing.doesShatter) lowerBits |= doesShatter;
			if (thing.isSticky) lowerBits |= isSticky;
			if (thing.isSlidey) lowerBits |= isSlidey;
			if (thing.doSnapPosition) lowerBits |= doSnapPosition;
			if (thing.amplifySpeech) lowerBits |= amplifySpeech;
			if (thing.showAtDistance) lowerBits |= showAtDistance;
			if (thing.scaleAllParts) lowerBits |= scaleAllParts;
			if (thing.softSnapAngles) lowerBits |= softSnapAngles;
			if (thing.alwaysMergeParts) lowerBits |= alwaysMergeParts;
			if (thing.addBodyWhenWorn) lowerBits |= addBodyWhenWorn;
			if (thing.hasSurrondSound) lowerBits |= hasSurrondSound;
			if (thing.canGetEventsWhenStateChanging) lowerBits |= canGetEventsWhenStateChanging;
			if (thing.replacesHandsWhenAttached) lowerBits |= replacesHandsWhenAttached;
			if (thing.mergeParticleSystems) lowerBits |= mergeParticleSystems;
			if (thing.isSittable) lowerBits |= isSittable;
			if (thing.finetuneParts) lowerBits |= finetuneParts;
			if (thing.scaleUniformally) lowerBits |= scaleUniformly;
			if (thing.snapAllPartsToGrid) lowerBits |= snapAllPartsToGrid;
			if (thing.invisibleWhenWorn) lowerBits |= invisibleWhenWorn;

			if (thing.replaceInstInArea) higherBits |= replaceInstInArea;
			if (thing.addBodyWhenWornNonClearing) higherBits |= addBodyWhenWornNonClearing;
			if (thing.dontCastShadow) higherBits |= dontCastShadow;
			if (thing.dontRecieveShadow) higherBits |= dontReceiveShadow;
			if (thing.omitAutoSounds) higherBits |= omitAutoSounds;
			if (thing.omitAutoHapticFeedback) higherBits |= omitAutoHapticFeedback;
			if (thing.keepSizeInInventory) higherBits |= keepSizeInInventory;
			if (thing.reflectSideways) higherBits |= reflectSideways;
			if (thing.reflectVertical) higherBits |= reflectVertical;
			if (thing.reflectDepth) higherBits |= reflectDepth;
			if (thing.activeInInventory) higherBits |= activeInInventory;
			if (thing.stricterPhysicsSyncing) higherBits |= stricterPhysicsSyncing;
			if (thing.removeOriginalWhenGrabbed) higherBits |= removeOriginalWhenGrabbed;
			if (thing.persistWhenThrownOrEmitted) higherBits |= persistWhenThrownOrEmitted;
			if (thing.invisible) higherBits |= invisible;
			if (thing.uncollidable) higherBits |= uncollidable;
			if (thing.movableByEveryone) higherBits |= movableByEveryone;
			if (thing.isNeverClonable) higherBits |= isNeverClonable;
			if (thing.floatsOnLiquid) higherBits |= floatsOnLiquid;
			if (thing.invisibleToDesktopCamera) higherBits |= invisibleToDesktopCamera;
			if (thing.personalExperience) higherBits |= personalExperience;
			return Int64.make(higherBits, lowerBits);
		}

		static function getPartAttributes(part:ThingPart) {
			var higherBits:HigherThingPartAttribute = 0;
			var lowerBits:LowerThingPartAttribute = 0;
			if (part.offersScreen) lowerBits |= offersScreen;
			if (part.isVideoButton) lowerBits |= isVideoButton;
			if (part.scalesUniformally) lowerBits |= scalesUniformally;
			if (part.screenSurrondSound) lowerBits |= screenSurrondSound;
			if (part.isLiquid) lowerBits |= isLiquid;
			if (part.offersSlideshow) lowerBits |= offersSlideshow;
			if (part.isSlideshowButton) lowerBits |= isSlideshowButton;
			if (part.isCamera) lowerBits |= isCamera;
			if (part.isCameraButton) lowerBits |= isCameraButton;
			if (part.isFisheyeCamera) lowerBits |= isFisheyeCamera;
			if (part.useUnsoftenedAnim) lowerBits |= useUnsoftenedAnim;
			if (part.partInvisible) lowerBits |= partInvisible;
			if (part.isCenter) lowerBits |= isCenter;
			if (part.omitAutoSoundsPart) lowerBits |= omitAutoSoundsPart;
			if (part.doTextureSnapAngles) lowerBits |= doTextureSnapAngles;
			if (part.textureScalesUniformally) lowerBits |= textureScalesUniformally;
			if (part.textAlignCenter) lowerBits |= textAlignCenter;
			if (part.textAlignRight) lowerBits |= textAlignRight;
			if (part.isAngleLocker) lowerBits |= isAngleLocker;
			if (part.isPositionLocker) lowerBits |= isPositionLocker;
			if (part.isLocked) lowerBits |= isLocked;
			if (part.avoidRecieveShadow) lowerBits |= avoidRecieveShadow;
			if (part.isImagePasteScreen) lowerBits |= isImagePasteScreen;
			if (part.allowBlackImageBackgrounds) lowerBits |= allowBlackImageBackgrounds;
			if (part.videoScreenLoops) lowerBits |= videoScreenLoops;
			if (part.videoScreenIsDirectlyOnMesh) lowerBits |= videoScreenIsDirectlyOnMesh;
			if (part.useTextureAsSky) lowerBits |= useTextureAsSky;
			if (part.stretchSkydomeSeam) lowerBits |= stretchSkydomeSeam;
			if (part.subthingFollowDelayed) lowerBits |= subthingFollowDelayed;
			if (part.reflectPartSideways) lowerBits |= reflectPartSideways;

			if (part.reflectPartDepth) higherBits |= reflectPartDepth;
			if (part.reflectPartVertical) higherBits |= reflectPartVertical;
			if (part.screenFlipsX) higherBits |= screenFlipsX;
			if (part.persistStates) higherBits |= persistStates;
			if (part.partUncollidable) higherBits |= partUncollidable;
			if (part.isDedicatedCollider) higherBits |= isDedicatedCollider;
			if (part.personalExperience) higherBits |= personalExperiencePart;
			if (part.partInvisbleWhenWorn) higherBits |= partInvisbleWhenWorn;
			if (part.lightOmitsShadow) higherBits |= lightOmitsShadow;
			if (part.showDirectionalArrowsWhenEditing) higherBits |= showDirectionalArrowsWhenEditing;
			if (part.isText) higherBits |= isText;
			return Int64.make(higherBits, lowerBits);

	}*/
}
