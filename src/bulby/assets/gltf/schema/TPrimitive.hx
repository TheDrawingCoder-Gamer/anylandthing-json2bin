package bulby.assets.gltf.schema;

typedef TPrimitive = {
	> TGLTFChildOfRoot,
	var attributes:Dynamic;
	@:optional var indices:TGLTFID;
	@:optional var material:TGLTFID;
	// ignore morph targets & mode
}
