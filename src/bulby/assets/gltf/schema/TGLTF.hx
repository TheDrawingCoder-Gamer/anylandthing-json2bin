package bulby.assets.gltf.schema;

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