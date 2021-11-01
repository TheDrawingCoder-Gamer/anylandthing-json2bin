package bulby.assets;

import haxe.io.Bytes;
import haxe.Json;
import bulby.BulbyMath;
import haxe.io.BytesBuffer;
import bulby.assets.mat.Material;
import bulby.assets.b3d.Vertex;
import bulby.cloner.Cloner;
import bulby.assets.Mesh;
import bulby.BulbyMath.roundf;
import bulby.assets.gltf.schema.*;
class Node {
    public var children:Array<Mesh>;
    public function new(children:Array<Mesh>) {
        this.children = children;
    }
    /**
     * Returns a mesh that is a merge of all children. Note scaling does NOT reset and is taken into account.
     */
    
    public function mergeAllChildren() {
        var mesh = new Mesh([], [], [], [], false);
        var totalP = 0;
        var totalU = 0;
        var totalN = 0;
        for (child in children) {
            var cChild = Cloner.clone(child);
            

            for (face in cChild.faces) {
                for (vert in face) {
                    vert.normal += totalN;
                    vert.position += totalP;
                    vert.uv += totalU;
                }
            }
			totalP += cChild.positions.length;
			totalU += cChild.uvs.length;
			totalN += cChild.normals.length;
            mesh.faces = mesh.faces.concat(cChild.faces);
            mesh.displayNormals = mesh.normals.concat(cChild.displayNormals);
            mesh.displayPositions = mesh.positions.concat(cChild.displayPositions);
            mesh.uvs = mesh.uvs.concat(cChild.uvs);
        }
        mesh.normals = mesh.displayNormals;
        mesh.positions = mesh.displayPositions;
        mesh.optimize();
        return mesh;
    }
	/*
    public function toObj() {
		var file = "# Export of Bulby's Anyland converter \nmtllib output.mtl\ng ALThing\n";
		for (mesh in this.children) {
			for (pos in mesh.displayPositions) {
				file += 'v ${roundf(pos.x, 7)} ${roundf(pos.y, 7)} ${roundf(pos.z, 7)}\n';
			}
		}
		for (mesh in this.children) {
			for (normal in mesh.displayNormals) {
				file += 'vn ${roundf(normal.x, 7)} ${roundf(normal.y, 7)} ${roundf(normal.z, 7)}\n';
			}
		}
		for (mesh in this.children) {
			for (uv in mesh.uvs) {
				file += 'vt ${roundf(uv.x, 7)} ${roundf(uv.y, 7)}\n';
			}
		}
		var totalP = 0;
		var totalU = 0;
		var totalN = 0;
		for (mesh in this.children) {
			file += 'usemtl ${mesh.material.name}\n';
			for (face in mesh.faces) {
				final v1 = face.v1;
				final v2 = face.v2;
				final v3 = face.v3;
				file += 'f ${v1.position + 1 + totalP}/${v1.uv + 1 + totalU}/${v1.normal + 1 + totalN} ${v2.position + 1 + totalP}/${v2.uv + 1 + totalU}/${v2.normal + 1 + totalN} ${v3.position + 1 + totalP}/${v3.uv + 1 + totalU}/${v3.normal + 1 + totalN}\n';
			}
			totalP += mesh.positions.length;
			totalU += mesh.uvs.length;
			totalN += mesh.normals.length;
		}
		var mtl = "";
		for (mesh in this.children) {
			var result = mesh.material.toMtl();
			if (mtl.indexOf(result) == -1) {
				mtl += result;
			}
		}
		return {obj: file, mtl: mtl};
    } */
	public static function filteri<A>(it:Array<A>, f:(item:A, index:Int) -> Bool) {
        return [for (i in 0...Lambda.count(it, (_) -> true )) if (f(it[i], i)) it[i]];
    }

