package objhandler;

import haxe.io.BytesBuffer;
import bulby.BulbyMath;
import bulby.assets.Node;
typedef TGLTF = {
    @:optional var extensionsUsed:Array<String>;
    @:optional var extensionsRequired:Array<String>;
    @:optional var accessors:Array<TAccessor>;
    // Skip animations; we'll never use it and it can be safely ignored
    var asset:TAsset;
    @:optional var buffers:Array<TBuffer>;
    @:optional var bufferViews:Array<TBufferView>;
    @:optional var meshes:Array<TMesh>;
    @:optional var nodes:Array<TNode>;
    @:optional var scenes:Array<TScene>;
    @:optional var scene:TGLTFID;
    // skins are unused, so we don't specify them
    @:optional var samplers:Array<TSampler>;
    @:optional var textures:Array<TTexture>;
    @:optional var images:Array<TImage>;
    @:optional var materials:Array<TMaterial>;

}
typedef TMaterial = {
	> TGLTFChildOfRoot,

	/**
	 *  A set of parameter values that are used to define the metallic-roughness material model from Physically-Based Rendering (PBR) methodology. When not specified, all the default values of `pbrMetallicRoughness` apply.
	 */
	@:optional var pbrMetallicRoughness:TMaterialPBRMetallicRoughness;

	/**
	 *  A tangent space normal map. The texture contains RGB components in linear space. Each texel represents the XYZ components of a normal vector in tangent space. Red [0 to 255] maps to X [-1 to 1]. Green [0 to 255] maps to Y [-1 to 1]. Blue [128 to 255] maps to Z [1/255 to 1]. The normal vectors use OpenGL conventions where +X is right and +Y is up. +Z points toward the viewer. In GLSL, this vector would be unpacked like so: `float3 normalVector = tex2D(<sampled normal map texture value>, texCoord) * 2 - 1`.
	 */
	@:optional var normalTexture:TMaterialNormalTextureInfo;


	/**
	 *  The emissive map controls the color and intensity of the light being emitted by the material. This texture contains RGB components in sRGB color space. If a fourth component (A) is present, it is ignored.
	 */
	@:optional var emissiveTexture:TTextureInfo;

	/**
	 *  The RGB components of the emissive color of the material. These values are linear. If an emissiveTexture is specified, this value is multiplied with the texel values.
	 */
	@:optional var emissiveFactor:Array<Float>;

	/**
	 *  The material's alpha rendering mode enumeration specifying the interpretation of the alpha value of the main factor and texture.
	 */
	@:optional var alphaMode:TAlphaMode;

	/**
	 *  Specifies the cutoff threshold when in `MASK` mode. If the alpha value is greater than or equal to this value then it is rendered as fully opaque, otherwise, it is rendered as fully transparent. A value greater than 1.0 will render the entire material as fully transparent. This value is ignored for other modes.
	 */
	@:optional var alphaCutoff:Float;

	/**
	 *  Specifies whether the material is double sided. When this value is false, back-face culling is enabled. When this value is true, back-face culling is disabled and double sided lighting is enabled. The back-face must have its normals reversed before the lighting equation is evaluated.
	 */
	@:optional var doubleSided:Bool;

    @:optional var extensions:Dynamic;
}
@:enum abstract TAlphaMode(String) {
	/**
	 *  The alpha value is ignored and the rendered output is fully opaque.
	 */
	var OPAQUE = "OPAQUE";

	/**
	 *  The rendered output is either fully opaque or fully transparent depending on the alpha value and the specified alpha cutoff value.
	 */
	var MASK = "MASK";

	/**
	 *  The alpha value is used to composite the source and destination areas. The rendered output is combined with the background using the normal painting operation (i.e. the Porter and Duff over operator).
	 */
	var BLEND = "BLEND";
}
typedef TMaterialNormalTextureInfo = {
	> TTextureInfo,

	/**
	 *  The scalar multiplier applied to each normal vector of the texture. This value scales the normal vector using the formula: `scaledNormal =  normalize((normalize(<sampled normal texture value>) * 2.0 - 1.0) * vec3(<normal scale>, <normal scale>, 1.0))`. This value is ignored if normalTexture is not specified. This value is linear.
	 */
	@:optional var scale:Float;
}
typedef TTextureInfo = {
	> TGLTFProperty,

	/**
	 *  The index of the texture.
	 */
	var index:TGLTFID;

	/**
	 *  This integer value is used to construct a string in the format TEXCOORD_<set index> which is a reference to a key in mesh.primitives.attributes (e.g. A value of 0 corresponds to TEXCOORD_0).
	 */
	@:optional var texCoord:Int;
}
typedef TSampler = {
    @:optional var magFilter:TMagFilter;
    @:optional var minFilter:TMinFilter;
    @:optional var wrapS:TWrapMode;
    @:optional var wrapT:TWrapMode;
}
typedef TImage = {
    @:optional var uri:String;
    var mimeType:String;
    @:optional var bufferView:TGLTFID;
}
@:enum abstract TImageMimeType(String) {
	var JPEG = "image/jpeg";
	var PNG = "image/png";
}
typedef TGLTFProperty = {
	@:optional var extensions:Dynamic;
	@:optional var extras:Dynamic;
}
typedef TMaterialPBRMetallicRoughness = {
	> TGLTFProperty,

	/**
	 *  The RGBA components of the base color of the material. The fourth component (A) is the alpha coverage of the material. The `alphaMode` property specifies how alpha is interpreted. These values are linear. If a baseColorTexture is specified, this value is multiplied with the texel values.
	 */
	@:optional var baseColorFactor:Array<Float>;

	/**
	 *  The base color texture. This texture contains RGB(A) components in sRGB color space. The first three components (RGB) specify the base color of the material. If the fourth component (A) is present, it represents the alpha coverage of the material. Otherwise, an alpha of 1.0 is assumed. The `alphaMode` property specifies how alpha is interpreted. The stored texels must not be premultiplied.
	 */
	@:optional var baseColorTexture:TTextureInfo;

	/**
	 *  The metalness of the material. A value of 1.0 means the material is a metal. A value of 0.0 means the material is a dielectric. Values in between are for blending between metals and dielectrics such as dirty metallic surfaces. This value is linear. If a metallicRoughnessTexture is specified, this value is multiplied with the metallic texel values.
	 */
	@:optional var metallicFactor:Float;

	/**
	 *  The roughness of the material. A value of 1.0 means the material is completely rough. A value of 0.0 means the material is completely smooth. This value is linear. If a metallicRoughnessTexture is specified, this value is multiplied with the roughness texel values.
	 */
	@:optional var roughnessFactor:Float;

	/**
	 *  The metallic-roughness texture. The metalness values are sampled from the B channel. The roughness values are sampled from the G channel. These values are linear. If other channels are present (R or A), they are ignored for metallic-roughness calculations.
	 */
	@:optional var metallicRoughnessTexture:TTextureInfo;
}
typedef TTexture = {
    >TGLTFChildOfRoot, 
    @:optional var sampler:TGLTFID;
    @:optional var source:TGLTFID;
}
@:enum abstract TMagFilter(Int) {
	var NEAREST = 9728;
	var LINEAR = 9729;
}
@:enum abstract TMinFilter(Int) {
	var NEAREST = 9728;
	var LINEAR = 9729;
	var NEAREST_MIPMAP_NEAREST = 9984;
	var LINEAR_MIPMAP_NEAREST = 9985;
	var NEAREST_MIPMAP_LINEAR = 9986;
	var LINEAR_MIPMAP_LINEAR = 9987;
}
@:enum abstract TWrapMode(Int) {
	var CLAMP_TO_EDGE = 33071;
	var MIRROR_REPEAT = 33648;
	var REPEAT = 10497;
}
typedef TScene = {
    >TGLTFChildOfRoot,
    var nodes:Array<TGLTFID>;
}
typedef TNode = {
    >TGLTFChildOfRoot,
    @:optional var mesh:TGLTFID;
}
typedef TBuffer = {
    var byteLength:Int;
    @:optional var uri:String;
}
typedef TBufferView = {
    var buffer:TGLTFID;
    @:optional var byteOffset:Int;
    var byteLength:Int;
    @:optional var byteStride:Int;
    @:optional var target:TBufferTarget;
}
enum abstract TBufferTarget(Int) {
	var ARRAY_BUFFER = 34962;
	var ELEMENT_ARRAY_BUFFER = 34963;
}
typedef TAsset = {
    @:optional var generator:String;
    var version:String;
    @:optional var minVersion:String;
}
typedef TGLTFID = Int;
typedef TGLTFChildOfRoot = {
  @:optional var name:String;  
};
enum abstract TComponentType(Int) {
    var BYTE = 5120;
    var UNSIGNED_BYTE = 5121;
    var SHORT = 5122;
    var UNSIGNED_SHORT = 5123;
    var UNSIGNED_INT = 5125;
    var FLOAT = 5126;
}
enum abstract TAttributeType(String) {
    var SCALAR;
    var VEC2;
    var VEC3;
    var VEC4;
    var MAT2;
    var MAT3;
    var MAT4;
}
typedef TAccessor = {
    >TGLTFChildOfRoot,
    @:optional var bufferView:TGLTFID;
    @:optional var byteOffset:Int;
    var componentType:TComponentType;
    @:optional var normalized:Bool;
    var count:Int;
    var type:TAttributeType;
    @:optional var max:Array<Float>;
    @:optional var min:Array<Float>;
}
typedef TMesh = {
    >TGLTFChildOfRoot,
    var primitives:Array<TPrimitive>;
    @:optional var weights:Array<Int>;
}
typedef TPrimitive = {
    >TGLTFChildOfRoot,
    var attributes:Dynamic;
    @:optional var indices:TGLTFID;
    @:optional var material:TGLTFID;
    // ignore morph targets & mode

}

