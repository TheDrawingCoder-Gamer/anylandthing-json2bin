package bulby.assets;

import haxe.io.Bytes;
import haxe.Json;
import bulby.BulbyMath;
import haxe.io.BytesBuffer;
import bulby.assets.mat.Material;
import bulby.assets.b3d.Vertex;
import bulby.assets.Mesh;
import bulby.assets.gltf.schema.*;

enum Child {
	ANode(node:Node);
	AMesh(mesh:Mesh);
}

typedef GLTFOffsets = {
	image:Int,
	buffer:Int,
	mats:Int,
	part:Int,
	mesh:Int
}

class Node {
	public var children:Array<Child>;
	public var name:String = "thing";
	public var translation:Vector3 = Vector3.empty();
	public var rotation = Quaternion.identity();
	public var scale:Vector3 = new Vector3(1, 1, 1);

	public function new(children:Array<Child>) {
		this.children = children;
	}

	/*
	 * Adds an extra transform to this whole group. Note that this will prevent reassigning transforms to children without breaking stuff
	 */
	/*
		@:access(bulby.assets.Mesh)
		@:deprecated
		public function applyTransform(transform:  Matrix4) {
			for (child in children) {
				switch (child) {
					case AMesh(mesh):
						mesh.positions = mesh.displayPositions;
						mesh.normals = mesh.displayNormals;
						mesh.specialTransform(transform);
					case ANode(node):
						node.applyTransform(transform);
				}
			}	
		}
	 */
	/*
	 * Returns a mesh that is a merge of all children. Note scaling does NOT reset and is taken into account.
	 */
	/*
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
			// mesh.optimize();
			return mesh;
		}
	 */
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
	}*/
	public static function filteri<A>(it:Array<A>, f:(item:A, index:Int) -> Bool) {
		return [for (i in 0...Lambda.count(it, (_) -> true)) if (f(it[i], i)) it[i]];
	}

	public function getGLTFData(?offsets:GLTFOffsets):{gltf:TGLTF, images:Array<Image>, buffer:Bytes} {
		if (offsets == null) {
			offsets = {
				image: 0,
				mats: 0,
				buffer: 0,
				part: 0,
				mesh: 0
			};
		}
		var gltf:TGLTF = {
			asset: {
				generator: "Bulby's Anyland Thing Converter",
				version: "2.0"
			},
			extensionsUsed: ["KHR_materials_unlit"],
			buffers: [],
			images: [],
			samplers: [
				{
					magFilter: NEAREST,
					minFilter: NEAREST,
					wrapS: REPEAT,
					wrapT: REPEAT
				}
			],
			textures: [],
			meshes: [],
			nodes: [
				{
					name: name,
					children: [],
					scale: this.scale.toArray(),
					rotation: this.rotation.toXYZW(),
					translation: this.translation.toArray()
				}
			],
			scenes: [
				{
					name: "Scene",
					nodes: [0]
				}
			]
		};
		final images:Array<Image> = [];
		var buf = new BytesBuffer();
		var usedMats:Map<String, Int> = [];
		var mats:Array<TMaterial> = [];
		var bufferViews:Array<TBufferView> = [];
		var accessors:Array<TAccessor> = [];

		var b = offsets.buffer;
		var m = offsets.mats;
		var p = offsets.part;
		var t = offsets.image;
		var ms = offsets.mesh;
		for (child in this.children) {
			switch (child) {
				case ANode(node):
					final data = node.getGLTFData({
						image: offsets.image + images.length,
						buffer: offsets.buffer + bufferViews.length,
						mats: offsets.mats + mats.length,
						part: p + 1,
						mesh: ms
					});
					for (a in data.gltf.accessors) {
						accessors.push(a);
					}
					for (view in data.gltf.bufferViews) {
						if (view.byteOffset != null) {
							view.byteOffset += buf.length;
						} else {
							view.byteOffset = buf.length;
						}
						bufferViews.push(view);
						b += 4;
					}
					buf.addBytes(data.buffer, 0, data.buffer.length);
					for (mesh in data.gltf.meshes) {
						gltf.meshes.push(mesh);
					}
					final nodeLength = gltf.nodes.length;
					for (n in 0...data.gltf.nodes.length) {
						final node = data.gltf.nodes[n];
						gltf.nodes.push(node);
						p++;
					}
					for (t in data.gltf.textures) {
						gltf.textures.push(t);
					}
					for (mat in data.gltf.materials) {
						mats.push(mat);
					}
					ms += data.gltf.meshes.length;
					// ???
					gltf.nodes[0].children.push(offsets.part + nodeLength);
					for (image in data.images) {
						images.push(image);
					}

				case AMesh(mesh):
					final compatMesh = GLTFMesh.fromMesh(mesh);
					if (!usedMats.exists(compatMesh.material.name)) {
						usedMats.set(compatMesh.material.name, m);
						var mat:TMaterial = {
							name: compatMesh.material.name,
							pbrMetallicRoughness: {
								baseColorFactor: compatMesh.material.diffuse.asVector4().asArray(),
								metallicFactor: 0
							},
							// don't waste time on blending if it's opaque
							alphaMode: (compatMesh.material.diffuse.a == 255 && compatMesh.material.texture == null) ? OPAQUE : BLEND,
							emissiveFactor: compatMesh.material.emissive.asVector4().asArray().slice(0, 3)
						};

						if (compatMesh.material.texture != null) {
							mat.pbrMetallicRoughness.baseColorTexture = {
								index: t
							};
							mat.pbrMetallicRoughness.baseColorFactor = [1, 1, 1, 1];
							images.push(compatMesh.material.texture);
							gltf.textures.push({
								source: t++,
								sampler: 0
							});
						}
						mat.extensions = {};
						for (ext in compatMesh.material.extensions) {
							switch (ext) {
								case Unlit:
									mat.extensions.KHR_materials_unlit = {};
								case Clearcoat(ccFactor, ccTex, ccRFactor, ccRTex, ccNTex):
									mat.extensions.KHR_materials_clearcoat = {};
									if (ccTex != null) {
										images.push(ccTex);
										gltf.textures.push({
											source: t,
											sampler: 0
										});
										mat.extensions.KHR_materials_clearcoat.clearcoatTexture = {
											index: t++
										};
									}
									if (ccRTex != null) {
										images.push(ccRTex);
										gltf.textures.push({
											source: t,
											sampler: 0
										});
										mat.extensions.KHR_materials_clearcoat.clearcoatRoughnessTexture = {
											index: t++
										};
									}
									if (ccNTex != null) {
										images.push(ccNTex);
										gltf.textures.push({
											source: t,
											sampler: 0
										});
										mat.extensions.KHR_materials_clearcoat.clearcoatTexture = {
											index: t++
										};
									}
									if (ccFactor != null) {
										mat.extensions.KHR_materials_clearcoat.clearcoatFactor = ccFactor;
									}
									if (ccRFactor != null) {
										mat.extensions.KHR_materials_clearcoat.clearcoatRoughnessFactor = ccRFactor;
									}
								case Ior(ior):
									mat.extensions.KHR_materials_ior = {
										ior: ior
									};
								case Sheen(sheenColorFactor, sheenColorTexture, sheenRoughnessFactor, sheenRoughnessTexture):
									mat.extensions.KHR_materials_sheen = {};
									if (sheenColorTexture != null) {
										images.push(sheenColorTexture);
										gltf.textures.push({
											source: t,
											sampler: 0
										});
										mat.extensions.KHR_materials_sheen.sheenColorTexture = {
											index: t++
										};
									}
									if (sheenRoughnessTexture != null) {
										images.push(sheenRoughnessTexture);
										gltf.textures.push({
											source: t,
											sampler: 0
										});
										mat.extensions.KHR_materials_sheen.sheenRoughnessTexture = {
											index: t++
										};
									}
									if (sheenColorFactor != null) {
										mat.extensions.KHR_materials_sheen.sheenColorFactor = sheenColorFactor.asVector4().asArray().slice(0, 3);
									}
									if (sheenRoughnessFactor != null) {
										mat.extensions.KHR_materials_sheen.sheenRoughnessFactor = sheenRoughnessFactor;
									}
								case Specular(specularFactor, specularTexture, specularColorFactor, specularColorTexture):
									mat.extensions.KHR_materials_specular = {};
									if (specularTexture != null) {
										images.push(specularTexture);
										gltf.textures.push({
											source: t,
											sampler: 0
										});
										mat.extensions.KHR_materials_specular.specularTexture = {
											index: t++
										};
									}
									if (specularColorTexture != null) {
										images.push(specularColorTexture);
										gltf.textures.push({
											source: t,
											sampler: 0
										});
										mat.extensions.KHR_materials_specular.specularColorTexture = {
											index: t++
										}
									}
									if (specularFactor != null) {
										mat.extensions.KHR_materials_specular.specularFactor = specularFactor;
									}
									if (specularColorFactor != null) {
										mat.extensions.KHR_materials_specular.specularColorFactor = specularColorFactor.asVector4().asArray().slice(0, 3);
									}
								case Transmission(transmissionFactor, transmissionTexture):
									mat.extensions.KHR_materials_transmission = {};
									if (transmissionTexture != null) {
										images.push(transmissionTexture);
										gltf.textures.push({
											source: t,
											sampler: 0
										});
										mat.extensions.KHR_materials_transmission.transmissionTexture = {
											index: t++
										};
									}
									if (transmissionFactor != null) {
										mat.extensions.KHR_materials_transmission.transmissionFactor = transmissionFactor;
									}
								case Volume(thicknessFactor, thicknessTexture, attenuationDistance, attenuationColor):
									mat.extensions.KHR_materials_volume = {};
									if (thicknessTexture != null) {
										images.push(thicknessTexture);
										gltf.textures.push({
											source: t,
											sampler: 0
										});
										mat.extensions.KHR_materials_volume.thicknessTexture = {
											index: t++
										};
									}
									if (thicknessFactor != null) {
										mat.extensions.KHR_materials_volume.thicknessFactor = thicknessFactor;
									}
									if (attenuationDistance != null) {
										mat.extensions.KHR_materials_volume.attenuationDistance = attenuationDistance;
									}
									if (attenuationColor != null) {
										mat.extensions.KHR_materials_volume.attenuationColor = attenuationColor.asVector4().asArray().slice(0, 3);
									}
							}
						}
						mats.push(mat);
						m++;
					}
					var posView:TBufferView = {
						buffer: 0,
						byteLength: 0,
						target: ARRAY_BUFFER
					};
					var normView:TBufferView = {
						buffer: 0,
						byteLength: 0,
						target: ARRAY_BUFFER
					};
					var uvView:TBufferView = {
						buffer: 0,
						byteLength: 0,
						target: ARRAY_BUFFER
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
						final goodNormal = vert.normal.normalize();
						buf.addFloat(goodNormal.x);
						buf.addFloat(goodNormal.y);
						buf.addFloat(goodNormal.z);
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
						byteOffset: curBufPos,
						target: ELEMENT_ARRAY_BUFFER
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
					// primitives.push(prim);
					b += 4;
					gltf.meshes.push({name: "output" + ms, primitives: [prim]});
					gltf.nodes.push({name: name + "_part" + p, mesh: ms});
					gltf.nodes[0].children.push(p + 1);
					p++;
					ms++;
			}
		}
		gltf.accessors = accessors;
		gltf.bufferViews = bufferViews;
		gltf.materials = mats;

		gltf.scene = 0;
		return {gltf: gltf, buffer: buf.getBytes(), images: images};
	}

	public function toGltf() {
		final data = getGLTFData();
		final gltf = data.gltf;
		for (image in data.images) {
			gltf.images.push({
				uri: "data:image/png;base64," + haxe.crypto.Base64.encode(image.getPngBytes())
			});
		}
		gltf.buffers.push({byteLength: data.buffer.length, uri: "data:application/octet-stream;base64," + haxe.crypto.Base64.encode(data.buffer)});
		return gltf;
	}

	public function toGLB() {
		var bytesChunkBuf = new BytesBuffer();
		var data = this.getGLTFData();
		final gltf = data.gltf;
		var images = data.images;

		bytesChunkBuf.addBytes(data.buffer, 0, data.buffer.length);
		var viewLen = gltf.bufferViews.length;
		for (image in images) {
			var curPos = bytesChunkBuf.length;
			final imgBytes = image.getPngBytes();
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
			jsonBuf.addByte(0x20);
		while (bytesChunkBuf.length % 4 != 0)
			bytesChunkBuf.addByte(0x00);
		final glbBuf = new BytesBuffer();
		final jsonLen = jsonBuf.length;
		final jsonBytes = jsonBuf.getBytes();
		final bytesChunkLen = bytesChunkBuf.length;
		final bytesChunkBytes = bytesChunkBuf.getBytes();
		glbBuf.addInt32(0x46546C67);
		glbBuf.addInt32(2);
		// header (12 bytes) + jsonBuf prefix (8 bytes) + jsonBuf + bytesChunkBuf prefix (8 bytes) + bytesChunkBuf
		final length = 12 + 8 + 8 + jsonLen + bytesChunkLen;
		glbBuf.addInt32(length);
		glbBuf.addInt32(jsonLen);
		glbBuf.addInt32(0x4E4F534A);
		glbBuf.addBytes(jsonBytes, 0, jsonLen);
		glbBuf.addInt32(bytesChunkLen);
		glbBuf.addInt32(0x004E4942);
		glbBuf.addBytes(bytesChunkBytes, 0, bytesChunkLen);

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