	public function toGltf() {
		var gltf:TGLTF = {
			asset: {
				generator: "Bulby's Anyland Thing Converter",
				version: "2.0"
			},
			extensionsUsed: ["KHR_materials_unlit"],
			buffers: [],
			images: [],
			samplers: [{
				magFilter:NEAREST,
				minFilter:NEAREST,
				wrapS:REPEAT,
				wrapT:REPEAT

			}],
			textures: []
		};
		var buf = new BytesBuffer();
		var compatMeshes:Array<GLTFMesh> = [for (mesh in this.children) GLTFMesh.fromMesh(mesh)];
		var usedMats:Map<String, Int> = [];
		var mats:Array<TMaterial> = [];
		var bufferViews:Array<TBufferView> = [];
		var primitives:Array<TPrimitive> = [];
		var accessors:Array<TAccessor> = [];
		
		var b = 0;
		var m = 0;
		var t1 = 1;
		var t = 0;
		for (compatMesh in compatMeshes) {
			if (!usedMats.exists(compatMesh.material.name)) {
				usedMats.set(compatMesh.material.name, m);
				var mat:TMaterial = {
					name: compatMesh.material.name,
					pbrMetallicRoughness: {
						baseColorFactor: compatMesh.material.diffuse.asVector4().asArray(),
						metallicFactor: 0
					},
					// don't waste time on blending if it's opaque
					alphaMode: compatMesh.material.alpha == 1 ? OPAQUE : BLEND
				};
				
				if (compatMesh.material.texture != null)  {
					mat.pbrMetallicRoughness.baseColorTexture = {
						index: t
					};
					mat.pbrMetallicRoughness.baseColorFactor = null;
					var bytes = compatMesh.material.texture.getPngBytes();
					gltf.images.push({
						uri: "data:application/octet-stream;base64," + haxe.crypto.Base64.encode(bytes)
					});
					gltf.textures.push({
						source: t++,
						sampler: 0
					});
				}
				
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
				if (vert.position.x < min.x)
					min.x = vert.position.x;
				if (vert.position.y < min.y)
					min.y = vert.position.y;
				if (vert.position.z < min.z)
					min.z = vert.position.z;
				if (vert.position.x > max.x)
					max.x = vert.position.x;
				if (vert.position.y > max.y)
					max.y = vert.position.y;
				if (vert.position.z > max.z)
					max.z = vert.position.z;
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
		gltf.meshes = [
			{
				name: "output",
				primitives: primitives
			}
		];
		gltf.nodes = [
			{
				name: "output",
				mesh: 0
			}
		];
		gltf.scenes = [
			{
				name: "Scene",
				nodes: [0]
			}
		];
		gltf.scene = 0;
		gltf.buffers.push({
			byteLength: buf.length,
			uri: "data:application/octet-stream;base64," + haxe.crypto.Base64.encode(buf.getBytes())
		});
		return gltf;
	}
	public function toGLB() {
		var bytesChunkBuf = new BytesBuffer();
		var gltf = this.toGltf();
		var buffers = gltf.buffers.copy();
		gltf.buffers = [];
		var images = gltf.images.copy();
		gltf.images = [];
		
		
		for (buffer in buffers) {
			var bufBytes = haxe.crypto.Base64.decode(buffer.uri.substring(buffer.uri.indexOf(",") + 1));
			bytesChunkBuf.addBytes(bufBytes, 0, bufBytes.length);
			
		}
		var viewLen = gltf.bufferViews.length;
		for (image in images ) {
			var curPos = bytesChunkBuf.length;
			var imgBytes = haxe.crypto.Base64.decode(image.uri.substring(image.uri.indexOf(",") + 1));
			
			bytesChunkBuf.addBytes(imgBytes, 0, imgBytes.length);
			var newPos = bytesChunkBuf.length;
			var len = newPos - curPos;
			gltf.bufferViews.push({
				buffer: 0,
				byteLength: len,
				byteOffset: curPos
			});
			gltf.images.push({
				bufferView: viewLen++,
				mimeType: "image/png"
			});
		}
		gltf.buffers.push({
			byteLength: bytesChunkBuf.length
		});
		var jsonBuf = new BytesBuffer();
		// sys.io.File.saveContent("debug.json", haxe.Json.stringify(gltf));
		jsonBuf.addString(Json.stringify(gltf));
		while (jsonBuf.length % 4 != 0)
			jsonBuf.addByte(0x02);
		while (bytesChunkBuf.length % 4 != 0)
			bytesChunkBuf.addByte(0x00);
		final glbBuf = new BytesBuffer();

		glbBuf.addInt32(0x46546C67);
		glbBuf.addInt32(2);
		// header (12 bytes) + jsonBuf prefix (8 bytes) + jsonBuf + bytesChunkBuf prefix (8 bytes) + bytesChunkBuf
		final length = 12 + 8 + 8 + jsonBuf.length + bytesChunkBuf.length;
		glbBuf.addInt32(length);
		glbBuf.addInt32(jsonBuf.length);
		glbBuf.addInt32(0x4E4F534A);
		glbBuf.addBytes(jsonBuf.getBytes(), 0, jsonBuf.length);
		glbBuf.addInt32(bytesChunkBuf.length);
		glbBuf.addInt32(0x004E4942);
		glbBuf.addBytes(bytesChunkBuf.getBytes(), 0, bytesChunkBuf.length);

		return glbBuf.getBytes();

	}
}

class GLTFMesh {
	public var material:Material;
	public var verticies:Array<Vertex>;
	public var faces:Array<Array<Int>>;

	public function new(material:Material, verticies:Array<Vertex>, faces:Array<Array<Int>>):Void {
		this.material = material;
		this.verticies = verticies;
		this.faces = faces;
	}

	public static function fromMesh(mesh:Mesh) {
		var verts:Array<Vertex> = [];
		var faces:Array<Array<Int>> = [];
		var i = 0;
		for (face in mesh.faces) {
			var faceVerts = [];
			for (vert in face) {
				// don't check for normal : )
				// Ignore uv outright if no texture (probably causes some wonky results)
				var foundIndex = Lambda.findIndex(verts,
					(v) -> v.position == mesh.displayPositions[vert.position]
						&& (mesh.material.texture == null || v.uv == mesh.uvs[vert.uv]));
				if (foundIndex != -1) {
					faceVerts.push(foundIndex);
					// Me when I average the normals
					verts[foundIndex].normal = (verts[foundIndex].normal + mesh.displayNormals[vert.normal]) / 2;
				} else {
					verts.push(new Vertex(mesh.displayPositions[vert.position], mesh.uvs[vert.uv], mesh.displayNormals[vert.normal]));
					faceVerts.push(i++);
				}
			}
			faces.push(faceVerts);
		}
		return new GLTFMesh(mesh.material, verts, faces);
	}
}