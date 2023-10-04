package bulby.assets.gltf.schema;

typedef TMesh = {
	> TGLTFChildOfRoot,
	var primitives:Array<TPrimitive>;
	@:optional var weights:Array<Int>;
}
