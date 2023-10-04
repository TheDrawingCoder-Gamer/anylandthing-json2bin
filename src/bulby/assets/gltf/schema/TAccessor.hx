package bulby.assets.gltf.schema;

typedef TAccessor = {
	> TGLTFChildOfRoot,
	@:optional var bufferView:TGLTFID;
	@:optional var byteOffset:Int;
	var componentType:TComponentType;
	@:optional var normalized:Bool;
	var count:Int;
	var type:TAttributeType;
	@:optional var max:Array<Float>;
	@:optional var min:Array<Float>;
}