class GlTFExporter {
    public static function exportMesh(node:Node) {
        var gltf:TGLTF = {
            asset: {
                "generator": "Bulby's Anyland Thing converter",
                "version": "2.0"
            },
            extensionsUsed: ["KHR_materials_unlit"]
        };
        var buf = new BytesBuffer();
        var compatMeshes:Array<GLTFCompatMesh> = [];
        for (mesh in node.children) {
            compatMeshes.push(GLTFCompatMesh.fromMesh(mesh));

        }
        var usedMats:Map<String, Int> = [];
        var mats:Array<TMaterial> = [];
        var bufferViews:Array<TBufferView> = [];
        var primitives:Array<TPrimitive> = [];
        var accessors:Array<TAccessor> = [];
        var b = 0;
        var m = 0;
        for (compatMesh in compatMeshes) {
            if (!usedMats.exists(compatMesh.material.name)) {
                usedMats.set(compatMesh.material.name, m);
                var mat:TMaterial = {
                    name: compatMesh.material.name,
                    pbrMetallicRoughness: {
                        baseColorFactor: [
                            compatMesh.material.diffuse.r,
                            compatMesh.material.diffuse.g,
                            compatMesh.material.diffuse.b,
                            compatMesh.material.alpha
                        ],
                        metallicFactor: 0
                    },
                    // don't waste time on blending if it's opaque
                    alphaMode: compatMesh.material.alpha == 1 ? OPAQUE : BLEND
                };
                if (compatMesh.material.isUnshaded)
                    mat.extensions = {
                        "KHR_materials_unlit": {}
                    };
                mats.push(mat);
                m++;
            }
            var posView:TBufferView = {
                buffer: 0,
                byteLength: 0,
                target: ELEMENT_ARRAY_BUFFER
            };
            var normView:TBufferView = {
                buffer: 0,
                byteLength: 0,
                target: ELEMENT_ARRAY_BUFFER
            };
            var uvView:TBufferView = {
                buffer: 0,
                byteLength: 0,
                target: ELEMENT_ARRAY_BUFFER
            };
            var curBufPos = buf.length;
			var min:Vector3 = new Vector3(compatMesh.verticies[0].position.x, compatMesh.verticies[0].position.y, compatMesh.verticies[0].position.z);
			var max:Vector3 = new Vector3(compatMesh.verticies[0].position.x, compatMesh.verticies[0].position.y, compatMesh.verticies[0].position.z);
            for (vert in compatMesh.verticies) {
                buf.addFloat(vert.position.x);
                buf.addFloat(vert.position.y);
                buf.addFloat(vert.position.z);
                if (vert.position.x < min.x) min.x = vert.position.x;
                if (vert.position.y < min.y) min.y = vert.position.y;
                if (vert.position.z < min.z) min.z = vert.position.z;
                if (vert.position.x > max.x) max.x = vert.position.x;
                if (vert.position.y > max.y) max.y = vert.position.y;
                if (vert.position.z > max.z) max.z = vert.position.z;
            }
            var newBufPos = buf.length;
            posView.byteLength = newBufPos - curBufPos;
            posView.byteOffset = curBufPos;
            curBufPos = newBufPos;
            for (vert in compatMesh.verticies) {
                buf.addFloat(vert.normal.x);
                buf.addFloat(vert.normal.y);
                buf.addFloat(vert.normal.z);
            }
            newBufPos = buf.length;
            normView.byteLength = newBufPos - curBufPos;
            normView.byteOffset = curBufPos;
            curBufPos = newBufPos;
            for (vert in compatMesh.verticies) {
                buf.addFloat(vert.uv.x);
                buf.addFloat(vert.uv.y);
            }
            newBufPos = buf.length;
            uvView.byteLength = newBufPos - curBufPos;
            uvView.byteOffset = curBufPos;
            curBufPos = newBufPos;
            // acts as unsigned even tho it isn't in haxe
            var vertCount = 0;
            for (face in compatMesh.faces) {
                for (i in face) {
                    buf.addInt32(i);
                    vertCount++;
                }
            }
            var newBufPos = buf.length;
            var indView:TBufferView = {
                buffer: 0,
                byteLength: newBufPos - curBufPos,
                byteOffset: curBufPos
            };
            
            bufferViews.push(posView);
            bufferViews.push(normView);
            bufferViews.push(uvView);
            bufferViews.push(indView);
            // position accessors MUST have min + max
            accessors.push({
                bufferView: b,
                byteOffset: 0,
                componentType: FLOAT,
                type: VEC3,
                count: compatMesh.verticies.length,
                min: min.toArray(),
                max: max.toArray()
            });
            accessors.push({
                bufferView: b + 1,
                byteOffset: 0,
                componentType: FLOAT,
                type: VEC3,
                count: compatMesh.verticies.length
            });
            accessors.push({
                bufferView: b + 2,
                byteOffset: 0,
                componentType: FLOAT,
                type: VEC2,
                count: compatMesh.verticies.length
            });
            accessors.push({
                bufferView: b + 3,
                byteOffset: 0,
                componentType: UNSIGNED_INT,
                type: SCALAR,
                count: vertCount
            });
            var prim:TPrimitive = {
                attributes: {
                    POSITION: b,
                    NORMAL: b + 1,
                    TEXCOORD_0: b + 2
                },
                indices: b + 3,
                material: usedMats.get(compatMesh.material.name)
            };
            primitives.push(prim);
            b += 4;
        }
        gltf.accessors = accessors;
        gltf.bufferViews = bufferViews;
        gltf.materials = mats;
        gltf.meshes = [{
            name: "output",
            primitives: primitives
        }];
        gltf.nodes = [{
            name: "output",
            mesh: 0
        }];
        gltf.scenes = [{
            name: "Scene",
            nodes: [
                0
            ]
        }];
        gltf.scene = 0;
        gltf.buffers = [
            {
                byteLength: buf.length,
                uri: "data:application/octet-stream;base64," + haxe.crypto.Base64.encode(buf.getBytes())
            }
        ];
        return gltf;
    }
}