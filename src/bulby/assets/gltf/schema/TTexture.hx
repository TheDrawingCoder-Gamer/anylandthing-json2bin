package bulby.assets.gltf.schema;

typedef TTexture = {
	> TGLTFChildOfRoot,
	@:optional var sampler:TGLTFID;
	@:optional var source:TGLTFID;
}
