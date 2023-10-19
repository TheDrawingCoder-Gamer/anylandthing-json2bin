package bulby.assets.gltf.schema;

typedef TNode = {
	> TGLTFChildOfRoot,
	@:optional var mesh:TGLTFID;
	@:optional var children:Array<TGLTFID>;
	@:optional var scale: Array<Float>;
	@:optional var rotation: Array<Float>;
	@:optional var translation: Array<Float>;
}
